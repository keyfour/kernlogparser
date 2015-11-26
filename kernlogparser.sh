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
TIMESTAMP="[*.*]"

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
# search in kernel directory string messages from log, use symbols : [ ] ( )
# as separators

# start with full string search if no separators
# remove values before separator : and between [ ] and ( )
# search again

# special search for kernel dump, if there is address search function name

# save all results to separate files with names based on current string
