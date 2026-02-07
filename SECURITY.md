# Security Policy

## Supported Versions

We actively support the following versions of Parzival Oversight Agent with security updates:

| Version | Supported          | End of Support |
| ------- | ------------------ | -------------- |
| 1.x.x   | :white_check_mark: | TBD            |
| < 1.0   | :x:                | 2026-01-27     |

**Note:** We recommend always using the latest stable release for the best security posture.

---

## Reporting a Vulnerability

We take security seriously. If you discover a security vulnerability in Parzival Oversight Agent, please help us address it responsibly.

### DO NOT create a public GitHub issue for security vulnerabilities

### How to Report

**Email:** security@wbsolutions.ca

**Subject Line:** `[SECURITY] Parzival Oversight Agent - [Brief Description]`

**Include in your report:**

1. **Description of the vulnerability**
   - What is the issue?
   - What impact does it have?

2. **Steps to reproduce**
   - Detailed instructions to reproduce the vulnerability
   - Include sample configuration, payloads, or file paths if applicable

3. **Affected versions**
   - Which versions are affected?
   - Have you tested multiple versions?

4. **Suggested fix (optional)**
   - If you have a proposed solution, we'd love to hear it

5. **Your contact information**
   - How can we reach you for clarification?

### What to Expect

1. **Acknowledgment:** We'll acknowledge receipt within **48 hours**

2. **Initial assessment:** We'll provide an initial assessment within **5 business days**, including:
   - Severity classification (Critical, High, Medium, Low)
   - Estimated timeline for fix
   - Whether we need more information

3. **Resolution:**
   - **Critical vulnerabilities:** Patch within 7 days
   - **High severity:** Patch within 14 days
   - **Medium/Low severity:** Patch in next minor release

4. **Credit:** We'll credit you in the security advisory (unless you prefer to remain anonymous)

### Coordinated Disclosure

We believe in coordinated disclosure:

- We'll work with you to understand the issue
- We'll develop and test a fix
- We'll prepare a security advisory
- We'll release the fix and advisory simultaneously
- **We ask that you do not publicly disclose the vulnerability until we've released a fix**

Typical timeline: **90 days** from initial report to public disclosure

---

## Security Considerations

When deploying Parzival Oversight Agent, be aware of these security considerations:

### 1. Agent Constraint Integrity

Parzival operates under strict behavioral constraints defined in `/pov/agents/parzival/CONSTRAINTS.md`. These constraints ensure Parzival remains advisory-only and never executes code or makes autonomous decisions.

**Protect constraint files:**
- Do not modify constraint files without thorough review
- Constraint bypass could allow unintended agent behavior
- Review all PRs that touch `/pov/agents/` carefully

```bash
# Verify constraint files haven't been tampered with
git diff --name-only HEAD~1 | grep -E "pov/agents/.*CONSTRAINTS"
```

### 2. Template File Integrity

Templates in `/pov/templates/` define the structure of oversight documents. Corrupted or malicious templates could produce misleading documentation.

**Best practices:**
- Version-control all template changes
- Review template modifications in PRs
- Verify template placeholders match expected patterns

```bash
# Check for unexpected template changes
git diff --stat -- 'pov/templates/'
```

### 3. Configuration File Security

The configuration file `/pov/config.yaml` controls Parzival's behavior, including paths and settings.

**Best practices:**
- Never store secrets in `config.yaml`
- Use environment variables for sensitive values
- Review configuration changes carefully, especially path modifications
- Ensure `pov-parzival.customize.yaml` does not override security-relevant settings

### 4. Hook Script Permissions

Installation scripts and git hooks require execute permissions. Ensure these are set correctly and reviewed before execution.

**Best practices:**
```bash
# Set appropriate permissions on installation scripts
chmod 755 install.sh
chmod 755 scripts/init-oversight.sh
chmod 755 scripts/update-templates.sh

# Verify git hook permissions
chmod 755 scripts/git-hooks/pre-commit
```

- Always review hook scripts before granting execute permissions
- Do not run installation scripts from untrusted sources
- Check script contents before piping to shell

### 5. Secrets Management

**Never commit:**
- `.env` files
- API keys or tokens
- Personal access tokens
- Credentials of any kind

**The `.gitignore` is configured to exclude:**
```
.env
.env.*
*.secret
```

### 6. Installation Security

When installing Parzival into a target project:

- **Review `install.sh` before running** -- understand what files it copies and where
- **Back up existing files** -- the installer warns before overwriting, but always have backups
- **Verify the source** -- only install from the official repository or trusted forks

```bash
# Verify you're installing from the correct remote
git remote -v
```

---

## Security Features

Parzival Oversight Agent includes these security features:

### Built-in Protections

1. **Advisory-only design:** Parzival cannot execute code, run commands, or modify project files directly
2. **Constraint enforcement:** Hard-coded behavioral limits prevent scope creep
3. **Escalation protocol:** Critical issues are escalated to the human operator, never resolved autonomously
4. **Minimal permissions:** No network access, database connections, or external service calls required
5. **Transparency:** All recommendations include confidence levels so operators can assess reliability

### File Safety

- Installation scripts use safe copy operations (no force-overwrite by default)
- Template updates preserve existing oversight data
- The three-script architecture (`install.sh`, `init-oversight.sh`, `update-templates.sh`) separates concerns to prevent accidental data loss

---

## Known Security Considerations

### Current Limitations

1. **File-based storage:** Oversight documents are stored as plain Markdown files
   - **Mitigation:** Use encrypted filesystems for sensitive projects

2. **No access control:** Any user with file access can read/modify oversight documents
   - **Mitigation:** Use OS-level file permissions and repository access controls

3. **Local-only design:** Designed for single-user, local development workflows
   - **Mitigation:** Do not expose oversight data to untrusted parties

### Future Enhancements

Planned security improvements:

- [ ] Signed template verification (tamper detection)
- [ ] Constraint integrity checksums
- [ ] Audit log for configuration changes

---

## Security Audit History

| Date       | Auditor          | Scope           | Findings   | Status   |
|------------|------------------|-----------------|------------|----------|
| 2026-01-29 | Internal Review  | v1.2.0 Release  | 0 Critical | Resolved |

---

## Contact

**Security Team:** security@wbsolutions.ca
**General Contact:** info@wbsolutions.ca
**Website:** https://wbsolutions.ca

---

## Acknowledgments

We thank the following security researchers for responsibly disclosing vulnerabilities:

_No reported vulnerabilities yet -- you could be the first to help secure Parzival Oversight Agent!_

---

**Last Updated:** 2026-01-29
**Policy Version:** 1.0
