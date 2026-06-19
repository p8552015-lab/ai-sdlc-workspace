# AI SDLC Workspace

這個資料夾是 AI-assisted SDLC 相關材料的整理 workspace，不是單一可執行產品。

主要內容分成四類：

- `starter-kits/`: 可複製到新 repo 的 starter kit。
- `skill-packs/`: 可供 agent 使用或參考的技能包。
- `docs/manuals/`: Word 手冊與設計說明。
- `archives/source-zips/`: 原始下載 zip 備份。

## Directory Map

```text
.
├── starter-kits/
│   └── ai-sdlc-v6.1-new-project-ready/
├── skill-packs/
│   ├── agent-skills/
│   └── superpowers/
├── docs/
│   └── manuals/
├── archives/
│   └── source-zips/
└── .ai/
    └── artifacts/
```

## What Each Folder Is For

### `starter-kits/ai-sdlc-v6.1-new-project-ready/`

主 starter kit。用途是把新的或既有的 repo 套上 skill-driven SDLC 流程。

它包含：

- `CLAUDE.md`: Claude Code 操作契約。
- `pipeline/`: lifecycle、skill map、artifact schema、approval matrix。
- `.claude/commands/`: `/sdlc-inception`、`/sdlc-define`、`/sdlc-architecture` 等入口。
- `.ai/`: SDLC governance、risk policy、artifact folders。
- `scripts/`: pipeline validation 與 external skills bootstrap scripts。

如果要建立新專案，從這個資料夾複製內容到新 repo root，再依照該 starter kit 的 `INSTALL.md` 執行。

### `skill-packs/agent-skills/`

工程 lifecycle 技能庫，包含 spec、plan、build、test、review、security、performance、ship 等技能。

這包適合用來讓 coding agent 遵循比較完整的工程流程，而不是直接寫 code。

### `skill-packs/superpowers/`

Agentic development 方法論與技能包，重點包含 brainstorming、writing plans、TDD、worktree isolation、subagent-driven development、code review。

這包適合用來強化 agent 的開發紀律與多代理工作流。

### `docs/manuals/`

放 Word 格式的使用手冊與 v6.1 pipeline 設計說明。

目前包含：

- `AI_SDLC_Claude_Code_New_Project_Ready_Pipeline_v6_1.docx`
- `Claude_Code_AI_SDLC_StarterKit_v6_1_使用手冊.docx`

### `archives/source-zips/`

放原始 zip 備份。這些檔案保留作為來源快照，不直接拿來編輯。

目前包含：

- `ai-sdlc-v6_1-new-project-ready-starter-kit.zip`
- `agent-skills-main.zip`
- `superpowers-main.zip`
- `awesome-agent-skills-main.zip`

`awesome-agent-skills-main.zip` 目前只保留為 archive，尚未解壓成工作資料夾。

## Local-Only Files

`.claude/settings.local.json` 是本機 Claude/Codex 工具設定，不是這個 workspace 的正式內容，已透過 `.gitignore` 忽略。

`.DS_Store` 也是本機 macOS 檔案，已透過 `.gitignore` 忽略。

## Validation

整理後可用這個指令驗證主 starter kit 的 pipeline 結構：

```bash
python3 starter-kits/ai-sdlc-v6.1-new-project-ready/scripts/validate_pipeline.py
```

若要真的在 starter kit 內下載 external skills，進入 starter kit 後執行：

```bash
cd starter-kits/ai-sdlc-v6.1-new-project-ready
bash scripts/bootstrap_external_skills.sh
```

目前整理作業沒有執行 external skills bootstrap，也沒有修改任何 skill pack 內部內容。
