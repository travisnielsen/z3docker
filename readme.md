# Introduction
This is an example of running Z3 in a Docker container.
# Build and Run
Start docker and execute the following commands to build the image
```
docker build -t z3demo .
docker run -d z3demo
```

Get the ID of the container from the response and attach to it via:

```
docker exec -it <container_id> "/bin/bash"
```
When inside the container, you have the ability to execute the code via dotnet CLI comamnds.