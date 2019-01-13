# Introduction
This is an example of running Z3 in a Docker container.
# Build and Run
Start docker and execute the following commands to build the image
```
docker build -t z3demo .
docker run -d z3demo
```

Get the ID of the container from the response and view the logs:

```
docker logs <container_id>
```
