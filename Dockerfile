FROM microsoft/dotnet:2.2-runtime-stretch-slim AS base

RUN apt-get update && \
    apt-get install -y --no-install-recommends unzip procps libgomp1 sudo && \
    rm -rf /var/lib/apt/lists/*

# Create `user` user for container with password `user` and give it password-less sudo access
RUN useradd -m user && \
    echo user:user | chpasswd && \
    cp /etc/sudoers /etc/sudoers.bak && \
    echo 'user  ALL=(root) NOPASSWD: ALL' >> /etc/sudoers
USER user

# Add VS Debugger
RUN curl -sSL https://aka.ms/getvsdbgsh | bash /dev/stdin -v latest -l ~/vsdbg

FROM microsoft/dotnet:2.2-sdk AS build-env
WORKDIR /app
COPY . ./
RUN dotnet restore
RUN dotnet publish -c Debug -o out

FROM base
WORKDIR /app
COPY --from=build-env /app/out ./
RUN sudo cp /app/runtimes/debian.8-x64/native/libz3.so /lib/x86_64-linux-gnu

ENTRYPOINT ["dotnet", "z3core.dll"]
# ENTRYPOINT ["tail", "-f", "/dev/null"]