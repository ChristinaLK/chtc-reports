# Report Scripts

For analyzing the daily/weekly reports

## Dependencies
* R, + dplyr, tidyr
* python, + pandas

## To use
* Clone this repository
* Create a `data` directory, with `hpc` and `htc` sub-directories
* Download data
    * CHTC usertable goes in `data/htc`
    * SLURM stats report goes in `data/hpc`, naming convention is `date_to_date_users.csv`
* Run analysis

## Analysis options
* 72 hour jobs
    * Run `check_72_hrs.sh` or run the `scripts/htc_report.py` script directly, using the `72` option
* Single node jobs
    * Run `check_single_node.sh` or run the `scripts/hpc_single_node.R` script directly
* Gluster users
    * Run `scripts/htc_report.py` using the `gluster` option.
