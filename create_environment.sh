#!/bin/bash

# create directory, subdirectory and files

mkdir -p submission_reminder_app/{app,modules,assets,config,}
touch submission_reminder_app/{app/reminder.sh,modules/functions.sh,assets/submissions.txt}
touch submission_reminder_app/startup.sh

# make files executable

chmod +x submission_reminder_app/{app/reminder.sh,modules/functions.sh,startup.sh}
mv submissions.txt submission_reminder_app/assets

# populate reminder.sh file
echo '#!/bin/bash

# Source environment variables and helper functions
source submission_reminder_app/config/config.env
source submission_reminder_app/modules/functions.sh

# Path to the submissions file
submissions_file="submission_reminder_app/assets/submissions.txt"

# Print remaining time and run the reminder function
echo "Assignment: $ASSIGNMENT"
echo "Days remaining to submit: $DAYS_REMAINING days"
echo "--------------------------------------------"

check_submissions $submissions_file' > submission_reminder_app/app/reminder.sh

# populate functions.sh file

echo '#!/bin/bash

# Function to read submissions file and output students who have not submitted
function check_submissions {
    local submissions_file=$1
    echo "Checking submissions in $submissions_file"

    # Skip the header and iterate through the lines
    while IFS=, read -r student assignment status; do
        # Remove leading and trailing whitespace
        student=$(echo "$student" | xargs)
        assignment=$(echo "$assignment" | xargs)
        status=$(echo "$status" | xargs)

        # Check if assignment matches and status is 'not submitted'
        if [[ "$assignment" == "$ASSIGNMENT" && "$status" == "not submitted" ]]; then
            echo "Reminder: $student has not submitted the $ASSIGNMENT assignment!"
        fi
    done < <(tail -n +2 "$submissions_file") # Skip the header
}' > submission_reminder_app/modules/functions.sh

# append 5 more data into submissions.txt

echo 'baba, Shell Navigation, submitted
teda, Shell Navigation, not submitted
jido, Shell Navigation, submitted
haile, Shell Navigation, not submitted
degi, Shell Navigation, submitted'  >> submission_reminder_app/assets/submissions.txt

# populate config.env file

echo '# This is the config file
ASSIGNMENT="Shell Navigation"
DAYS_REMAINING=2' > submission_reminder_app/config/config.env

# the script for stratup.sh to start reminder app

echo '#!/bin/bash
# This script starts the reminder application

echo "Starting the reminder app..."
submission_reminder_app/app/reminder.sh' > submission_reminder_app/startup.sh
