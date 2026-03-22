# <img src='Workflow/icon.png' width='45' align='center' alt='icon'> Orion Bookmarks

Search Orion bookmarks, history, & reading list in Alfred

## Setup

This workflow requires [jq](https://jqlang.github.io/jq/) to function, which comes preinstalled on macOS 15 Sequoia and later.

## Usage

Search for your [Orion](https://orionbrowser.com) bookmarks via the `bm` keyword. Type to refine your search.

![Searching for Orion bookmarks](Workflow/images/about/keyword.png)

Bookmarks are always searchable by Name, while filtering by Folder, Keyword, and URL is configurable from the [Workflow’s Configuration](https://www.alfredapp.com/help/workflows/user-configuration/).

![Narrowing search for Orion bookmarks](Workflow/images/about/tagFilter.png)

* <kbd>↩</kbd> Open bookmark in primary browser.
* <kbd>⇧</kbd><kbd>⌘</kbd><kbd>↩</kbd> Open in primary browser without closing Alfred.
* <kbd>⌘</kbd><kbd>↩</kbd> Open bookmark in secondary browser.
* <kbd>⌘</kbd><kbd>L</kbd> View Folder and full URL in Large Type.

Search your Orion History and Reading List via the `bh` and `rl` keywords respectively. History and Reading List entries are searchable by Name and URL. Reading List entries are also searchable by Read/Unread status.

![Searching Orion History](Workflow/images/about/history.png)

![Searching Orion Reading List](Workflow/images/about/readingList.png)

* <kbd>↩</kbd> Open entry in primary browser.
* <kbd>⇧</kbd><kbd>⌘</kbd><kbd>↩</kbd> Open in primary browser without closing Alfred.
* <kbd>⌘</kbd><kbd>↩</kbd> Open entry in secondary browser.
* <kbd>⌘</kbd><kbd>L</kbd> View full Date and URL in Large Type.

Append `::` to the configured [Keywords](https://www.alfredapp.com/help/workflows/inputs/keyword) to access other actions, including opening the Current Profile in Finder. Bookmarks, History, and Reading Lists are indexed from the Default profile set in Orion, unless overridden in the [Workflow’s Configuration](https://www.alfredapp.com/help/workflows/user-configuration/).

![Other actions](Workflow/images/about/inlineSettings.png)

Configure the [Hotkeys](https://www.alfredapp.com/help/workflows/triggers/hotkey/) as shortcuts for searching your bookmarks and history.

Bookmarks in a folder named `Exclude-Alfred` will be hidden from search. This folder is case sensitive.