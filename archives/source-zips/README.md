# Source ZIP snapshots — immutable cold storage

These are disaster-recovery snapshots, **not** the source of truth. See
[`../../SOURCE-OF-TRUTH.md`](../../SOURCE-OF-TRUTH.md).

They exist for the one case a pinned commit SHA cannot cover: an upstream
repository disappearing. Do not edit them and do not treat them as the working
copy. To obtain a working copy of the external skills, run the kit's
`scripts/bootstrap_external_skills.sh` (pulls upstream, pins `skills.lock`).

| Snapshot | Upstream |
|---|---|
| `agent-skills-main.zip` | github.com/addyosmani/agent-skills |
| `superpowers-main.zip` | github.com/obra/superpowers |
| `awesome-agent-skills-main.zip` | github.com/heilcheng/awesome-agent-skills |
| `ai-sdlc-v6_1-new-project-ready-starter-kit.zip` | release snapshot of the kit in this repo |
