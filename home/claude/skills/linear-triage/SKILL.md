---
name: linear-triage
description: Triage the Linear issues assigned to Michael — routing each via the existing `awaiting-detail` / `Claude` / `needs-human` labels (or cancelling addressed-elsewhere ones), improving his own under-specified issues, checking customer correspondence and the web-client codebase, and DMing a coverage summary to Slack. Use for the daily Linear backlog triage routine.
# allowed-tools pre-approves these tools for INTERACTIVE runs (testing) so you
# aren't prompted. It is IGNORED by scheduled routines — those are scoped by the
# Connectors you enable in the /schedule form (see "RUNNING AUTONOMOUSLY" below).
allowed-tools:
  - mcp__claude_ai_Linear__*
  - mcp__claude_ai_Slack__*
  - mcp__claude_ai_Intercom__*
  - Read
  - Grep
  - Glob
---

# Linear morning backlog triage

Every morning, triage the Linear issues currently assigned to Michael (michael@fugo.ai) and route each into an outcome:

1. **Needs more detail** → label `awaiting-detail`.
2. **Ready to work on** → label `Claude` (well-defined + code-shaped) or `needs-human` (needs Michael).
3. **Addressed elsewhere / can be cancelled** → cancel (no label).

Act automatically — you are authorized to edit Michael's own issues, post comments on others' issues, apply/change labels, and cancel obsolete issues without asking for confirmation.

== TOOLS ==

- Linear MCP (list_users, list_issues, get_issue, save_issue, save_comment, list_comments, list_issue_labels, list_issue_statuses). `save_issue` is used for description edits, label changes, and state changes (cancelling).
- Slack MCP tools are prefixed mcp__efa6eeb7-7285-4389-a169-e28022ce1212__ (slack_search_users, slack_send_message). Michael's Slack channel ID is D03G9CAE3RV — DM the summary by passing that as channel_id.
- Intercom MCP (search, get_conversation, get_contact) — to check for further customer correspondence on customer-reported issues (see Step 2). Read-only: never message the customer.
- fugo-cms-client codebase (read-only) — for web-client bug verification (see Step 2). Interactive run: read it locally at `/Users/msharr/Documents/fugo/fugo-cms-client`. Scheduled cloud run: it's checked out from `https://github.com/OutOfAxis/fugo-cms-client` (Claude GitHub App required on the repo).
- Michael's Linear user is michael@fugo.ai. `assignee:"me"` resolves to Michael. Resolve Michael's own user id once (via list_users or the authenticated identity) so you can compare `createdById` to tell Michael's own issues from issues others created and assigned to him.

== LABELS (existing team labels — matched BY NAME, do NOT invent new ones) ==
Route each non-cancelled issue to exactly one of these three labels. They already exist in the workspace (Web Client, Marketing, etc.), may be nested in a mutually-exclusive label group, and an issue carries at most one of them:

- `awaiting-detail` = under-specified; a request for detail is pending (your comment or an active thread).
- `Claude` = ready + code-shaped; "done" is objective (broken links, responsive fixes, surfacing data fields, clear bugs with repro). A separate Claude Code routine auto-works these. **Capitalisation matters — the label is `Claude`.**
- `needs-human` = ready/understood but the core work needs Michael: heavy UI/UX or visual-design decisions, creating/uploading assets an agent can't produce, subjective taste/product calls, or visual QA.
- (no label) addressed-elsewhere → set the issue to its team's **Canceled** state.

== TOOLING CONSTRAINT ==
Use the Linear, Slack, and Intercom MCP tools, plus READ-ONLY access to the fugo-cms-client codebase (only for the Step 2 web-client verification). Beyond those, NEVER rely on a local shell or python to work around MCP tool limits — paginate inside the tool instead (smaller `limit`, `cursor`). The scheduled cloud routine has no shell anyway, and an interactive run would stall on approval gates.

== STEP 1: COUNT FIRST, THEN LIST EVERY ASSIGNED ISSUE ==
FIRST establish and COUNT the full set of open issues assigned to Michael — this is the coverage check you reconcile against at the end so the run can prove nothing was missed.
`list_issues(assignee:"me")` with no state filter exceeds the token limit, and even a single state at `limit:100` can overflow. So query each state separately with a SMALL page size and paginate:

- list_issues(assignee:"me", state:"started", limit:25)
- list_issues(assignee:"me", state:"unstarted", limit:25)
- list_issues(assignee:"me", state:"backlog", limit:25)

