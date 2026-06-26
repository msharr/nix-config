---
name: linear-triage
description: Triage the Linear backlog issues assigned to Michael into three buckets — needs more detail, ready to work on, or addressed elsewhere (cancel) — applying labels, improving his own under-specified issues, cancelling obsolete ones, and DMing a coverage summary to Slack. Use for the daily Linear backlog triage routine.
# allowed-tools pre-approves these tools for INTERACTIVE runs (testing) so you
# aren't prompted. It is IGNORED by scheduled routines — those are scoped by the
# Connectors you enable in the /schedule form (see "RUNNING AUTONOMOUSLY" below).
# Adjust the server prefixes to match your connected MCP server names.
allowed-tools:
  - mcp__claude_ai_Linear__*
  - mcp__claude_ai_Slack__*
  - mcp__claude_ai_Intercom__*
  - Read
  - Grep
  - Glob
---

# Linear morning backlog triage

Every morning, triage the Linear issues currently assigned to Michael (michael@fugo.ai) into three buckets and act on each:

1. **Needs more detail** — under-specified; missing a clear goal, acceptance criteria, or context.
2. **Ready to work on** — well-defined enough to start.
3. **Addressed elsewhere / can be cancelled** — duplicate, already shipped, superseded, or obsolete.

Act automatically — you are authorized to edit Michael's own issues, post comments on others' issues, apply/change labels, and cancel obsolete issues without asking for confirmation.

== TOOLS ==

- Linear MCP (list_users, list_issues, get_issue, save_issue, save_comment, list_comments, create_issue_label, list_issue_labels, list_issue_statuses). `save_issue` is used for description edits, label changes, and state changes (cancelling).
- Slack MCP tools are prefixed mcp__efa6eeb7-7285-4389-a169-e28022ce1212__ (slack_search_users, slack_send_message). Michael's Slack channel ID is D03G9CAE3RV — DM the summary by passing that as channel_id.
- Intercom MCP (search, get_conversation, get_contact) — to check for further customer correspondence on customer-reported issues (see Step 2). Read-only: never message the customer.
- fugo-cms-client codebase (read-only) — for web-client bug verification (see Step 2). Interactive run: read it locally at `/Users/msharr/Documents/fugo/fugo-cms-client`. Scheduled cloud run: it must be attached as a git source AND the Claude GitHub App installed on the repo — the cloud session has no local filesystem.
- Michael's Linear user is michael@fugo.ai. `assignee:"me"` resolves to Michael. Resolve Michael's own user id once (via list_users or the authenticated identity) so you can compare `createdById` to tell Michael's own issues from issues others created and assigned to him.

== CATEGORIES & LABELS (matched BY NAME) ==
The first two buckets are marked with a Linear label; the third is cancelled (no label). An issue ends in exactly one bucket.

- `needs-detail` = under-specified; a clear goal / acceptance criteria / context is missing.
- `ready` = detailed enough to start work.
- (no label) addressed-elsewhere → set the issue to its team's **Canceled** state.

