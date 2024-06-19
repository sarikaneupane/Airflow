#!/bin/bash

# Source delete.sh script and make sure it's executable
source /home/kiit/airflow/bashScripts/delete.sh
chmod +x /home/kiit/airflow/bashScripts/delete.sh

# Set current date for backup file naming
current_date=$(date +"%Y%m%d_%H%M%S")

# Define backup path and MySQL connection details
backupPath="/home/kiit/airflow/backup"
mysql_host="localhost"
mysql_port="3306"
db_name="airflow_db"
mysql_user="airflow_user"
mysql_password="airflow_pass"

# Attempt MySQL connection
if ! mysql -h ${mysql_host} -P ${mysql_port} -u ${mysql_user} -p"${mysql_password}" -e "USE ${db_name};"; then
    echo "Error: Unable to connect to MySQL server."
    exit 1
fi

# SQL query to get the total size of the database in bytes
SQL_QUERY="SELECT SUM(data_length + index_length) FROM information_schema.tables WHERE table_schema='${db_name}';"

# Execute the SQL query and store the result in a variable
DB_SIZE_BYTES=$(mysql -h ${mysql_host} -P ${mysql_port} -u ${mysql_user} -p"${mysql_password}" -sse "${SQL_QUERY}")
DB_SIZE=$(echo "scale=2; ${DB_SIZE_BYTES}/1000^3" | bc)

# Calculate total available space in the system (in GB)
TOTAL_FREE_SPACE_KB=$(df --output=avail / | awk 'NR>1 {sum += $1} END {print sum}')
FREE_SPACE=$(echo "scale=2; ${TOTAL_FREE_SPACE_KB}/1000^2" | bc)

# Perform backup only if there's enough free space
if [ $(echo "${DB_SIZE} < ${FREE_SPACE}" | bc) -eq 1 ]; then
    start_time=$(date +%s)
    
    # Backup the database
    BACKUP_FILE="${backupPath}/${db_name}_${current_date}.sql.gz"
    mysqldump -h ${mysql_host} -P ${mysql_port} -u ${mysql_user} -p"${mysql_password}" ${db_name} | gzip > ${BACKUP_FILE}
    
    # Call deleteFile function from delete.sh script
    deleteFile ${backupPath}
    
    end_time=$(date +%s)
    elapsed_time=$((end_time - start_time))
    echo "Backup completed in ${elapsed_time} seconds"
    
    messageOut="Backup Success in location: ${backupPath} | Required Space: ${DB_SIZE}GB, Available Space: ${FREE_SPACE}GB"
else
    messageOut="Backup Failed. | Required Space: ${DB_SIZE}GB, Available Space: ${FREE_SPACE}GB"
fi

# Output message for Airflow to pick up
echo "$messageOut"










# source /home/kiit/airflow/bashScripts/delete.sh

# current_date=$(date +"%Y%m%d_%H%M%S")

# backupPath="/home/kiit/airflow/backup"
# mysql_host="localhost"
# mysql_port="3306"
# db_name="airflow_db"

# # SQL query to get the total size of the database in bytes
# SQL_QUERY="SELECT SUM(data_length + index_length) FROM information_schema.tables WHERE table_schema='${db_name}';"
# # Execute the SQL query and store the result in a variable
# DB_SIZE_BYTES=$(mysql -h ${mysql_host} -P ${mysql_port} -sse "${SQL_QUERY}")
# DB_SIZE=$(echo "scale=2; ${DB_SIZE_BYTES}/1000^3" | bc)

# # echo ${DB_SIZE}

# #Calculate total availabe space in the system
# TOTAL_FREE_SPACE_KB=$(df --output=avail -x tmpfs -x devtmpfs -x squashfs -x overlay -x aufs | awk 'NR>1 {sum += $1} END {print sum}')
# # Convert total free space from KB to GB (For 1000 block size)
# FREE_SPACE=$(echo "scale=2; ${TOTAL_FREE_SPACE_KB}/1000^2" | bc)


# # if [ $(echo "${DB_SIZE} < ${FREE_SPACE}" | bc) -eq 1 ];then
# if [[ "${DB_SIZE}" < "${FREE_SPACE}" ]]; then
    
#     start_time=$(date +%s)

#     BACKUP_FILE="${backupPath}/${db_name}_${current_date}.sql.gz"
#     mysqldump -h ${mysql_host} -P ${mysql_port} ${db_name} | gzip > ${BACKUP_FILE}

#     deleteFile ${backupPath}

#     end_time=$(date +%s)
#     elapsed_time=$((end_time - start_time))
#     echo "Backup completed in ${elapsed_time} seconds"

#     messageOut="Backup Success in location: ${backupPath}|Required Space: ${DB_SIZE}GB, Available Space: ${FREE_SPACE}GB"

# else
#     messageOut="Backup Failed.|Required Space: ${DB_SIZE}GB, Available Space: ${FREE_SPACE}GB"
# fi

# echo "$messageOut" #output message for Airflow to pick up








#!/bin/bash

# Variables
 #USER="airflow_user"
 #PASSWORD="airflow_pass"
 #HOST="localhost"
# DATABASE="airflow_db"
# BACKUP_PATH="/home/kiit/airflow/backup"

# Create backup
# mysqldump -u $USER -p$PASSWORD -h $HOST $DATABASE > $BACKUP_PATH/${DATABASE}$(date +%F%T).sql


#!/bin/bash





