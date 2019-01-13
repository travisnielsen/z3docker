FROM microsoft/dotnet:2.2-runtime-stretch-slim AS base

RUN apt-get update && \
    apt-get install -y --no-install-recommends unzip procps libgomp1 && \
    rm -rf /var/lib/apt/lists/*

RUN useradd -ms /bin/bash moduleuser
USER moduleuser

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

# currently required for z3lib.so to be located. Possible fix in nuget package at a future point
ENV LD_LIBRARY_PATH=/app/runtimes/debian.8-x64/native

ENTRYPOINT ["dotnet", "z3core.dll"]