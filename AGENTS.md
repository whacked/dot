# Emacs Config Modernization — Migration Guide

## Context

Migrating from a monolithic `org-babel-load-file` literate config to a flat set of
self-contained `.el` modules loaded from `init.el`.

**Working branch:** `2026-03_ai-assited-emacs-refactor`
**Emacs versions:**
- CLI (testing): GNU Emacs 30.2 via `~/.nix-profile/bin/emacs`
- GUI (daily driver): Carbon Emacs at `/Applications/Emacs.app`

---

## File Layout

```
emacs.d/
  early-init.el        # Emacs-native: loaded before GUI/package.el init
  init.el              # Emacs-native: master loader, lists all requires
  my-core.el           # core utils, env vars, exec-path
  my-ui.el             # visual defaults, theme, custom faces
  my-completion.el     # vertico, consult, marginalia, corfu, orderless
  my-editing.el        # global editing settings, save hooks, keybindings
  my-org.el            # org-mode config
  my-packages.el       # remaining active packages
  my-system.el         # OS/machine-specific config
  mode/                # local minor modes (highlight-chat-mode, tsv-mode, etc.)
  custom.el            # Emacs-managed; loaded by init.el, not hand-edited
  config.org           # LEGACY — being emptied block by block, then deleted
  config.el            # LEGACY — tangled copy; no longer loaded after scaffold
```

The `my-` prefix avoids load-path collisions with MELPA packages.

---

## Migration Strategy

### Phase 0: Scaffold (done first)
1. Write `early-init.el` — GC tuning, disable `package.el` early, suppress UI flash
2. Rewrite `init.el` — empty require list, load-path setup, load `custom.el`
3. `config.org` / `config.el` are **no longer loaded** — Emacs starts vanilla
4. Commit

### Phase 1+: Block-by-block migration
For each semantic block:
1. **Extract** the relevant section from `config.org` into `my-<topic>.el`
2. **Clean** while extracting:
   - Remove dead/commented-out code
   - Replace deprecated APIs (`defadvice` → `advice-add`, `eval-after-load` → `:after`)
   - Replace obsolete vars (`special-display-*`, `org-remember-*`)
   - Consolidate duplicate `custom-set-faces` calls
3. **End each file** with `(provide 'my-<topic>)` for `require`-based navigation
4. **Test syntax** with headless Emacs (see Testing section)
5. **Add** `(require 'my-<topic>)` to `init.el`
6. **Remove** the migrated section from `config.org`
7. **Commit** (see commit style below)
8. **GUI smoke test:** restart `/Applications/Emacs.app` and verify the block works

### Phase Final
- Delete `config.org` and `config.el` once both are empty
- Commit

---

## Planned Block Order

| # | Module | Key contents |
|---|--------|-------------|
| 0 | scaffold | `early-init.el`, `init.el` |
| 1 | `my-core` | `path-join`, `insert-timestamp`, env vars, exec-path, straight.el bootstrap |
| 2 | `my-ui` | visual defaults, theme (`modus-operandi-tinted`), faces |
| 3 | `my-completion` | vertico, consult, marginalia, corfu, orderless |
| 4 | `my-editing` | global settings, keybindings, `my-keys-minor-mode` |
| 5 | `my-packages` | eat, treesit-auto, markdown-mode, magit, paredit, etc. |
| 6 | `my-org` | org, org-babel, org-logseq, org-capture |
| 7 | `my-system` | darwin/linux branches, system-name sub-configs |
| 8 | cleanup | delete `config.org`, `config.el`; consolidate `mode/` locals |

Order may shift based on dependencies discovered during migration.

---

## Package Considerations

- **Package manager:** straight.el + use-package (already in place)
- **Watch for packages that need special sourcing:**
  - GitHub-only packages: use `straight` recipe with `:host github :repo ...`
  - Previously via quelpa: find equivalent straight recipe
  - Local `.el` files in `emacs.d/mode/`: add `mode/` to `load-path` in `init.el`
- **Broken/obsolete packages:** flag during migration; either find a replacement,
  fix the recipe, or drop it. Document the decision in the commit message.
- **CJK and other possibly-obsolete sections:** evaluate whether they're needed
  on current hardware; drop if not, otherwise migrate.

---

## Testing Protocol

### Syntax / byte-compile check (headless)
```bash
emacs --batch -Q -f batch-byte-compile emacs.d/my-<topic>.el
```

### Idempotency check (load twice, expect no errors)
```bash
emacs --batch -Q \
  --eval "(add-to-list 'load-path \"$(pwd)/emacs.d\")" \
  --load emacs.d/my-<topic>.el \
  --load emacs.d/my-<topic>.el \
  --eval "(message \"idempotency ok\")"
```

Note: modules using `straight.el` / `use-package` require the full init to be
loaded first for real functional testing. Batch mode covers syntax and structure;
GUI smoke test (`/Applications/Emacs.app`) covers behavior.

### GUI smoke test
Restart `/Applications/Emacs.app` and verify:
- No error messages at startup
- The feature(s) from the migrated block work as expected

---

## Git Commit Style

- **Subject prefix:** `[ai]`
- **Subject:** short imperative description (≤ 72 chars total)
- **Body:** thorough but concise — cover:
  - What old code/pattern was replaced
  - What replaced it and why
  - Any broken/obsolete items dropped and why
  - Any packages with non-standard sourcing

**Example:**
```
[ai] scaffold early-init.el and blank init.el

Replaced single-line init.el (org-babel-load-file config.org) with:
- early-init.el: disables package.el, raises GC threshold, suppresses
  UI flash before frame is ready. Runs before package init and GUI setup.
- init.el: establishes load-path (includes emacs.d/mode/ for local modes),
  loads custom.el, provides commented (require) list as the canonical load
  manifest. M-. on any require symbol navigates to that module file.

config.org and config.el are preserved in the repo but no longer loaded.
Emacs now starts vanilla — modules will be added block by block.
```

---

## Session Resume Notes

- Check git log for last `[ai]` commit to see where migration left off
- Check `config.org` for remaining sections (anything still there is not yet migrated)
- The `init.el` require list reflects what has been migrated so far
