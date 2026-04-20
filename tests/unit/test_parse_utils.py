import sb.parse_utils


def test_docker_codes_contains_expected_mappings():
    assert sb.parse_utils.DOCKER_CODES[125] == "DOCKER_INVOCATION_PROBLEM"
    assert sb.parse_utils.DOCKER_CODES[126] == "DOCKER_CMD_NOT_EXECUTABLE"
    assert sb.parse_utils.DOCKER_CODES[127] == "DOCKER_CMD_NOT_FOUND"
    assert sb.parse_utils.DOCKER_CODES[137] == "DOCKER_KILL_OOM"
    assert sb.parse_utils.DOCKER_CODES[139] == "DOCKER_SEGV"
    assert sb.parse_utils.DOCKER_CODES[143] == "DOCKER_TERM"


def test_discard_ansi_removes_escape_sequences():
    lines = [
        "\x1b[31merror\x1b[0m\n",
        "plain\n",
        "\x1b[1;32msuccess\x1b[0m",
    ]

    result = list(sb.parse_utils.discard_ansi(lines))

    assert result == [
        "error\n",
        "plain\n",
        "success",
    ]


def test_discard_ansi_returns_generator():
    result = sb.parse_utils.discard_ansi(["x"])
    assert iter(result) is result


def test_truncate_message_returns_original_when_shorter_than_limit():
    message = "short message"
    assert sb.parse_utils.truncate_message(message, length=20) == message


def test_truncate_message_returns_original_when_equal_to_limit():
    message = "x" * 10
    assert sb.parse_utils.truncate_message(message, length=10) == message


def test_truncate_message_truncates_middle_when_too_long():
    message = "abcdefghijklmnopqrstuvwxyz"
    assert sb.parse_utils.truncate_message(message, length=15) == "abcde ... vwxyz"


def test_truncate_message_uses_default_length():
    message = "a" * 300
    result = sb.parse_utils.truncate_message(message)
    half_length = (205 - 5) // 2

    assert len(result) == 205
    assert result == ("a" * half_length) + " ... " + ("a" * half_length)


def test_exceptions_detects_python_traceback_exception():
    lines = [
        "some log line",
        sb.parse_utils.TRACEBACK,
        '  File "script.py", line 1, in <module>',
        "ValueError: bad value",
        "afterwards",
    ]

    result = sb.parse_utils.exceptions(lines)

    assert result == {"exception (ValueError: bad value)"}


def test_exceptions_ignores_indented_traceback_lines_until_non_indented():
    lines = [
        sb.parse_utils.TRACEBACK,
        '  File "a.py", line 1',
        '  File "b.py", line 2',
        "RuntimeError: boom",
    ]

    result = sb.parse_utils.exceptions(lines)

    assert result == {"exception (RuntimeError: boom)"}


def test_exceptions_does_not_add_anything_for_traceback_without_final_exception():
    lines = [
        sb.parse_utils.TRACEBACK,
        '  File "script.py", line 1',
        "  more indented output",
    ]

    assert sb.parse_utils.exceptions(lines) == set()


def test_exceptions_detects_shell_java_and_rust_patterns():
    lines = [
        "foo line 12: Segmentation fault",
        'Exception in thread "main" boom happened',
        "com.example.MyException: java issue",
        "thread 'worker-1' panicked at 'rust issue'",
    ]

    result = sb.parse_utils.exceptions(lines)

    assert result == {
        "exception (Segmentation fault)",
        "exception (boom happened)",
        "exception (java issue)",
        "exception (rust issue)",
    }


def test_exceptions_collects_unique_matches_only():
    lines = [
        "foo line 1: Killed",
        "foo line 2: Killed",
        'Exception in thread "main" repeated',
        'Exception in thread "worker" repeated',
    ]

    result = sb.parse_utils.exceptions(lines)

    assert result == {
        "exception (Killed)",
        "exception (repeated)",
    }


