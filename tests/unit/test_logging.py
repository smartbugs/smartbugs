import os
import threading
import tempfile
from multiprocessing import Queue
from unittest.mock import patch

import sb.colors
import sb.logging


def test_stop_logger_without_starting_it():
    q = Queue()
    sb.logging.stop(q)
    assert sb.logging.logger is None


def test_logger_process_write_and_stop():
    q = Queue()
    with tempfile.TemporaryDirectory() as d:
        fn = os.path.join(d, "log.txt")

        prolog = ["p1", "p2"]
        q.put("x")
        q.put("y")
        q.put(None)

        sb.logging.logger_process(fn, overwrite=True, queue=q, prolog=prolog)

        with open(fn) as f:
            lines = f.read().splitlines()

        assert lines == ["p1", "p2", "x", "y"]


def test_logger_process_write_local_and_stop():
    q = Queue()
    with tempfile.TemporaryDirectory() as d:
        os.chdir(d)
        fn = "log.txt"

        prolog = ["p1", "p2"]
        q.put("x")
        q.put("y")
        q.put(None)

        sb.logging.logger_process(fn, overwrite=True, queue=q, prolog=prolog)

        with open(fn) as f:
            lines = f.read().splitlines()

        assert lines == ["p1", "p2", "x", "y"]


def test_start_creates_thread():
    q = Queue()
    with tempfile.TemporaryDirectory() as d:
        fn = os.path.join(d, "log.txt")

        sb.logging.start(fn, append=False, queue=q)

        assert isinstance(sb.logging.logger, threading.Thread)
        assert sb.logging.logger.is_alive()

        q.put(None)
        sb.logging.logger.join()


def test_message_console_and_queue(capsys):
    q = Queue()

    with patch("sb.colors.strip", return_value="LOGGED"):
        sb.logging.quiet = False
        sb.logging.message(con="COUT", log="", queue=q)

    out = capsys.readouterr().out
    assert "COUT" in out

    assert q.get() == "LOGGED"


def test_message_console_suppressed():
    q = Queue()
    sb.logging.quiet = True

    sb.logging.message(con="X", log="Y", queue=q)

    # nothing printed
    # queue receives "Y"
    assert q.get() == "Y"


def test_message_prolog_when_no_queue():
    sb.logging.__prolog.clear()
    sb.logging.quiet = True

    sb.logging.message(con=None, log="A", queue=None)

    assert sb.logging.__prolog == ["A"]


def test_message_appends_nonempty_log_to_queue():
    q = Queue()
    sb.logging.message(con=None, log="Z", queue=q)
    assert q.get() == "Z"


def test_message_empty_con_log_ignored():
    q = Queue()
    q.put("something")
    sb.logging.message(con="", log="", queue=q)
    assert q.get() == "something"


def test_stop_sends_none_and_joins():
    q = Queue()
    with tempfile.TemporaryDirectory() as d:
        fn = os.path.join(d, "log.txt")

        sb.logging.start(fn, append=False, queue=q)
        sb.logging.stop(q)

        assert sb.logging.logger is not None
        assert not sb.logging.logger.is_alive()
