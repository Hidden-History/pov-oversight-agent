# Parzival Subagent Enhancements - Implementation Plan

**Document**: Implementation specification for Parzival subagent improvements
**Version**: 1.1.0
**Created**: 2026-01-12
**Status**: READY FOR IMPLEMENTATION

---

## Executive Summary

This document specifies enhancements to Parzival's three subagents based on live testing and analysis. The changes improve project constraint awareness, enable knowledge persistence, and add automated verification capabilities.

### Subagents Being Enhanced

| Subagent | Current State | Enhancement Focus |
|----------|---------------|-------------------|
| Code Reviewer | Basic review checklist | Project constraint awareness, 2026 standards verification |
| Best Practices Researcher | Research output only | Auto-activation, knowledge persistence, deduplication |
| Verify Implementation | Manual verification | Test execution, pytest parsing, constraint validation |

---

## Part 1: Code Reviewer Enhancements

### File to Modify
`claude-commands/pov/agents/code-reviewer.md`

### Current Tools
```yaml
tools: Read, Grep, Glob, Bash
```

### Enhanced Tools (ADD WebSearch)
```yaml
tools: Read, Grep, Glob, Bash, WebSearch, WebFetch
```

### New Section to Add (After line 11, before "## Review Priority Order")

```markdown
## Pre-Review Steps (REQUIRED)

Before reviewing any code, complete these steps:

### Step 1: Load Project Constraints
```bash
# Read project-specific constraints
Read: {project-root}/project-context.md
Read: {project-root}/CLAUDE.md
```

Extract and note:
- Python version requirement (e.g., Python 3.10 for AMD ROCm)
- Sync vs async architecture decisions
- Specific library version constraints
- Project-specific coding conventions

### Step 2: Check Python Version Constraints

If Python version is constrained (e.g., 3.10):
- DO NOT flag missing 3.11+ features (exception groups, tomllib)
- DO NOT flag missing 3.12+ features (type parameter syntax)
- DO NOT recommend `StrEnum` if target is < 3.11
- DO flag code that REQUIRES newer Python than project allows

### Step 3: Verify Standards via Best Practices Directory (REQUIRED)

Before flagging ANY pattern as "outdated" or "not best practice":

**3a. Check existing findings FIRST**
```bash
# Check if topic already researched
Glob: {oversight}/knowledge/best-practices/*.md
Grep: "[pattern keywords]" in {oversight}/knowledge/best-practices/
Read: {oversight}/knowledge/best-practices/index.md
```

**3b. If finding exists:**
- Check status (CURRENT vs NEEDS_REVIEW)
- If CURRENT and < 6 months old: Use existing finding as baseline
- If NEEDS_REVIEW or > 6 months: Proceed to web verification

**3c. Web search to verify/update (ALWAYS after checking directory)**
```bash
WebSearch: "[topic] best practices 2026"
WebFetch: [official documentation URL]
```

Compare web results against existing finding (if any).

**3d. Update best-practices directory if needed**

If web search reveals NEW or CHANGED best practice:
1. Update existing finding file with correction section
2. Or create new finding if topic not covered
3. Update index.md with new/modified entry
4. Use the SAME template as Best Practices Researcher

Correction format to append:
```markdown
### Correction [YYYY-MM-DD]
**Previous Understanding**: [What the finding said]
**Updated Understanding**: [What web search revealed]
**Reason for Change**: [New version, deprecated pattern, etc.]
**Source**: [URL]
**Updated By**: Code Reviewer (during review of [file])
```

**3e. Cite the finding in your review**
```markdown
- **Reference**: BP-XXX in `best-practices/{topic}.md`
- **Standard**: [What the best practice recommends]
- **Code Status**: [Compliant / Non-compliant]
```

### Step 4: Document Constraint-Blocked Recommendations

If a best practice cannot be applied due to project constraints:
```markdown
### Deferred: [Issue Title]
- **Best Practice**: [What 2026 recommends]
- **Blocked By**: [Project constraint - e.g., Python 3.10 requirement]
- **Reference**: BP-XXX (if documented in best-practices/)
- **Recommendation**: Add to TECH-DEBT backlog for future consideration
```
```

### Modified Output Format Section

Add to the output format (after "## Positive Observations"):

```markdown
## Constraint-Blocked Recommendations

| Recommendation | Blocked By | Defer To |
|----------------|------------|----------|
| [Best practice] | [Constraint] | [TECH-DEBT-XXX or Epic N] |

## Standards Verification Log

| Pattern Checked | BP-ID | Source | Date | Result | Action |
|-----------------|-------|--------|------|--------|--------|
| [Pattern] | BP-XXX | [URL] | [Date] | [Valid/Outdated] | [None/Updated/Created] |

## Best Practices Updates Made

| BP-ID | Topic | Action | Reason |
|-------|-------|--------|--------|
| BP-XXX | [Topic] | [Created/Updated/Corrected] | [Why - outdated, new pattern, etc.] |
```

---

## Part 2: Best Practices Researcher Enhancements (MAJOR)

### Files to Modify
1. `claude-commands/pov/agents/best-practices-researcher.md` - Agent definition
2. `pov/config.yaml` - Add configuration settings
3. `pov/templates/oversight/knowledge/` - Add new directory and templates

### New Section to Add (After line 9, REPLACE entire Research Process section)

```markdown
## Activation Triggers

This agent AUTOMATICALLY activates when any agent or user:
- Asks "What's the best practice for X?"
- Asks "How should we handle Y in 2026?"
- Asks "Is this pattern current/modern?"
- Asks "Verify this approach against standards"
- Uses keywords: "best practice", "current standard", "modern approach", "2026 pattern"

## Research Process (ENHANCED)

### Phase 1: Check Existing Knowledge (REQUIRED FIRST)

Before ANY web search, check if topic already researched:

```bash
# Check existing findings
Glob: {oversight}/knowledge/best-practices/*.md
Grep: "[topic keywords]" in {oversight}/knowledge/best-practices/

# Check index
Read: {oversight}/knowledge/best-practices/index.md
```

**If topic found:**
1. Read existing finding
2. Check staleness (> 6 months = NEEDS_REVIEW)
3. If CURRENT: Use existing finding, skip web search
4. If NEEDS_REVIEW: Proceed to Phase 2 for verification only

**If topic NOT found:**
1. Proceed to Phase 2 for full research

### Phase 2: Web Research (If Needed)

1. **Search official documentation first**
   - Python: docs.python.org
   - Qdrant: qdrant.tech/documentation
   - FastAPI: fastapi.tiangolo.com
   - pytest: docs.pytest.org

2. **Search 2024-2026 sources**
   ```
   WebSearch: "[topic] best practices 2026"
   WebSearch: "[topic] [library version] guide"
   ```

3. **Verify against project constraints**
   - Read project-context.md for constraints
   - Check Python version compatibility
   - Check sync/async architecture alignment

### Phase 3: Save Finding (REQUIRED)

After completing research, ALWAYS save to oversight directory.

**File Location**: `{oversight}/knowledge/best-practices/{topic-slug}.md`

**Naming Convention**: `{technology}-{topic}[-{version}].md`
- Examples:
  - `python-async-context-managers.md`
  - `qdrant-multitenancy-filtering.md`
  - `python-type-hints-3.10.md`
  - `pytest-async-fixtures.md`

### Phase 4: Update Related Files (REQUIRED)

After saving finding:

1. **Update index.md**
   ```markdown
   | BP-XXX | [Topic] | [Date] | [Confidence] | [Status] |
   ```

2. **Update confidence-map.md** (if applicable)
   ```markdown
   | [Topic] | [Understanding] | [Confidence] | [Date] | Researched via BP-XXX |
   ```

3. **Link to decisions-log.md** (if finding influences a decision)
   ```markdown
   **Research Reference**: See BP-XXX in best-practices/[topic].md
   ```

## Finding File Template

Use this EXACT template for all findings:

```markdown
# Best Practice: [Topic Title]

**ID**: BP-XXX
**File**: `{filename}.md`
**Created**: [YYYY-MM-DD]
**Last Verified**: [YYYY-MM-DD]
**Status**: [CURRENT | NEEDS_REVIEW | SUPERSEDED | ARCHIVED]
**Confidence**: [Verified | Informed | Inferred]
**Triggered By**: [Agent name] / "[User query]"

---

## Summary

[One paragraph - what this best practice is about]

## Applicability Check

| Constraint | Project Value | Compatible |
|------------|---------------|------------|
| Python Version | [e.g., 3.10] | [YES/NO] |
| Sync/Async | [e.g., Sync] | [YES/NO] |
| Key Dependencies | [List] | [YES/NO] |

**Applicability**: [APPLICABLE | NOT_APPLICABLE | PARTIAL]

---

## Current Best Practice (2024-2026)

### Recommended Approach

[Description of recommended approach]

### Code Example

```[language]
# Example code demonstrating best practice
```

### Why This Approach

- [Reason 1]
- [Reason 2]
- [Reason 3]

### When NOT to Use

- [Exception 1]
- [Exception 2]

---

## Sources

| Source | Type | Date | Relevance |
|--------|------|------|-----------|
| [URL](url) | Documentation | YYYY-MM-DD | High |
| [URL](url) | Article | YYYY-MM-DD | Medium |

## Key Quotes

> "[Direct quote from authoritative source]"
> - [Source name and date]

---

## Alternative Approaches

### Alternative 1: [Name]

**When to use**: [Conditions]
**Tradeoffs**:
- Pro: [Advantage]
- Con: [Disadvantage]

### Alternative 2: [Name]

**When to use**: [Conditions]
**Tradeoffs**:
- Pro: [Advantage]
- Con: [Disadvantage]

---

## Project-Specific Recommendation

**For this project**: [Specific recommendation considering constraints]

**Related Decisions**:
- [DEC-XXX](../../decisions/decisions-log.md#dec-xxx) - [Brief description]

**Related Findings**:
- [BP-YYY](./other-topic.md) - [Brief description]

---

## Corrections History

<!-- Append corrections here, newest first -->
<!-- Template for corrections:

### Correction [YYYY-MM-DD]

**Previous Understanding**: [What we thought before]
**Updated Understanding**: [What's now correct]
**Reason for Change**: [Why - new version, deprecated pattern, etc.]
**Source**: [URL or reference]
**Verified By**: Best Practices Researcher

---
-->

---

## Staleness Tracking

| Event | Date | Next Review |
|-------|------|-------------|
| Created | [YYYY-MM-DD] | [+6 months] |
| Verified | [YYYY-MM-DD] | [+6 months] |

**Auto-Review Trigger**: This finding should be re-verified if:
- [ ] 6 months since last verification
- [ ] Major version change in [technology]
- [ ] User questions applicability
- [ ] Contradictory information encountered

---
*Generated by Best Practices Researcher (Parzival subagent)*
*Review recommended before applying to production code*
```

## Deduplication Logic

```
IF topic_exists_in_index(topic):
    existing_finding = read_finding(topic)

    IF existing_finding.status == "CURRENT" AND age < 6_months:
        RETURN existing_finding  # No web search needed

    ELSE IF existing_finding.status == "NEEDS_REVIEW" OR age >= 6_months:
        new_research = web_search(topic)

        IF new_research.differs_from(existing_finding):
            append_correction(existing_finding, new_research)
            existing_finding.last_verified = today()
            existing_finding.status = "CURRENT"
        ELSE:
            existing_finding.last_verified = today()
            # No correction needed, just refresh date

        RETURN existing_finding

ELSE:
    # New topic - full research
    new_finding = full_research(topic)
    save_finding(new_finding)
    update_index(new_finding)
    RETURN new_finding
```

## Retention Policy

**NEVER delete findings.** Knowledge evolution is valuable.

| Status | Meaning | Action |
|--------|---------|--------|
| CURRENT | Verified within 6 months | Use confidently |
| NEEDS_REVIEW | > 6 months old | Verify before using |
| SUPERSEDED | Replaced by newer finding | Keep for history, link to replacement |
| ARCHIVED | Technology no longer relevant | Keep for audit trail |

**Staleness Detection**:
- Findings > 6 months: Auto-flag NEEDS_REVIEW
- Findings > 12 months: Require verification before use
- After verification: Reset to CURRENT or mark SUPERSEDED
```

### New Template File to Create

**File**: `pov/templates/oversight/knowledge/best-practices/index.md`

```markdown
# Best Practices Knowledge Base

**Purpose**: Index of all researched best practices with status tracking.
**Maintained By**: Best Practices Researcher (Parzival subagent)
**Last Updated**: [DATE]

---

## Quick Reference

| ID | Topic | Status | Confidence | Last Verified |
|----|-------|--------|------------|---------------|
| BP-001 | [Topic] | CURRENT | Verified | [Date] |

---

## Status Legend

| Status | Meaning | Action Required |
|--------|---------|-----------------|
| CURRENT | Verified within 6 months | None - use confidently |
| NEEDS_REVIEW | > 6 months since verification | Re-verify before critical use |
| SUPERSEDED | Replaced by newer finding | Use replacement instead |
| ARCHIVED | No longer relevant to project | Historical reference only |

---

## By Technology

### Python
| ID | Topic | File | Status |
|----|-------|------|--------|
| - | - | - | - |

### Qdrant
| ID | Topic | File | Status |
|----|-------|------|--------|
| - | - | - | - |

### FastAPI
| ID | Topic | File | Status |
|----|-------|------|--------|
| - | - | - | - |

### pytest
| ID | Topic | File | Status |
|----|-------|------|--------|
| - | - | - | - |

### Other
| ID | Topic | File | Status |
|----|-------|------|--------|
| - | - | - | - |

---

## Needing Review

| ID | Topic | Last Verified | Days Since |
|----|-------|---------------|------------|
| - | - | - | - |

---

## Recently Added

| ID | Topic | Added | By |
|----|-------|-------|-----|
| - | - | - | - |

---

## Usage Instructions

### For Agents
1. Check this index BEFORE web searching
2. If topic exists with CURRENT status, use existing finding
3. If topic exists with NEEDS_REVIEW, verify then update
4. If topic not found, research and add new entry

### For Users
1. Browse by technology section for quick lookup
2. Check "Needing Review" for stale findings
3. Request re-verification if finding seems outdated

---
*Auto-maintained by Best Practices Researcher*
```

### Config Updates

**File**: `pov/config.yaml`

Add after line 50:

```yaml
  # Best Practices Researcher settings
  best_practices:
    # Where findings are stored
    findings_folder: "{oversight_folder}/knowledge/best-practices"

    # Staleness thresholds (in days)
    needs_review_after: 180  # 6 months
    requires_verification_after: 365  # 12 months

    # Primary technologies for this module
    tech_focus:
      - Python
      - Qdrant
      - FastAPI
      - pytest
      - Docker

    # Auto-link settings
    auto_link_decisions: true
    auto_update_confidence_map: true

    # ID prefix for findings
    finding_id_prefix: "BP"
```

---

## Part 3: Verify Implementation Enhancements

### File to Modify
`claude-commands/pov/agents/verify-implementation.md`

### New Section to Add (After "## Verification Process", before "## Output Format")

```markdown
## Test Execution Protocol

### Pre-Execution Check

Before running any tests:

1. **Check for active test processes**
   ```bash
   # Check if pytest is already running
   ps aux | grep pytest
   ```

   If tests are running in another terminal:
   - DO NOT execute tests
   - Report: "Test execution deferred - tests running in Terminal X"
   - Proceed with code inspection verification only

2. **Identify correct test file**
   ```bash
   # Find tests for this story
   Glob: tests/test_{story_slug}*.py
   Glob: tests/integration/test_{story_slug}*.py
   ```

### Test Execution (When Safe)

```bash
# Run story-specific tests
python3 -m pytest tests/test_{story}.py -v --tb=short

# For integration tests (slower)
python3 -m pytest tests/integration/test_{story}.py -v --tb=short -m integration
```

### Pytest Output Parsing

Parse output and report:

```markdown
## Test Execution Results

**Command**: `pytest tests/test_X.py -v`
**Exit Code**: [0 = all pass, 1 = failures, 2 = error]

| Metric | Count |
|--------|-------|
| Total Tests | X |
| Passed | X |
| Failed | X |
| Skipped | X |
| Errors | X |

### Failed Tests (if any)

| Test Name | Failure Reason | Line |
|-----------|----------------|------|
| test_X | AssertionError: ... | file.py:123 |

### Test Coverage (if available)

| File | Coverage |
|------|----------|
| src/memory/X.py | XX% |
```

## Constraint Validation Protocol

### Python Version Check

Verify implementation uses only features available in project's Python version:

```bash
# Check Python version requirement
Grep: "python_requires" in pyproject.toml
Read: project-context.md for Python constraint
```

**For Python 3.10 projects, flag if code uses:**
- Exception groups (`except* ...`) - Python 3.11+
- `tomllib` module - Python 3.11+
- Type parameter syntax (`def f[T]()`) - Python 3.12+
- `StrEnum` - Python 3.11+ (use `str, Enum` instead)

### Architecture Alignment Check

Verify implementation aligns with architecture decisions:

```bash
Read: project-context.md for architecture constraints
Read: architecture.md for design decisions
```

**Check for:**
- Sync vs async pattern alignment
- Correct module placement (flat structure)
- Proper logging format (structured logging)
- Error handling pattern (graceful degradation)

### Dependency Version Check

```bash
# Check pinned versions
Read: requirements.txt
Read: pyproject.toml [project.dependencies]

# Verify used features exist in pinned version
WebSearch: "[library] [version] API [feature]"
```

## Enhanced Output Format Addition

Add to output format:

```markdown
## Constraint Validation

### Python Version Compliance
**Required**: Python [X.Y]
**Status**: [COMPLIANT | VIOLATION]

| Feature Used | Requires | Status |
|--------------|----------|--------|
| [Feature] | Python X.Y+ | OK/VIOLATION |

### Architecture Alignment
**Status**: [ALIGNED | MISALIGNED]

| Aspect | Expected | Actual | Status |
|--------|----------|--------|--------|
| Sync/Async | Sync | Sync | OK |
| Module Structure | Flat | Flat | OK |
| Logging | Structured | Structured | OK |

### Dependency Compatibility
**Status**: [COMPATIBLE | INCOMPATIBLE]

| Dependency | Pinned | Feature Used | Available In |
|------------|--------|--------------|--------------|
| qdrant-client | 1.16.2 | query_points | 1.16.0+ | OK |
```
```

---

## Part 4: New Template Directory Structure

### Create Directory Structure

```
pov/templates/oversight/knowledge/
├── confidence-map.md          # (existing)
├── assumption-registry.md     # (existing)
└── best-practices/            # NEW
    ├── index.md               # NEW - Index of all findings
    └── _TEMPLATE.md           # NEW - Template for new findings
```

### Template File for New Findings

**File**: `pov/templates/oversight/knowledge/best-practices/_TEMPLATE.md`

```markdown
# Best Practice: [TOPIC TITLE]

**ID**: BP-XXX
**File**: `[filename].md`
**Created**: [YYYY-MM-DD]
**Last Verified**: [YYYY-MM-DD]
**Status**: CURRENT
**Confidence**: [Verified | Informed | Inferred]
**Triggered By**: [Agent/User] / "[Query that triggered research]"

---

## Summary

[One paragraph summary of the best practice]

## Applicability Check

| Constraint | Project Value | Compatible |
|------------|---------------|------------|
| Python Version | [Version] | [YES/NO] |
| Sync/Async | [Pattern] | [YES/NO] |
| Key Dependencies | [List] | [YES/NO] |

**Applicability**: [APPLICABLE | NOT_APPLICABLE | PARTIAL]

---

## Current Best Practice (2024-2026)

### Recommended Approach

[Detailed description]

### Code Example

```[language]
# Example implementation
```

### Why This Approach

- [Reason 1]
- [Reason 2]

### When NOT to Use

- [Exception 1]
- [Exception 2]

---

## Sources

| Source | Type | Date | Relevance |
|--------|------|------|-----------|
| [URL](url) | [Type] | [Date] | [High/Med/Low] |

## Key Quotes

> "[Quote]"
> - [Source]

---

## Alternative Approaches

### Alternative 1: [Name]
- **When to use**: [Conditions]
- **Tradeoffs**: [Pros/cons]

---

## Project-Specific Recommendation

[Recommendation for this specific project]

**Related Decisions**: [DEC-XXX links]
**Related Findings**: [BP-XXX links]

---

## Corrections History

<!-- Append corrections newest first -->

---

## Staleness Tracking

| Event | Date | Next Review |
|-------|------|-------------|
| Created | [YYYY-MM-DD] | [+6 months] |

---
*Generated by Best Practices Researcher (Parzival subagent)*
```

---

## Part 5: Installation/Update Instructions

### For Existing Parzival Installations

After updating the module files, users must:

1. **Update oversight directory structure**
   ```bash
   mkdir -p {project}/oversight/knowledge/best-practices
   cp _TEMPLATE.md {project}/oversight/knowledge/best-practices/
   cp index.md {project}/oversight/knowledge/best-practices/
   ```

2. **Update existing best-practices-log.md**
   - Migrate entries to individual files in `best-practices/` directory
   - Or keep existing format and add new directory alongside

3. **No changes to existing sessions**
   - Enhancements are backward compatible
   - Existing oversight files remain valid

### Update install.sh

Add to install.sh after oversight directory creation:

```bash
# Create best-practices directory
mkdir -p "${OVERSIGHT_DIR}/knowledge/best-practices"
cp "${TEMPLATE_DIR}/oversight/knowledge/best-practices/index.md" "${OVERSIGHT_DIR}/knowledge/best-practices/"
cp "${TEMPLATE_DIR}/oversight/knowledge/best-practices/_TEMPLATE.md" "${OVERSIGHT_DIR}/knowledge/best-practices/"
```

---

## Part 6: Implementation Checklist

### Phase 1: Code Reviewer Updates
- [ ] Add WebSearch, WebFetch to tools in frontmatter
- [ ] Add "Pre-Review Steps" section with 4 steps
- [ ] Step 3 must include best-practices directory check BEFORE web search
- [ ] Step 3 must include logic to UPDATE best-practices directory
- [ ] Add "Constraint-Blocked Recommendations" to output format
- [ ] Add "Standards Verification Log" to output format (with BP-ID column)
- [ ] Add "Best Practices Updates Made" to output format
- [ ] Test: Verify Code Reviewer checks directory before web search
- [ ] Test: Verify Code Reviewer updates findings when web reveals changes

### Phase 2: Best Practices Researcher Updates
- [ ] Replace Research Process section with enhanced version
- [ ] Add Finding File Template
- [ ] Add Deduplication Logic section
- [ ] Add Retention Policy section
- [ ] Update config.yaml with best_practices settings
- [ ] Create index.md template
- [ ] Create _TEMPLATE.md for findings
- [ ] Test with sample research query

### Phase 3: Verify Implementation Updates
- [ ] Add Test Execution Protocol section
- [ ] Add Pytest Output Parsing section
- [ ] Add Constraint Validation Protocol section
- [ ] Add enhanced output format sections
- [ ] Test with sample story verification

### Phase 4: Template Updates
- [ ] Create best-practices/ directory in templates
- [ ] Create index.md template
- [ ] Create _TEMPLATE.md template
- [ ] Update install.sh for new directory
- [ ] Update install-windows.bat for new directory

### Phase 5: Documentation
- [ ] Update README.md with new features
- [ ] Update INSTALL-GUIDE.md with new directory structure
- [ ] Add migration notes for existing installations

---

## Part 7: Testing Plan

### Code Reviewer Test Cases

1. **Constraint awareness**: Review code using Python 3.11 features in 3.10 project
   - Expected: Flag as constraint violation, not "outdated"

2. **Directory check first**: Review code with pattern that exists in best-practices/
   - Expected: Read existing finding BEFORE web search
   - Expected: Use existing finding if CURRENT and < 6 months

3. **Update outdated finding**: Review code, existing finding is 8 months old
   - Expected: Check directory, find stale entry, verify via web
   - Expected: Append correction to finding if web shows changes
   - Expected: Update finding status to CURRENT

4. **Create new finding**: Review code with pattern NOT in best-practices/
   - Expected: Check directory (not found), web search, CREATE new finding
   - Expected: Update index.md with new entry

5. **Cite findings in review**: Review code with documented best practice
   - Expected: Output includes "Reference: BP-XXX" with link
   - Expected: Output includes "Best Practices Updates Made" if any

6. **Deferred recommendations**: Flag blocked best practice
   - Expected: Document in "Constraint-Blocked" section with BP-ID reference

### Best Practices Researcher Test Cases

1. **New topic**: Research "Python dataclasses 2026"
   - Expected: Full research, save to file, update index

2. **Existing topic (current)**: Research same topic again
   - Expected: Return existing finding, no web search

3. **Existing topic (stale)**: Research 7-month-old topic
   - Expected: Verify via web, append correction if changed

4. **Cross-linking**: Research topic that affects a decision
   - Expected: Auto-link to decisions-log.md

### Verify Implementation Test Cases

1. **Safe execution**: Verify story when no other tests running
   - Expected: Execute pytest, parse output, report results

2. **Conflict detection**: Verify story while Terminal 1 running tests
   - Expected: Skip execution, proceed with code inspection

3. **Constraint validation**: Verify code with 3.11 feature in 3.10 project
   - Expected: Flag as VIOLATION in constraint section

---

## Summary of Changes

| Component | Changes | Priority |
|-----------|---------|----------|
| code-reviewer.md | +Pre-review steps, +WebSearch tools, +Best practices directory check, +Update findings, +Constraint sections | HIGH |
| best-practices-researcher.md | Major rewrite - auto-activation, persistence, dedup | HIGH |
| verify-implementation.md | +Test execution, +Constraint validation | HIGH |
| config.yaml | +best_practices settings section | MEDIUM |
| templates/oversight/knowledge/best-practices/ | New directory + templates | HIGH |
| install.sh | +Directory creation | MEDIUM |
| install-windows.bat | +Directory creation | MEDIUM |
| README.md | Documentation updates | LOW |
| INSTALL-GUIDE.md | +New directory structure | LOW |

### Unified Knowledge Persistence Pattern

Both **Code Reviewer** and **Best Practices Researcher** now contribute to the best-practices directory:

```
┌─────────────────────────────────────────────────────────────────────────┐
│               Unified Best Practices Knowledge Flow                      │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                         │
│  Code Reviewer                      Best Practices Researcher           │
│       │                                    │                            │
│       ▼                                    ▼                            │
│  ┌─────────────────────────────────────────────────────────────┐       │
│  │        CHECK: oversight/knowledge/best-practices/            │       │
│  │        (Both agents check here FIRST before web search)      │       │
│  └─────────────────────────────────────────────────────────────┘       │
│       │                                    │                            │
│       ▼                                    ▼                            │
│  ┌─────────────────────────────────────────────────────────────┐       │
│  │              VERIFY: WebSearch for current standards         │       │
│  │              (Both agents verify against web)                │       │
│  └─────────────────────────────────────────────────────────────┘       │
│       │                                    │                            │
│       ▼                                    ▼                            │
│  ┌─────────────────────────────────────────────────────────────┐       │
│  │        UPDATE: Add/correct findings in best-practices/       │       │
│  │        (Both agents maintain the knowledge base)             │       │
│  └─────────────────────────────────────────────────────────────┘       │
│       │                                    │                            │
│       ▼                                    ▼                            │
│  Uses finding in review              Returns finding to user            │
│                                                                         │
└─────────────────────────────────────────────────────────────────────────┘
```

**Benefits of Unified Pattern:**
1. Knowledge stays current through multiple touchpoints
2. Code reviews automatically improve the knowledge base
3. Reduces redundant web searches across agents
4. Single source of truth for best practices
5. Audit trail shows which agent updated each finding

---

**Document Status**: Ready for implementation
**Estimated Effort**: 2-3 hours for all changes
**Risk Level**: Low - backward compatible, additive changes

---
*Implementation plan created by Parzival oversight session 2026-01-12*
