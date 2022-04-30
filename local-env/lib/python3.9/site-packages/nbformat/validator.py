# Copyright (c) IPython Development Team.
# Distributed under the terms of the Modified BSD License.


import json
import os
import pprint

from traitlets.log import get_logger

from ._imports import import_item
from .corpus.words import generate_corpus_id
from .json_compat import ValidationError, _validator_for_name, get_current_validator
from .reader import get_version

validators = {}


def _relax_additional_properties(obj):
    """relax any `additionalProperties`"""
    if isinstance(obj, dict):
        for key, value in obj.items():
            if key == "additionalProperties":
                value = True
            else:
                value = _relax_additional_properties(value)
            obj[key] = value
    elif isinstance(obj, list):
        for i, value in enumerate(obj):
            obj[i] = _relax_additional_properties(value)
    return obj


def _allow_undefined(schema):
    schema["definitions"]["cell"]["oneOf"].append({"$ref": "#/definitions/unrecognized_cell"})
    schema["definitions"]["output"]["oneOf"].append({"$ref": "#/definitions/unrecognized_output"})
    return schema


def get_validator(version=None, version_minor=None, relax_add_props=False, name=None):
    """Load the JSON schema into a Validator"""
    if version is None:
        from . import current_nbformat

        version = current_nbformat

    v = import_item("nbformat.v%s" % version)
    current_minor = getattr(v, "nbformat_minor", 0)
    if version_minor is None:
        version_minor = current_minor

    if name:
        current_validator = _validator_for_name(name)
    else:
        current_validator = get_current_validator()

    version_tuple = (current_validator.name, version, version_minor)

    if version_tuple not in validators:
        try:
            schema_json = _get_schema_json(v, version=version, version_minor=version_minor)
        except AttributeError:
            return None

        if current_minor < version_minor:
            # notebook from the future, relax all `additionalProperties: False` requirements
            schema_json = _relax_additional_properties(schema_json)
            # and allow undefined cell types and outputs
            schema_json = _allow_undefined(schema_json)

        validators[version_tuple] = current_validator(schema_json)

    if relax_add_props:
        try:
            schema_json = _get_schema_json(v, version=version, version_minor=version_minor)
        except AttributeError:
            return None

        # this allows properties to be added for intermediate
        # representations while validating for all other kinds of errors
        schema_json = _relax_additional_properties(schema_json)
        validators[version_tuple] = current_validator(schema_json)

    return validators[version_tuple]


def _get_schema_json(v, version=None, version_minor=None):
    """
    Gets the json schema from a given imported library and nbformat version.
    """
    if (version, version_minor) in v.nbformat_schema:
        schema_path = os.path.join(
            os.path.dirname(v.__file__), v.nbformat_schema[(version, version_minor)]
        )
    elif version_minor > v.nbformat_minor:
        # load the latest schema
        schema_path = os.path.join(os.path.dirname(v.__file__), v.nbformat_schema[(None, None)])
    else:
        raise AttributeError("Cannot find appropriate nbformat schema file.")
    with open(schema_path) as f:
        schema_json = json.load(f)
    return schema_json


def isvalid(nbjson, ref=None, version=None, version_minor=None):
    """Checks whether the given notebook JSON conforms to the current
    notebook format schema. Returns True if the JSON is valid, and
    False otherwise.

    To see the individual errors that were encountered, please use the
    `validate` function instead.
    """
    try:
        validate(nbjson, ref, version, version_minor)
    except ValidationError:
        return False
    else:
        return True


def _format_as_index(indices):
    """
    (from jsonschema._utils.format_as_index, copied to avoid relying on private API)

    Construct a single string containing indexing operations for the indices.

    For example, [1, 2, "foo"] -> [1][2]["foo"]
    """

    if not indices:
        return ""
    return "[%s]" % "][".join(repr(index) for index in indices)


_ITEM_LIMIT = 16
_STR_LIMIT = 64


