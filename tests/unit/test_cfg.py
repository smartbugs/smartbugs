import sb.cfg


def test_constants_defined():
    assert {
        "CPU",
        "HOME",
        "PARSER_OUTPUT",
        "PLATFORM",
        "Path",
        "SARIF_OUTPUT",
        "SB_HOME",
        "SB_LOCAL",
        "SB_VERSION",
        "SITE_CFG",
        "SOLC",
        "TASK_LOG",
        "TOOLS_HOME",
        "TOOLS_LOCAL",
        "TOOL_CONFIG",
        "TOOL_FINDINGS",
        "TOOL_LOG",
        "TOOL_OUTPUT",
        "TOOL_PARSER",
        "UNAME",
        "USER_CFG",
    }.issubset(set(dir(sb.cfg)))
    assert {
        "smartbugs",
        "python",
        "system",
        "release",
        "version",
        "machine",
        "host",
        "user",
        "cpu",
    } == set(sb.cfg.PLATFORM.keys())
