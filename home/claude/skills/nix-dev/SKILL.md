---
name: nix-dev
description: How to run project commands (bun, pnpm, node, and other dev tooling) on this machine. Use whenever you need to install dependencies, run a dev server, run tests, run a build, or invoke any JS/TS toolchain binary. Required because bun/pnpm/node are NOT on the global PATH — they only exist inside the project's nix devShell.
---

# Running commands in the nix devShell

On this machine, `bun`, `pnpm`, `node`, and most project toolchain binaries are
**not installed globally**. They are provided by the project's nix flake
devShell. Running them directly (e.g. `bun install`) will fail with
"command not found".

## The rule

Prefix every toolchain command with `nix develop -c`:

```bash
nix develop -c bun install
nix develop -c bun run dev
nix develop -c pnpm test
nix develop -c node script.js
```

`nix develop -c <cmd>` runs a single command inside the devShell without
entering an interactive shell, so it works cleanly from non-interactive tool
calls. Do **not** run a bare `nix develop` (it opens an interactive shell and
will hang).

## Practical notes

- Run it from the project root (where `flake.nix` lives). If you're in a
  subdirectory, the nearest flake up the tree is used; `cd` to the root if
  unsure.
- The first invocation in a session may be slow while nix evaluates and builds
  the shell. Subsequent ones are fast (cached). Allow a generous timeout on the
  first call.
- Chaining: wrap multiple commands in a shell invocation, e.g.
  `nix develop -c bash -c "bun install && bun run build"`.
- If a command genuinely isn't found even inside the shell, the dependency may
  be missing from the flake's devShell — surface that rather than installing it
  globally.
- Never `npm install -g`, `brew install`, or otherwise add these tools to the
  global system to work around this — the devShell is the source of truth.
