# check for OWAN proxy server
proxy () {
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
proxy
