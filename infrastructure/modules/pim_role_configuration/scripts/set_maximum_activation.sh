#!/bin/bash

# Function to display help message
usage() {
  echo "Usage: $0 -u uri -d duration"
  echo
  echo "Options:"
  echo "  -u URI       The URI to be processed"
  echo "  -d DURATION  The duration in hours (1 to 24)"
  exit 1
}

# Initialize variables
uri=""
duration=""

# Parse options
while getopts ":u:d:" opt; do
  case ${opt} in
    u )
      uri=$OPTARG
      ;;
    d )
      duration=$OPTARG
      ;;
    \? )
      echo "Invalid option: -$OPTARG" >&2
      usage
      ;;
    : )
      echo "Option -$OPTARG requires an argument." >&2
      usage
      ;;
  esac
done

# Check if the required parameters are provided
if [ -z "$uri" ] || [ -z "$duration" ]; then
  echo "Error: Missing required parameters."
  usage
fi

# Check if the duration is a valid integer and between 1 and 24
if ! [[ "$duration" =~ ^[0-9]+$ ]]; then
  echo "Error: Duration must be a valid integer."
  usage
fi

if [ "$duration" -lt 1 ] || [ "$duration" -gt 24 ]; then
  echo "Error: Duration must be between 1 and 24 hours."
  usage
fi

# Convert duration to ISO 8601 duration format
iso_duration="PT${duration}H"

# Create JSON payload
payload=$(cat <<EOF
{
  "properties": {
    "rules": [
      {
        "isExpirationRequired": true,
        "maximumDuration": "$iso_duration",
        "id": "Expiration_EndUser_Assignment",
        "ruleType": "RoleManagementPolicyExpirationRule",
        "target": {
          "caller": "EndUser",
          "operations": [
            "All"
          ],
          "level": "Assignment",
          "targetObjects": [],
          "inheritableSettings": [],
          "enforcedSettings": []
        }
      }
    ]
  }
}
EOF
)

# Make PATCH request using az rest
response=$(az rest --method patch --uri "$uri" --headers "Content-Type=application/json" --body "$payload" --output json 2>&1)

# Check if the request was successful
if [ $? -ne 0 ]; then
  echo "Error: $response"
  exit 1
fi

exit 0
