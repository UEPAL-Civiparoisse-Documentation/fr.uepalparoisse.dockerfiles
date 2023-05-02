#!/bin/bash
/usr/bin/mysqlrouter
ret=$?
if [ $ret -eq 0 -o $ret -eq 143 ]
then
exit 0;
fi;
exit $ret;
