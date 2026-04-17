import json
import pytest
import codecs

import sb.io
import sb.errors


def test_read_bin_ok(tmp_path):
    fn = tmp_path / "a.bin"
    fn.write_bytes(b"abc")
    assert sb.io.read_bin(fn) == b"abc"


def test_read_bin_error():
    with pytest.raises(sb.errors.SmartBugsError):
        sb.io.read_bin("missing.bin")


def test_read_text_utf8(tmp_path):
    fn = tmp_path / "a.txt"
    fn.write_bytes(b"hello")
    assert sb.io.read_text(fn) == "hello"


def test_read_text_utf8_bom(tmp_path):
    fn = tmp_path / "a.txt"
    fn.write_bytes(codecs.BOM_UTF8 + b"x")
    assert sb.io.read_text(fn) == "x"


def test_read_text_utf16_le_bom(tmp_path):
    fn = tmp_path / "a.txt"
    fn.write_bytes(codecs.BOM_UTF16_LE + "abc".encode("utf-16-le"))
    assert sb.io.read_text(fn) == "abc"


def test_read_text_utf16_be_bom(tmp_path):
    fn = tmp_path / "a.txt"
    fn.write_bytes(codecs.BOM_UTF16_BE + "abc".encode("utf-16-be"))
    assert sb.io.read_text(fn) == "abc"


def test_read_text_error():
    with pytest.raises(sb.errors.SmartBugsError):
        sb.io.read_text("missing.txt")


def test_read_lines(tmp_path):
    fn = tmp_path / "a.txt"
    fn.write_text("a\nb\nc", encoding="utf-8")
    assert sb.io.read_lines(fn) == ["a", "b", "c"]


def test_read_json(tmp_path):
    fn = tmp_path / "a.json"
    fn.write_text(json.dumps({"a": 1}), encoding="utf-8")
    assert sb.io.read_json(fn) == {"a": 1}


def test_read_json_error():
    with pytest.raises(sb.errors.SmartBugsError):
        sb.io.read_json("missing.json")


def test_read_yaml(tmp_path):
    fn = tmp_path / "a.yaml"
    fn.write_text("a: 1", encoding="utf-8")
    assert sb.io.read_yaml(fn) == {"a": 1}


def test_read_yaml_empty(tmp_path):
    fn = tmp_path / "a.yaml"
    fn.write_text("", encoding="utf-8")
    assert sb.io.read_yaml(fn) == {}


def test_write_bin(tmp_path):
    fn = tmp_path / "b.bin"
    sb.io.write_bin(fn, b"xyz")
    assert fn.read_bytes() == b"xyz"


def test_write_bin_error(monkeypatch):
    def bad_open(*a, **k):
        raise OSError("fail")
    monkeypatch.setattr("builtins.open", bad_open)
    with pytest.raises(sb.errors.SmartBugsError):
        sb.io.write_bin("x.bin", b"x")


def test_write_text_str(tmp_path):
    fn = tmp_path / "t.txt"
    sb.io.write_text(fn, "hello")
    assert fn.read_text(encoding="utf-8") == "hello"


def test_write_text_list(tmp_path):
    fn = tmp_path / "t.txt"
    sb.io.write_text(fn, ["a", "b"])
    assert fn.read_text(encoding="utf-8") == "a\nb\n"


def test_write_text_error(monkeypatch):
    def bad_open(*a, **k):
        raise OSError("fail")
    monkeypatch.setattr("builtins.open", bad_open)
    with pytest.raises(sb.errors.SmartBugsError):
        sb.io.write_text("t.txt", "hello")


def test_write_json(tmp_path):
    fn = tmp_path / "j.json"
    sb.io.write_json(fn, {"b": 2})
    data = json.loads(fn.read_text(encoding="utf-8"))
    assert data == {"b": 2}


def test_write_json_error(monkeypatch):
    def bad_open(*a, **k):
        raise OSError("fail")
    monkeypatch.setattr("builtins.open", bad_open)
    with pytest.raises(sb.errors.SmartBugsError):
        sb.io.write_json("x.json", {"a": 1})
