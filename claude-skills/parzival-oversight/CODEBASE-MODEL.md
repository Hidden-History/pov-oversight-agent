# Codebase Mental Model

**Purpose**: Parzival's understanding of how the system works. Updated as the project evolves.

**Last Updated**: [DATE]
**Confidence**: [Overall confidence in this model]

---

## System Overview

[High-level description of what the system does and why it exists]

---

## Architecture

### Component Map

```
[ASCII diagram or description of major components and their relationships]
```

### Component Descriptions

| Component | Purpose | Key Files | Dependencies |
|-----------|---------|-----------|--------------|
| [Name] | [What it does] | [Main files] | [What it depends on] |

### Data Flow

```
[How data moves through the system]
```

---

## Key Abstractions

### Core Concepts

| Concept | Definition | Where Used |
|---------|------------|------------|
| [Term] | [What it means in this codebase] | [Components] |

### Domain Language

| Term | Meaning |
|------|---------|
| [Project-specific term] | [Definition] |

---

## Integration Points

### External Services

| Service | Purpose | How We Connect | Failure Mode |
|---------|---------|----------------|--------------|
| [Name] | [Why we use it] | [Connection method] | [What happens if down] |

### APIs

| API | Direction | Purpose |
|-----|-----------|---------|
| [Name] | Inbound/Outbound | [What it's for] |

---

## Critical Paths

### Happy Path
[The main flow when everything works correctly]

### Failure Modes
[What can go wrong and how the system handles it]

---

## Configuration

### Environment Variables

| Variable | Purpose | Required | Default |
|----------|---------|----------|---------|
| [NAME] | [What it controls] | Yes/No | [Value] |

### Feature Flags

| Flag | Controls | Default |
|------|----------|---------|
| [Name] | [What it enables/disables] | [Value] |

---

## Testing Strategy

### Test Types

| Type | Location | Purpose | Coverage |
|------|----------|---------|----------|
| Unit | [Path] | [What they test] | [% or description] |
| Integration | [Path] | [What they test] | [% or description] |
| E2E | [Path] | [What they test] | [% or description] |

### How to Run Tests

```bash
# [Commands to run different test types]
```

---

## Build & Deploy

### Build Process
[How the system is built]

### Deployment Process
[How the system is deployed]

### Environments

| Environment | Purpose | URL/Location |
|-------------|---------|--------------|
| Local | Development | [Location] |
| Staging | Testing | [URL] |
| Production | Live | [URL] |

---

## Known Quirks

[Things that are non-obvious or surprising about this codebase]

1. [Quirk description and why it exists]
2. [Another quirk]

---

## Areas of Uncertainty

[Parts of the system Parzival doesn't fully understand yet]

| Area | What's Unclear | How to Verify |
|------|----------------|---------------|
| [Component] | [What Parzival doesn't know] | [How to find out] |

---

## Change Log

| Date | Change | Verified By |
|------|--------|-------------|
| [Date] | [What was updated in this model] | [How verified] |

---

**Note**: This document should be updated whenever Parzival learns something new about the system. Always note what changed and how it was verified.
