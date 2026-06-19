# Claude Code AI SDLC Starter Kit v6.1 使用手冊

從空資料夾初始化新 repo，讓 Claude Code 依照 Skill-Driven 生命開發週期執行

> 本手冊目的 協助你把 Starter Kit v6.1 放進全新 GitHub repo，建立可被 Claude Code 遵循的 CLAUDE.md、pipeline metadata、skills、commands、GitHub Actions 與階段輸出物規範。重點不是讓 AI 直接寫完整產品，而是讓它先完成 Inception、Define、Architecture、Bootstrap，再進入一般 Build/Verify/Review/Ship。

## 一頁總覽

| 階段 | 你要做的事 | Claude Code 要做的事 | 主要產出 |
| --- | --- | --- | --- |
| 0. 準備 | 建立空 repo，解壓 Starter Kit | 尚未啟動或只讀檔 | CLAUDE.md、pipeline、skills scaffold |
| 1. Skills | 執行 bootstrap script | 後續依 skill-map 選用 | external skills、skills.lock |
| 2. Inception | 提供產品想法 | 釐清問題、MVP、non-goals | project brief、MVP scope |
| 3. Define | 審查需求規格 | 把想法轉成可驗收 spec | specs、acceptance criteria |
| 4. Architecture | 人工核准架構 | 提出方案與 ADR | architecture.md、ADRs |
| 5. Bootstrap | 允許初始化骨架 | 建立 scaffold、CI、測試 | 可跑、可測、可 build 的 repo |
| 6. Plan+ | 逐一 issue 開發 | Build/Verify/Review/Ship | PR、test evidence、rollback plan |

## 1. 適用情境與基本概念

Starter Kit v6.1 適用於兩種情境：全新專案與既有專案。全新專案必須啟用 New Project Pipeline，先完成產品與架構設計，再建立程式骨架；既有專案則可以從 Issue → Plan → Build → Verify → Review → Ship 開始。

