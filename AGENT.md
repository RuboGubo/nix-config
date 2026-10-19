# Task tracking with ai-todo

Use ai-todo to track substantial work and preserve enough context for another
session to continue. Keep the task record current as work progresses.

## Environment

- The CLI project is at `~/Projects/ai-todo`. Adjust this path if it moves.
- Run the CLI through **devenv**. The `todo` script invokes Cargo for you.
- Use the existing server at `127.0.0.1:3000`, unless the user specifies another
  address. Do not restart it or start a second server just to use the CLI.
- Run task commands from the ai-todo directory; perform project work in the
  target project's directory.

```sh
cd ~/Projects/ai-todo
devenv shell -- todo list
devenv shell -- todo show 1
```

For another server, put `--server HOST:PORT` before the subcommand:

```sh
devenv shell -- todo --server 127.0.0.1:4000 list
```

If a command fails, read the error and check the environment and server address.
Do not assume the server's task list is empty because a connection failed.

## Start or resume work

1. Read the target project's instructions and inspect its working tree.
2. Run `list`, then `show` the relevant tasks, including their descriptions and
   blockers. Resume existing work instead of creating duplicates.
3. Prefix new task titles with `[project-name]` to distinguish projects sharing
   the server. Include the target repository's absolute path in the description.
4. Create one task for the overall objective and actionable tasks for substantial
   steps. Use the IDs returned by the CLI; examples below use placeholder IDs.
5. Assign active work to your agent identity and mark it `in-progress` before
   starting. Keep routine, one-step edits lightweight.

```sh
devenv shell -- todo new --title '[project-name] Implement the requested feature' \
  --description 'Repository: /absolute/project/path. Goal: describe the requested outcome and constraints.' \
  --assignee 'primary-agent' --status in-progress

devenv shell -- todo update 1 --assignee 'primary-agent' --status in-progress
```

## Update progress and dependencies

- Valid statuses are `pending`, `in-progress`, and `completed`.
- Record findings, decisions, changes, validation results, and the next action
  after meaningful milestones or a change in approach.
- Keep observations separate from assumptions and untested proposals. An
  investigation can be completed even if its result rules out that approach;
  the overall objective stays open until achieved.
- There is no `blocked` status. Explain a blocker in the description, use
  `pending` when no work can proceed, and add dependency relationships where
  another task must finish first.
- `update --description` replaces the description. Read it first and retain
  relevant context when rewriting it.
- Put task IDs before field options. Quote titles and descriptions. Do not
  delete unrelated tasks or overwrite another agent's work.

```sh
devenv shell -- todo update 2 --description 'Goal: ... Findings: ... Validation: ... Next: ...'
devenv shell -- todo block 2 3
# Task 2 blocks task 3. Equivalent: relationship add 3 2.
devenv shell -- todo unblock 2 3
devenv shell -- todo update 2 --status completed
devenv shell -- todo show 1 2 3
```

Multiple IDs may be separated by spaces or commas. Batch changes are not
transactional; inspect the results after a partial failure.

## Handoff and recovery

Maintain the overall task's description as a self-contained handoff. Before
ending a session or changing repositories, include:

- The user's objective, accepted scope, constraints, and relevant preferences.
- Repository paths, branch, existing user changes, and related task IDs.
- What actually succeeded, what failed, and what remains unverified.
- Relevant commands, file locations, artifacts, and test results.
- Services or processes started, how to inspect them, and any cleanup needed.
- Current blockers and the precise next steps, including required user input.

Store scripts and essential artifacts in durable project-appropriate locations;
identify anything still under `/tmp` as temporary. Never put passwords, PINs,
tokens, or private-key contents in task descriptions. Reference their locations
or the required user interaction instead.

Verify the saved description with `show`. Do not claim a task or handoff was
recorded until the CLI has confirmed the write.

## Delegated work

This workflow does not authorize spawning additional agents. If delegation is
otherwise authorized, give each agent its task IDs, server address, project
path, and these instructions. Each agent must read its tasks, set its assignee
and status, and record findings and handoff details in the same server. The
primary agent reconciles results and updates the overall task before reporting
completion.

## Server lifecycle

The running server is the shared task record. The current implementation saves
to its configured data file on graceful shutdown with Ctrl+C or SIGTERM, rather
than after each edit. SIGKILL or a crash can lose unsaved changes. Do not edit
the data file behind a running server or stop the user's server without a
reason within the authorized work.

Only if starting a server is part of the task, run it from `~/Projects/ai-todo`
with an explicit data file and the agreed address:

```sh
devenv shell -- server --listen 127.0.0.1:3000 --data-file /absolute/path/tasks.json
```
