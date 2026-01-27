# Parzival Procedures

This document defines standard operating procedures for Parzival oversight operations.

---

## Bug Tracking Procedures

### Creating Bug Reports

1. **Check for existing bugs** first using oversight/bugs/ directory
2. **Assign sequential BUG-ID** (e.g., BUG-001, BUG-002)
3. **Use BUG_TEMPLATE.md** from oversight/bugs/
4. **Link related issues** (other bugs, decisions, tasks)
5. **Document thoroughly** - include reproduction steps and evidence

### Bug Status Workflow

```
New → In Progress → Fixed → Verified → Closed
                      ↓
                  Reopened (if verification fails)
```

---

## Fix Verification Protocol

**CRITICAL**: Every bug fix MUST follow this verification protocol before being marked complete.

### Pre-Fix Verification

Before implementing any fix:

1. **Reproduce the Issue**
   - [ ] Follow reproduction steps from bug report
   - [ ] Confirm issue exists in target environment
   - [ ] Document actual behavior vs. expected behavior
   - [ ] Capture evidence (logs, screenshots, error messages)

2. **Confirm Root Cause**
   - [ ] Verify root cause analysis is accurate
   - [ ] Identify all affected components
   - [ ] Review related code/configuration
   - [ ] Document any additional findings

3. **Validate Fix Approach**
   - [ ] Review proposed solution
   - [ ] Assess impact on other systems
   - [ ] Identify potential side effects
   - [ ] Confirm rollback strategy exists

**STOP**: Do not proceed to implementation until all pre-fix verification is complete.

---

### Post-Fix Verification

After implementing a fix:

1. **Functional Verification**
   - [ ] Apply the fix in test environment
   - [ ] Reproduce original issue - verify it no longer occurs
   - [ ] Test edge cases and boundary conditions
   - [ ] Verify error handling works correctly

2. **Regression Testing**
   - [ ] Run all relevant test suites
   - [ ] Verify existing functionality still works
   - [ ] Test integration points with other systems
   - [ ] Check for performance impact

3. **Code Review**
   - [ ] Review code changes for quality
   - [ ] Verify adherence to coding standards
   - [ ] Check for proper error handling
   - [ ] Confirm documentation is updated

4. **Deployment Verification**
   - [ ] Verify fix in staging environment
   - [ ] Run smoke tests post-deployment
   - [ ] Monitor logs for errors
   - [ ] Check metrics/dashboards

5. **User Acceptance**
   - [ ] Notify original reporter
   - [ ] Request verification from stakeholders
   - [ ] Document sign-off

**SIGN-OFF REQUIREMENT**: A fix is NOT complete until:
- All verification steps are checked
- No new issues introduced
- Original reporter (or stakeholder) confirms resolution
- Documentation is updated

Only AFTER all post-fix verification is complete can the bug status be changed to "Verified".

---

## Decision Tracking Procedures

### Creating Decision Logs

1. **Assign sequential DEC-ID** (e.g., DEC-001, DEC-002)
2. **Use DECISION_TEMPLATE.md** from oversight/decisions/
3. **Document context thoroughly** - why the decision was needed
4. **List all options considered** with pros/cons
5. **State the decision clearly** - no ambiguity
6. **Document rationale** - explain WHY this choice was made
7. **Identify implications** - what changes as a result
8. **Define success criteria** - how to validate the decision

### Decision Status Workflow

```
Proposed → Under Review → Accepted → Implemented
             ↓               ↓
          Rejected      Superseded (by newer decision)
```

---

## Specification Procedures

### Creating Technical Specs

1. **Assign sequential SPEC-ID** (e.g., SPEC-001, SPEC-002)
2. **Use SPEC_TEMPLATE.md** from oversight/specs/
3. **Reference related work** (bugs, decisions, tasks)
4. **Define clear requirements** - functional and non-functional
5. **Document architecture** - components, data flow, interfaces
6. **List all files affected** - create, modify, delete
7. **Define testing strategy** - unit, integration, manual
8. **Plan deployment** - steps, rollback, monitoring

### Spec Review Checklist

Before approving a spec:

- [ ] Requirements are clear and testable
- [ ] Architecture is sound and scalable
- [ ] All dependencies identified
- [ ] Testing strategy is comprehensive
- [ ] Deployment plan is detailed
- [ ] Rollback plan exists
- [ ] Security considerations addressed
- [ ] Performance impact assessed

---

## Audit Procedures

### Conducting Audits

1. **Define audit scope** clearly
2. **Use AUDIT_TEMPLATE.md** from oversight/audits/
3. **Document methodology** - approach, tools, standards
4. **Categorize findings** by severity (Critical/High/Med/Low/Info)
5. **Provide evidence** for each finding
6. **Make specific recommendations** - actionable steps
7. **Create remediation plan** with owners and dates
8. **Schedule follow-up** audit

### Audit Finding Severity Levels

- **Critical**: Immediate action required, blocks progress
- **High**: Important issue, should be addressed soon
- **Medium**: Moderate issue, schedule for resolution
- **Low**: Minor issue, address when convenient
- **Informational**: Observation, no action required

---

## Validation Procedures

### Validating Deliverables

1. **Use VALIDATION_TEMPLATE.md** from oversight/validation/
2. **Define acceptance criteria** clearly
3. **Execute test cases** systematically
4. **Document all results** - expected vs. actual
5. **Capture evidence** - logs, screenshots, metrics
6. **Make decision** - Pass/Fail/Pass with Concerns
7. **Require sign-off** from stakeholders

### Validation Decision Criteria

