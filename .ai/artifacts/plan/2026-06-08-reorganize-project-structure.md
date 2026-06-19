# Project Structure Reorganization Plan

## SDLC Metadata

- Phase: Plan
- Date: 2026-06-08
- Branch: `chore/reorganize-project-structure`
- Task: Reorganize `/Users/tunghsing/Desktop/init` into a clean project workspace
- Risk class: R1
- Selected skills:
  - `planning-and-task-breakdown`
  - `documentation-and-adrs`
  - `git-workflow-and-versioning`
- Author: Codex
- Status: Approved and executed

## Goal

把目前混在 repo root 的 starter kit、skill pack、source zip、Word 手冊與本機設定整理成清楚分層的資料結構。這次只整理外層資料夾，不修改各套來源專案的內部內容。

## Current Inventory

目前 root 主要內容：

- `ai-sdlc-v6_1-new-project-ready-starter-kit/`
- `ai-sdlc-v6_1-new-project-ready-starter-kit.zip`
- `agent-skills-main/`
- `agent-skills-main.zip`
- `superpowers-main/`
- `superpowers-main.zip`
- `awesome-agent-skills-main.zip`
- `AI_SDLC_Claude_Code_New_Project_Ready_Pipeline_v6_1.docx`
- `Claude_Code_AI_SDLC_StarterKit_v6_1_使用手冊.docx`
- `.claude/settings.local.json`
- `.DS_Store`

## Target Structure

```text
/Users/tunghsing/Desktop/init
├── README.md
├── .gitignore
├── .ai/
│   └── artifacts/
│       └── plan/
│           └── 2026-06-08-reorganize-project-structure.md
├── starter-kits/
│   └── ai-sdlc-v6.1-new-project-ready/
├── skill-packs/
│   ├── agent-skills/
│   └── superpowers/
├── docs/
│   └── manuals/
│       ├── AI_SDLC_Claude_Code_New_Project_Ready_Pipeline_v6_1.docx
│       └── Claude_Code_AI_SDLC_StarterKit_v6_1_使用手冊.docx
├── archives/
│   └── source-zips/
│       ├── ai-sdlc-v6_1-new-project-ready-starter-kit.zip
│       ├── agent-skills-main.zip
│       ├── superpowers-main.zip
│       └── awesome-agent-skills-main.zip
└── .claude/
    └── settings.local.json
```

`.claude/settings.local.json` 先保留原位置，因為它是 Codex/Claude 本機工具設定，不是專案內容。會用 `.gitignore` 避免把它當成正式專案資料提交。

## Scope

### In Scope

- 建立外層分類資料夾。
- 移動已解壓的主要資料夾到清楚位置。
- 移動 zip 原始檔到 archive。
- 移動 Word 手冊到 docs。
- 新增 root `README.md`，說明每個資料夾用途。
- 新增 `.gitignore`，忽略 `.DS_Store` 與本機 Claude settings。
- 搬完後驗證 AI-SDLC starter kit 的 pipeline script 仍可執行。

### Out of Scope

- 不修改 `ai-sdlc` starter kit 內部設計。
- 不修改 `agent-skills` 或 `superpowers` 的技能內容。
- 不解壓 `awesome-agent-skills-main.zip`，除非後續另行決定要建立 skill index workspace。
- 不執行 `bootstrap_external_skills.sh` 下載外部 repo。
- 不刪除任何 source zip。
- 不建立遠端 GitHub repo、不 push、不開 PR。

## Architecture Decisions

- Decision 1: 外層採「用途分類」而不是「來源名稱平鋪」。
  - Reason: 使用時最常問的是「我要 starter kit、技能庫、手冊、原始壓縮檔在哪裡」，不是問下載來源名稱。

- Decision 2: source zip 全部保留到 `archives/source-zips/`。
  - Reason: zip 是來源備份，不應和可閱讀/可使用資料夾混在 root。

- Decision 3: 不移動 `.claude/settings.local.json`。
  - Reason: 這是本機工具設定，移動可能影響目前 Codex/Claude session；用 `.gitignore` 管理比較安全。

- Decision 4: root README 是整理後的主要入口。
  - Reason: 之後打開資料夾應該能直接知道「哪個是主 starter kit」、「哪個是外部 skill pack」、「如果要開始新專案要複製哪個資料夾」。

## Task List

### Task 1: Add Repository Hygiene Files

