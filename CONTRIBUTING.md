# Contributing to Parzival Oversight Agent

Thank you for your interest in contributing! This guide will help you get started.

## Prerequisites

- Git
- Claude Code (latest version)
- Bash shell (Linux/macOS/WSL)

## Getting Started

1. **Fork** the repository on GitHub
2. **Clone** your fork:
   ```bash
   git clone https://github.com/YOUR-USERNAME/pov-oversight-agent.git
   cd pov-oversight-agent
   ```
3. **Set upstream**:
   ```bash
   git remote add upstream https://github.com/Hidden-History/pov-oversight-agent.git
   ```
4. **Activate git hooks**:
   ```bash
   git config core.hooksPath scripts/git-hooks
   ```

## Development Setup

1. Run the installer to see how the agent deploys:
   ```bash
   ./install.sh /path/to/test-project
   ```
2. Verify templates are copied correctly
3. Test Claude Code commands load properly

## What You Can Contribute

### Templates
- New oversight templates in `pov/templates/`
- Improvements to existing templates
- New verification checklists

### Agent Configuration
- New procedures in `pov/procedures/`
- Claude Code command improvements in `.claude/commands/`
- Agent behavior refinements

### Installation
- Installation script improvements (`install.sh`, `install-windows.bat`)
- Cross-platform compatibility fixes

### Documentation
- README, INSTALL-GUIDE, or CHANGELOG improvements
- New examples or tutorials

## Development Workflow

1. **Create a branch** from `main`:
   ```bash
   git checkout -b feature/your-description
   # or: git checkout -b fix/issue-XXX-description
   ```

2. **Make your changes** following the conventions below

3. **Test locally**:
   - Verify YAML files: `yamllint pov/config.yaml`
   - Verify shell scripts: `shellcheck install.sh scripts/*.sh`
   - Test installation on a fresh directory

4. **Commit** using conventional commits:
   ```
   feat(templates): add new audit template
   fix(install): handle spaces in directory paths
   docs(readme): update installation instructions
   ```

5. **Push** and create a Pull Request

## Commit Message Format

```
<type>(<scope>): <description>

[optional body]

[optional footer: Fixes #XXX]
```

**Types:** `feat`, `fix`, `docs`, `refactor`, `test`, `chore`

**Scopes:** `agents`, `commands`, `constraints`, `templates`, `procedures`, `install`, `ci`, `docs`

## Code Standards

### YAML
- Use 2-space indentation
- Quote strings that could be misinterpreted
- Pass `yamllint` with relaxed rules

### Markdown
- Use ATX-style headers (`#`)
- One blank line between sections
- No trailing whitespace

### Shell Scripts
- Use `#!/usr/bin/env bash`
- Include `set -euo pipefail`
- Pass `shellcheck --severity=warning`
- Quote all variables

### Agent Constraints
- **Never** modify `CONSTRAINTS.md` without explicit approval
- Parzival must remain advisory-only
- All recommendations must include confidence levels

## Pull Request Process

1. Fill out the PR template completely
2. Ensure all CI checks pass
3. Update `CHANGELOG.md` if applicable
4. Wait for maintainer review
5. Address any feedback

## Questions?

- Open a [Discussion](https://github.com/Hidden-History/pov-oversight-agent/discussions)
- Check existing [Issues](https://github.com/Hidden-History/pov-oversight-agent/issues)

## License

By contributing, you agree that your contributions will be licensed under the MIT License.
