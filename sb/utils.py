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
