CWD = $(shell pwd)

install:
	ln --symbolic --force $(CWD)/ssh-agent.sh ~/.ssh-agent.sh

uninstall:
	unlink ~/.ssh-agent.sh
