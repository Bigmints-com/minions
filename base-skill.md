---
name: minions
description: Execute a YAML prompt queue sequentially against the Gemini CLI (pi) without manual intervention. Supports dry-run preview, per-prompt overrides, and run logs.
---

# Minions Batch Prompt Scheduler

**Triggers:** "run my queue" | "execute the queue" | "check my minions queue" | "schedule these prompts" | "batch these tasks"

**CLI:** `pi` (or `minions`), symlinked globally from `.agents/skills/minions/scripts/minions`

---

## Queue File Format

```yaml
queue:
  - name: "Task label"          # required — shown in logs
    prompt: "Full prompt text"  # required
    workdir: /path/to/dir       # optional — override per prompt
    model: gemini-2.0-flash     # optional — override per prompt
    approval_mode: auto_edit    # optional — default | auto_edit | yolo
    context_files:              # optional — JSON files to compress with TOON before injecting
      - path/to/data.json
```

**Search order for queue file:**
1. Path explicitly provided by user
2. `./queue.yaml`
3. `./prompts.yaml`
4. `./batch.yaml`
5. `.agents/queue/` directory

---

## TOON Context Compression (Pre-Run Step)

Before executing any queue, scan each prompt entry for `context_files`. For every listed `.json` file:

1. **Compress with TOON:**
   ```bash
   npx @toon-format/cli <file.json> --stats        # report savings
   npx @toon-format/cli <file.json> -o <file.toon> # write compressed file
   ```

2. **Inject into the prompt** — append a TOON block before the task instruction:
   ```
   Data is in TOON format.
   ```toon
   <contents of file.toon>
   ```
   Task: <original prompt text>
   ```

3. **Skip if not uniform arrays** — if the file is deeply nested config, skip TOON and inject raw compact JSON instead. Use `--stats` output to decide: if savings < 10%, skip.

This step runs **before** dry-run. The rewritten prompts (with TOON blocks injected) are what gets previewed and executed.

---

## Actions

### Show / Check Queue
1. Find the queue file (search order above)
2. Display its contents and summarize task names
3. Ask if user wants to run it

### Create Queue
1. Collect tasks from user (or infer from context)
2. For each task that references large data, add a `context_files:` entry pointing to the JSON
3. Write `queue.yaml` at project root
4. Show dry-run preview (with TOON compression applied)

### Run Queue

**Step 1 — Compress context files (TOON pre-processing)**
Run TOON compression for all `context_files` entries across all prompts (see above).

**Step 2 — Dry-run with compressed prompts:**
```bash
pi --queue <file> --workdir <project-dir> --dry-run
```

**Step 3 — Confirm with user, then execute:**
```bash
pi --queue <file> --workdir <project-dir> --approval-mode yolo
```

---

## CLI Flags Reference

| Flag | Default | Description |
|---|---|---|
| `--queue <file>` | required | Path to YAML queue file |
| `--workdir <dir>` | `.` | Working directory for each prompt |
| `--approval-mode <mode>` | `yolo` | `default` \| `auto_edit` \| `yolo` |
| `--dry-run` | off | Print prompts without executing |
| `--continue-on-error` | off | Don't abort on failure |
| `--model <model>` | CLI default | Override Gemini model |
| `--delay <seconds>` | `2` | Wait between prompts |
| `--log-dir <dir>` | `./runs/` | Run log output directory |

---

## Run Logs

Each run writes `<log-dir>/run-<timestamp>.log` with per-prompt start/end times, exit codes, and a summary. Check `.agents/queue/status.md` for recent run history.
