import os, string
import sb.io, sb.config
from sb.exceptions import SmartBugsError, InternalError

FIELDS = ("id","path","mode","image","name","origin","version","info","parser",
    "output","bin","solc","user","cpu_quota","mem_limit","command","entrypoint")

class Tool():

    def __init__(self, cfg):
        for k in FIELDS:
            v = cfg.get(k)
            if v is not None:
                if k in ("solc"):
                    try:
                        v = bool(v)
                    except:
                        raise SmartBugsError(f"Tool: value of attribute '{k}' is not a Boolean.\n{cfg}")
                elif k in ("user","cpu_quota"):
                    try:
                        v = int(v)
                        assert v >= 0
                    except:
                        raise SmartBugsError(f"Tool: value of attribute '{k}' is not an integer>=0.\n{cfg}")
                elif k in ("mem_limit"):
                    try:
                        v = str(v).replace(" ","")
                        if v[-1] in "kKmMgG":
                            assert int(v[:-1]) > 0
                        else:
                            assert int(v) > 0
                    except:
                        raise SmartBugsError(f"Tool: value of attribute '{k}' is not a valid memory specifcation.\n{cfg}")
                else:
                    try:
                        v = str(v)
                    except:
                        raise SmartBugsError(f"Tool: value of attribute '{k}' is not a string.\n{cfg}")
            if k in ("command","entrypoint"):
                k = f"_{k}"
                v = string.Template(v) if v else None
            setattr(self, k, v)
                
        for k in ("id", "mode"):
            if not getattr(self, k):
                raise InternalError(f"Tool: Field '{k}' missing.\n{cfg}")
        if not self.image:
            raise SmartBugsError(f"Tool {self.id}/{self.mode}: no image specified")
        extras = set(cfg.keys()).difference(FIELDS)
        if extras:
            raise SmartBugsError(f"Tool {self.id}/{self.mode}: extra field(s) {', '.join(extras)}")
        if not self._command and not self._entrypoint:
            raise SmartBugsError(f"Tool {self.id}/{self.mode}: neither command nor entrypoint specified.")
        if not self.parser:
            self.parser = sb.config.TOOL_PARSER
        if self.bin:
            self.absbin = os.path.join(sb.config.TOOLS_HOME,self.id,self.bin)


    def command(self, filename, timeout, bin):
        try:
            return self._command.substitute(FILENAME=filename, TIMEOUT=timeout, BIN=bin) if self._command else None
        except KeyError as e:
            raise SmartBugsError(f"Unknown variable '{e}' in command of tool {self.id}/{self.mode}")

    def entrypoint(self, filename, timeout, bin):
        try:
            return self._entrypoint.substitute(FILENAME=filename, TIMEOUT=timeout, BIN=bin) if self._entrypoint else None
        except KeyError as e:
            raise SmartBugsError(f"Unknown variable '{e}' in entrypoint of tool {self.id}/{self.mode}")

    def dict(self):
        d = {}
        for k,v in self.__dict__.items():
            if k == "_command":
                d["command"] = self._command.template if self._command else None
            elif k == "_entrypoint":
                d["entrypoint"] = self._entrypoint.template if self._entrypoint else None
            elif k == "absbin":
                # We do not want to leak private information like the full path
                pass
            else:
                d[k] = v
        return d

    def __str__(self):
        l = [ f"{k}: {str(v)}" for k,v in self.dict().items() ]
        return f"{{{', '.join(l)}}}"



def load(ids, tools=[], seen=set()):
    if isinstance(ids, str):
        ids = [ids]

    for id in ids:
        if id in seen:
            continue
        seen.add(id)
        toolpath = os.path.join(sb.config.TOOLS_HOME, id)
        fn = os.path.join(toolpath, sb.config.TOOL_CONFIG)
        cfg = sb.io.read_yaml(fn)

        alias = cfg.get("alias")
        if alias:
            load(alias, tools, seen)
            continue

        cfg["id"] = id
        found = False
        for mode in ("solidity", "bytecode", "runtime"):
            if mode not in cfg:
                continue
            found = True
            cfg_copy = cfg.copy()
            for m in ("solidity", "bytecode", "runtime"):
                cfg_copy.pop(m,None)
            cfg_copy["mode"] = mode
            if not isinstance(cfg[mode], dict):
                raise SmartBugsError(f"Tool {id}/{mode}: key/value mapping expected.")
            cfg_copy.update(cfg[mode])
            tools.append(Tool(cfg_copy))
        if not found:
            raise SmartBugsError(f"{fn}: needs one of the attributes 'alias', 'solidity', 'bytecode', 'runtime'")
    return tools



# the contents of tools/.../findings.yaml is cached, once per process
info_findings = {}

def info_finding(tool_id, fname):
    if tool_id not in info_findings:
        try:
            fn = os.path.join(sb.config.TOOLS_HOME, tool_id, sb.config.TOOL_FINDINGS)
            info_findings[tool_id] = sb.io.read_yaml(fn)
        except Exception:
            info_findings[tool_id] = {}
    return info_findings[tool_id].get(fname, {})
