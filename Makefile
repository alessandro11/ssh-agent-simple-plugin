ifndef XDG_CONFIG_HOME
XDG_CONFIG_HOME  := $(HOME)/.config
endif

PREFIX           := $(HOME)/.local/bin
CWD              := $(shell pwd)
CONFIG           := $(XDG_CONFIG_HOME)/ssh-agent
USERID           := $(shell id -u)
ENTRY_POINT      := .zprofile


.PHONY: install
install:
	@install -Dm0750 $(CWD)/ssh-agent.sh  -t $(PREFIX)/
	@install -Dm0750 $(CWD)/ssh-pass.exp  -t $(PREFIX)/
	@install -Dm0640 $(CWD)/env.sh        -t $(CONFIG)/

	@if ! grep -q "source $(PREFIX)/ssh-agent.sh" $(HOME)/$(ENTRY_POINT); then \
		echo "source $(PREFIX)/ssh-agent.sh" >> $(HOME)/$(ENTRY_POINT); \
	fi

.PHONY: uninstall
uninstall:
	@rm -f $(PREFIX)/ssh-agent.sh
	@rm -f $(PREFIX)/ssh-pass.exp
	@rm -rf $(CONFIG)
	@sed -i "/source $(shell sed 's/\//\\\//g' <<<$(PREFIX)/ssh-agent.sh)/d" $(HOME)/$(ENTRY_POINT)

.PHONY: stop-agent
stop-agent:
	@kill $(shell pgrep ssh-agent)
	@unlink /run/user/$(USERID)/ssh-agent
