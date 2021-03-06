#!/bin/bash
#Author: Aleksandr Karpov <keyfour13@gmail.com>
#-----------------------------------------------

#Set kernel path for search
KERNDIR="./linux-3.10.49"

#Set output for results
OUTDIR="/tmp/kernlogparser.output"

#Default file for parsing
PFILE="./logfile.txt"

#Path to temp logfile
LOGFILE=$OUTDIR/kernlogparser.logfile

#Timestamp pattern
TIMESTAMP="^\[*.*\]"

AWK_SCRIPT_BACK="\'{ if (NF > 1) { 
                for (i=1; i<NF;i++) {
                  printf $i
                  printf " "
                }
                printf "\n"
              }
            }\'"

AWK_SCRIPT_FORWARD="\'{ if (NF > 1) { 
                for (i=NF; i>1;i++) {
                  printf $i
                  printf " "
                }
                printf "\n"
              }
            }\'"


#Check if $OUTDIR presents
[[ ! -d $OUTDIR ]] && mkdir $OUTDIR
[[ ! -d $OUTDIR ]] && { echo "Can't create $OUTDIR"; exit 2; }

# check argument
# read log file from argument
[[ ! "$1" == "" ]] && PFILE=$1
[[ ! -f $PFILE ]] && { echo "There is no such file $FILE"; exit 2; }

cp -f $PFILE $LOGFILE

# replace add function names to address with pykernmap
# save to temporary file
# remove strings without timestamps
kernmap.py -m $KERNDIR/System.map -t $LOGFILE -r > $OUTDIR/tmp.txt
[[ -f $OUTDIR/tmp ]] && mv -f $OUTDIR/tmp $LOGFILE
grep $TIMESTAMP $LOGFILE > $OUTDIR/tmp
[[ -f $OUTDIR/tmp ]] && mv -f $OUTDIR/tmp $LOGFILE

# open updated file, read line by line, filter (remove) timestamp
# search in kernel directory string messages from log
sed -i -e 's/$TIMESTAMP//' $LOGFILE
while read line; do
  message=$line
  result=$(grep -nHIirF -- $message $KERNDIR)
  while true do
    [[ $message ]] && message=$(echo $message | awk $AWK_SCRIPT) || break
    [[ $result ]] && break
  done
done < $LOGFILE

# special search for kernel dump, if there is address search function name

# save all results to separate files with names based on current string