**Pass**: All acceptance criteria met, no blocking issues
**Pass with Concerns**: AC met but minor issues noted
**Fail**: One or more acceptance criteria not met

Only "Pass" or "Pass with Concerns" allow progression to next phase.

---

## Session Management Procedures

### Starting a Session

1. **Load SESSION_WORK_INDEX.md** for quick context
2. **Review active tasks** from task-tracker.md
3. **Check open blockers** from blockers-log.md
4. **Review recent decisions** from decisions/
5. **Note any risks** from risk-register.md

### During a Session

1. **Update task status** as work progresses
2. **Document decisions** as they're made
3. **Log new blockers** immediately when discovered
4. **Capture insights** and learnings
5. **Track time spent** on major activities

### Ending a Session

1. **Create session snapshot** using SESSION_SNAPSHOT_TEMPLATE.md
2. **Update all tracking documents** (tasks, blockers, risks)
3. **Document context for next session** - what to pick up
4. **List open questions** that need resolution
5. **Save handoff notes** for continuity

---

## Planning Procedures

### Creating Project Plans

1. **Use PLAN_TEMPLATE.md** from oversight/plans/
2. **Define clear objectives** and success criteria
3. **Break down work** into phases and tasks
4. **Estimate effort** realistically (use complexity, not time)
5. **Identify dependencies** internal and external
6. **Assess risks** and create mitigation strategies
7. **Define communication plan** for stakeholders
8. **Establish monitoring** metrics and checkpoints

### Plan Review Cycle

Plans should be reviewed:
- **Daily**: During active development
- **Weekly**: During planning/research phases
- **After blockers**: When significant issues arise
- **After scope changes**: When requirements shift

---

## Document Sharding Procedures

See `docs/SHARDING_STRATEGY.md` for comprehensive guidance on when and how to shard oversight documents.

### When to Shard

Shard a document when:
- **Line count** exceeds 500 lines
- **Item count** exceeds 50 items (bugs, tasks, decisions, etc.)
- **Performance** degradation when loading/editing
- **Logical boundaries** exist (by status, date, component)

### How to Shard

1. **Choose sharding strategy** (status-based, date-based, component-based)
2. **Create subdirectories** with clear naming
3. **Split content** logically - don't break mid-item
4. **Create index file** in parent directory
5. **Update references** in other documents
6. **Archive old shards** when no longer active

---

## Quality Gates

### Before Starting Implementation

- [ ] Requirements documented and approved
- [ ] Architecture reviewed and validated
- [ ] Dependencies identified and confirmed
- [ ] Risks assessed and mitigated
- [ ] Test strategy defined

### Before Deploying to Production

- [ ] All tests passing (unit, integration, E2E)
- [ ] Code review complete
- [ ] Performance validated
- [ ] Security review complete
- [ ] Documentation updated
- [ ] Rollback plan tested
- [ ] Stakeholder sign-off obtained

### Before Closing a Bug

- [ ] Pre-fix verification complete
- [ ] Fix implemented and reviewed
- [ ] Post-fix verification complete
- [ ] No regressions introduced
- [ ] Original reporter confirms resolution
- [ ] Prevention measures documented

---

## Confidence Levels

All recommendations and findings should include a confidence level:

| Level | Definition | When to Use |
|-------|------------|-------------|
| **Verified** | Directly confirmed from source | After reading/testing |
| **Informed** | Based on reliable information | From documentation/specs |
| **Inferred** | Logical deduction from patterns | Pattern recognition |
| **Uncertain** | Limited information available | Gaps in understanding |
| **Unknown** | No basis for assessment | Needs investigation |

**ALWAYS state confidence level** when making recommendations.

---

## Emergency Procedures

### Critical Bug Discovered

1. **Immediately document** in bugs/ with Critical severity
2. **Notify stakeholders** - don't wait for session end
3. **Create blocker** if it blocks other work
4. **Assess blast radius** - what's affected
5. **Recommend immediate action** or workaround

### Blocker Encountered

1. **Document in blockers-log.md** immediately
2. **Link to affected tasks** in task-tracker.md
3. **Identify owner** who can resolve
4. **Propose workarounds** if possible
5. **Escalate if critical** and no owner identified

### Scope Creep Detected

1. **Stop and document** the scope change
2. **Assess impact** on timeline/resources
3. **Present options** to user with recommendations
4. **Get explicit approval** before proceeding
5. **Update planning docs** if approved

---

## Continuous Improvement

### Learning Capture

After significant work or discoveries:
- Document in oversight/learning/
- Update procedures if process improvements identified
- Share insights with team
- Update templates if gaps found

### Retrospectives

Conduct retrospectives:
- After completing epics
- After resolving major incidents
- When significant learnings emerge
- At regular intervals (monthly/quarterly)

Capture:
- What worked well
- What didn't work
- What should change
- Action items for improvement

---

## Document Maintenance

### Review Cycle

- **Weekly**: Active tracking documents (tasks, blockers)
- **Monthly**: Procedure documents, templates
- **Quarterly**: Strategic documents (architecture, standards)

### Archival Policy

Archive documents when:
- Work is complete and verified
- Document is superseded by newer version
- Content is no longer relevant
- Document is historical reference only

Archived documents should:
- Be moved to archive/ subdirectory
- Retain all content (don't delete)
- Include archive date in filename
- Be referenced in index files

---

## Notes

This procedures document is a living document. Update it when:
- New procedures are established
- Existing procedures are improved
- Gaps or issues are discovered
- Templates or workflows change

All updates should be reviewed and approved before implementation.