def _truncate_obj(obj):
    """Truncate objects for use in validation tracebacks

    Cell and output lists are squashed, as are long strings, lists, and dicts.
    """
    if isinstance(obj, dict):
        truncated = {k: _truncate_obj(v) for k, v in list(obj.items())[:_ITEM_LIMIT]}
        if isinstance(truncated.get("cells"), list):
            truncated["cells"] = ["...%i cells..." % len(obj["cells"])]
        if isinstance(truncated.get("outputs"), list):
            truncated["outputs"] = ["...%i outputs..." % len(obj["outputs"])]

        if len(obj) > _ITEM_LIMIT:
            truncated["..."] = "%i keys truncated" % (len(obj) - _ITEM_LIMIT)
        return truncated
    elif isinstance(obj, list):
        truncated = [_truncate_obj(item) for item in obj[:_ITEM_LIMIT]]
        if len(obj) > _ITEM_LIMIT:
            truncated.append("...%i items truncated..." % (len(obj) - _ITEM_LIMIT))
        return truncated
    elif isinstance(obj, str):
        truncated = obj[:_STR_LIMIT]
        if len(obj) > _STR_LIMIT:
            truncated += "..."
        return truncated
    else:
        return obj


class NotebookValidationError(ValidationError):
    """Schema ValidationError with truncated representation

    to avoid massive verbose tracebacks.
    """

    def __init__(self, original, ref=None):
        self.original = original
        self.ref = getattr(self.original, "ref", ref)
        self.message = self.original.message

    def __getattr__(self, key):
        return getattr(self.original, key)

    def __unicode__(self):
        """Custom str for validation errors

        avoids dumping full schema and notebook to logs
        """
        error = self.original
        instance = _truncate_obj(error.instance)

        return "\n".join(
            [
                error.message,
                "",
                "Failed validating %r in %s%s:"
                % (
                    error.validator,
                    self.ref or "notebook",
                    _format_as_index(list(error.relative_schema_path)[:-1]),
                ),
                "",
                "On instance%s:" % _format_as_index(error.relative_path),
                pprint.pformat(instance, width=78),
            ]
        )

    __str__ = __unicode__


def better_validation_error(error, version, version_minor):
    """Get better ValidationError on oneOf failures

    oneOf errors aren't informative.
    if it's a cell type or output_type error,
    try validating directly based on the type for a better error message
    """
    key = error.schema_path[-1]
    ref = None
    if key.endswith("Of"):

        if isinstance(error.instance, dict):
            if "cell_type" in error.instance:
                ref = error.instance["cell_type"] + "_cell"
            elif "output_type" in error.instance:
                ref = error.instance["output_type"]

        if ref:
            try:
                validate(
                    error.instance,
                    ref,
                    version=version,
                    version_minor=version_minor,
                )
            except ValidationError as sub_error:
                # keep extending relative path
                error.relative_path.extend(sub_error.relative_path)
                sub_error.relative_path = error.relative_path
                better = better_validation_error(sub_error, version, version_minor)
                if better.ref is None:
                    better.ref = ref
                return better
            except Exception:
                # if it fails for some reason,
                # let the original error through
                pass
    return NotebookValidationError(error, ref)


def validate(
    nbdict=None,
    ref=None,
    version=None,
    version_minor=None,
    relax_add_props=False,
    nbjson=None,
    repair_duplicate_cell_ids=True,
    strip_invalid_metadata=False,
):
    """Checks whether the given notebook dict-like object
    conforms to the relevant notebook format schema.


    Raises ValidationError if not valid.
    """

    # backwards compatibility for nbjson argument
    if nbdict is not None:
        pass
    elif nbjson is not None:
        nbdict = nbjson
    else:
        raise TypeError("validate() missing 1 required argument: 'nbdict'")

    if ref is None:
        # if ref is not specified, we have a whole notebook, so we can get the version
        nbdict_version, nbdict_version_minor = get_version(nbdict)
        if version is None:
            version = nbdict_version
        if version_minor is None:
            version_minor = nbdict_version_minor
    else:
        # if ref is specified, and we don't have a version number, assume we're validating against 1.0
        if version is None:
            version, version_minor = 1, 0

    notebook_supports_cell_ids = ref is None and version >= 4 and version_minor >= 5
    if notebook_supports_cell_ids and repair_duplicate_cell_ids:
        # Auto-generate cell ids for cells that are missing them.
        for cell in nbdict["cells"]:
            if "id" not in cell:
                # Generate cell ids if any are missing
                cell["id"] = generate_corpus_id()

    for error in iter_validate(
        nbdict,
        ref=ref,
        version=version,
        version_minor=version_minor,
        relax_add_props=relax_add_props,
        strip_invalid_metadata=strip_invalid_metadata,
    ):
        raise error

    if notebook_supports_cell_ids:
        # if we support cell ids check for uniqueness when validating the whole notebook
        seen_ids = set()
        for cell in nbdict["cells"]:
            cell_id = cell["id"]
            if cell_id in seen_ids:
                if repair_duplicate_cell_ids:
                    # Best effort to repair if we find a duplicate id
                    cell["id"] = generate_corpus_id()
                    get_logger().warning(
                        "Non-unique cell id '{}' detected. Corrected to '{}'.".format(
                            cell_id, cell["id"]
                        )
                    )
                else:
                    raise ValidationError(f"Non-unique cell id '{cell_id}' detected.")
            seen_ids.add(cell_id)


