#!/bin/bash

set -e

# Get the directory of the current script
scriptDir=$(dirname "$0")

# Function to parse JSON
parse_json() {
    echo "$1" | sed 's/\\\\\//\//g' | sed 's/[{}]/''/g' | awk -v k="\"$2\"" '{n=split($0,a,","); for (i=1; i<=n; i++) if (a[i] ~ k) print a[i];}' | sed 's/\"//g' | awk -F: '{print $2}'
}

# Retrieve the policy data
policyUri="https://management.azure.com${RESOURCE_ID}/providers/Microsoft.Authorization/roleManagementPolicyAssignments?api-version=2020-10-01&\$filter=roleDefinitionId+eq+%27${ROLE_DEFINITION_ID}%27"
policyData=$(az rest --method get --url $policyUri)

# Check if policyData is not empty
if [ -z "$policyData" ]; then
  echo "Error: No data retrieved from az rest command"
  exit 1
fi

# Parse the JSON and check the number of results
resultCount=$(echo "$policyData" | grep -o '"policyId"' | wc -l)

# Throw an error if there is more than one result
if [ "$resultCount" -ne 1 ]; then
  echo "Error: Expected exactly one result but found $resultCount"
  exit 1
fi

# Extract the policyId from properties.policyId
policyId=$(echo "$policyData" | sed -n 's/.*"policyId": "\([^"]*\)".*/\1/p')

patchUri="https://management.azure.com${policyId}?api-version=2020-10-01&\$filter=asTarget()"

if [ $ALLOW_PERMANENT_ACTIVE ]; then
    "$scriptDir/set_allow_permanent_active.sh" -u $patchUri -a $ALLOW_PERMANENT_ACTIVE
fi

if [ $MAXIMUM_ACTIVE_ASSIGNMENT_DURATION ]; then
    "$scriptDir/set_maximum_active_assignment.sh" -u $patchUri -d $MAXIMUM_ACTIVE_ASSIGNMENT_DURATION
fi

if [ $ALLOW_PERMANENT_ELIGIBLE ]; then
    "$scriptDir/set_allow_permanent_eligible.sh" -u $patchUri -a $ALLOW_PERMANENT_ELIGIBLE
fi

if [ $MAXIMUM_ELIGIBLE_ASSIGNMENT_DURATION ]; then
    "$scriptDir/set_maximum_eligible_assignment.sh" -u $patchUri -d $MAXIMUM_ELIGIBLE_ASSIGNMENT_DURATION
fi

if [ $MAXIMUM_ACTIVATION_DURATION ]; then
    "$scriptDir/set_maximum_activation.sh" -u $patchUri -d $MAXIMUM_ACTIVATION_DURATION
fi

if [ $REQUIRE_ACTIVATION_JUSTIFICATION ]; then
    "$scriptDir/set_require_justification.sh" -u $patchUri -r $REQUIRE_ACTIVATION_JUSTIFICATION
fi


