# This version is only compatible with zsh, since the line of the script:
# for eachKey in $(echo $SSH_KEYS); do does not interact in bash,
#it returns a single string

#
# Load configs either from the default config path or defined on XDG_CONFIG_HOME
# https://wiki.archlinux.org/title/XDG_Base_Directory
if [ -z "$XDG_CONFIG_HOME" ]; then
    source "${HOME}/.config/ssh-agent/env.sh"
else
    source "${XDG_CONFIG_HOME}/ssh-agent/env.sh"
fi

perr() {
    echo $@ 1>&2
}

get_file_name() {
    local full_path=$1

    echo ${full_path##*/}
}

run_ssh_agent() {
    local pvt_key_path_filename='' pass_filename='' pass=''

    #
    # run ssh agent
    #
    eval $(ssh-agent -s)

    #
    # Interact on each pair of variables defined as csv.
    # Definition of a pair in a csv
    # filename2pass:PATH_FILE_NAME1,filename2pass:PATH_FILE_NAME2, ... ,filename2pass:PATH_FILE_NAMEn
    # WHERE:
    #  filename2pass is the file name at $HOME dir with the password only
    #  PATH_FILE_NAME is absolute path to the private ssh key
    #
    IFS_BACKUP=$IFS
    IFS=','
	  for eachKey in $(echo $SSH_KEYS); do
        IFS=':' read pass_filename pvt_key_path_filename <<<$eachKey
        #
        # Expected the file at the HOME dir; read the password defined
        #
        read pass < ${HOME}/${pass_filename}
        if [ -z "$pass" ]; then # password has been defined?
            perr "Error: no pass found for private key '$pvt_key_path_filename'!"
        else
            # load dynamically ssh key with the password
            ssh-pass.exp "$pvt_key_path_filename" "$pass"
        fi
	  done
    IFS=$IFS_BACKUP

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

