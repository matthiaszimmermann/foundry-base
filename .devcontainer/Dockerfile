ARG DEBIAN_VERSION=bookworm
ARG UV_VERSION=0.5.9
ARG PYTHON_VERSION=3.13

FROM ghcr.io/astral-sh/uv:$UV_VERSION AS uv

FROM mcr.microsoft.com/vscode/devcontainers/base:$DEBIAN_VERSION
LABEL maintainer="matthias zimmermann <zimmermann@xbrain.com>"

# Switch to the vscode user for installations below
USER vscode
WORKDIR /home/vscode

# Install UV/Python
COPY --from=uv --chown=vscode: /uv /uvx /bin/
RUN uv python install $PYTHON_VERSION

# Install Foundry
RUN curl -L https://foundry.paradigm.xyz | bash && /home/vscode/.foundry/bin/foundryup
ENV PATH="/home/vscode/.foundry/bin:$PATH"

# RUN $HOME/.foundry/bin/foundryup
