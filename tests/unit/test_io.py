import json
import pytest

import sb.errors
import sb.io


def test_read_yaml_ok(tmp_path):
    fn = tmp_path / "x.yaml"
    fn.write_text("a: 1\nb: 2", encoding="utf-8")
    assert sb.io.read_yaml(str(fn)) == {"a": 1, "b": 2}


def test_read_yaml_empty(tmp_path):
    fn = tmp_path / "x.yaml"
    fn.write_text("", encoding="utf-8")
    assert sb.io.read_yaml(str(fn)) == {}


def test_read_yaml_error():
    with pytest.raises(sb.errors.SmartBugsError):
        sb.io.read_yaml("does_not_exist.yaml")


def test_read_json_ok(tmp_path):
    fn = tmp_path / "x.json"
    fn.write_text(json.dumps({"a": 1}), encoding="utf-8")
    assert sb.io.read_json(str(fn)) == {"a": 1}


def test_read_json_error():
    with pytest.raises(sb.errors.SmartBugsError):
        sb.io.read_json("missing.json")


def test_write_json_ok(tmp_path):
    fn = tmp_path / "out.json"
    sb.io.write_json(str(fn), {"b": 2})
    data = json.loads(fn.read_text(encoding="utf-8"))
    assert data == {"b": 2}


def test_write_json_error(monkeypatch):
    def bad_open(*args, **kwargs):
        raise OSError("fail")

    monkeypatch.setattr("builtins.open", bad_open)
    with pytest.raises(sb.errors.SmartBugsError):
        sb.io.write_json("x.json", {"a": 1})


def test_read_lines_ok(tmp_path):
    fn = tmp_path / "x.txt"
    fn.write_text("a\nb\nc", encoding="utf-8")
    assert sb.io.read_lines(str(fn)) == ["a", "b", "c"]


def test_read_lines_error():
    with pytest.raises(sb.errors.SmartBugsError):
        sb.io.read_lines("missing.txt")


def test_write_txt_str(tmp_path):
    fn = tmp_path / "x.txt"
    sb.io.write_txt(str(fn), "hello")
    assert fn.read_text(encoding="utf-8") == "hello"


def test_write_txt_list(tmp_path):
    fn = tmp_path / "x.txt"
    sb.io.write_txt(str(fn), ["a", "b"])
    assert fn.read_text(encoding="utf-8") == "a\nb\n"


def test_write_txt_error(monkeypatch):
    def bad_open(*a, **k):
        raise OSError("x")

    monkeypatch.setattr("builtins.open", bad_open)
    with pytest.raises(sb.errors.SmartBugsError):
        sb.io.write_txt("x.txt", "x")


def test_read_bin_ok(tmp_path):
    fn = tmp_path / "x.bin"
    fn.write_bytes(b"abc")
    assert sb.io.read_bin(str(fn)) == b"abc"


def test_read_bin_error():
    with pytest.raises(sb.errors.SmartBugsError):
        sb.io.read_bin("missing.bin")


def test_write_bin_ok(tmp_path):
    fn = tmp_path / "x.bin"
    sb.io.write_bin(str(fn), b"xyz")
    assert fn.read_bytes() == b"xyz"


def test_write_bin_error(monkeypatch):
    def bad_open(*a, **k):
        raise OSError("x")

    monkeypatch.setattr("builtins.open", bad_open)
    with pytest.raises(sb.errors.SmartBugsError):
        sb.io.write_bin("x.bin", b"x")
