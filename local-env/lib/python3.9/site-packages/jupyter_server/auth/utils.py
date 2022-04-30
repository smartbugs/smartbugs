"""A module with various utility methods for authorization in Jupyter Server.
"""
# Copyright (c) Jupyter Development Team.
# Distributed under the terms of the Modified BSD License.
import importlib
import re
import warnings


def warn_disabled_authorization():
    warnings.warn(
        "The Tornado web application does not have an 'authorizer' defined "
        "in its settings. In future releases of jupyter_server, this will "
        "be a required key for all subclasses of `JupyterHandler`. For an "
        "example, see the jupyter_server source code for how to "
        "add an authorizer to the tornado settings: "
        "https://github.com/jupyter-server/jupyter_server/blob/"
        "653740cbad7ce0c8a8752ce83e4d3c2c754b13cb/jupyter_server/serverapp.py"
        "#L234-L256",
        FutureWarning,
    )


HTTP_METHOD_TO_AUTH_ACTION = {
    "GET": "read",
    "HEAD": "read",
    "OPTIONS": "read",
    "POST": "write",
    "PUT": "write",
    "PATCH": "write",
    "DELETE": "write",
    "WEBSOCKET": "execute",
}


def get_regex_to_resource_map():
    """Returns a dictionary with all of Jupyter Server's
    request handler URL regex patterns mapped to
    their resource name.

    e.g.
    { "/api/contents/<regex_pattern>": "contents", ...}
    """
    from jupyter_server.serverapp import JUPYTER_SERVICE_HANDLERS

    modules = []
    for mod in JUPYTER_SERVICE_HANDLERS.values():
        if mod:
            modules.extend(mod)
    resource_map = {}
    for handler_module in modules:
        mod = importlib.import_module(handler_module)
        name = mod.AUTH_RESOURCE
        for handler in mod.default_handlers:
            url_regex = handler[0]
            resource_map[url_regex] = name
    # terminal plugin doesn't have importable url patterns
    # get these from terminal/__init__.py
    for url_regex in [
        r"/terminals/websocket/(\w+)",
        "/api/terminals",
        r"/api/terminals/(\w+)",
    ]:
        resource_map[url_regex] = "terminals"
    return resource_map


def match_url_to_resource(url, regex_mapping=None):
    """Finds the JupyterHandler regex pattern that would
    match the given URL and returns the resource name (str)
    of that handler.

    e.g.
    /api/contents/... returns "contents"
    """
    if not regex_mapping:
        regex_mapping = get_regex_to_resource_map()
    for regex, auth_resource in regex_mapping.items():
        pattern = re.compile(regex)
        if pattern.fullmatch(url):
            return auth_resource
