#!/bin/bash

# script to explain the possible scenerios where variable appears without prefix

#during assigning the variable
num=2;
let var=2344+num; #use let keyword assignment only for arithmetic expression    
echo $var;

a=$(pwd);
echo $a;

#during arithmetic operation within double parenthesis
((var = var + 7));
echo "after addition $var";

#during eporting a variable
export VAR=21

#during for each loop
for var in str1 str2 str3
do
echo $var;
done

#during de-assigning the variable
unset var;
echo "this should be empty $var";

#during read from STDIN
echo "enter a string";
read var;
echo $var;
