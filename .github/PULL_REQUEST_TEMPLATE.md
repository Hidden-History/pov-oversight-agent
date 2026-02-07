## Description
<!-- Provide a clear and concise description of what this PR does -->



## Related Issue
<!-- Link to the related issue(s). Use "Fixes #XXX" to auto-close issues when PR merges -->

Fixes #

## Type of Change
<!-- Check all that apply -->

- [ ] Bug fix (non-breaking change which fixes an issue)
- [ ] New feature (non-breaking change which adds functionality)
- [ ] Breaking change (fix or feature that would cause existing functionality to not work as expected)
- [ ] New template or procedure
- [ ] Agent configuration change
- [ ] Documentation update
- [ ] Refactoring (no functional changes)
- [ ] CI/CD or workflow change
- [ ] Dependency update

## Changes Made
<!-- List the key changes in this PR -->

-
-
-

## Testing
<!-- Describe the tests you ran to verify your changes -->

### Test Environment
- **OS:**
- **Shell:**
- **Claude Code Version:**

### Test Checklist
- [ ] `install.sh` runs without errors on a clean directory
- [ ] `install-windows.bat` runs without errors (if applicable)
- [ ] `scripts/init-oversight.sh` creates expected directory structure
- [ ] `scripts/update-templates.sh` updates without data loss
- [ ] All templates exist and contain valid content
- [ ] All YAML files pass syntax validation (`yamllint` or equivalent)
- [ ] All shell scripts pass `shellcheck` (if applicable)
- [ ] All Markdown files render correctly
- [ ] Claude Code commands load and execute properly
- [ ] Tested on clean installation (fresh clone + install)

### Test Cases Covered
<!-- Describe specific test scenarios you verified -->

1.
2.
3.

## Template Validation
<!-- If templates were modified -->

- [ ] Template placeholders are consistent (e.g., `{project-root}`, `{date}`)
- [ ] Template structure matches documented format
- [ ] No broken Markdown links within templates
- [ ] Templates render correctly when initialized by `init-oversight.sh`

## Agent Constraint Compliance
<!-- Verify changes respect Parzival's core constraints -->

- [ ] Parzival remains advisory-only (no execution capabilities added)
- [ ] Constraint definitions in `/pov/agents/parzival/CONSTRAINTS.md` are intact
- [ ] No changes bypass existing quality gates
- [ ] Escalation protocol is preserved
- [ ] Confidence levels are used correctly in any new recommendations

## Documentation
- [ ] README.md updated (if public-facing changes)
- [ ] INSTALL-GUIDE.md updated (if installation changes)
- [ ] CHANGELOG.md updated
- [ ] Inline comments added where needed
- [ ] Command help text is accurate

## Breaking Changes
<!-- If this is a breaking change, describe the impact and migration path -->

- [ ] This PR introduces breaking changes

**Impact:**
<!-- What will break? -->


**Migration Guide:**
<!-- How should users update their setup? -->


## Security Considerations
- [ ] No sensitive data (API keys, credentials, etc.) is exposed
- [ ] No new file permission escalations in scripts
- [ ] `.env` files remain in `.gitignore`
- [ ] Agent constraints cannot be bypassed by new changes
- [ ] Hook scripts maintain appropriate permissions

## Screenshots / Logs (if applicable)
<!-- Add screenshots or log output showing the changes in action -->



## Checklist
<!-- Final review before submitting -->

- [ ] My changes follow the project's conventions (Markdown, YAML, Bash)
- [ ] I have performed a self-review of my changes
- [ ] My changes generate no new warnings or errors
- [ ] I have tested the installation flow end-to-end
- [ ] I have updated the documentation accordingly
- [ ] Commit messages follow conventional commit format

## Additional Context
<!-- Add any other context about the PR here -->


---

**For Maintainers:**
- [ ] Code review completed
- [ ] Template validation verified
- [ ] Installation tested on clean environment
- [ ] Ready to merge
