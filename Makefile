CWD = $(shell pwd)

install:
	ln --symbolic --force $(CWD)/ssh-agent.incsh ~/.ssh-agent.incsh

uninstall:
	unlink ~/.ssh-agent.incsh

