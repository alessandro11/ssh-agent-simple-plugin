# Symbolic link to the ssh-agent socket
SSH_AGENT_PATH="/run/user/$(id -u)/ssh-agent"

# Define a pair of a csv list filename2pass:PATH_FILE_NAME1,filename2pass:PATH_FILE_NAME2, ... ,filename2pass:PATH_FILE_NAMEn
# WHERE:
#  filename2pass is the file name at $HOME dir with the password only
#  PATH_FILE_NAME is absolute path to the private ssh key
SSH_KEYS=".ecdsa-m3coolAtxps_m3cool:${HOME}/.ssh/id_ecdsa,.alessandro_eliasAteposnow_com:${HOME}/.ssh/eposnow/id_ecdsa"
