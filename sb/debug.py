ENABLED = False


def log(messages):
    if not ENABLED:
        return
    if not isinstance(messages, list):
        messages = [messages]
    for m in messages:
        for line in str(m).splitlines():
            print(f"[DEBUG] {line}")