**Description:** 建立 `.gitignore`，避免把 macOS 與本機 agent 設定當成正式內容。

**Acceptance criteria:**
- [ ] `.gitignore` 存在於 repo root。
- [ ] `.DS_Store` 被忽略。
- [ ] `.claude/settings.local.json` 被忽略。

**Verification:**
- [ ] Run: `git status --short --ignored`
- [ ] Expected: `.DS_Store` 與 `.claude/settings.local.json` 顯示為 ignored 或不出現在一般 untracked 清單。

**Dependencies:** None

**Files likely touched:**
- `.gitignore`

**Estimated scope:** XS

### Task 2: Create Destination Directories

**Description:** 建立整理後的外層分類資料夾。

**Acceptance criteria:**
- [ ] `starter-kits/` exists.
- [ ] `skill-packs/` exists.
- [ ] `docs/manuals/` exists.
- [ ] `archives/source-zips/` exists.

**Verification:**
- [ ] Run: `find . -maxdepth 2 -type d | sort`
- [ ] Expected: 目標資料夾全部出現在輸出中。

**Dependencies:** Task 1

**Files likely touched:**
- Directory structure only

**Estimated scope:** XS

### Task 3: Move AI-SDLC Starter Kit

**Description:** 把主 starter kit 移到 `starter-kits/`，並改成較穩定、易讀的目錄名稱。

**Acceptance criteria:**
- [ ] `starter-kits/ai-sdlc-v6.1-new-project-ready/` exists.
- [ ] Original `ai-sdlc-v6_1-new-project-ready-starter-kit/` no longer exists at root.
- [ ] Starter kit root still contains `CLAUDE.md`, `pipeline/`, `scripts/`, `skills/`, `.ai/`.

**Verification:**
- [ ] Run: `test -f starter-kits/ai-sdlc-v6.1-new-project-ready/CLAUDE.md`
- [ ] Run: `test -d starter-kits/ai-sdlc-v6.1-new-project-ready/pipeline`
- [ ] Run: `python3 starter-kits/ai-sdlc-v6.1-new-project-ready/scripts/validate_pipeline.py`
- [ ] Expected: pipeline validation passes.

**Dependencies:** Task 2

**Files likely touched:**
- `ai-sdlc-v6_1-new-project-ready-starter-kit/`
- `starter-kits/ai-sdlc-v6.1-new-project-ready/`

**Estimated scope:** M

### Task 4: Move Skill Packs

**Description:** 把已解壓的 engineering skill packs 移到 `skill-packs/`。

**Acceptance criteria:**
- [ ] `skill-packs/agent-skills/` exists.
- [ ] `skill-packs/superpowers/` exists.
- [ ] Original `agent-skills-main/` no longer exists at root.
- [ ] Original `superpowers-main/` no longer exists at root.
- [ ] Each moved skill pack still has its own `README.md`.

**Verification:**
- [ ] Run: `test -f skill-packs/agent-skills/README.md`
- [ ] Run: `test -f skill-packs/superpowers/README.md`

**Dependencies:** Task 2

**Files likely touched:**
- `agent-skills-main/`
- `superpowers-main/`
- `skill-packs/agent-skills/`
- `skill-packs/superpowers/`

**Estimated scope:** M

### Task 5: Move Manuals

**Description:** 把 Word 手冊集中到 `docs/manuals/`。

**Acceptance criteria:**
- [ ] `docs/manuals/AI_SDLC_Claude_Code_New_Project_Ready_Pipeline_v6_1.docx` exists.
- [ ] `docs/manuals/Claude_Code_AI_SDLC_StarterKit_v6_1_使用手冊.docx` exists.
- [ ] No `.docx` files remain loose in root.

**Verification:**
- [ ] Run: `find . -maxdepth 1 -name '*.docx' -print`
- [ ] Expected: no output.

**Dependencies:** Task 2

**Files likely touched:**
- `*.docx`
- `docs/manuals/`

**Estimated scope:** S

### Task 6: Move Source Archives

**Description:** 把所有 source zip 集中到 `archives/source-zips/`。

**Acceptance criteria:**
- [ ] All four zip files exist under `archives/source-zips/`.
- [ ] No `.zip` files remain loose in root.
- [ ] Zip files are not deleted or modified.

