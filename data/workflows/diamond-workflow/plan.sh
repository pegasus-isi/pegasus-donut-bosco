#!/usr/bin/env bash

DIR=$(cd $(dirname $0) && pwd)

if [ $# -ne 1 ]; then
    echo "Usage: $0 WORKFLOW"
    exit 1
fi

WORKFLOW=$1

# This command tells Pegasus to plan the workflow contained in 
# dax file passed as an argument. The planned workflow will be stored
# in the "submit" directory. The execution # site is "".
# --input-dir tells Pegasus where to find workflow input files.
# --output-dir tells Pegasus where to place workflow output files.
pegasus-plan --conf pegasus.properties \
    --dir $DIR/submit \
    --sites donut \
    --output-site local \
    --cleanup leaf \
    --force \
    $WORKFLOW
