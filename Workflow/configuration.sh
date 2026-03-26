#!/bin/zsh --no-rcs

# Get Selected Orion Profile
orion_path="${HOME}/Library/Application Support/Orion"
profile_id="$(plutil -convert json "${orion_path}/profiles" -o - | jq -r --arg useSelectProfile "${useSelectProfile}" '(.profiles[] | select(.name == $useSelectProfile).identifier) // .defaultProfile // "Defaults"')"

if [[ ! -d "${orion_path}" ]]; then
	defaultProfileSubtext="❌ No Profiles Found in ~/Library/Application Support/Orion ❌"
	defaultProfileArg="${orion_path}"
else
	defaultProfileSubtext="${orion_path//${HOME}/~}/${profile_id}"
	defaultProfileArg="${orion_path}/${profile_id}"
fi

cat << EOB
{"items": [
	{
		"title": "Open Current Profile in Finder",
		"subtitle": "${defaultProfileSubtext}",
		"arg": "file://${defaultProfileArg}",
		"variables": { "pref_id": "profilePath" }
	},
	{
	    "title": "Configure Workflow...",
		"subtitle": "Open the configuration window for ${alfred_workflow_name}",
		"arg": "alfredpreferences://navigateto/workflows>workflow>${alfred_workflow_uid}>userconfig",
		"variables": { "pref_id": "configure" }
	},
]}
EOB