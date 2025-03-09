# Sam's SSH (SSSH)
# SSH wrapper that prompts to delete invalid known hosts keys
# Author: sam.k.tan@oracle.com

sssh () {
	# save the input parameters
	PARAMS="$*"

	# get the paths to the executables
	SSH="/usr/bin/ssh"
	SSHKEYGEN="/usr/bin/ssh-keygen"
	SSSH="::::"

	echo "${SSSH} Sam's SSH by sam.k.tan@oracle.com"

	# run SSH with the given parameters
	${SSH} ${PARAMS}
	# if SSH did not exit with status code 255 ...
	RC=$? && [ ${R} -ne 255 ] && return ${RC}

	# extract the hostname from the SSH parameters
	HOST=$(${SSH} -G ${PARAMS} | grep -i '^hostname' | cut -d ' ' -f2)
	# check if hostname exists in known_hosts file
	${SSHKEYGEN} -F ${HOST} > /dev/null 2>&1
	# if hostname does not exist, then exit
	[ $? -ne 0 ] && return ${RC}

	# since hostname exists, ask to delete and try again
	echo "${SSSH} Matching hostname found in known_hosts file."
	echo "${SSSH} Do you want to remove the offending host key(s) and retry the connection?"
	echo "${SSSH} Only YES is accepted, any other key to cancel."
	read R

	[ "xx${R}xx" != "xxYESxx" ] && return ${RC}
	${SSHKEYGEN} -R ${HOST}
	${SSH} ${PARAMS}
}
alias ssh=sssh
