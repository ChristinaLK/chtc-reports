#!/bin/bash

filename=`ls -rt data/hpc/ | tail -n 1`
echo $filename
Rscript scripts/hpc_single_node.R data/hpc/$filename
