# set default locale settings
export LANG=C

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
		unset all_proxy
	else
		echo "Setting proxy server ..."
		export http_proxy="http://${PROXYHOST}:${PROXYPORT}"
		export https_proxy=$http_proxy
		export all_proxy=$http_proxy
		export no_proxy=".oracle.com,.oraclecorp.com"
	fi
}
check_proxy

# add Sam's common utilities
if [ -d $HOME/commons/bin ]; then
	alias ssh=$HOME/commons/bin/sssh
	export PATH=$HOME/commons/bin:$PATH
fi

# enable homebrew
eval "$(/opt/homebrew/bin/brew shellenv)"

# configuration settings for OCI CLI
# export no_proxy=".skt-pca-9.au.oracle.com,$no_proxy"
# export OCI_CLI_CERT_BUNDLE=/Users/samktan/.oci/pcax9.cert

