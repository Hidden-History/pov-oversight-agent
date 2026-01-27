# Parzival Agent Constraints

**Version**: 1.1
**Last Updated**: 2026-01-27
**Purpose**: Persistent constraints to prevent agent drift and ensure consistent behavior across sessions

---

## Critical Constraints (MUST Follow)

### C1: Mandatory Bug Tracking Protocol
**Severity**: CRITICAL
**Applies To**: All bug/error encounters
**Tech Debt**: TECH-DEBT-030

Every bug or error MUST:
1. Get assigned a BUG-XXX ID immediately upon identification
2. Be documented using `oversight/bugs/BUG_TEMPLATE.md`
3. Include root cause analysis using `oversight/bugs/ROOT_CAUSE_TEMPLATE.md`
4. Have verification steps before marking resolved
5. Link to related issues if any exist

**Rationale**: Prevents piecemeal fixes and repeat issues (lesson from BUG-003).

**Examples**:
- Hook script error → Create BUG-XXX before recommending fix
- Feature not working → Create BUG-XXX with reproduction steps
- Performance issue → Create BUG-XXX with evidence (metrics, logs)

---

### C2: Similar Issue Detection
**Severity**: HIGH
**Applies To**: Before creating any new bug report
**Tech Debt**: TECH-DEBT-033

Before creating a new bug, MUST:
1. Search `oversight/bugs/` for existing reports on same file/component
2. Check for same error type or symptom pattern
3. Review past fixes that might apply
4. Link to related bugs if found (prevents solving same problem differently)

**Rationale**: Enables pattern detection and prevents duplicate effort.

**Search Criteria**:
- Same file path affected
- Same error message or exception type
- Same symptom (e.g., "zero points", "missing data")
- Same component (e.g., "hooks", "memory storage")

---

### C3: Fix Verification Protocol
**Severity**: CRITICAL
**Applies To**: All bug fixes
**Tech Debt**: TECH-DEBT-031

Every fix MUST follow verification protocol from PROCEDURES.md:
1. **Pre-fix**: Reproduce the issue, document expected behavior
2. **Post-fix**: Verify fix resolves issue without regressions
3. **Sign-off**: Explicit verification before marking bug as closed

**Rationale**: Prevents introducing new bugs while fixing others.

**Verification Requirements**:
- Pre-fix: Can reproduce issue consistently
- Post-fix: Issue no longer occurs
- Regression: Existing functionality still works
- Evidence: Logs/tests show successful fix

---

### C4: Complex Bug Unified Spec Requirement
**Severity**: HIGH
**Applies To**: Bugs with >2 sub-issues or affecting >2 files
**Tech Debt**: TECH-DEBT-034

For complex bugs (>2 sub-issues OR >2 files OR previous fix failed):
1. MUST create unified fix spec using `oversight/specs/FIX_SPEC_TEMPLATE.md`
2. NEVER allow piecemeal fixes to complex bugs
3. MUST follow fix order specified in unified spec
4. MUST get user approval if deviating from spec

**Rationale**: Prevents the BUG-003 pattern of 6 separate fixes introducing new issues.

**Complex Bug Indicators**:
- Multiple symptoms (e.g., wrong field + truncation + timing)
- Multiple files need changes
- Previous fix attempt failed
- Architectural understanding required

---

## Operational Constraints

### C5: Template Usage
**Severity**: MEDIUM
**Applies To**: All oversight documentation

All oversight documents MUST use appropriate templates from:
- `oversight/bugs/` - BUG_TEMPLATE.md, ROOT_CAUSE_TEMPLATE.md
- `oversight/specs/` - FIX_SPEC_TEMPLATE.md for complex bugs
- `oversight/decisions/` - DECISION_TEMPLATE.md for architectural choices
- `oversight/plans/` - PLAN_TEMPLATE.md for major initiatives
- `oversight/audits/` - AUDIT_TEMPLATE.md for system audits
- `oversight/validation/` - VALIDATION_TEMPLATE.md for verification reports

**Rationale**: Consistent structure enables pattern recognition and searchability.

---

### C6: Sharding Compliance
**Severity**: MEDIUM
**Applies To**: When oversight documents exceed thresholds

When oversight documents exceed thresholds (per `docs/SHARDING_STRATEGY.md`):
- **Threshold**: >500 lines OR >50 items
- **Action**: Apply sharding strategy
- **Methods**: Status-based, date-based, or component-based sharding
- **Requirement**: Maintain index files for sharded directories

**Rationale**: Prevents performance degradation and maintains navigability.

---

### C7: Observability Requirements
**Severity**: HIGH
**Applies To**: All new scripts, services, and features

Every new script/service/feature MUST include observability from the start:

1. **Structured Logging**:
   - Use `extra={}` dict pattern, not f-strings in log messages
   - Include context: `session_id`, `memory_id`, `operation`, `duration_ms`
   - Follow severity levels: DEBUG (traces), INFO (operations), WARNING (recoverable), ERROR (failures)
   - Reference: `docs/structured-logging.md`

2. **Prometheus Metrics**:
   - Counter: Track operations (success/failure counts)
   - Histogram: Track latencies (storage, search, embedding)
   - Gauge: Track current state (queue size, connection status)
   - Push via Pushgateway for short-lived scripts
   - Reference: `docs/prometheus-queries.md`

3. **Grafana Dashboard Updates**:
   - New metrics MUST be added to relevant dashboard panel
   - Dashboard location: `monitoring/grafana/dashboards/`
   - Update `Memory Overview` dashboard for memory operations
   - Include alerting thresholds where appropriate

**Rationale**: Observability enables proactive issue detection and rapid debugging. Adding metrics after-the-fact is expensive and often incomplete.

**Examples**:
- New hook script → Add latency histogram + success/failure counters + dashboard panel
- New API endpoint → Add request latency + error rate + Grafana row
- Background processor → Add queue depth gauge + processing rate + alerting

**Checklist**:
- [ ] Structured logging with `extra={}` pattern
- [ ] Prometheus metrics (counter/histogram/gauge as appropriate)
- [ ] Pushgateway integration for scripts
- [ ] Dashboard panel or row added
- [ ] Alert threshold defined (if applicable)

---

## Constraint Enforcement

### How These Constraints Are Loaded
1. Parzival activation step 3 loads this file automatically
2. Constraints apply to ALL sessions (persistent across compactions)
3. Violations should be flagged immediately

### When to Update Constraints
- New patterns identified from bugs/failures
- Process improvements validated
- New TECH-DEBT items requiring enforcement
- User explicitly requests constraint modification

---

**Note**: These constraints are derived from lessons learned during Memory System V2 development, particularly BUG-003 (Agent Response Capture Failure) which required 6 separate fixes and introduced new bugs due to lack of systematic approach.
