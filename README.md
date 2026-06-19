# AI SDLC Workspace

這個資料夾是 AI-assisted SDLC 相關材料的整理 workspace,不是單一可執行產品。

> **Source of truth:** 見 [`SOURCE-OF-TRUTH.md`](SOURCE-OF-TRUTH.md)。簡述:本 repo 採「瘦策展 (thin curator)」模型——外部 skill 包不在此維護,而是由 starter kit 的 bootstrap script 依需求拉取、並用 `skills.lock` 釘住 commit。本機 checkout 預設**不含**外部 skill(刻意如此),需要時才 bootstrap。

主要內容:

- `starter-kits/`: 可複製到新 repo 的 starter kit(本 repo 真正維護的東西)。
- `docs/manuals/`: Word 手冊與設計說明。
- `archives/source-zips/`: 上游與 kit 的**不可變冷備份快照**(災難復原用,非工作來源)。

## Directory Map

```text
.
├── SOURCE-OF-TRUTH.md
├── starter-kits/
│   └── ai-sdlc-v6.1-new-project-ready/
├── docs/
│   └── manuals/
├── archives/
│   └── source-zips/
├── scripts/
│   └── check_consistency.sh
└── .github/workflows/
    └── consistency.yml
```

## What Each Folder Is For

### `starter-kits/ai-sdlc-v6.1-new-project-ready/`

主 starter kit。用途是把新的或既有的 repo 套上 skill-driven SDLC 流程。

它包含:

- `CLAUDE.md`: Claude Code 操作契約。
- `pipeline/`: lifecycle、skill map、artifact schema、approval matrix。
- `.claude/commands/`: `/sdlc-inception`、`/sdlc-define`、`/sdlc-architecture` 等入口。
- `.ai/`: SDLC governance、risk policy、artifact folders。
- `scripts/`: pipeline validation 與 external skills bootstrap scripts。

如果要建立新專案,從這個資料夾複製內容到新 repo root,再依照該 starter kit 的 `INSTALL.md` 執行。

### 外部 skill 包(不在此 repo 內維護)

過去這裡有一個 `skill-packs/` 放外部 skill 的可編輯副本,但那是多餘的第三份拷貝(和 bootstrap 目標、zip 快照重複),已移除。要在本機取得外部 skill:

- 執行 `starter-kits/ai-sdlc-v6.1-new-project-ready/scripts/bootstrap_external_skills.sh`(clone 上游到 `skills/external/`,並產出 `skills.lock`),或
- 解壓 `archives/source-zips/` 內對應的快照。

來源:[addyosmani/agent-skills](https://github.com/addyosmani/agent-skills)(工程 lifecycle 技能)、[obra/superpowers](https://github.com/obra/superpowers)(方法論/紀律)、[heilcheng/awesome-agent-skills](https://github.com/heilcheng/awesome-agent-skills)(discovery index)。

### `docs/manuals/`

使用手冊與 v6.1 pipeline 設計說明。**Markdown (`*.md`) 是正本**,Word (`*.docx`) 是產生出來的 render(以 `scripts/docx_to_md.py` 由 docx 轉出;要反向由 md 生成 docx 可用 pandoc)。

- `AI_SDLC_Claude_Code_New_Project_Ready_Pipeline_v6_1.md` / `.docx`
- `Claude_Code_AI_SDLC_StarterKit_v6_1_使用手冊.md` / `.docx`

### `archives/source-zips/`

上游 skill 包與 kit 的不可變快照,作為**離線災難復原**備份(上游消失時的後備,commit SHA 無法涵蓋此情況)。不直接編輯,也不是工作來源。詳見 [`SOURCE-OF-TRUTH.md`](SOURCE-OF-TRUTH.md) 與 `archives/source-zips/README.md`。

## Source of Truth 與一致性

- 完整規則見 [`SOURCE-OF-TRUTH.md`](SOURCE-OF-TRUTH.md)。
- `scripts/check_consistency.sh` 驗證不變量(無 `skill-packs/`、bootstrap 產出單一 `skills.lock`、kit 結構通過 validate),並由 `.github/workflows/consistency.yml` 在 CI 強制執行。

## Local-Only Files

`.claude/settings.local.json` 是本機 Claude/Codex 工具設定,已透過 `.gitignore` 忽略。`.DS_Store` 也已忽略。

## Validation

```bash
# workspace 一致性 (source of truth 不變量)
bash scripts/check_consistency.sh

# 主 starter kit 的 pipeline 結構
python3 starter-kits/ai-sdlc-v6.1-new-project-ready/scripts/validate_pipeline.py
```

若要在 starter kit 內下載 external skills(本機預設未執行):

```bash
cd starter-kits/ai-sdlc-v6.1-new-project-ready
bash scripts/bootstrap_external_skills.sh
python3 scripts/audit_skills.py
```
