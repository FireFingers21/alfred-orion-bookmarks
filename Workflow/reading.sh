#!/bin/zsh --no-rcs

# Get Selected Orion Profile
orion_path="${HOME}/Library/Application Support/Orion"
profile_id="$(plutil -convert json "${orion_path}/profiles" -o - | jq -r --arg useSelectProfile "${useSelectProfile}" '(.profiles[] | select(.name == $useSelectProfile).identifier) // .defaultProfile // "Defaults"')"
reading_list_file="${orion_path}/${profile_id}/reading_list.plist"

# Load Reading List
plutil -convert xml1 "${reading_list_file}" -o - |
sed 's/date\(\>\)/string\1/g' |
plutil -convert json -o - - |
jq -cs \
   --arg useQL "$useQL" \
'{
    "skipknowledge": true,
    "items": (if (.[] | length > 0) then map(.[] |
        {
            "title": .title,
            "subtitle": "[\(.dateAdded/1000 | strflocaltime("%Y-%m-%d"))] \(.url.relative)",
            "arg": .url.relative,
            "match": [
                .title, .url.relative,
                (if (.lastViewed) then "read" else "unread" end)
            ] | map(select(.)) | join(" "),
            "quicklookurl": "\(if $useQL == "1" then .url.relative else "" end)",
            "text": { "largetype": "[\(.dateAdded/1000 | strflocaltime("%Y-%m-%d, %I:%M %p"))]\n\n\(.url.relative)" },
            "icon": {
                "path": "images/reading\(if (.lastViewed) then "Done" else "" end).png"
            },
            "variables": { "id": .id },
            "mods": {
     			"cmd": {
    				"subtitle": "⌘↩ Open in secondary browser",
    				"arg": .url.relative,
    				"variables": { "bSecondary": true, "id": .id }
     			}
      		}
        }
    ) else
        [{
            "title": "Search Reading List...",
			"subtitle": "Your Reading List is empty",
			"valid": "false"
		}]
	end)
}'