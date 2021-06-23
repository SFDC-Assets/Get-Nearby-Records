#!/bin/bash
#
#  Creates a new package in the dev hub.
#
#  This code is provided AS IS, with no warranty or guarantee of suitability for use.
#  Contact: john.meyer@salesforce.com

readonly devHubOrgAlias=$(jq --raw-output .defaultdevhubusername < .sfdx/sfdx-config.json) || {
    echo "Make sure that \"jq\" is installed and that \"defaultdevhubusername\" is defined in .sfdx/sfdx-config.json." >&2
    exit 1
}

sfdx force:package:create \
    --packagetype "Unlocked" \
    --nonamespace \
    --name "Get Nearby Records" \
    --description "This package contains a Salesforce Lightning Web Component that can retrieve geographically near records." \
    --path "force-app" \
    --targetdevhubusername "$devHubOrgAlias"