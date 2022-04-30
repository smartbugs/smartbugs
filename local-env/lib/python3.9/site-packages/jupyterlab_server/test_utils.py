import json
import os
import sys
from contextlib import contextmanager
from http.cookies import SimpleCookie
from pathlib import Path
from urllib.parse import parse_qs, urlparse

import requests
import tornado
from openapi_core.validation.request.datatypes import OpenAPIRequest, RequestParameters
from openapi_core.validation.request.validators import RequestValidator
from openapi_core.validation.response.datatypes import OpenAPIResponse
from openapi_core.validation.response.validators import ResponseValidator

from jupyterlab_server.spec import get_openapi_spec

HERE = Path(os.path.dirname(__file__)).resolve()

with open(HERE / "test_data" / "app-settings" / "overrides.json", encoding="utf-8") as fpt:
    big_unicode_string = json.load(fpt)["@jupyterlab/unicode-extension:plugin"]["comment"]


def wrap_request(request, spec):
    """Wrap a tornado request as an open api request"""
    # Extract cookie dict from cookie header
    cookie = SimpleCookie()
    cookie.load(request.headers.get("Set-Cookie", ""))
    cookies = {}
    for key, morsel in cookie.items():
        cookies[key] = morsel.value

    # extract the path
    o = urlparse(request.url)

    # extract the best matching url
    # work around lack of support for path parameters which can contain slashes
    # https://github.com/OAI/OpenAPI-Specification/issues/892
    url = None
    for path in spec["paths"]:
        if url:
            continue
        has_arg = "{" in path
        if has_arg:
            path = path[: path.index("{")]
        if path in o.path:
            u = o.path[o.path.index(path) :]
            if not has_arg and len(u) == len(path):
                url = u
            if has_arg and not u.endswith("/"):
                url = u[: len(path)] + r"foo"

    if url is None:
        raise ValueError(f"Could not find matching pattern for {o.path}")

    # gets deduced by path finder against spec
    path = {}

    # Order matters because all tornado requests
    # include Accept */* which does not necessarily match the content type
    mimetype = (
        request.headers.get("Content-Type") or request.headers.get("Accept") or "application/json"
    )

    parameters = RequestParameters(
        query=parse_qs(o.query),
        header=dict(request.headers),
        cookie=cookies,
        path=path,
    )

    return OpenAPIRequest(
        full_url_pattern=url,
        method=request.method.lower(),
        parameters=parameters,
        body=request.body,
        mimetype=mimetype,
    )


def wrap_response(response):
    """Wrap a tornado response as an open api response"""
    mimetype = response.headers.get("Content-Type") or "application/json"
    return OpenAPIResponse(
        data=response.body,
        status_code=response.code,
        mimetype=mimetype,
    )


def validate_request(response):
    """Validate an API request"""
    openapi_spec = get_openapi_spec()
    validator = RequestValidator(openapi_spec)
    request = wrap_request(response.request, openapi_spec)
    result = validator.validate(request)
    print(result.errors)
    result.raise_for_errors()

    validator = ResponseValidator(openapi_spec)
    response = wrap_response(response)
    result = validator.validate(request, response)
    print(result.errors)
    result.raise_for_errors()


def maybe_patch_ioloop():
    """a windows 3.8+ patch for the asyncio loop"""
    if sys.platform.startswith("win") and tornado.version_info < (6, 1):
        if sys.version_info >= (3, 8):
            import asyncio

            try:
                from asyncio import (
                    WindowsProactorEventLoopPolicy,
                    WindowsSelectorEventLoopPolicy,
                )
            except ImportError:
                pass
                # not affected
            else:
                if type(asyncio.get_event_loop_policy()) is WindowsProactorEventLoopPolicy:
                    # WindowsProactorEventLoopPolicy is not compatible with tornado 6
                    # fallback to the pre-3.8 default of Selector
                    asyncio.set_event_loop_policy(WindowsSelectorEventLoopPolicy())


def expected_http_error(error, expected_code, expected_message=None):
    """Check that the error matches the expected output error."""
    e = error.value
    if isinstance(e, tornado.web.HTTPError):
        if expected_code != e.status_code:
            return False
        if expected_message is not None and expected_message != str(e):
            return False
        return True
    elif any(
        [
            isinstance(e, tornado.httpclient.HTTPClientError),
            isinstance(e, tornado.httpclient.HTTPError),
        ]
    ):
        if expected_code != e.code:
            return False
        if expected_message:
            message = json.loads(e.response.body.decode())["message"]
            if expected_message != message:
                return False
        return True


@contextmanager
def assert_http_error(status, msg=None):
    try:
        yield
    except requests.HTTPError as e:
        real_status = e.response.status_code
        assert real_status == status, "Expected status %d, got %d" % (status, real_status)
        if msg:
            assert msg in str(e), e
    else:
        raise AssertionError("Expected HTTP error status")
