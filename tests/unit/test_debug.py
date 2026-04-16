import sb.debug


def test_log_disabled_returns_none():
    sb.debug.ENABLED = False
    assert sb.debug.log("x") is None


def test_log_single_message_enabled(capsys):
    sb.debug.ENABLED = True
    sb.debug.log("hello")
    out = capsys.readouterr().out
    assert "[DEBUG] hello" in out


def test_log_list_messages_enabled(capsys):
    sb.debug.ENABLED = True
    sb.debug.log(["a", "b"])
    out = capsys.readouterr().out
    assert "[DEBUG] a" in out
    assert "[DEBUG] b" in out


def test_log_multiline_string_enabled(capsys):
    sb.debug.ENABLED = True
    sb.debug.log("a\nb")
    out = capsys.readouterr().out
    assert "[DEBUG] a" in out
    assert "[DEBUG] b" in out


def test_log_non_string_object_enabled(capsys):
    sb.debug.ENABLED = True
    sb.debug.log(123)
    out = capsys.readouterr().out
    assert "[DEBUG] 123" in out


def test_log_list_of_multiline_strings_enabled(capsys):
    sb.debug.ENABLED = True
    sb.debug.log(["a\nb", "c\nd"])
    out = capsys.readouterr().out
    assert "[DEBUG] a" in out
    assert "[DEBUG] b" in out
    assert "[DEBUG] c" in out
    assert "[DEBUG] d" in out


def test_log_empty_list_enabled(capsys):
    sb.debug.ENABLED = True
    sb.debug.log([])
    out = capsys.readouterr().out
    assert out == ""


def test_log_respects_global_toggle(capsys):
    sb.debug.ENABLED = False
    sb.debug.log("should_not_print")
    assert capsys.readouterr().out == ""

    sb.debug.ENABLED = True
    sb.debug.log("should_print")
    assert "[DEBUG] should_print" in capsys.readouterr().out
