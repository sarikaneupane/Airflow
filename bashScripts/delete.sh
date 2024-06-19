#!/bin/bash

backupDir=$1  # First argument passed from BashOperator

function deleteFile(){
    local backupDir=$1
    cd "${backupDir}" || exit

    local file_count
    file_count=$(ls | wc -l)

    if [ "$file_count" -gt 2 ];then
        ls -t | tail -n +3 | xargs rm --  # Orders files by latest modified date and deletes oldest files
    fi
}

# Call the function with provided backup directory
deleteFile "${backupDir}"




#!/bin/bash

 #function deleteFile(){
  #  local backupDir=$1
   # cd "${backupDir}" || exit

    #local file_count
   # file_count=$(ls | wc -l)

   # if [ "$file_count" -gt 2 ];then
    #    ls -t | tail -n +3 | xargs rm -- #orders file acc to latest modified date and deletes oldest file
   # fi
 #}

# backupPath="/home/kiit/airflow/backup "
# deleteFile ${backupPath}
