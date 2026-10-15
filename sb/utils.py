import hashlib


def str2label(s: str) -> str:
    """Convert string to label.

    - leading non-letters are removed
    - trailing characters that are neither letters nor digits ("other chars") are removed
    - sequences of other chars within the string are replaced by a single underscore
    """
    label = ""
    separator = False
    has_started = False
    for c in s:
        if c.isalpha() or (has_started and c.isdigit()):
            has_started = True
            if separator:
                separator = False
                label += "_"
            label += c
        else:
            separator = has_started
    return label


def hide(value: str) -> str:
    """
    Hide values in places such as the log or the result json
    by replacing them by a deterministic hash. Revealing
    16 bits (4 hex digits) of the hash is sufficient to recover
    the original value ourselves if we have a few candidates,
    but without knowing them the 16 bits do not reveal much.
    """
    return "secret_" + hashlib.sha256(value.encode("utf-8")).hexdigest()[:4]
