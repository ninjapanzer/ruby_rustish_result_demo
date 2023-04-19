SHELL := /bin/sh

run:
	@ruby main.rb

asdf-setup:
	asdf plugin add ruby || true
	asdf install ruby

.PHONY: run asdf-setup

