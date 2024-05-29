#!/bin/bash

# Function to display help message
usage() {
  echo "Usage: $0 -u uri [-g group]"
  echo
  echo "Options:"
  echo "  -u URI       The URI to be processed"
  echo "  -g GROUP     The Entra group name to be set as the approver (optional)"
  exit 1
}

# Initialize variables
uri=""
group=""

# Parse options
while getopts ":u:g::" opt; do
  case ${opt} in
    u )
      uri=$OPTARG
      ;;
    g )
      group_set="true"
      group=$OPTARG
      ;;
    \? )
      echo "Invalid option: -$OPTARG" >&2
      usage
      ;;
    : )
      if [ "$OPTARG" = "g" ]; then
        group=""
      else
        echo "Option -$OPTARG requires an argument." >&2
        usage
      fi
      ;;
  esac
done

# Check if the required parameter is provided
if [ -z "$uri" ]; then
  echo "Error: Missing required parameter."
  usage
fi

# Get the group ID from the group name if provided
if [ -n "$group" ]; then
  group_id=$(az ad group show --group "$group" --query id --output tsv)

  if [ -z "$group_id" ]; then
    echo "Error: Could not find group with name '$group'."
    exit 1
  fi

  # Create JSON payload with approver
  payload=$(cat <<EOF
{
  "properties": {
    "rules": [
      {
        "id": "Approval_EndUser_Assignment",
        "ruleType": "RoleManagementPolicyApprovalRule",
        "target": {
          "caller": "EndUser",
          "operations": [
            "All"
          ],
          "level": "Assignment"
        },
        "setting": {
          "isApprovalRequired": true,
          "isApprovalRequiredForExtension": false,
          "isRequestorJustificationRequired": true,
          "approvalMode": "SingleStage",
          "approvalStages": [
            {
              "approvalStageTimeOutInDays": 1,
              "isApproverJustificationRequired": true,
              "escalationTimeInMinutes": 0,
              "isEscalationEnabled": false,
              "primaryApprovers": [
                {
                  "id": "$group_id",
                  "userType": "Group",
                  "description": "$group",
                  "isBackup": false
                }
              ],
              "escalationApprovers": []
            }
          ]
        }
      }
    ]
  }
}
EOF
)
else
  # Create JSON payload without approver
  payload=$(cat <<EOF
{
  "properties": {
    "rules": [
      {
        "id": "Approval_EndUser_Assignment",
        "ruleType": "RoleManagementPolicyApprovalRule",
        "target": {
          "caller": "EndUser",
          "operations": [
            "All"
          ],
          "level": "Assignment"
        },
        "setting": {
          "isApprovalRequired": false,
          "isApprovalRequiredForExtension": false,
          "isRequestorJustificationRequired": true,
          "approvalMode": "SingleStage",
          "approvalStages": [
            {
              "approvalStageTimeOutInDays": 1,
              "isApproverJustificationRequired": true,
              "escalationTimeInMinutes": 0,
              "isEscalationEnabled": false,
              "primaryApprovers": [],
              "escalationApprovers": []
            }
          ]
        }
      }
    ]
  }
}
EOF
)
fi

# Make PATCH request using az rest
response=$(az rest --method patch --uri "$uri" --headers "Content-Type=application/json" --body "$payload" --only-show-errors 2>&1)

if [ $? -ne 0 ]; then
  echo "Error: $response"
  exit 1
fi

exit 0