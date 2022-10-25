import yaml, json
from sb.exceptions import SmartBugsError

def read_yaml(fn):
    try:
        with open(fn, 'r', encoding='utf-8') as f:
            # for an empty file, return empty dict, not NoneType
            return yaml.safe_load(f) or {}
    except Exception as e:
        raise SmartBugsError(f"Error reading '{fn}'.\n{e}")

def read_json(fn):
    try:
        with open(fn, 'r', encoding='utf-8') as f:
            return json.load(f)
    except Exception as e:
        raise SmartBugsError(f"Error reading '{fn}'.\n{e}")

def write_json(fn, output):
    try:
        j = json.dumps(output, sort_keys=True, indent=4)
        with open(fn, 'w', encoding='utf-8') as f:
            print(j, file=f)
    except Exception as e:
        raise SmartBugsError(f"Error writing '{fn}'.\n{e}")

def read_lines(fn):
    try:
        with open(fn, 'r', encoding='utf-8') as f:
            return f.readlines()
    except Exception as e:
        raise SmartBugsError(f"Error reading '{fn}'.\n{e}")

def write_txt(fn, output):
    try:
        with open(fn, 'w', encoding='utf-8') as f:
            if isinstance(output, str):
                f.write(output)
            else:
                for line in output:
                    f.write(f"{line}\n")
    except Exception as e:
        raise SmartBugsError(f"Error writing '{fn}'.\n{e}")

def write_bin(fn, output):
    try:
        with open(fn, 'wb') as f:
            for chunk in output:
                f.write(chunk)
    except Exception as e:
        raise SmartBugsError(f"Error writing '{fn}'.\n{e}")

