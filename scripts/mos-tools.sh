# Sam's MOS Tools
# Tools for My Oracle Support website
# Author: sam.k.tan@oracle.com

mos-status () {
    # Use GNU date command
    DATECMD="/usr/gnu/bin/date"

    echo "Status of moswget downloads based on *.log files ..."
    wgetc=$(ps -e -o comm | grep -i wget | wc -l)
    echo "wget instances running: ${wgetc}"

    for f in `ls *.zip.log`; do
        name=$(basename $f '.log')
        age=$(($(${DATECMD} +%s) - $(${DATECMD} -r "$f" +%s)))
        n=$(fgrep '100%' ${f})
        if [ $? -eq 0 ]; then
            echo "DONE:   " ${name}
        elif [ ${age} -gt 3600 ]; then
            echo "STALLED:" ${name}
        else
            echo "RUNNING:" ${name} "(progress / bandwidth / time remaining)"
            cat ${f} | grep '%' | tail -1
        fi
    done
}

mos-upload () {
    CURL=$(which curl)

    [ -z $1 ] &&  echo "${0##*/} <file to upload>" && exit 1
    p=$(realpath "$1")

    [ ! -f "${p}" ] && echo "${p} is not a file." && exit 1; 

    printf "SR: "; read s; 
    printf "Login: "; read l; 
    u="https://transport.oracle.com/upload/issue/${s}/"
    ${CURL} --verbose --progress-bar --user ${l} --upload-file "${p}" ${u};
}

mos-download () {
    # Trap to cleanup cookie file in case of unexpected exits.
    trap 'rm -f $COOKIE_FILE; exit 1' 1 2 3 6

    # Path to wget command
    WGET="`which wget`"
    if [ -z "$WGET" ] || [ ! -x "$WGET" ]; then
        echo "wget not found."
        return 1
    fi

    # Log directory and file
    LOGDIR=.
    LOGFILE=$LOGDIR/wget-log-$(date +%Y-%m-%d_%H:%M:%S).log
    echo "Writing to log file $LOGFILE"

    # SSO username
    printf 'SSO Username: '
    read SSO_USERNAME < /dev/tty

    # Location of cookie file
    COOKIE_FILE=$(mktemp -t wget_sh_XXXXXX) >> "$LOGFILE" 2>&1
    if [ $? -ne 0 ] || [ -z "$COOKIE_FILE" ]; then
        echo "Temporary cookie file creation failed. See $LOGFILE for more details." |  tee -a "$LOGFILE"
        return 1
    fi
    echo "Created temporary cookie file $COOKIE_FILE" >> "$LOGFILE"

    # Output directory and file
    OUTPUT_DIR=.

    # The following command to authenticate uses HTTPS. This will work only if the wget in the environment
    # where this script will be executed was compiled with OpenSSL. 
    printf 'SSO Password: '
    $WGET  --secure-protocol=auto --save-cookies="$COOKIE_FILE" --keep-session-cookies  --http-user "$SSO_USERNAME" --ask-password  "https://updates.oracle.com/Orion/Services/download" -O /dev/null 2>> "$LOGFILE"
    # Verify if authentication is successful
    if [ $? -ne 0 ]; then
        echo "Authentication failed with the given credentials." | tee -a "$LOGFILE"
        echo "Please check logfile: $LOGFILE for more details."
        return 1
    else
        echo "Authentication is successful. Proceeding with downloads..." | tee -a "$LOGFILE"
    fi
    echo "\n"

    echo "Enter URLs one at a time and press RETURN, type Ctrl-D to exit."
    while IFS='' read inputline; do
        # scan for lines that contain this specific URL format
        if [[ $inputline =~ https://updates.oracle.com/Orion/Services/download/[^\ \"]+ ]]; then
            url="${BASH_REMATCH[0]}"
        else
            url=""
        fi

        if [ ! -z "$url" ]; then
            # scan for a patchfile parameter
            if [[ $url =~ patch_file=([^\ \&\"]+) ]]; then
                patchfile="${BASH_REMATCH[1]}"
            else
                patchfile=""
            fi
            # scan for a filename parameter
            if [[ $url =~ fileName=([^\ \&\"]+) ]]; then
                filename="${BASH_REMATCH[1]}"
            else
                filename=""
            fi
            # if there is no patchfile parameter, use the filename parameter
            if [ -z $patchfile ]; then
                patchfile="$filename"
            fi

            if [ -z "$patchfile" ]; then
                echo "No patchfile name found in URL, try again."
            else
                echo "Downloading $patchfile from $url" >> $LOGFILE
                echo "Downloading $patchfile ..."
                $WGET --background --load-cookies="$COOKIE_FILE" "$url" -O "$OUTPUT_DIR/$patchfile" -o "$OUTPUT_DIR/${patchfile}.log" >> "$LOGFILE" 2>&1 
            fi
        echo "Next URL ... (Ctrl-D when done)"
        fi
    done

    # Cleanup
    rm -f "$COOKIE_FILE"
    echo "Removed temporary cookie file $COOKIE_FILE" >> "$LOGFILE"

    # END OF SCRIPT - SKT

}