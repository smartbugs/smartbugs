# This is a sample file showing how to call SmartBugs
# from a Python script.

import sb.smartbugs, sb.settings, sb.exceptions
if __name__ == "__main__":
    settings = sb.settings.Settings()
    settings.update({
        "tools": ["conkas"],
        "files": ["samples/simple_dao.*"],
        #"quiet": True # suppress output on stdout
    })
    try:
        sb.smartbugs.main(settings)
    except sb.exceptions.SmartBugsError as e:
        print(f"Something didn't work: {e}")