Query ALL THREE states. Whenever a response has hasNextPage:true, follow the `cursor` until every issue is pulled. If a page still overflows, drop `limit` (e.g. 15) and retry — never fall back to a shell. Record the TOTAL and per-state counts. Set aside (counted, with reason) statusType completed/canceled/triage and archived issues. Build a ledger: every remaining issue must end in exactly one outcome bucket — labelled Claude, labelled needs-human, commented+awaiting-detail (others'), still-awaiting-detail (carried over), promoted, cancelled, left-as-is (detailed but wrong state), or skipped (with reason).
Identify yourself: every listed issue's assigneeId is Michael's id; compare createdById to it to tell Michael's issues from others'.

== STEP 2: ASSESS & ROUTE EACH ISSUE ==
Read the description and comments. If the description is cut off with "(truncated…)", call get_issue first. Decide the outcome — **check for cancellable first** (don't improve something you're about to cancel):

**(a) Addressed elsewhere / obsolete → CANCEL.** Only when there is *clear evidence*: an explicit duplicate of another issue, work already shipped, or plainly superseded/obsolete. Cancel by setting the issue to its team's Canceled state (statusType: canceled) via save_issue, and leave a save_comment stating why. Be conservative — if unsure, don't cancel. Never cancel In Progress / In Review issues; flag them in the report.

**(b) Ready (detailed enough) → route `Claude` vs `needs-human`:**
  - `Claude` for well-defined, code-shaped work where "done" is objective.
  - `needs-human` when the core work is heavy UI/UX or visual-design decisions, creating/uploading assets an agent can't produce, subjective taste/product calls, or visual QA. When routing to needs-human, add a short "## What's needed from you" note (or brief comment) listing exactly what unblocks automation.
  - Test for Claude: could an agent know it's done from code + acceptance criteria alone? Genuinely mixed → lean `needs-human`.

**(c) Needs more detail** (vague one-liners, image-only or empty descriptions, missing acceptance criteria):
  - **Created by Michael → IMPROVE** via save_issue: preserve the existing description verbatim at the top, then append `## Goal`, `## Context`, `## Acceptance criteria` (checklist), `## Open questions`. Only inferable context; unknowns as open questions. Don't change the title meaning, status, assignee, priority, or estimate. Then route: if your improvement made it fully actionable → `Claude` or `needs-human` (per the test in (b)); if open questions remain that block starting → `awaiting-detail`.
  - **Created by someone else → DO NOT edit.** Post a save_comment @mentioning the creator with the specific missing details (expected/current behaviour, reference/screenshot, acceptance criteria, affected area), then apply `awaiting-detail`. If an active thread is already sorting out the detail, skip the comment but still apply `awaiting-detail`.

**Customer-reported issues** (carry a `User Reported` label or link an Intercom thread): before settling on an outcome, check Intercom for further correspondence — open the linked conversation, or search Intercom by the customer / subject. A newer customer reply may (i) supply the missing detail → fold it in (improve, per above) and route `Claude`/`needs-human`; (ii) indicate it's resolved or no longer reproducing → treat as cancellable per (a); or (iii) still be unanswered → `awaiting-detail`. Read-only — never message the customer.

**Web-client bug verification** (bugs in the Web Client / Fugo teams that look like fugo-cms-client issues): do a QUICK, read-only check of the fugo-cms-client codebase (interactive: `/Users/msharr/Documents/fugo/fugo-cms-client`; cloud routine: the checked-out repo) to gauge whether the bug still exists. This is a sanity check, NOT a debugging session — timebox it, grep the relevant area, don't trace deeply. If the code clearly shows it's already fixed → CANCEL per (a) with a comment pointing at the fix. If there's reasonable doubt either way → route `Claude` (code-shaped) or `needs-human`. Never edit code. (If the codebase isn't available, skip this check, route on the issue text alone, and note it as skipped.)

== STEP 3: RE-EXAMINATION LOOP (idempotency across daily runs) ==
All three labels are temporary states. On EVERY run:
- Re-examine each `awaiting-detail` issue (latest description, ALL comments, attached docs/links, and any Intercom correspondence for customer issues): if the detail is now sufficient → remove `awaiting-detail` and route it (`Claude` if code-shaped, `needs-human` if it needs Michael). If still nothing, leave it; don't re-nag.
- Re-examine each `needs-human` issue: if Michael has resolved the human blocker (design decided, assets present, acceptance criteria clear) → PROMOTE: remove `needs-human`, add `Claude`.
Keep labels stable — no run-to-run flip-flopping; demote `Claude`→`needs-human` only on a true regression; don't re-improve an already-improved issue unless it regressed; don't re-cancel.