Labels are matched by name (they may be nested in a label group — names don't change; Linear makes same-group labels mutually exclusive per issue, which matches the one-bucket-at-a-time semantics).

== TOOLING CONSTRAINT (read first) ==
Use the Linear, Slack, and Intercom MCP tools, plus READ-ONLY access to the fugo-cms-client codebase (only for the Step 2 web-client verification). Beyond those, NEVER rely on a local shell, python, or saved tool-result files to work around anything — the scheduled cloud routine has none of those, and an interactive run would stall on approval gates. If a tool response is too large, handle it inside the MCP tool itself (smaller `limit`, paginate via `cursor`), never by post-processing a file.

== STEP 1: COUNT FIRST, THEN LIST EVERY ASSIGNED ISSUE ==
FIRST establish and COUNT the full set of open issues assigned to Michael — this is the coverage check you reconcile against at the end so the run can prove nothing was missed.
`list_issues(assignee:"me")` with no state filter exceeds the token limit, and even a single state at `limit:100` can overflow. So query each state separately with a SMALL page size and paginate:

- list_issues(assignee:"me", state:"started", limit:25)
- list_issues(assignee:"me", state:"unstarted", limit:25)
- list_issues(assignee:"me", state:"backlog", limit:25)

Query ALL THREE states. Whenever a response has hasNextPage:true, follow the `cursor` until every issue is pulled. If a page still overflows the token limit, drop `limit` further (e.g. 15) and retry — never fall back to a shell. Record the TOTAL and per-state counts. Set aside (counted, with reason) statusType completed/canceled/triage and archived issues. Build a ledger: every remaining issue must end in exactly one outcome bucket — improved→ready, improved→needs-detail, commented+needs-detail (others'), labelled ready, cancelled, still-needs-detail (carried over), left-as-is (detailed but wrong state), or skipped (with reason).
Identify yourself: every listed issue's assigneeId is Michael's id; compare createdById to it to tell Michael's issues from others'.

== STEP 2: ASSESS & CATEGORISE EACH ISSUE ==
Read the description and comments. If the description is cut off with "(truncated…)", call get_issue first. Decide the bucket — **check for cancellable first** (don't improve something you're about to cancel):

**(a) Addressed elsewhere / obsolete → CANCEL.** Only when there is *clear evidence*: an explicit duplicate of another issue, work already shipped, or the issue is plainly superseded/obsolete (signals in the description or comments). Cancel by setting the issue to its team's Canceled state (statusType: canceled) via save_issue, and leave a save_comment stating why (e.g. "Cancelled: duplicate of ENG-9" / "already shipped in <PR/issue>"). Be conservative — if you are not confident, do NOT cancel; treat it as (b) or (c) instead. Never cancel In Progress / In Review issues; flag them in the report instead.

**(b) Ready (detailed enough)** — clear goal, acceptance criteria, context, constraints → apply the `ready` label.

**(c) Needs more detail** (vague one-liners, image-only or empty descriptions, missing acceptance criteria):
  - **Created by Michael → IMPROVE** via save_issue: preserve the existing description verbatim at the top, then append `## Goal`, `## Context`, `## Acceptance criteria` (checklist), `## Open questions`. Use only inferable context; record unknowns as open questions. Don't change the title meaning, status, assignee, priority, or estimate. Then label: if open questions remain that block starting → `needs-detail`; if your improvement made it fully actionable → `ready`.
  - **Created by someone else → DO NOT edit.** Post a save_comment @mentioning the creator with the specific missing details (expected/current behaviour, reference/screenshot, acceptance criteria, affected area), then apply the `needs-detail` label. If an active thread is already sorting out the detail, skip the comment but still apply `needs-detail`.

**Customer-reported issues** (carry a `User Reported` label or link an Intercom thread): before settling on a bucket, check Intercom for further correspondence — open the linked conversation, or search Intercom by the customer / subject. A newer customer reply may (i) supply the missing detail → fold it into the issue (improve, per the rules above) and route to `ready`; (ii) indicate it's resolved or no longer reproducing → treat as cancellable per (a); or (iii) still be unanswered → proceed to `needs-detail` as normal. This is read-only triage of existing correspondence — never message the customer.

**Web-client bug verification** (bugs in the Web Client / Fugo teams that look like fugo-cms-client issues): do a QUICK, read-only check of the fugo-cms-client codebase (interactive: `/Users/msharr/Documents/fugo/fugo-cms-client`; cloud routine: the attached git checkout) to gauge whether the bug still exists. This is a sanity check, NOT a debugging session — timebox it, grep the relevant area, don't trace deeply. If the code clearly shows it's already fixed → CANCEL per (a) with a comment pointing at the fix. If there's reasonable doubt either way → mark `ready` and let a human/agent verify. Never edit code. (If the codebase isn't available — repo not attached in the cloud run — skip this check and route on the issue text alone; note it as skipped.)

== STEP 3: RE-EXAMINATION LOOP (idempotency across daily runs) ==
Both labels are temporary. On EVERY run, re-examine issues already carrying `needs-detail` (latest description, ALL comments, attached docs/links): if the detail is now sufficient (Michael fleshed it out, or the creator responded) → remove `needs-detail`, add `ready` in one save_issue. If still nothing, leave it; don't re-nag. Keep labels stable — no run-to-run flip-flopping, and don't re-improve an already-improved issue unless it regressed. Don't re-cancel already-cancelled issues (they're excluded by the state filter anyway).

