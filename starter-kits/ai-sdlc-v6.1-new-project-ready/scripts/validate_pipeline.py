#!/usr/bin/env python3
from pathlib import Path
import sys

import yaml

ROOT = Path(__file__).resolve().parents[1]
required = [
    'CLAUDE.md', '.ai/sdlc-governance.md', '.ai/risk-policy.md', '.ai/new-project-policy.md',
    'pipeline/lifecycle.yml', 'pipeline/skill-map.yml', 'pipeline/artifact-schema.yml', 'pipeline/approval-matrix.yml',
    'skills/company/ai-sdlc-orchestrator/SKILL.md'
]
missing = [p for p in required if not (ROOT / p).exists()]
if missing:
    print('Missing required files:')
    print('\n'.join(missing))
    sys.exit(1)

loaded = {}
for p in ['pipeline/lifecycle.yml','pipeline/skill-map.yml','pipeline/artifact-schema.yml','pipeline/approval-matrix.yml']:
    try:
        loaded[p] = yaml.safe_load((ROOT/p).read_text(encoding='utf-8'))
    except Exception as e:
        print(f'Invalid YAML {p}: {e}')
        sys.exit(1)

stages = loaded['pipeline/lifecycle.yml'].get('stages', {})
for stage in ['inception','define','architecture','bootstrap','plan','build','verify','review','ship','operate']:
    if stage not in stages:
        print(f'Missing lifecycle stage: {stage}')
        sys.exit(1)
    d = ROOT / '.ai' / 'artifacts' / stage
    if not d.exists():
        print(f'Missing artifact dir: {d}')
        sys.exit(1)
    if stage not in loaded['pipeline/skill-map.yml'].get('phases', {}):
        print(f'Missing skill map phase: {stage}')
        sys.exit(1)
    if stage not in loaded['pipeline/artifact-schema.yml'].get('phases', {}):
        print(f'Missing artifact schema phase: {stage}')
        sys.exit(1)

print('Pipeline validation passed: v6.1 new-project-ready structure is complete')
