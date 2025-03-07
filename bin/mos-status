#!/usr/bin/sh

# Use GNU date command
DATECMD="/usr/gnu/bin/date"

echo "Status of moswget downloads based on *.log files ..."
echo "\n"

for f in `ls *.zip.log`
do
	# echo $f
	name=$(basename $f '.log')
	age=$(($(${DATECMD} +%s) - $(${DATECMD} -r "$f" +%s)))
	n=$(fgrep '100%' ${f})
	if [ $? -eq 0 ]
	then
		echo "DONE:   " ${name}
		echo "\n"
	elif [ ${age} -gt 3600 ]
	then
		echo "STALLED:" ${name}
		echo "\n"
	else
		echo "RUNNING:" ${name} "(progress / bandwidth / time remaining)"
       		cat ${f} | grep '%' | tail -1
       		echo "\n"

	fi
done
