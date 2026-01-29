# BMAD Agent & Workflow Index

This document provides a complete reference of all BMAD agents and workflows.

**Purpose**: Avoid repeated searches - check here first.

> **Note**: This index references agents across the full BMAD-METHOD ecosystem.
> Paths marked with `bmm/`, `bmgd/`, `cis/`, `bmb/` refer to agents in those
> respective modules (installed separately via BMAD-METHOD), not this Parzival module.
> Only `pov/` agents are included in this module's installation.

---

## Module Overview

| Module | Full Name | Agents | Focus Area |
|--------|-----------|--------|------------|
| **bmm** | BMAD Method Main | 9 | Software development lifecycle |
| **bmgd** | BMAD Game Development | 6 | Game development workflow |
| **cis** | Creative & Innovation Suite | 6 | Ideation & storytelling |
| **bmb** | BMAD Builder | 3 | Building BMAD modules |
| **pov** | Parzival Oversight | 4 | Project oversight & quality |

---

## BMM Agents (Software Development)

**Location**: `src/modules/bmm/agents/`

| Agent | File | Purpose |
|-------|------|---------|
| analyst | `analyst.agent.yaml` | Business analysis, requirements |
| architect | `architect.agent.yaml` | Technical architecture design |
| dev | `dev.agent.yaml` | Development, implementation |
| pm | `pm.agent.yaml` | Product management |
| sm | `sm.agent.yaml` | Scrum master, sprint management |
| tea | `tea.agent.yaml` | Test engineering & automation |
| tech-writer | `tech-writer.agent.yaml` | Documentation |
| ux-designer | `ux-designer.agent.yaml` | UX/UI design |
| quick-flow-solo-dev | `quick-flow-solo-dev.agent.yaml` | Solo development workflow |

### BMM Claude Code Sub-Agents

**Location**: `src/modules/bmm/sub-modules/claude-code/sub-agents/`

| Agent | Purpose |
|-------|---------|
| bmad-analysis | Analysis tasks via Claude Code |
| bmad-planning | Planning tasks via Claude Code |
| bmad-research | Research tasks via Claude Code |
| bmad-review | Review tasks via Claude Code |

---

## BMGD Agents (Game Development)

**Location**: `src/modules/bmgd/agents/`

| Agent | File | Purpose |
|-------|------|---------|
| game-architect | `game-architect.agent.yaml` | Game architecture design |
| game-designer | `game-designer.agent.yaml` | Game design, mechanics |
| game-dev | `game-dev.agent.yaml` | Game development |
| game-qa | `game-qa.agent.yaml` | Game QA & testing |
| game-scrum-master | `game-scrum-master.agent.yaml` | Game sprint management |
| game-solo-dev | `game-solo-dev.agent.yaml` | Solo game development |

---

## CIS Agents (Creative & Innovation)

**Location**: `src/modules/cis/agents/`

| Agent | File | Purpose |
|-------|------|---------|
| brainstorming-coach | `brainstorming-coach.agent.yaml` | Ideation facilitation |
| creative-problem-solver | `creative-problem-solver.agent.yaml` | Problem solving methods |
| design-thinking-coach | `design-thinking-coach.agent.yaml` | Design thinking process |
| innovation-strategist | `innovation-strategist.agent.yaml` | Innovation strategy |
| presentation-master | `presentation-master.agent.yaml` | Presentation design |
| storyteller | `storyteller/storyteller.agent.yaml` | Narrative & storytelling |

---

## BMB Agents (BMAD Builders)

**Location**: `src/modules/bmb/agents/`

| Agent | File | Purpose |
|-------|------|---------|
| agent-builder | `agent-builder.agent.yaml` | Build new BMAD agents |
| module-builder | `module-builder.agent.yaml` | Build BMAD modules |
| workflow-builder | `workflow-builder.agent.yaml` | Build BMAD workflows |

---

## POV Agents (Parzival Oversight)

**Location**: `bmad-parzival-module/claude-commands/pov/agents/`

| Agent | File | Purpose |
|-------|------|---------|
| parzival | `parzival.md` | Main oversight agent |
| code-reviewer | `code-reviewer.md` | Code quality review |
| best-practices-researcher | `best-practices-researcher.md` | Research patterns |
| verify-implementation | `verify-implementation.md` | Verify against criteria |

### POV Commands

**Location**: `bmad-parzival-module/claude-commands/pov/commands/`

| Command | File | Purpose |
|---------|------|---------|
| parzival-start | `parzival-start.md` | Begin session |
| parzival-status | `parzival-status.md` | Quick status check |
| parzival-closeout | `parzival-closeout.md` | End session with handoff |
| parzival-handoff | `parzival-handoff.md` | Mid-session snapshot |
| parzival-blocker | `parzival-blocker.md` | Analyze blocker |
| parzival-decision | `parzival-decision.md` | Decision support |
| parzival-verify | `parzival-verify.md` | Run verification |

---

## Key Workflows by Phase

### BMM Workflows

**Phase 1 - Analysis**:
- `research` - Market/technical research
- `document-project` - Brownfield documentation

**Phase 2 - Planning**:
- `create-prd` - Product requirements
- `create-product-brief` - Product brief

**Phase 3 - Solutioning**:
- `create-architecture` - Architecture design
- `create-tech-spec` - Technical specification
- `create-ux-design` - UX design

**Phase 4 - Implementation**:
- `create-story` - Create user stories
- `dev-story` - Implement stories
- `code-review` - Review code
- `sprint-planning` - Plan sprints
- `sprint-status` - Check sprint status
- `retrospective` - Epic retrospective
- `correct-course` - Handle changes

### BMGD Workflows

**Phase 1 - Preproduction**:
- `game-brief` - Game concept brief

**Phase 2 - Design**:
- `gdd` - Game design document
- `narrative` - Narrative design

**Phase 3 - Technical**:
- `game-architecture` - Game tech architecture

**Phase 4 - Production**:
- `dev-story` - Implement features
- `code-review` - Review game code

### CIS Workflows

- `design-thinking` - Design thinking process
- `innovation-strategy` - Innovation planning
- `problem-solving` - Problem solving methods
- `storytelling` - Narrative development

### BMB Workflows

- `agent` - Create/edit agents
- `module` - Create modules
- `workflow` - Create workflows

---

## Quick Reference: Invoking Agents

```
# Via slash command (Claude Code)
/bmad:bmm:agents:dev
/pov:agents:code-reviewer

# Via workflow
/bmad:bmm:workflows:dev-story
/pov:commands:parzival-start
```

---

*Last updated: 2026-01-13*
*Source: BMAD-METHOD repository + bmad-parzival-module*
