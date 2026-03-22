#!/bin/zsh --no-rcs

# Get Selected Orion Profile
orion_path="${HOME}/Library/Application Support/Orion"
profile_id="$(plutil -convert json "${orion_path}/profiles" -o - | jq -r --arg useSelectProfile "${useSelectProfile}" '(.profiles[] | select(.name == $useSelectProfile).identifier) // .defaultProfile // "Defaults"')"
bookmarks_file="${orion_path}/${profile_id}/favourites.plist"

# Load Bookmarks
plutil -convert xml1 "${bookmarks_file}" -o - |
sed 's/date\(\>\)/string\1/g' |
plutil -convert json -o - - |
jq -cs \
   --arg useKeyword "$useKeyword" \
   --arg useFolder "$useFolder" \
   --arg useURL "$useURL" \
   --arg useQL "$useQL" \
'(map(.[] | select(.type == "folder" and .id != "0"))) as $folders |
{
    "items": map(.[] | select(.unmodifiable != "managed" and .type != "folder") |
    (.parentId) as $parentId |
    ($folders[] | select(.id == "\($parentId)").title) as $folderName |
    select($folderName != "Exclude-Alfred") |
        {
            "uid": .id,
            "title": .title,
            "subtitle": "[\($folderName)] \(.url)",
            "arg": .url,
            "match": [
                .title,
                (if $useFolder == "1" then ("#" + $folderName) else empty end),
                (if $useKeyword == "1" then .keyword else empty end),
                (if $useURL == "1" then .url else empty end)
            ] | map(select(.)) | join(" "),
            "quicklookurl": "\(if $useQL == "1" then .url else "" end)",
            "text": { "largetype": "[\($folderName)]\n\n\(.url)" },
            "icon": { "path": "images/bookmark.png" },
            "mods": { "cmd": {
    				"subtitle": "⌘↩ Open in secondary browser",
    				"arg": .url,
    				"variables": { "bSecondary": true }
            } }
        }
    ) | (if (length > 0) then . else [{
		"title": "Search Bookmarks...",
		"subtitle": "You have no bookmarks",
		"valid": "false"
	}]end)
}'