#!/bin/bash

# Source environment variables and helper functions
source submission_reminder_app/config/config.env
source submission_reminder_app/modules/functions.sh

# Path to the submissions file
submissions_file="submission_reminder_app/assets/submissions.txt"

# Print remaining time and run the reminder function
echo "Assignment: $ASSIGNMENT"
echo "Days remaining to submit: $DAYS_REMAINING days"
echo "--------------------------------------------"

check_submissions $submissions_file
