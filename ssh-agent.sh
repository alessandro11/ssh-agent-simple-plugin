SSH_AGENT_PATH="$HOME/.ssh/ssh-agent"
SSH_KEYS="$HOME/.ssh/id_rsa $HOME/.ssh/id_ecdsa"

perr() {
    echo $@ 1>&2
}

get_file_name() {
    local full_path=$1

    echo ${full_path##*/}
}

run_ssh_agent() {
    local var='' pass=''

    #
    # run ssh agent
    #
    eval $(ssh-agent -s)

    #
    # for each defined key on variable at beggining
    # of this file.
    #
    # DO NOT use simple "SSH_KEYS expantion"
    # zsh does not work, it passes as sigle string
	for eachKey in $(echo $SSH_KEYS); do
        #
        # Expect a variable with name of the
        # private ssh key file (e.g id_rsa)
        # with content; the password
        #
        var="\$$(get_file_name $eachKey)"
        eval pass=$var
        if [ -z "$pass" ]; then # password has been defined?
            perr "Error: no pass found for key '$eachKey'!"
        else
            # load dynamically ssh key with the password
            $HOME/.ssh/ssh-pass.exp "$eachKey" "$pass"
            # remove from the env for security purpose
            unset "${var:1}"
        fi
	done

    # create an symbolic link for the ssh agent socket
    # that's the way we detect if the agent is running
	ln -s "$SSH_AUTH_SOCK" "$SSH_AGENT_PATH"
}

#
# Check if our symbolic link exist,
# if yes, check if the env var for the
# auth sock has been defined, if not
# run agent
#
if [ -L "$SSH_AGENT_PATH" ]; then
	SSH_AUTH_SOCK="$(readlink -f $SSH_AGENT_PATH)"
	if [ -z "$SSH_AUTH_SOCK" ]; then
		unlink "$SSH_AGENT_PATH"
		run_ssh_agent
	fi
else # does not exist link; assume agent is not running.
	run_ssh_agent
fi

#
# unset variables
#
unset SSH_AGENT_PATH
unset SSH_KEY

#
# export env with auth sock
#
export SSH_AUTH_SOCK

