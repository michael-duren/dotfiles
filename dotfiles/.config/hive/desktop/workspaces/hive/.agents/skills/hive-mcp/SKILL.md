---
name: hive-mcp
description: "Point a coding agent at this install's live MCP server — the tools it calls to drive the app directly, without editing config files. Use when configuring this in Hive Desktop (http://127.0.0.1:34857/mcp)."
---
Drive Hive Desktop directly through its local MCP server, instead of — or
alongside — editing its config files.

Hive Desktop is a desktop app that turns GitHub activity and webhook deliveries
into triaged feeds and automated coding-agent sessions. Its configuration is
plain text on this machine, meant to be edited directly:

- /Users/Z00HCXG/.config/hive/desktop/flows/<id>.yaml — flows: the graph that decides what reaches which feed and what fires an action.
- /Users/Z00HCXG/.config/hive/desktop/actions.yml — actions: what a feed item, a terminal session or window, or a flow node can trigger.
- /Users/Z00HCXG/.config/hive/desktop/settings.yaml — app settings: polling, updates, notifications, appearance, keyboard shortcuts.

This install also runs an MCP server whose tools observe and operate the app:
list and create profiles, read a profile's graph, read the inbox and feeds, set
a profile avatar, force a source refresh, and dry-run a flow against a payload
you supply — without editing the files above.

Connect over Streamable HTTP at:

    http://127.0.0.1:34857/mcp

There is no token to configure: the server is bound to loopback and runs no
command you write. A source refresh still runs the command sources a flow
already declares, and nothing here starts an agent.

Every tool is also a `hive dt` command with the same input: `inbox_list` is
`hive dt inbox list`, and `--input` takes the arguments as JSON.

The server describes itself, so you do not work from this prompt — you work
from the server. Call `tools/list` and work from what it reports; the input
schemas come from the server's own types, so they never drift from what it
actually accepts.

Conventions those schemas assume:

- A failing tool answers with an error result whose text opens with a stable machine string — `invalid`, `not_found`, `conflict`, `unavailable`, `unauthenticated`, `internal` — followed by the detail. Branch on that, never on the prose.
- Every id-taking argument names a profile, and `profile_list` is where profile ids come from. `flow_get` turns one into its graph, which is where node ids come from — `flow_preview` and the node-image tools take those.
- A thing that does not exist is `not_found`, not an empty collection. An empty list means nothing has landed there, never that you named the wrong profile, feed or item.
- Images go in as base64 and come back as images: `profile_image_put` takes base64 bytes (a `data:` URL is accepted, prefix and all), while `profile_image_get` answers with the PNG itself.
- Any tool that would answer with source-supplied JSON takes a `detail` argument and defaults to `summary`, which omits it. A payload is as large as the source made it and gets repeated per item or per node, so ask for `full` only once you have narrowed the read. Each answer echoes the level it used.
- Scheduled chats are managed here too. `workspace_list` names the agent workspaces; `schedule_list`, `schedule_put` and `schedule_delete` read and write one workspace's `schedules:` list, editing its `agent-workspace.yaml` in place with every other key and comment kept; `schedule_put` on an existing id changes only the fields you pass, so an omitted `disabled` or `name` stays as stored; `schedule_preview` dry-runs a cron and prompt template before you save it, rendering the prompt both with a previous run and as the first run sees it; `schedule_run_list` reads what a schedule did. Running a schedule outside its timetable spawns an agent CLI, which this server never does; that stays the Chats area's "Run now".
- Hive sessions carry tags, and tags are how an agent finds the sessions it works on. `session_list` filters by tags (every tag must match, ignoring case) and by state; `session_tags_update` adds and then removes tags on one session in a single call, and starts or attaches nothing. An orchestrator polls `session_list` with `tags: ["auto"]`, and when it picks a session up it calls `session_tags_update` with `remove: ["auto"]` and `add: ["claimed"]`, so the next poll does not return that session again. A launch-session action or flow node can put `tags` on a session when it creates one.
- Reads and dry runs are safe to repeat. `flow_preview` commits nothing in particular — no feed membership, inbox rows, notifications, queued actions or durable kv — so use it to test a flow edit, including one you have not saved, instead of deploying and waiting for a poll.

---

What I want:

<describe it here>
