# set default locale settings
typeset +x LANG=C

# set prompt
typeset +x PS1="\u@\h:\w\\$ "

# check for OWAN proxy server
check_proxy () {
	# detect and set proxy server settings
	PROXYHOST="www-proxy.us.oracle.com"
	PROXYPORT="80"
	
	echo "Checking for proxy server $PROXYHOST ..."
	ping -c 3 $PROXYHOST > /dev/null 2>&1
	
	if [ $? -ne 0 ]; then
		echo "Proxy server ${PROXYHOST} not reachable."
		unset http_proxy
		unset https_proxy
	else
		echo "Setting proxy server ..."
		export http_proxy="http://${PROXYHOST}:${PROXYPORT}"
		export https_proxy=$http_proxy
		export no_proxy=".oracle.com,.oraclecorp.com,identity.oraclecloud.com"
	fi
}
check_proxy

# add common utilities
[ -d $HOME/commons/bin ] && export PATH=$HOME/commons/bin:$PATH
[ -x $HOME/commons/bin/sssh ] && alias ssh=$HOME/commons/bin/sssh

# enable homebrew
[ -d /opt/homebrew/bin ] && eval "$(/opt/homebrew/bin/brew shellenv)"

# configuration settings for OCI CLI
# export no_proxy=".skt-pca-9.au.oracle.com,$no_proxy"
# export OCI_CLI_CERT_BUNDLE=/Users/samktan/.oci/pcax9.cert