def iter_validate(
    nbdict=None,
    ref=None,
    version=None,
    version_minor=None,
    relax_add_props=False,
    nbjson=None,
    strip_invalid_metadata=False,
):
    """Checks whether the given notebook dict-like object conforms to the
    relevant notebook format schema.

    Returns a generator of all ValidationErrors if not valid.
    """
    # backwards compatibility for nbjson argument
    if nbdict is not None:
        pass
    elif nbjson is not None:
        nbdict = nbjson
    else:
        raise TypeError("iter_validate() missing 1 required argument: 'nbdict'")

    if version is None:
        version, version_minor = get_version(nbdict)

    validator = get_validator(version, version_minor, relax_add_props=relax_add_props)

    if validator is None:
        # no validator
        yield ValidationError("No schema for validating v%s notebooks" % version)
        return

    if ref:
        errors = validator.iter_errors(nbdict, {"$ref": "#/definitions/%s" % ref})
    else:
        errors = [e for e in validator.iter_errors(nbdict)]

        if len(errors) > 0 and strip_invalid_metadata:
            if validator.name == "fastjsonschema":
                validator = get_validator(
                    version, version_minor, relax_add_props=relax_add_props, name="jsonschema"
                )
                errors = [e for e in validator.iter_errors(nbdict)]

            error_tree = validator.error_tree(errors)
            if "metadata" in error_tree:
                for key in error_tree["metadata"]:
                    nbdict["metadata"].pop(key, None)

            if "cells" in error_tree:
                number_of_cells = len(nbdict.get("cells", 0))
                for cell_idx in range(number_of_cells):
                    # Cells don't report individual metadata keys as having failed validation
                    # Instead it reports that it failed to validate against each cell-type definition.
                    # We have to delve into why those definitions failed to uncover which metadata
                    # keys are misbehaving.
                    if "oneOf" in error_tree["cells"][cell_idx].errors:
                        intended_cell_type = nbdict["cells"][cell_idx]["cell_type"]
                        schemas_by_index = [
                            ref["$ref"]
                            for ref in error_tree["cells"][cell_idx].errors["oneOf"].schema["oneOf"]
                        ]
                        cell_type_definition_name = f"#/definitions/{intended_cell_type}_cell"
                        if cell_type_definition_name in schemas_by_index:
                            schema_index = schemas_by_index.index(cell_type_definition_name)
                            for error in error_tree["cells"][cell_idx].errors["oneOf"].context:
                                rel_path = error.relative_path
                                error_for_intended_schema = error.schema_path[0] == schema_index
                                is_top_level_metadata_key = (
                                    len(rel_path) == 2 and rel_path[0] == "metadata"
                                )
                                if error_for_intended_schema and is_top_level_metadata_key:
                                    nbdict["cells"][cell_idx]["metadata"].pop(rel_path[1], None)

            # Validate one more time to ensure that us removing metadata
            # didn't cause another complex validation issue in the schema.
            # Also to ensure that higher-level errors produced by individual metadata validation
            # failures are removed.
            errors = validator.iter_errors(nbdict)

    for error in errors:
        yield better_validation_error(error, version, version_minor)
