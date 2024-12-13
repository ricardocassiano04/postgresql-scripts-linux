#!/bin/bash
#
# Author: Ricardo Cassiano
#
# Vacuum all databases
# 
# 

LOG_FILE=vacuum-all-databases.log

function get_datetime() {
	    
	    date +%Y-%m-%d_%H-%M-%S
    }



echo "$(get_datetime) - Vacuum all database started" 2>&1 | tee -a "${LOG_FILE}"

vacuumdb --all --analyze --force-index-cleanup --verbose 2>&1  | tee -a "${LOG_FILE}"


echo "$(get_datetime) - Vacuum all database finished" 2>&1 | tee -a "${LOG_FILE}"