== LABELLING SAFELY ==

- save_issue REPLACES the label set — always read current labels first and pass EXISTING labels PLUS/MINUS the change. A transition (e.g. `awaiting-detail`→`Claude`) = old label removed and new one added in one call. These three are mutually exclusive (one queue at a time).
- **NEVER create labels.** These are existing team labels. If one of the three doesn't exist in an issue's team, do NOT create it — instead post a save_comment stating the intended outcome (e.g. "Triage → awaiting-detail") and flag it in the report under LEFT AS-IS/SKIPPED ("label missing in &lt;team&gt;"). Never drop the issue from the count.
- For improve-and-label saves, fold the label into the same save_issue call; otherwise do minimal label-only saves.

== DEDUP / SAFETY ==
Before commenting on someone else's issue, list_comments and check the LATEST comment. SKIP commenting if the last comment is from Michael (his previous request still stands — don't repeat it and spam teammates), if you already left a request-for-detail comment, or if an active thread is sorting it out. In every skip case still apply/keep the `awaiting-detail` label. Don't re-improve an already-improved issue unless it regressed. Re-saving a description containing an embedded image with a time-limited signed URL (uploads.linear.app/...?signature=...) can break the image — leave such descriptions untouched (label-only saves are fine). Cancel only on clear evidence (Step 2a); when in doubt, don't.

== STEP 4: REPORT IN SLACK ==
DM Michael (channel_id D03G9CAE3RV). LEAD with the coverage check; buckets must sum to the total — if they don't, say so and list the unaccounted issues:

- COVERAGE CHECK: "N assigned · N processed :white_check_mark:" (from Step 1).
- IMPROVED (your own): identifier, title, one-line note, URL.
- LABELLED `Claude` (handed to the agent): identifiers/count.
- FLAGGED `needs-human`: identifier + one-line reason + what unblocks each.
- AWAITING-DETAIL — commented (others'): identifier, title, creator, what you asked for, URL.
- AWAITING-DETAIL — still open (carried over, no response yet): count, optionally identifiers.
- PROMOTED (awaiting-detail→routed, or needs-human→Claude): identifiers.
- CANCELLED (addressed elsewhere): identifier, title, reason, URL.
- CUSTOMER CORRESPONDENCE CHECKED (issues where Intercom changed the outcome): identifier, note.
- VERIFIED IN CODE (web-client issues checked against fugo-cms-client): identifier, verdict.
- LEFT AS-IS / SKIPPED (detailed but wrong state, embedded-image, no-permission, codebase unavailable): brief note/count.

If nothing needed action: "Your backlog looks healthy today :white_check_mark: (N assigned, C Claude, H need you, A awaiting detail)". Always finish with the Slack DM even if no changes were made.

== RUNNING AUTONOMOUSLY (scheduling setup) ==
This skill is built to run unattended as a scheduled routine (Claude Code cloud session via /schedule).

- **No per-run approvals.** Routines execute autonomously with no permission prompts — they always run in bypass mode. You do NOT configure permission modes or `permissions.allow` for the scheduled run. The `allowed-tools` frontmatter above is only for interactive testing.
- **Scope access via Connectors.** When creating the routine, enable exactly the connectors this skill uses:
  - **Linear** — list_users, list_issues, get_issue, save_issue, save_comment, list_comments, list_issue_labels, list_issue_statuses.
  - **Slack** — slack_search_users, slack_send_message (DM the summary to channel D03G9CAE3RV).
  - **Intercom** — search, get_conversation, get_contact (customer-correspondence check).
- **Repository access (for web-client bug verification).** Attach `OutOfAxis/fugo-cms-client` as a git source and install the Claude GitHub App on it. The cloud env has no local filesystem, so the local path only works interactively. Read-only — the skill never commits or edits code. If the repo isn't attached, the web-client verification step is skipped.
- **Schedule:** weekday mornings. See [SCHEDULE.md](SCHEDULE.md) for the live routine id and cron.
- The routine's authenticated identity must be Michael so `assignee:"me"` resolves to him.
