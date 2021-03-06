#!/bin/bash

do_version_check() {

   [ "$1" == "$2" ] && return 10

   ver1front=`echo $1 | cut -d "." -f -1`
   ver1back=`echo $1 | cut -d "." -f 2-`

   ver2front=`echo $2 | cut -d "." -f -1`
   ver2back=`echo $2 | cut -d "." -f 2-`

   if [ "$ver1front" != "$1" ] || [ "$ver2front" != "$2" ]; then
       [ "$ver1front" -gt "$ver2front" ] && return 11
       [ "$ver1front" -lt "$ver2front" ] && return 9

       [ "$ver1front" == "$1" ] || [ -z "$ver1back" ] && ver1back=0
       [ "$ver2front" == "$2" ] || [ -z "$ver2back" ] && ver2back=0
       do_version_check "$ver1back" "$ver2back"
       return $?
   else
           [ "$1" -gt "$2" ] && return 11 || return 9
   fi
}    


python_version=`python -V 2>&1 | awk '{print $2}'`
python_cmd="python"
do_version_check $python_version "2.6"


if [ $? == 9 ]
then
	python_cmd=`which python2.6`
fi

base_dir=`dirname $0`

if [ $python_cmd == "" ]
then
	echo "python2.6 not exist!"
	exit
fi

nohup $python_cmd $base_dir/cleaner.py &>/dev/null &

