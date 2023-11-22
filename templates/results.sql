CREATE TABLE results (
    filename TEXT,
    basename TEXT,
    toolid TEXT,
    toolmode TEXT,
    parser_version TEXT,
    runid TEXT,
    start NUMERIC,
    duration NUMERIC,
    exit_code INTEGER,
    findings TEXT[],
    infos TEXT[],
    errors TEXT[],
    fails TEXT[],
    PRIMARY KEY (filename, toolid, toolmode, parser_version, runid)
);
