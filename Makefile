PIP_COMPILE=pip-compile --generate-hashes

requirements:
	$(PIP_COMPILE) requirements.in
	$(PIP_COMPILE) requirements.dev.in

pip-sync:
	pip-sync requirements.txt requirements.dev.txt

tasks:
	@grep -e '^[^\w]\+:' Makefile | tr -d ':'

pip-init:
	python -m pip install --upgrade pip wheel setuptools pip-tools

dev:
	docker compose run --service-ports --rm featherweb /usr/bin/zsh

stop:
	docker compose down --remove-orphans

build:
	docker compose build
