# AI SDLC Claude Code Pipeline v6.1 New Project Ready 修正版

本文件修整 v6，使 pipeline 同時支援既有專案與全新專案。核心修正是新增 Inception、Architecture、Bootstrap 三個階段，避免 Claude Code 在新專案一開始就直接寫功能。

版本：v6.1 | 用途：Claude Code 可遵循的 CLAUDE.md + starter kit 資料結構 + skill-driven lifecycle。

## 設計依據

- addyosmani/agent-skills：作為主要 lifecycle skill pack。其 SKILL.md 不是參考文件，而是 agent 應遵循的 step-by-step engineering workflow，包含 verification、anti-pattern 與 exit criteria。
- obra/superpowers：作為方法論層，補強 discovery、planning、TDD、worktree isolation、review before merge 等紀律。
- heilcheng/awesome-agent-skills：作為 skill discovery index，用於尋找額外 domain-specific skills，不直接當 runtime skill。

## v6.1 的核心修正

| 修正項目 | v6 問題 | v6.1 解法 |
| --- | --- | --- |
| 新專案起始流程 | Define/Plan/Build 對新專案仍太快進入 coding | 新增 Inception → Define → Architecture → Bootstrap |
| CLAUDE.md | 沒有強制新專案不得先寫功能 | 新增 New Project Rule 與 bootstrap boundaries |
| Lifecycle | 缺少專案立項、架構核准、初始化骨架階段 | 更新 lifecycle.yml 至 version 1.1 |
| Skill Map | 只映射既有 SDLC | 新增 inception / architecture / bootstrap 對應 skills |
| Artifacts | 缺少 project brief、MVP、ADR、bootstrap report | 更新 artifact-schema.yml |
| Approval | 架構選型與新專案 bootstrap 閘門不足 | 更新 approval-matrix.yml |

## 全新專案生命週期

inception → define → architecture → bootstrap → plan → build → verify → review → ship → operate

| 階段 | 目的 | 主要輸出物 | 是否人工核准 |
| --- | --- | --- | --- |
| Inception | 定義產品、使用者、MVP、non-goals、成功指標 | project brief、MVP scope、open questions | 需要 |
| Define | 把想法轉成可驗收規格 | PRD、user stories、acceptance criteria | R2+ 需要 |
| Architecture | 技術選型與架構決策 | architecture.md、ADRs、security/testing/deployment strategy | 需要 |
| Bootstrap | 建立可運作專案骨架 | scaffold、CI、tests、README、.env.example、smoke test | R3/R4 需要 |
| Plan | 拆 MVP 任務 | roadmap、task breakdown、test strategy | R2+ 需要 |
| Build | 小步實作 | build report、changed files | R3/R4 需要 |
| Verify | 證明可用 | test commands、results、evidence | 通常不需要 |
| Review | 品質/安全/簡化/效能審查 | review report | R2+ 需要 |
| Ship | PR/Release/Rollback | PR body、release notes、rollback plan | R2+ 需要 |
| Operate | 監控與回饋 | monitoring result、follow-up tasks | R3/R4 需要 |

## 既有專案生命週期

define → plan → build → verify → review → ship → operate

既有專案不需要 Inception/Architecture/Bootstrap，除非任務涉及重大架構更動、全新模組、資料庫、Auth、Infra 或部署策略。

## Starter Kit v6.1 資料結構

repo/
├── CLAUDE.md
├── .ai/
│   ├── sdlc-governance.md
│   ├── risk-policy.md
│   ├── new-project-policy.md
│   ├── artifacts/{inception,define,architecture,bootstrap,plan,build,verify,review,ship,operate}/
│   └── decisions/
├── docs/
│   ├── project-brief.md
│   ├── product-requirements.md
│   ├── mvp-scope.md
│   ├── architecture.md
│   ├── roadmap.md
│   └── adrs/0001-tech-stack.md
├── pipeline/
│   ├── lifecycle.yml
│   ├── skill-map.yml
│   ├── artifact-schema.yml
│   └── approval-matrix.yml
├── skills/company/ai-sdlc-orchestrator/SKILL.md
├── skills/external/{addyosmani-agent-skills,obra-superpowers,heilcheng-awesome-agent-skills}/
├── .claude/commands/{sdlc-inception,sdlc-define,sdlc-architecture,sdlc-bootstrap,...}.md
├── scripts/{bootstrap_external_skills.sh,audit_skills.py,validate_pipeline.py,graduate_sdlc.sh}
└── optional/{langgraph,crewai}/   # 選用編排骨架,可刪

