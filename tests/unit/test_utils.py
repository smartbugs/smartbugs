from sb.utils import str2label


def test_leading_non_letters_removed():
    assert str2label("123--abc") == "abc"
    assert str2label("!!!Hello") == "Hello"


def test_trailing_non_alnum_removed():
    assert str2label("abc!!!") == "abc"
    assert str2label("abc123---") == "abc123"


def test_internal_sequences_collapsed():
    assert str2label("a---b") == "a_b"
    assert str2label("a!!!b@@@c") == "a_b_c"


def test_digits_only_after_start():
    assert str2label("a1b2") == "a1b2"
    assert str2label("1a2b3") == "a2b3"
    assert str2label("1-2-3") == ""


def test_mixed_complex_cases():
    assert str2label("--a--1--b--2--") == "a_1_b_2"
    assert str2label("___A__B__C___") == "A_B_C"


def test_all_non_letters():
    assert str2label("123---456") == ""
    assert str2label("!!!") == ""


def test_single_letter():
    assert str2label("a") == "a"


def test_single_digit_no_start():
    assert str2label("7") == ""
