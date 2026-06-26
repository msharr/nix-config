# linear-triage — schedule

Runs as a **cloud routine** (claude.ai Routines), not via nix — `darwin-rebuild`
doesn't manage it. Edit/recreate it through the `/schedule` skill.

- **Routine:** `trig_01Qi6Q56sjfUStJVRJKydS7z` · https://claude.ai/code/routines/trig_01Qi6Q56sjfUStJVRJKydS7z
- **Schedule:** `20 7 * * 1-5` = weekdays **07:20 UTC / 08:20 BST** (fixed UTC — in winter/GMT this is 07:20 local)
- **Connectors:** Linear, Slack, Intercom · DMs `D03G9CAE3RV`
- **Prompt:** a self-contained copy of [SKILL.md](SKILL.md) — if you change the skill, update the routine too.

Recreate/update with the `/schedule` skill, e.g. "update the daily Linear triage routine `trig_01Qi6Q56sjfUStJVRJKydS7z`".
