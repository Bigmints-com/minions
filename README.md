# Minions

Batch prompt scheduler for AI CLIs. 

Executes a YAML prompt queue sequentially without manual intervention. Designed to allow autonomous AI agents to schedule their own parallel or sequential task pipelines.

## Installation

### Globally via NPM
```bash
npm install -g minions
```

### Via NPX (no install)
```bash
npx minions --queue prompts.yaml
```

## Quick Start

1. **Create a prompt queue (`tasks.yaml`)**
```yaml
queue:
  - name: "Task 1: Generate Docs"
    prompt: "Write documentation for the project"
    workdir: ./docs
    approval_mode: yolo

  - name: "Task 2: Run Tests"
    prompt: "Execute unit tests and fix any failing tests"
    model: default-model
```

2. **Execute the queue**
```bash
minions --queue tasks.yaml
```

## Initializing in a Project

If you use AI agents in your project, you can scaffold the standard Minions skill documentation into your repository. This teaches your agents how to write queue files and invoke `minions`.

```bash
minions init
```
*Creates `.agents/skills/minions/SKILL.md` with instructions for your agents.*

## CLI Flags Reference

| Flag | Description | Default |
|---|---|---|
| `--queue <file>` | Path to YAML queue file | **Required** |
| `--workdir <dir>` | Base working directory for prompts | `.` |
| `--approval-mode <mode>` | `default`, `auto_edit`, or `yolo` | `yolo` |
| `--dry-run` | Print prompts without executing them | - |
| `--parallel` | Run all prompts concurrently | - |
| `--continue-on-error`| Don't abort the queue if a prompt fails | - |
| `--model <model>` | Override the model used | - |
| `--cli <name>` | Target AI CLI command | `pi` |
| `--sandbox` | Run the CLI in sandbox mode | - |
| `--delay <seconds>` | Delay between sequential prompts | `2` |
| `--log-dir <dir>` | Directory to write run logs | `./runs/` |

## Run Logs
Every execution writes a structured log to `./runs/run-<timestamp>.log` containing prompt outputs, execution durations, and exit codes.