## 新增/修改的關鍵檔案

| 檔案 | 用途 |
| --- | --- |
| CLAUDE.md | Claude Code 的最高操作契約，新增 New Project Rule |
| .ai/new-project-policy.md | 新專案不得先寫功能、不得未核准先選架構的硬規則 |
| pipeline/lifecycle.yml | v1.1 lifecycle state machine，支援 new_project 與 existing_project paths |
| pipeline/skill-map.yml | 把 inception / architecture / bootstrap 對應到 agent-skills 與 superpowers |
| pipeline/artifact-schema.yml | 定義每個階段必備輸出物與 evidence |
| pipeline/approval-matrix.yml | 定義 R0-R4 與新專案關鍵閘門 |
| skills/company/ai-sdlc-orchestrator/SKILL.md | 總控 skill，負責選 phase、選 skill、檢查 artifacts、套 approval gate |
| .claude/commands/sdlc-inception.md | 新專案第一個入口 |
| .claude/commands/sdlc-architecture.md | 架構選型與 ADR 入口 |
| .claude/commands/sdlc-bootstrap.md | 初始化專案骨架入口 |

## Skill 對應設計

| Phase | Primary skills |
| --- | --- |
| Inception | interview-me、idea-refine、spec-driven-development + Superpowers methodology |
| Define | interview-me、idea-refine、spec-driven-development |
| Architecture | planning-and-task-breakdown、api-and-interface-design、security-and-hardening、documentation-and-adrs |
| Bootstrap | incremental-implementation、test-driven-development、ci-cd-and-automation、git-workflow-and-versioning、documentation-and-adrs |
| Plan | planning-and-task-breakdown、context-engineering |
| Build | incremental-implementation、context-engineering、source-driven-development、doubt-driven-development、test-driven-development、api-and-interface-design |
| Verify | debugging-and-error-recovery、browser-testing-with-devtools |
| Review | code-review-and-quality、code-simplification、security-and-hardening、performance-optimization |
| Ship | git-workflow-and-versioning、ci-cd-and-automation、deprecation-and-migration、documentation-and-adrs、shipping-and-launch |

## Claude Code 使用方式

全新專案第一個 prompt：

/sdlc-inception

我要建立一個新的 B2B SaaS，用來管理客戶合約、到期提醒與續約流程。
請依照 CLAUDE.md 的 New Project Pipeline 執行。
先不要建立程式碼。

請產出：
1. Project Brief
2. MVP Scope
3. User Stories
4. Non-goals
5. Acceptance Criteria
6. Open Questions
7. Initial Risk Assessment

架構核准 prompt：

/sdlc-architecture

根據已核准的 MVP Scope，提出 2-3 種技術架構選項。
比較開發速度、維護成本、部署複雜度、安全性、成本與擴充性。
請推薦一個方案，產生 architecture.md 與 ADR。
先不要寫 code。

初始化 prompt：

/sdlc-bootstrap

依照已核准的 architecture.md 與 ADR 初始化專案骨架。
只建立 framework scaffold、lint、test、CI、README、.env.example、health check/smoke test。
不要實作完整業務功能。

## 落地檢查清單

- 把 starter kit 解壓到 repo 根目錄。
- 執行 bash scripts/bootstrap_external_skills.sh 下載外部 skills。
- 執行 python scripts/validate_pipeline.py 確認 v6.1 結構完整。
- 執行 python scripts/audit_skills.py 檢查 SKILL.md 結構。
- 用 Claude Code 開啟 repo，先要求它讀 CLAUDE.md。
- 全新專案從 /sdlc-inception 開始；既有專案從 /sdlc-define 或 /sdlc-plan 開始。
- 任何 R3/R4 變更都必須先產生 plan 與 approval request。
- PR 前確認 evidence、risk class、rollback plan、CI status 都存在。
- 出貨/交付前執行 `bash scripts/graduate_sdlc.sh --full` 移除開發鷹架,得到乾淨產品 repo(見 starter kit 內 `docs/SDLC-SCAFFOLDING.md`)。

## 修整後的判斷原則

v6.1 的重點不是讓 Claude Code 更快寫 code，而是讓它在正確時機做正確事情。全新專案時，AI 先當 PM/Architect；通過 Inception、Define、Architecture 後，才當 Developer；最後由 Verify/Review/Ship gate 控制品質。

## 參考來源

- https://github.com/addyosmani/agent-skills
- https://github.com/addyosmani/agent-skills/blob/main/docs/getting-started.md
- https://github.com/obra/superpowers
- https://github.com/heilcheng/awesome-agent-skills
