#!/bin/bash

# --- Configuration Variables ---
# Set default values to empty string
ORG_ID=""
ACTION=""
export DISPLAY_NAME="Block former employee personal Google Identity"
export DESCRIPTION="Group to force conflict with former employees personal Google Identity"
export INPUT_FILE="former_employees.csv"
# ------------------------------

# --- Function to display usage instructions ---
function usage() {
    echo "Usage: $0 --organization-id <ORG_ID> --action <ACTION>"
    echo "--organization-id: The 12-digit numeric GCP Organization ID."
    echo "--action: The operation to create or delete Google Groups. Must be 'create' or 'delete'."
    echo "Example: $0 --organization-id 123456789012 --action create"
    exit 1
}

# --- Process Flag Arguments ---
# This loop parses long-form flags.
while [[ $# -gt 0 ]]; do
    case "$1" in
        --organization-id)
            # Assign the next argument (the value) to ORG_ID
            ORG_ID="$2"
            # Shift past the value
            shift
            ;;
        --action)
            # Assign the next argument (the value) to ACTION
            ACTION="$2"
            # Shift past the value
            shift
            ;;
        *)
            # Stop processing if an unknown flag is encountered
            echo "Error: Unknown argument $1"
            usage
            ;;
    esac
    # Shift to the next flag or value
    shift
done

# --- Function to Validate Inputs ---
function check_variables () {
    # Check if required arguments are present
    if [ -z "$ORG_ID" ] || [ -z "$ACTION" ]; then
        echo "Error: Both --organization-id and --action flags are required."
        usage
    fi

    # 1. Validate the Organization ID format (check for numeric)
    if ! [[ "$ORG_ID" =~ ^[0-9]+$ ]]; then
        printf "ERROR: Invalid Organization ID '$ORG_ID'. It should be a numeric string.\n\n"
        exit 1
    fi

    # 2. Validate and normalize the action
    ACTION=$(echo "$ACTION" | tr '[:upper:]' '[:lower:]')
    if [[ "$ACTION" != "create" && "$ACTION" != "delete" ]]; then
        printf "ERROR: Invalid action '$ACTION'. Action must be 'create' or 'delete'.\n\n"
        exit 1
    fi
}

# --- Combined Group Management Function ---
function manage_groups () {
echo "Starting group $ACTION process..."
echo "Reading email addresses from: $INPUT_FILE"
echo "Target Organization ID: $ORG_ID"
echo "---"

# Check if the input file exists
if [ ! -f "$INPUT_FILE" ]; then
    echo "ERROR: Input file '$INPUT_FILE' not found. Please create it and add email addresses (one per line)."
    exit 1
fi

# Read the input file line by line
while IFS= read -r GROUP_EMAIL
do
    # Skip empty lines and lines starting with '#' (comments)
    if [[ -z "$GROUP_EMAIL" || "$GROUP_EMAIL" =~ ^# ]]; then
        continue
    fi

    echo "-> Attempting to $ACTION group: $GROUP_EMAIL"

    # Conditional Execution based on the action
    if [ "$ACTION" == "create" ]; then
        # Create command: Uses the ORG_ID variable
        # Note: The gcloud flag is --organization, but the input flag is --organization-id
        gcloud identity groups create "$GROUP_EMAIL" \
            --display-name="$DISPLAY_NAME" \
            --description="$DESCRIPTION" \
            --organization="$ORG_ID" \
            --quiet
        
        OPERATION_NAME="Creation"
    elif [ "$ACTION" == "delete" ]; then
        # Delete command
        gcloud identity groups delete "$GROUP_EMAIL" --quiet

        OPERATION_NAME="Deletion"
    fi

    # Check the exit code of the last command (gcloud)
    if [ $? -eq 0 ]; then
        echo " Success: $OPERATION_NAME of group '$GROUP_EMAIL' successful."
    else
        echo " Failed: Could not perform $ACTION on group '$GROUP_EMAIL'. Check gcloud output for details."
    fi
    echo "" # Add a newline for better readability
    
done < "$INPUT_FILE"

echo "---"
echo "Group $ACTION process complete."
}

# --- Main Script Execution ---
check_variables
manage_groups