#!/bin/bash

# Function to display help message
usage() {
  echo "Usage: $0 -u uri -a true|false"
  echo
  echo "Options:"
  echo "  -u URI       The URI to be processed"
  echo "  -a ALLOW     Allow permanent activation (true|false)"
  exit 1
}

# Initialize variables
uri=""
allow=""

# Parse options
while getopts ":u:a:" opt; do
  case ${opt} in
    u )
      uri=$OPTARG
      ;;
    a )
      allow=$OPTARG
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
if [ -z "$uri" ] || [ -z "$allow" ]; then
  echo "Error: Missing required parameters."
  usage
fi

# Check if the allow variable is either true or false
if [[ "$allow" != "true" && "$allow" != "false" ]]; then
  echo "Error: Allow must be either 'true' or 'false'."
  usage
fi

# Convert allow to boolean
is_expiration_required=true
if [ "$allow" == "true" ]; then
  is_expiration_required=false
fi

# Set default maximum expiry if expiration is required
# otherwise don't include that in json
if [ "$is_expiration_required" == "true" ]; then
  max_expiry='"maximumDuration": "P180D",'
else
  max_expiry=""
fi

payload=$(cat <<EOF
{
  "properties": {
    "rules": [
      {
        "isExpirationRequired": $is_expiration_required,
        $max_expiry
        "id": "Expiration_Admin_Assignment",
        "ruleType": "RoleManagementPolicyExpirationRule",
        "target": {
          "caller": "Admin",
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

response=$(az rest --method patch --uri "$uri" --headers "Content-Type=application/json" --body "$payload" --only-show-errors --query "statusCode")

# Check if the response is not 200
if [ "$response" -ne 200 ]; then
  echo "Error: PATCH request failed with status code $response"
  exit 1
fi

echo "PATCH request succeeded with status code $response"

exit 0
