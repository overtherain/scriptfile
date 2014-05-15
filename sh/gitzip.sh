#!/bin/bash
#echo $1
#echo $2
git archive -o update${zipstr}.zip HEAD `git diff --name-only $1 $2`