== LABELLING SAFELY ==

- save_issue REPLACES the label set — always read current labels first and pass EXISTING labels PLUS/MINUS the change. A transition (needs-detail→ready) = old label removed and new one added in one call.
- If a label is missing in a team, try create_issue_label (team-scoped). If you can't create it (no permission in that team), fall back to posting a save_comment on the issue stating the intended bucket (e.g. "Triage → needs-detail" or "Triage → ready"), and note it in the report — never drop the issue from the count.
- For improve-and-label saves, fold the label into the same save_issue call; otherwise do minimal label-only saves.

== DEDUP / SAFETY ==
Before commenting on someone else's issue, list_comments and check the LATEST comment. SKIP commenting if the last comment is from Michael (his previous request still stands — don't repeat it and spam teammates), if you already left a request-for-detail comment, or if an active thread is sorting it out. In every skip case, still apply/keep the `needs-detail` label. Don't re-improve an already-improved issue unless it regressed. Re-saving a description containing an embedded image with a time-limited signed URL (uploads.linear.app/...?signature=...) can break the image — leave such descriptions untouched (label-only saves are fine). Cancel only on clear evidence (see Step 2a); when in doubt, don't.

== STEP 4: REPORT IN SLACK ==
DM Michael (channel_id D03G9CAE3RV). LEAD with the coverage check; buckets must sum to the total — if they don't, say so and list the unaccounted issues:

- COVERAGE CHECK: "N assigned · N processed :white_check_mark:" (from Step 1).
- IMPROVED (your own, now ready): identifier, title, one-line note, URL.
- NEEDS DETAIL — commented (others'): identifier, title, creator, what you asked for, URL.
- NEEDS DETAIL — still open (carried over, no response yet): count, optionally identifiers — keep stale requests visible.
- READY (good to pick up): identifiers/count.
- CANCELLED (addressed elsewhere): identifier, title, reason, URL.
- LEFT AS-IS / SKIPPED (detailed but wrong state, embedded-image, no-permission): brief note/count.

If nothing needed action: "Your backlog looks healthy today :white_check_mark: (N assigned, M ready, K need detail, J cancelled)". Always finish with the Slack DM even if no changes were made.

== RUNNING AUTONOMOUSLY (scheduling setup) ==
This skill is built to run unattended as a scheduled routine (Claude Code cloud session via /schedule).

- **No per-run approvals.** Routines execute autonomously with no permission prompts — they always run in bypass mode. You do NOT configure permission modes or `permissions.allow` for the scheduled run; those don't apply to routines. The `allowed-tools` frontmatter above is only for interactive testing.
- **Scope access via Connectors.** When creating the routine, enable exactly the connectors this skill uses:
  - **Linear** — list_users, list_issues, get_issue, save_issue, save_comment, list_comments, list_issue_labels, create_issue_label, list_issue_statuses.
  - **Slack** — slack_search_users, slack_send_message (DM the summary to channel D03G9CAE3RV).
  - **Intercom** — search, get_conversation, get_contact (customer-correspondence check on customer-reported issues).
- **Repository access (for web-client bug verification).** Attach the `fugo-cms-client` repo as a git source so the cloud session can read it, and install the Claude GitHub App on that repo. The cloud env has no local filesystem, so the local path only works for interactive runs. Read-only — the skill never commits or edits code. If the repo isn't attached, the web-client verification step is skipped (issues route on text alone).
- **Schedule:** weekday mornings (Mon–Fri), e.g. 08:00 local.
- The routine's authenticated identity must be Michael so `assignee:"me"` resolves to him.