def test_add_match_adds_first_matching_group_and_returns_true():
    patterns = [
        sb.parse_utils.re.compile(r"^ERR: (.*)$"),
        sb.parse_utils.re.compile(r"^WARN: (.*)$"),
    ]
    matches = set()

    result = sb.parse_utils.add_match(matches, "ERR: failed", patterns)

    assert result is True
    assert matches == {"failed"}


def test_add_match_stops_after_first_match():
    patterns = [
        sb.parse_utils.re.compile(r"^(.*)$"),
        sb.parse_utils.re.compile(r"^(.+)$"),
    ]
    matches = set()

    result = sb.parse_utils.add_match(matches, "line", patterns)

    assert result is True
    assert matches == {"line"}


def test_add_match_returns_false_when_no_pattern_matches():
    patterns = [sb.parse_utils.re.compile(r"^ERR: (.*)$")]
    matches = set()

    result = sb.parse_utils.add_match(matches, "INFO: ok", patterns)

    assert result is False
    assert matches == set()


def test_errors_fails_none_exit_code_adds_timeout():
    errors, fails = sb.parse_utils.errors_fails(None, [], log_expected=True)

    assert errors == set()
    assert fails == {"DOCKER_TIMEOUT"}


def test_errors_fails_zero_exit_code_with_no_log_and_log_expected_adds_execution_failed():
    errors, fails = sb.parse_utils.errors_fails(0, [], log_expected=True)

    assert errors == set()
    assert fails == {"execution failed"}


def test_errors_fails_zero_exit_code_with_no_log_and_log_not_expected_adds_nothing():
    errors, fails = sb.parse_utils.errors_fails(0, [], log_expected=False)

    assert errors == set()
    assert fails == set()


def test_errors_fails_exit_code_127_uses_special_message():
    errors, fails = sb.parse_utils.errors_fails(127, [], log_expected=True)

    assert errors == set()
    assert fails == {
        "SmartBugs was invoked with option 'main', but the filename did not match any contract"
    }


def test_errors_fails_known_docker_code_maps_to_fail():
    errors, fails = sb.parse_utils.errors_fails(137, [], log_expected=True)

    assert errors == set()
    assert fails == {"DOCKER_KILL_OOM"}


def test_errors_fails_signal_range_maps_to_received_signal():
    errors, fails = sb.parse_utils.errors_fails(130, [], log_expected=True)

    assert errors == set()
    assert fails == {"DOCKER_RECEIVED_SIGNAL_2"}


def test_errors_fails_other_nonzero_exit_code_adds_error():
    errors, fails = sb.parse_utils.errors_fails(5, [], log_expected=True)

    assert errors == {"EXIT_CODE_5"}
    assert fails == {"execution failed"}


def test_errors_fails_with_log_adds_detected_exceptions_and_not_execution_failed():
    log = [
        "foo line 12: Segmentation fault",
        'Exception in thread "main" java boom',
    ]

    errors, fails = sb.parse_utils.errors_fails(0, log, log_expected=True)

    assert errors == set()
    assert fails == {
        "exception (Segmentation fault)",
        "exception (java boom)",
    }


def test_errors_fails_combines_exit_code_error_with_logged_exceptions():
    log = [
        sb.parse_utils.TRACEBACK,
        '  File "x.py", line 1',
        "ValueError: boom",
    ]

    errors, fails = sb.parse_utils.errors_fails(9, log, log_expected=True)

    assert errors == {"EXIT_CODE_9"}
    assert fails == {"exception (ValueError: boom)"}


def test_errors_fails_log_present_but_no_exceptions_produces_no_execution_failed():
    errors, fails = sb.parse_utils.errors_fails(0, ["normal output"], log_expected=True)

    assert errors == set()
    assert fails == set()


def test_errors_fails_timeout_with_log_includes_timeout_and_exceptions():
    log = ["thread 'main' panicked at 'bad things'"]

    errors, fails = sb.parse_utils.errors_fails(None, log, log_expected=True)

    assert errors == set()
    assert fails == {"DOCKER_TIMEOUT", "exception (bad things)"}
