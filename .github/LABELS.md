# GitHub Labels for Parzival Oversight Agent

This document defines the label system for organizing issues and pull requests.

## Label Categories

### Type Labels

| Label | Color | Description |
|-------|-------|-------------|
| `type: bug` | `#d73a4a` (red) | Something isn't working correctly |
| `type: feature` | `#0e8a16` (green) | New feature or request |
| `type: docs` | `#0075ca` (blue) | Documentation improvements |
| `type: enhancement` | `#a2eeef` (light cyan) | Enhancement to existing feature |
| `type: refactor` | `#d4c5f9` (light purple) | Refactoring (no functional changes) |
| `type: security` | `#b60205` (dark red) | Security-related issues |
| `type: test` | `#1d76db` (blue) | Testing-related changes |

### Priority Labels

| Label | Color | Description |
|-------|-------|-------------|
| `priority: critical` | `#b60205` (dark red) | Blocks usage, needs immediate attention |
| `priority: high` | `#d93f0b` (orange) | Important, address soon |
| `priority: medium` | `#fbca04` (yellow) | Moderate importance |
| `priority: low` | `#c5def5` (light gray) | Nice to have |

### Component Labels

| Label | Color | Description |
|-------|-------|-------------|
| `component: agents` | `#7209b7` (purple) | Agent definitions and configuration |
| `component: commands` | `#1d76db` (blue) | Claude Code commands |
| `component: constraints` | `#b60205` (dark red) | Agent constraint definitions |
| `component: templates` | `#0dcaf0` (cyan) | Oversight templates |
| `component: procedures` | `#198754` (green) | Workflow procedures |
| `component: installer` | `#fd7e14` (orange) | Installation scripts |
| `component: documentation` | `#0075ca` (blue) | README, guides, docs |
| `component: ci` | `#6f42c1` (purple) | CI/CD workflows |

### Status Labels

| Label | Color | Description |
|-------|-------|-------------|
| `status: needs-triage` | `#ededed` (light gray) | Needs initial review |
| `status: in-progress` | `#0075ca` (blue) | Being worked on |
| `status: blocked` | `#d93f0b` (orange) | Blocked by dependency |
| `status: ready-for-review` | `#0e8a16` (green) | Ready for review |
| `status: needs-info` | `#d4c5f9` (light purple) | Waiting for more info |
| `status: stale` | `#fef2c0` (yellow) | No activity for extended period |

### Special Labels

| Label | Color | Description |
|-------|-------|-------------|
| `good first issue` | `#7057ff` (purple) | Good for newcomers |
| `help wanted` | `#008672` (teal) | Community contributions welcome |
| `duplicate` | `#cfd3d7` (gray) | Already exists |
| `wontfix` | `#ffffff` (white) | Will not be worked on |
| `breaking change` | `#b60205` (dark red) | Breaking changes |

## Label Creation Script

```bash
#!/usr/bin/env bash
# create-labels.sh - Create GitHub labels for Parzival Oversight Agent

REPO="Hidden-History/pov-oversight-agent"

# Type Labels
gh label create "type: bug" --color d73a4a --description "Something isn't working correctly" --repo "$REPO" --force
gh label create "type: feature" --color 0e8a16 --description "New feature or request" --repo "$REPO" --force
gh label create "type: docs" --color 0075ca --description "Documentation improvements" --repo "$REPO" --force
gh label create "type: enhancement" --color a2eeef --description "Enhancement to existing feature" --repo "$REPO" --force
gh label create "type: refactor" --color d4c5f9 --description "Refactoring" --repo "$REPO" --force
gh label create "type: security" --color b60205 --description "Security-related issues" --repo "$REPO" --force
gh label create "type: test" --color 1d76db --description "Testing-related changes" --repo "$REPO" --force

# Priority Labels
gh label create "priority: critical" --color b60205 --description "Blocks usage, needs immediate attention" --repo "$REPO" --force
gh label create "priority: high" --color d93f0b --description "Important, address soon" --repo "$REPO" --force
gh label create "priority: medium" --color fbca04 --description "Moderate importance" --repo "$REPO" --force
gh label create "priority: low" --color c5def5 --description "Low priority" --repo "$REPO" --force

# Component Labels
gh label create "component: agents" --color 7209b7 --description "Agent definitions" --repo "$REPO" --force
gh label create "component: commands" --color 1d76db --description "Claude Code commands" --repo "$REPO" --force
gh label create "component: constraints" --color b60205 --description "Agent constraints" --repo "$REPO" --force
gh label create "component: templates" --color 0dcaf0 --description "Oversight templates" --repo "$REPO" --force
gh label create "component: procedures" --color 198754 --description "Workflow procedures" --repo "$REPO" --force
gh label create "component: installer" --color fd7e14 --description "Installation scripts" --repo "$REPO" --force
gh label create "component: documentation" --color 0075ca --description "Documentation" --repo "$REPO" --force
gh label create "component: ci" --color 6f42c1 --description "CI/CD workflows" --repo "$REPO" --force

# Status Labels
gh label create "status: needs-triage" --color ededed --description "Needs initial review" --repo "$REPO" --force
gh label create "status: in-progress" --color 0075ca --description "Being worked on" --repo "$REPO" --force
gh label create "status: blocked" --color d93f0b --description "Blocked by dependency" --repo "$REPO" --force
gh label create "status: ready-for-review" --color 0e8a16 --description "Ready for review" --repo "$REPO" --force
gh label create "status: needs-info" --color d4c5f9 --description "Waiting for more info" --repo "$REPO" --force
gh label create "status: stale" --color fef2c0 --description "No activity for extended period" --repo "$REPO" --force

# Special Labels
gh label create "good first issue" --color 7057ff --description "Good for newcomers" --repo "$REPO" --force
gh label create "help wanted" --color 008672 --description "Community contributions welcome" --repo "$REPO" --force
gh label create "duplicate" --color cfd3d7 --description "Already exists" --repo "$REPO" --force
gh label create "wontfix" --color ffffff --description "Will not be worked on" --repo "$REPO" --force
gh label create "breaking change" --color b60205 --description "Breaking changes" --repo "$REPO" --force

echo "Labels created successfully!"
```

## Automated Labeling

See `.github/labeler.yml` for automatic label assignment based on file paths changed in PRs.
