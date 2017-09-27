#!/bin/bash

filename=`ls -rt data/htc/ | tail -n 1`
echo $filename
python scripts/htc_report.py data/htc/$filename 72
