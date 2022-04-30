import os
from pathlib import Path

HERE = Path(os.path.dirname(__file__)).resolve()


def get_openapi_spec():
    """Get the OpenAPI spec object."""
    from openapi_core import create_spec

    openapi_spec_dict = get_openapi_spec_dict()
    return create_spec(openapi_spec_dict)


def get_openapi_spec_dict():
    """Get the OpenAPI spec as a dictionary."""
    from ruamel.yaml import YAML

    path = HERE / "rest-api.yml"
    yaml = YAML(typ="safe")
    return yaml.load(path.read_text(encoding="utf-8"))
