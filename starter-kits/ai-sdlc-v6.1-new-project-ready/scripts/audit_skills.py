#!/usr/bin/env python3
from pathlib import Path
import re
import sys

ROOT = Path(__file__).resolve().parents[1]
MAP = ROOT / 'pipeline' / 'skill-map.yml'
required_sections = ['Overview', 'When to Use', 'Process', 'Rationalizations', 'Red Flags', 'Verification']

def load_yaml(path):
    try:
        import yaml
        return yaml.safe_load(path.read_text(encoding='utf-8'))
    except Exception as e:
        print(f'ERROR: failed to read {path}: {e}')
        sys.exit(2)

def check_skill(path, strict_sections):
    if not path.exists():
        return [f'missing {path}']
    text = path.read_text(encoding='utf-8', errors='replace')
    errors = []
    if not text.startswith('---'):
        errors.append(f'{path}: missing YAML frontmatter')
    if strict_sections:
        for s in required_sections:
            if not re.search(rf'^#{{1,3}}\s+.*\b{re.escape(s)}\b', text, re.M):
                errors.append(f'{path}: missing section {s}')
    return errors

def mapped_skill_paths(data):
    phases = data.get('phases') or {}
    for _phase, cfg in phases.items():
        for key in ('primary', 'optional', 'supporting'):
            for item in cfg.get(key, []):
                if isinstance(item, str) and item.endswith('SKILL.md'):
                    path = ROOT / item
                    yield path, 'skills/company/' in item
                elif isinstance(item, dict):
                    skill = item.get('skill')
                    source = item.get('source')
                    if not skill:
                        continue
                    if source == 'addyosmani_agent_skills':
                        yield ROOT / 'skills' / 'external' / 'addyosmani-agent-skills' / 'skills' / skill / 'SKILL.md', False
                    elif source == 'company':
                        yield ROOT / 'skills' / 'company' / skill / 'SKILL.md', True

data = load_yaml(MAP)
errors = []
for path, strict_sections in sorted(set(mapped_skill_paths(data))):
    errors += check_skill(path, strict_sections)

if errors:
    ext = ROOT / 'skills' / 'external'
    def _placeholder_only(d):
        if not d.exists():
            return True
        return all(p.name == '.gitkeep' for p in d.iterdir())
    all_external = all('skills/external' in e for e in errors)
    externals_unbootstrapped = ext.exists() and all(
        _placeholder_only(c) for c in ext.iterdir() if c.is_dir()
    )
    if all_external and externals_unbootstrapped:
        print('External skills are not bootstrapped - local tree is intentionally incomplete.')
        print('Run: bash scripts/bootstrap_external_skills.sh  (then re-run this audit).')
        print('The starter kit skill-audit workflow bootstraps before this audit in target repos.')
        sys.exit(1)
    print('\n'.join(errors))
    sys.exit(1)
print('Skill audit passed')
