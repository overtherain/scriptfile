#!/bin/sh 

function processFile {
    if [ -d $1 ]; then 
        for currentFile in $1/* 
        do 
            if [ -d "$currentFile" ]; then 
                contain=$(echo "$currentFile" | grep '.svn')
                if [ -n "$contain" ]; then 
                    echo "rm -rvf $currentFile"
                else    
                    processFile "$currentFile"
                fi      
            fi      
        done    
    fi
}

processFile $1