> 核心原則 Claude Code 不是自由發揮的 coding bot。它必須讀取 CLAUDE.md、pipeline/*.yml、company orchestrator skill 與 external skills，依照階段、風險、輸出物與核准規則執行。

### 三層設計

- CLAUDE.md：Claude Code 的最高層操作契約。
- pipeline/*.yml：生命週期、skill 對應、輸出物 schema、核准矩陣。
- skills/：公司自有 orchestrator skill 與外部 skill pack。

### 全新專案生命週期

- Inception：立項與 MVP 範圍。
- Define：需求規格與驗收條件。
- Architecture：技術選型、架構、ADR。
- Bootstrap：初始化 repo、CI、測試、最小可運作骨架。
- Plan/Build/Verify/Review/Ship/Operate：逐一 issue 開發與出貨。

## 2. 前置工具安裝

以下指令以 macOS / Linux 為主。Windows 使用者建議在 WSL2 或 PowerShell 中對應安裝。

```
# 必要工具檢查
git --version
gh --version
node -v
python3 --version
claude --version

# 安裝 Claude Code（若尚未安裝）
npm install -g @anthropic-ai/claude-code

# GitHub CLI 登入
gh auth login
```

> 安全提醒 不要把真實 API key、資料庫密碼、production token 寫入 repo。只建立 .env.example，真實 secret 放在本機環境或 GitHub Secrets。

## 3. 從空資料夾建立新 repo

```
mkdir my-new-app
cd my-new-app
git init

gh repo create my-new-app --private --source=. --remote=origin
```

如果你想建立 public repo，將 --private 改成 --public。

## 4. 解壓 Starter Kit 到 repo 根目錄

Starter Kit 的內容必須放在 repo root，而不是放在多一層子資料夾。

```
unzip ~/Downloads/ai-sdlc-v6_1-new-project-ready-starter-kit.zip
cp -R ai-sdlc-v6_1-new-project-ready-starter-kit/. .
rm -rf ai-sdlc-v6_1-new-project-ready-starter-kit
```

完成後應該看到：

```
my-new-app/
├── CLAUDE.md
├── .ai/
├── pipeline/
├── skills/
├── .claude/
├── .cursor/
├── scripts/
├── .github/
└── docs/
```

## 5. 初始化外部 skills

Starter Kit 不直接內建第三方 repo，而是透過 bootstrap script 拉取並記錄版本。

```
bash scripts/bootstrap_external_skills.sh
```

完成後預期結構：

```
skills/external/
├── addyosmani-agent-skills/
├── obra-superpowers/
├── heilcheng-awesome-agent-skills/
└── skills.lock
```

| 來源 | 定位 | 在 pipeline 的用途 |
| --- | --- | --- |
| addyosmani/agent-skills | 主 lifecycle skill pack | 提供 Define/Plan/Build/Verify/Review/Ship 對應 SKILL.md |
| obra/superpowers | 方法論層 | 強化 discovery、planning、TDD、review discipline |
| heilcheng/awesome-agent-skills | skill discovery index | 用於尋找額外 domain-specific skills，不直接當 runtime skill |

## 6. 驗證 pipeline 結構

```
python3 scripts/validate_pipeline.py
python3 scripts/audit_skills.py
```

判斷方式：

- validate_pipeline.py 應該通過；若失敗，先補齊缺少的 pipeline 檔案。
- audit_skills.py 對外部 repo 有 warning 時，先確認是否為外部專案格式差異；公司自有 SKILL.md 必須通過。
- 不要在驗證失敗時開始產品功能開發。

## 7. 第一次 commit：只提交 pipeline

```
git add .
git commit -m "chore: initialize AI SDLC pipeline"
git push -u origin main
```

> 為什麼要先 commit pipeline？ 這讓後續 Claude Code 的每個變更都可以與 baseline 比較，也避免產品功能與治理框架混在同一個 commit。

## 8. 啟動 Claude Code 並讓它讀取規則

```
claude
```

進入 Claude Code 後，先貼這段，不要直接貼產品功能需求：

```
請先不要寫任何應用程式碼。

這是一個全新 repo，我要使用本 repo 的 AI SDLC Pipeline 初始化專案。
請先閱讀並遵守：

- CLAUDE.md
- .ai/sdlc-governance.md
- .ai/risk-policy.md
- .ai/new-project-policy.md
- pipeline/lifecycle.yml
- pipeline/skill-map.yml
- pipeline/artifact-schema.yml
- pipeline/approval-matrix.yml
- skills/company/ai-sdlc-orchestrator/SKILL.md

請確認：
1. 你會使用 New Project Pipeline
2. 你會從 Inception 開始
3. Architecture 核准前不會 Bootstrap
4. Bootstrap 前不會建立應用程式碼
5. Build 前不會實作業務功能
6. R3/R4 風險會先要求人工核准
7. 每個階段會產出 artifact 到 .ai/artifacts/<phase>/

確認後，請等待我提供專案想法。
```

## 9. Inception：專案立項

使用 Claude Code slash command：/sdlc-inception

```
/sdlc-inception

專案名稱：
<你的專案名稱>

產品想法：
<你想做什麼>

目標使用者：
<誰會使用>

核心問題：
<要解決什麼痛點>

商業/技術限制：
<預算、時程、部署、資料、法規、團隊限制>

請開始 Inception 階段。
先不要建立應用程式碼。
請產出：
1. docs/project-brief.md
2. docs/product-requirements.md
3. docs/mvp-scope.md
4. docs/open-questions.md
5. .ai/artifacts/inception/inception-report.md
```

### 人工檢查重點

- problem statement
- target users
- MVP scope
- non-goals
- open questions
- initial risk assessment

## 10. Define：需求規格化

使用 Claude Code slash command：/sdlc-define

```
/sdlc-define

請根據已核准的 docs/project-brief.md、docs/product-requirements.md、docs/mvp-scope.md 進行 Define 階段。

請產出：
1. docs/specs/001-mvp-core-flow.md
2. docs/specs/002-data-model-requirements.md
3. docs/specs/003-api-requirements.md
4. .ai/artifacts/define/define-report.md

每份 spec 必須包含：
- user story
- functional requirements
- non-functional requirements
- acceptance criteria
- edge cases
- out-of-scope items
- test implications

先不要建立應用程式碼。
```

### 人工檢查重點

- 需求是否可驗收
- 是否有清楚 non-goals
- 是否列出邊界情境與錯誤處理

## 11. Architecture：架構設計與人工核准

使用 Claude Code slash command：/sdlc-architecture

```
/sdlc-architecture

請根據已核准的 Define 階段文件，提出 2 到 3 個技術架構選項。

請比較：
- 開發速度
- 維護成本
- 測試容易度
- 部署複雜度
- 安全性
- 可擴充性
- 團隊學習成本

請產出：
1. docs/architecture.md
2. docs/adrs/0001-tech-stack.md
3. docs/adrs/0002-application-architecture.md
4. docs/adrs/0003-testing-strategy.md
5. docs/adrs/0004-deployment-strategy.md
6. .ai/artifacts/architecture/architecture-report.md

限制：
- 不要建立應用程式碼
- 不要安裝套件
- 不要初始化 framework
- 只做架構設計與 ADR
```

### 人工檢查重點

- 技術選型是否符合團隊能力
- 安全與資料邊界是否清楚
- 是否避免過度設計
- 此階段必須人工核准

## 12. Bootstrap：初始化專案骨架

使用 Claude Code slash command：/sdlc-bootstrap

```
/sdlc-bootstrap

請依照已核准的 docs/architecture.md 與 docs/adrs/ 初始化專案骨架。

請只做 Bootstrap，不要實作完整業務功能。

請建立：
1. framework scaffold
2. package manager 設定
3. lint / format
4. test framework
5. CI workflow
6. README local setup
7. .env.example
8. 基本 src/ 或 app/ 目錄
9. health check 或最小可運行頁面
10. .ai/artifacts/bootstrap/bootstrap-report.md

完成後請執行：
- install
- lint
- test
- build

並在 bootstrap-report.md 記錄：
- changed files
- commands run
- test result
- known risks
- next recommended phase
```

### 人工檢查重點

- 能安裝
- 能 lint
- 能 test
- 能 build
- 沒有真實 secrets
- README 能讓新人跑起來

## 13. Plan：拆解 MVP 任務

使用 Claude Code slash command：/sdlc-plan

```
/sdlc-plan

請根據 docs/mvp-scope.md、docs/specs/、docs/architecture.md，把 MVP 拆成 GitHub Issues。

請產出：
1. docs/roadmap.md
2. docs/milestones/mvp.md
3. .ai/artifacts/plan/mvp-task-breakdown.md

每個任務必須包含：
- title
- user story
- acceptance criteria
- impacted areas
- test strategy
- risk level R0-R4
- dependencies
- estimated size
```

### 人工檢查重點

- 每個 issue 小到可獨立完成
- 每個 issue 都有 acceptance criteria
- R3/R4 要先人工核准

## 14. 逐一 issue 開發：Build / Verify / Review / Ship

Bootstrap 與 Plan 完成後，不要讓 Claude Code 一次實作整個 MVP。每次只處理一個 issue。

```
/sdlc-build

請處理 GitHub issue #3。
請依照 CLAUDE.md、pipeline/skill-map.yml 與 approval-matrix.yml 執行。

限制：
- 一次只處理這個 issue
- 不修改 unrelated files
- 實作前先列出 plan
- 若風險等級為 R3/R4，先停止並要求人工核准
- 實作後執行 lint/test/build
/sdlc-verify

請針對 issue #3 驗證 acceptance criteria。
請執行必要測試，並產出 .ai/artifacts/verify/issue-3-verify.md。
/sdlc-review

請針對目前 diff 做 review。
請使用 code-review-and-quality、security-and-hardening、code-simplification 相關 skills。
請產出 .ai/artifacts/review/issue-3-review.md。
/sdlc-ship

請準備 issue #3 的 PR。
請產出：
- PR title
- PR body
- test evidence
- risk level
- rollback plan
- linked issue
```

## 15. 建立 PR 與 GitHub Actions 驗證

```
git checkout -b feat/issue-3-core-flow
git add .
git commit -m "feat: implement issue 3 core flow"
git push -u origin feat/issue-3-core-flow
gh pr create --fill
```

PR body 必須包含 Summary、Linked Issue、Acceptance Criteria、Test Evidence、Risk Level、Rollback Plan。GitHub Actions 應該至少執行 ci.yml、ai-policy-gate.yml、skill-audit.yml。

## 16. 人工核准與風險邊界

| 風險 | 範例 | Claude Code 權限 | 人工核准 |
| --- | --- | --- | --- |
| R0 | 文件、註解、格式 | 可自行修改 | 通常不需要 |
| R1 | 測試、型別、小 bug | 可實作並驗證 | 視情況 |
| R2 | 一般功能、API 行為變更 | 可實作，但需 PR review | merge 前需要 |
| R3 | auth、DB schema、payment、security-sensitive | 只能先規劃 | 實作前必須 |
| R4 | production deploy、資料刪除、不可逆 migration | 不可自動執行 | 必須人工決策 |

## 17. 常見問題排除

| 問題 | 處理方式 |
| --- | --- |
| Claude Code 一開始就想寫 code | 停止它，要求重新閱讀 CLAUDE.md 與 .ai/new-project-policy.md，並確認目前是 Inception 或 Architecture 前階段。 |
| 找不到 external skills | 重新執行 bash scripts/bootstrap_external_skills.sh，檢查 skills/external/ 是否有三個 repo。 |
| validate_pipeline.py 失敗 | 先補齊缺少的 pipeline/*.yml、CLAUDE.md、company orchestrator skill，再繼續。 |
| audit_skills.py 對外部 repo 有 warning | 確認 warning 是否來自外部 repo 格式差異。公司自有 skill 必須符合規範。 |
| CI 失敗 | 不要略過。回到 /sdlc-verify 或 /sdlc-review，讓 Claude Code 根據錯誤日誌修復。 |
| Claude Code 修改 unrelated files | 要求它還原非必要 diff，並重新依照 issue scope 執行。 |

## 18. 初始化完成檢查表

☐ repo root 有 CLAUDE.md

☐ pipeline/lifecycle.yml、skill-map.yml、artifact-schema.yml、approval-matrix.yml 存在

☐ skills/company/ai-sdlc-orchestrator/SKILL.md 存在

☐ skills/external/ 三個外部來源已 bootstrap

☐ validate_pipeline.py 通過

☐ 至少完成 Inception、Define、Architecture、Bootstrap artifacts

☐ lint/test/build 可執行

☐ GitHub Actions 已建立

☐ 沒有真實 secrets

☐ README 可讓新人啟動專案

## 附錄 A：最短命令版

```
mkdir my-new-app
cd my-new-app
git init

unzip ~/Downloads/ai-sdlc-v6_1-new-project-ready-starter-kit.zip
cp -R ai-sdlc-v6_1-new-project-ready-starter-kit/. .
rm -rf ai-sdlc-v6_1-new-project-ready-starter-kit

bash scripts/bootstrap_external_skills.sh
python3 scripts/validate_pipeline.py
python3 scripts/audit_skills.py

git add .
git commit -m "chore: initialize AI SDLC pipeline"

gh repo create my-new-app --private --source=. --remote=origin --push

claude
```

## 附錄 B：參考來源與設計依據

| 來源 | URL | 用途 |
| --- | --- | --- |
| addyosmani/agent-skills | https://github.com/addyosmani/agent-skills | Production-grade engineering skills for AI coding agents，強調 skills encode workflows、quality gates 與 senior engineering best practices。 |
| agent-skills getting started | https://github.com/addyosmani/agent-skills/blob/main/docs/getting-started.md | 說明 SKILL.md 是 agent follow 的工程 workflow，包含 verification steps、anti-patterns、exit criteria。 |
| obra/superpowers | https://github.com/obra/superpowers | 作為 SDLC 方法論層，補強 discovery、planning、TDD、review discipline。 |
| heilcheng/awesome-agent-skills | https://github.com/heilcheng/awesome-agent-skills | 作為 skill discovery index，尋找 domain-specific skills。 |
| GitHub MCP Server | https://github.com/github/github-mcp-server | GitHub 官方 MCP Server，讓 AI tools 可讀 repo、code、issues、PRs、Actions 等。 |

## 附錄 C：操作原則

- 先讓 AI 當 PM 與 Architect，再讓 AI 當 Developer。
- Architecture 核准前不 Bootstrap；Bootstrap 前不寫業務功能。
- 每個階段都要有 artifact；每個 PR 都要有 test evidence 與 rollback plan。
- GitHub Actions 是硬閘門，不用 AI 的自評取代 CI。
- R3/R4 高風險變更永遠先人工核准。
