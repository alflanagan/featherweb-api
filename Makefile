PIPCOMPILE=pip-compile --generate-hashes

requirements:
	$(PIPCOMPILE) requirements.in
	$(PIPCOMPILE) requirements.dev.in

pip-sync:
	pip-sync requirements.txt requirements.dev.txt

tasks:
	@grep -e '^[^\w]\+:' Makefile | tr -d ':'

pip-init:
	python -m pip install --upgrade pip wheel setuptools pip-tools
