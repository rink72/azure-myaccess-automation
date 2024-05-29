#!/bin/bash

# Function to display help message
usage() {
  echo "Usage: $0 -u uri -r require"
  echo
  echo "Options:"
  echo "  -u URI       The URI to be processed"
  echo "  -r REQUIRE   Whether justification and ticketing are required (true|false)"
  exit 1
}

# Initialize variables
uri=""
require=""

# Parse options
while getopts ":u:r:" opt; do
  case ${opt} in
    u )
      uri=$OPTARG
      ;;
    r )
      require=$OPTARG
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
if [ -z "$uri" ] || [ -z "$require" ]; then
  echo "Error: Missing required parameters."
  usage
fi

# Check if the require variable is either true or false
if [[ "$require" != "true" && "$require" != "false" ]]; then
  echo "Error: Require must be either 'true' or 'false'."
  usage
fi

# Determine enabled rules based on the require parameter
if [ "$require" == "true" ]; then
  enabled_rules='[ "Justification", "Ticketing" ]'
else
  enabled_rules='[]'
fi

# Create JSON payload
payload=$(cat <<EOF
{
  "properties": {
    "rules": [
      {
        "enabledRules": $enabled_rules,
        "id": "Enablement_EndUser_Assignment",
        "ruleType": "RoleManagementPolicyEnablementRule",
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
response=$(az rest --method patch --uri "$uri" --headers "Content-Type=application/json" --body "$payload" --output json --only-show-errors 2>&1)

if [ $? -ne 0 ]; then
  echo "Error: $response"
  exit 1
fi

exit 0
