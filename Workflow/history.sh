#!/bin/zsh --no-rcs

# Get Selected Orion Profile
orion_path="${HOME}/Library/Application Support/Orion"
profile_id="$(plutil -convert json "${orion_path}/profiles" -o - | jq -r --arg useSelectProfile "${useSelectProfile}" '(.profiles[] | select(.name == $useSelectProfile).identifier) // .defaultProfile // "Defaults"')"
history_file="file://${orion_path}/${profile_id}/history"

# SQL Query
query="${1}"
query="${query//\%/\\%}"
query="${query//_/\_}"
titleQuery="%${query// /%' ESCAPE '\\' AND TITLE LIKE '%}%"
urlQuery="%${query// /%' ESCAPE '\\' AND URL LIKE '%}%"

readonly sqlQuery="SELECT URL, TITLE, HOST, LAST_VISIT_TIME
FROM history_items
WHERE (URL LIKE '${urlQuery}' ESCAPE '\') OR (TITLE LIKE '${titleQuery}' ESCAPE '\')
ORDER BY LAST_VISIT_TIME DESC
LIMIT 500;"

# Load History
sqlite3 -json ${history_file} ${sqlQuery} | jq -cs \
--arg useQL "$useQL" \
'{
    "items": (if (length > 0) then map(sort_by(.LAST_VISIT_TIME) | reverse | .[] |
    	{
    		"title": (if (.TITLE == "") then .HOST else .TITLE end),
    		"subtitle": "[\(.LAST_VISIT_TIME | strptime("%Y-%m-%d %H:%M:%S") | strflocaltime("%Y-%m-%d"))] \(.URL)",
    		"arg": .URL,
    		"quicklookurl": "\(if $useQL == "1" then .URL else "" end)",
            "text": { "largetype": "[\(.LAST_VISIT_TIME | strptime("%Y-%m-%d %H:%M:%S") | strflocaltime("%Y-%m-%d, %I:%M %p"))]\n\n\(.URL)" },
            "icon": { "path": "images/history.png" },
    		"mods": {
    			"cmd": {
    				"subtitle": "⌘↩ Open in secondary browser",
    				"arg": .URL,
    				"variables": { "bSecondary": true }
    			}
    		}
    	}
    ) else
        [{
			"title": "Search History...",
			"subtitle": "No matching History entries",
			"valid": "false"
		}]
	end)
}'