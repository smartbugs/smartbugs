import yaml, json, tomllib
from sb.exceptions import SmartBugsError

def read_yaml(fn):
    try:
        with open(fn, 'r', encoding='utf-8') as f:
            # for an empty file, return empty dict, not NoneType
            return yaml.safe_load(f) or {}
    except BaseException as e:
        raise SmartBugsError(f"Error reading '{fn}'.\n{e}")

def read_json(fn):
    try:
        with open(fn, 'r', encoding='utf-8') as f:
            return json.load(f)
    except BaseException as e:
        raise SmartBugsError(f"Error reading '{fn}'.\n{e}")

def write_json(fn, output):
    try:
        j = json.dumps(output, sort_keys=True, indent=4)
        with open(fn, 'w', encoding='utf-8') as f:
            print(j, file=f)
    except BaseException as e:
        raise SmartBugsError(f"Error writing '{fn}'.\n{e}")

def read_lines(fn):
    try:
        with open(fn, 'r', encoding='utf-8') as f:
            return f.readlines()
    except BaseException as e:
        raise SmartBugsError(f"Error reading '{fn}'.")

def write_txt(fn, output):
    try:
        with open(fn, 'w', encoding='utf-8') as f:
            if isinstance(output, str):
                f.write(output)
            else:
                for line in output:
                    print(line, file=f)
    except BaseException as e:
        raise SmartBugsError(f"Error writing '{fn}'.")

def write_bin(fn, output):
    try:
        with open(fn, 'wb') as f:
            for chunk in output:
                f.write(chunk)
    except BaseException as e:
        raise SmartBugsError(f"Error writing '{fn}'.")

