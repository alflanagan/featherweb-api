FROM python:3.10.0-slim-bullseye

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y curl xz-utils postgresql-client zsh zsh-doc git sudo \
    && apt-get autoremove && apt-get clean

# 16.13.1 is lts/gallium now
ENV NODE_VERSION=16.13.1 NODE_ARCH=x64
RUN curl -fsSLO --compressed "https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION-linux-$NODE_ARCH.tar.xz" \
  && tar -xJf "node-v$NODE_VERSION-linux-$NODE_ARCH.tar.xz" -C /usr/local --strip-components=1 --no-same-owner \
  && rm "node-v$NODE_VERSION-linux-$NODE_ARCH.tar.xz" \
  && ln -s /usr/local/bin/node /usr/local/bin/nodejs \
  && node --version \
  && npm --version

RUN useradd -G sudo -s /usr/bin/zsh -m feather

RUN mkdir -p /app

RUN chown feather /app

USER feather

WORKDIR /app

COPY Makefile requirements.txt requirements.dev.txt LICENSE README.md .zshrc.extra ./

RUN python -m venv .venv
RUN . .venv/bin/activate && python -m pip install -U pip wheel pip-tools
RUN . .venv/bin/activate && pip-sync requirements.txt requirements.dev.txt

COPY --chown=feather ./featherweb/ /app/featherweb/
WORKDIR /app/featherweb/

RUN sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
RUN echo "if [ -f '/app/.venv/bin/activate' ]; then source /app/.venv/bin/activate; fi" >> ~/.zshrc
RUN cat /app/.zshrc.extra >> ~/.zshrc && rm /app/.zshrc.extra
