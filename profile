# set default locale settings
export LANG=C
export EDITOR="vi -e"
export VISUAL="vi"

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

# configure git
GIT=$(which git)
if [ ! -z "$GIT" ] && [ -x "$GIT" ]; then
        $GIT config --global user.name "samktan"
        $GIT config --global user.email "samktan@gmail.com"
        $GIT config --global credential.helper store
fi

# add common utilities
if [ -d $HOME/commons ]; then
	export PATH=$HOME/commons/bin:$PATH
	alias ssh=$HOME/commons/bin/sssh
	CWD=$(pwd)
	cd $HOME/commons
	${GIT} pull
	cd "${CWD}"
fi

# configuration settings for OCI CLI
# export no_proxy=".skt-pca-9.au.oracle.com,$no_proxy"
CA_ROOT_CERT="$HOME/.oci/ca.cert"
[ -f $CA_ROOT_CERT ] && export OCI_CLI_CERT_BUNDLER=$CA_ROOT_CERT && export REQUESTS_CA_BUNDLE=$CA_ROOT_CERT


