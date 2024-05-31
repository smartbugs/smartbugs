#!/usr/bin/env python

import docker

print("get handle to communicate with docker")
client = docker.from_env()

print("testing the communication")
client.info()

print("load a sample image")
image = "hello-world"
client.images.pull(image)

image_list = client.images.list(image)
if image_list:
    print(f"image {image} has been loaded")
else:
    print(f"loading of {image} failed")

print("run the container, retrieve the output, and print the second line")
container = client.containers.run(image="hello-world", detach=True)
logs = container.logs().decode("utf8").splitlines()
print(f"*** {logs[1]} ***")

print("cleaning up")
container.stop()
try:
    container.kill()
    print("container shouldn't have been running anymore")
except:
    pass
container.remove()
