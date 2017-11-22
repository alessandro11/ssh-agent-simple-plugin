SSH_AGENT_PATH="$HOME/.ssh/ssh-agent"
SSH_KEY="$HOME/.ssh/id_rsa $HOME/.ssh/id_rsa.ae11@mumm"

run_ssh_agent() {
	eval $(ssh-agent)
	for eachKey in `echo "$SSH_KEY"`; do
		ssh-add "$eachKey";
	done
	ln -s "$SSH_AUTH_SOCK" "$SSH_AGENT_PATH"
}

if [ -L "$SSH_AGENT_PATH" ]; then
	SSH_AUTH_SOCK="$(readlink -f $SSH_AGENT_PATH)"
	if [ -z "$SSH_AUTH_SOCK" ]; then
		unlink "$SSH_AGENT_PATH"
		run_ssh_agent
	fi
else
	run_ssh_agent
fi
unset SSH_AGENT_PATH
unset SSH_KEY

export SSH_AUTH_SOCK

export PATH=$PATH:$HOME/.local/bin
