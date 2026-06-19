# Installation

1. Copy this starter kit into the root of your repository.
2. Install prerequisites:
   - Git
   - Python 3.11+
   - Node.js 20+
   - Claude Code
   - GitHub CLI if you want GitHub issue/PR automation
3. Bootstrap external skills:

```bash
bash scripts/bootstrap_external_skills.sh
```

4. Validate structure:

```bash
python scripts/validate_pipeline.py
python scripts/audit_skills.py
```

5. Open the repository with Claude Code.
6. For a new project, begin with:

```text
/sdlc-inception
```

7. For an existing project feature, begin with:

```text
/sdlc-define
```
