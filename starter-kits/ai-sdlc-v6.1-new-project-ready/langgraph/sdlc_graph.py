"""Optional scaffold: use LangGraph only after the file-based pipeline is stable."""
from typing import TypedDict, Literal

Stage = Literal['define', 'plan', 'build', 'verify', 'review', 'ship', 'operate']

class SDLCState(TypedDict):
    issue: str
    stage: Stage
    risk: str
    selected_skills: list[str]
    artifact_path: str
    gate_status: str

# Implement with langgraph when you need resumable workflows and explicit human interrupts.
