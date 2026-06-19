# optional/ — opt-in scaffolds

These are **optional** orchestration scaffolds that most projects do not need.
They are not referenced by the pipeline, validators, or any product code.

- `langgraph/sdlc_graph.py` — a typed-state stub if you later want LangGraph for
  resumable workflows with explicit human interrupts.
- `crewai/agents.yaml`, `crewai/tasks.yaml` — a CrewAI multi-agent role/task map.

If you are not using LangGraph or CrewAI, **delete this whole directory** (or run
`scripts/graduate_sdlc.sh`). See `docs/SDLC-SCAFFOLDING.md`.
