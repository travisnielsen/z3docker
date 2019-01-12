FROM ubuntu:xenial

RUN apt-get update && \
    apt-get install -y --no-install-recommends wget \
    unzip \
    procps \ 
    sudo \
    liblttng-ust0 \
    libcurl3 \
    libssl1.0.0 \
    libkrb5-3 \
    zlib1g \
    libicu55 \
    nano \
    apt-transport-https \
    ca-certificates \
    apt-utils && \
    rm -rf /var/lib/apt/lists/*

# Create `user` user for container with password `user`.  and give it
# password-less sudo access
RUN useradd -m user && \
    echo user:user | chpasswd && \
    cp /etc/sudoers /etc/sudoers.bak && \
    echo 'user  ALL=(root) NOPASSWD: ALL' >> /etc/sudoers
USER user

WORKDIR /home/user

# Download and install the .Net SDK
RUN wget --no-check-certificate https://packages.microsoft.com/config/ubuntu/16.04/packages-microsoft-prod.deb && \ 
    sudo dpkg -i packages-microsoft-prod.deb
RUN sudo apt-get update && sudo apt-get install -y dotnet-sdk-2.2

COPY . /home/user
RUN sudo dotnet restore
RUN sudo dotnet publish -c Debug -o out

# ENTRYPOINT ["dotnet", "z3core.dll"]
ENTRYPOINT ["tail", "-f", "/dev/null"]