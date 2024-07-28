#!/bin/bash

MINPARAMS=10;

#display the filename which is first argument
echo "the name of the script is $0";

#display the first argument
if [ -n $1 ];
then 
echo "the first argument is $1";
fi

#display all arguments
echo "all the arguments are $*";

#to check minimum number of arguments
if [ $# -lt $MINPARAMS ];
then
echo "there should be $MINPARAMS of arguments";
fi


