import sys
from unittest.mock import patch

import sb.colors


def test_strip_removes_ansi():
    s = "\x1b[31mhello\x1b[0m"
    assert sb.colors.strip(s) == "hello"


def test_strip_non_string_input():
    assert sb.colors.strip(123) == "123"


@patch.object(sys, "platform", "linux")
def test_color_non_windows_wraps():
    res = sb.colors.color("\x1b[31m", "x")
    assert "\x1b[31m" in res
    assert "x" in res
    assert sb.colors.Style.RESET_ALL in res


@patch.object(sys, "platform", "win32")
def test_color_windows_passthrough():
    assert sb.colors.color("\x1b[31m", "x") == "x"


@patch.object(sys, "platform", "linux")
def test_file_color():
    res = sb.colors.file("a")
    assert "a" in res
    assert sb.colors.Fore.BLUE in res
    assert sb.colors.Style.RESET_ALL in res


@patch.object(sys, "platform", "linux")
def test_tool_color():
    res = sb.colors.tool("b")
    assert "b" in res
    assert sb.colors.Fore.CYAN in res


@patch.object(sys, "platform", "linux")
def test_error_color():
    res = sb.colors.error("c")
    assert "c" in res
    assert sb.colors.Fore.RED in res


@patch.object(sys, "platform", "linux")
def test_warning_color():
    res = sb.colors.warning("d")
    assert "d" in res
    assert sb.colors.Fore.YELLOW in res


@patch.object(sys, "platform", "linux")
def test_success_color():
    res = sb.colors.success("e")
    assert "e" in res
    assert sb.colors.Fore.GREEN in res


@patch.object(sys, "platform", "win32")
def test_wrappers_on_windows_passthrough():
    assert sb.colors.file("x") == "x"
    assert sb.colors.tool("x") == "x"
    assert sb.colors.error("x") == "x"
    assert sb.colors.warning("x") == "x"
    assert sb.colors.success("x") == "x"