**Verification:**
- [ ] Run: `find . -maxdepth 1 -name '*.zip' -print`
- [ ] Expected: no output.
- [ ] Run: `find archives/source-zips -maxdepth 1 -name '*.zip' | sort`
- [ ] Expected: four zip files listed.

**Dependencies:** Task 2

**Files likely touched:**
- `*.zip`
- `archives/source-zips/`

**Estimated scope:** S

### Task 7: Add Root README

**Description:** 建立 root `README.md` 作為整理後的入口文件。

**Acceptance criteria:**
- [ ] README explains the purpose of this workspace.
- [ ] README lists each top-level directory and its role.
- [ ] README explains how to start a new project from the AI-SDLC starter kit.
- [ ] README notes that `.claude/settings.local.json` is local-only and ignored.
- [ ] README records that `awesome-agent-skills-main.zip` is currently archived only, not extracted.

**Verification:**
- [ ] Run: `sed -n '1,220p' README.md`
- [ ] Expected: README contains overview, directory map, and usage notes.

**Dependencies:** Tasks 3, 4, 5, 6

**Files likely touched:**
- `README.md`

**Estimated scope:** S

### Task 8: Final Structure Verification

**Description:** 驗證整理後 root 沒有雜散原始資料，主要內容都進到分類資料夾。

**Acceptance criteria:**
- [ ] Root has no loose `*-main/` extracted folders.
- [ ] Root has no loose `.zip` files.
- [ ] Root has no loose `.docx` files.
- [ ] `starter-kits/`, `skill-packs/`, `docs/`, `archives/`, `.ai/` exist.
- [ ] AI-SDLC starter kit validation passes after move.

**Verification:**
- [ ] Run: `find . -maxdepth 1 -type f | sort`
- [ ] Run: `find . -maxdepth 1 -type d | sort`
- [ ] Run: `python3 starter-kits/ai-sdlc-v6.1-new-project-ready/scripts/validate_pipeline.py`
- [ ] Run: `git status --short`

**Dependencies:** Tasks 1-7

**Files likely touched:**
- None

**Estimated scope:** XS

## Checkpoints

### Checkpoint 1: After Tasks 1-2

- [ ] Hygiene files and target directories exist.
- [ ] No project content has been moved yet.

### Checkpoint 2: After Tasks 3-6

- [ ] All existing large content has been moved into target categories.
- [ ] Source zip archives are preserved.
- [ ] No loose source directories, zips, or manuals remain in root.

### Checkpoint 3: After Tasks 7-8

- [ ] README explains the organized workspace.
- [ ] Starter kit validation still passes.
- [ ] `git status --short` only shows expected new/renamed files.

## Verification Commands

Run these before claiming Build complete:

```bash
git status --short --branch
find . -maxdepth 1 -type f | sort
find . -maxdepth 1 -type d | sort
python3 starter-kits/ai-sdlc-v6.1-new-project-ready/scripts/validate_pipeline.py
find . -maxdepth 1 -name '*.zip' -print
find . -maxdepth 1 -name '*.docx' -print
```

Optional skill-map audit after external skills are bootstrapped:

```bash
python3 starter-kits/ai-sdlc-v6.1-new-project-ready/scripts/audit_skills.py
```

Note: `audit_skills.py` was corrected during the `agentic_RAG` initialization test so it reads `phases`, audits mapped `SKILL.md` paths, and applies stricter section checks only to company-owned skills.

## Risks and Mitigations

| Risk | Impact | Mitigation |
|---|---|---|
| Moving `.claude/settings.local.json` breaks local tool behavior | Medium | Do not move it; ignore it via `.gitignore`. |
| Source zip accidentally deleted | Medium | Move, do not remove; verify all four zip files under `archives/source-zips/`. |
| Nested starter kit scripts fail after move | Medium | Run `validate_pipeline.py` from the moved path. |
| Root README becomes stale | Low | Keep README descriptive and structural, not full duplicate docs. |
| External skill formats differ from company skill format | Low | `audit_skills.py` checks company skills strictly and external skills for existence/frontmatter. |

## Open Questions

- None blocking for the file organization itself.

## Approval Gate

這次是 R1：只整理資料夾、README、`.gitignore`，不改產品行為、不改 skill 內容、不下載外部依賴。

Approved by the user on 2026-06-08 and executed on branch `chore/reorganize-project-structure`.

## Next Recommended Phase

- Next phase after execution: Review
- Review action: inspect the final structure, confirm no unrelated content changes, then decide whether to commit.
