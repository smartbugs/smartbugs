def str2label(s):
    """Convert string to label.

    - leading non-letters are removed
    - trailing characters that are neither letters nor digits ("other chars") are removed
    - sequences of other chars within the string are replaced by a single underscore
    """
    l = ""
    separator = False
    has_started = False
    for c in s:
        if c.isalpha() or (has_started and c.isdigit()):
            has_started = True
            if separator:
                separator = False
                l += "_"
            l += c
        else:
            separator = has_started
    return l
