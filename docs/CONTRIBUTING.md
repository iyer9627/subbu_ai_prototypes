# Contributing Guide

Thank you for contributing to this project! This guide outlines our development workflow and processes.

---

## Table of Contents

- [Development Workflow](#development-workflow)
- [Environment Setup](#environment-setup)
- [Creating Issues](#creating-issues)
- [Working on Issues](#working-on-issues)
- [Pull Request Process](#pull-request-process)
- [Code Review](#code-review)
- [Release Process](#release-process)

---

## Development Workflow

We use Linear for project management and follow a GitFlow-inspired branching strategy.

### Environments

| Environment | Branch | Purpose |
|-------------|--------|---------|
| Prototype | feature branches | Early exploration, POCs |
| Develop | `develop` | Integration testing |
| Staging | `staging` | QA and UAT |
| Production | `main` | Live customers |

### Issue Lifecycle

```
Backlog → Triage → Ideate/Prototype → Develop → Code Review → Staging/QA → Production → Done
```

---

## Environment Setup

### Prerequisites

```bash
# Clone the repository
git clone <repository-url>
cd <project-name>

# Install dependencies
npm install  # or: pip install -r requirements.txt

# Copy environment file
cp .env.example .env

# Start development server
npm run dev
```

### Git Configuration

```bash
# Set up commit message template (optional)
git config commit.template .gitmessage
```

---

## Creating Issues

### Where to Create Issues

- **Linear** (preferred): For tracked work with proper workflow
- **GitHub Issues**: For external contributors without Linear access

### Issue Types

1. **Feature Request** - New functionality
2. **Bug Report** - Something broken
3. **Tech Debt** - Code improvements
4. **Documentation** - Docs updates

### Writing Good Issues

- **Title**: Clear, concise description
- **Description**: Problem, proposed solution, acceptance criteria
- **Labels**: Apply appropriate type, environment, and source labels
- **Priority**: Set based on impact and urgency

---

## Working on Issues

### 1. Claim an Issue

- Assign yourself in Linear
- Issue auto-moves to "Ideate/Prototype" or "Develop"

### 2. Create a Branch

```bash
# Feature
git checkout -b feature/LIN-123-add-user-auth

# Bug fix
git checkout -b fix/LIN-456-login-error

# Hotfix (from main)
git checkout main
git checkout -b hotfix/LIN-789-critical-fix
```

**Branch naming**: `{type}/LIN-{id}-{short-description}`

### 3. Make Your Changes

- Write clean, documented code
- Follow existing code style
- Add/update tests as needed
- Keep commits focused and atomic

### 4. Commit Messages

```
[LIN-123] type: short description

Longer description if needed.

- Detail 1
- Detail 2
```

**Types**: `feat`, `fix`, `docs`, `style`, `refactor`, `test`, `chore`

### 5. Push and Create PR

```bash
git push -u origin feature/LIN-123-add-user-auth
```

Then create PR via GitHub.

---

## Pull Request Process

### PR Title Format

```
[LIN-123] type: description
```

### PR Description

Include:
- Summary of changes
- Linear issue link (`Fixes LIN-123`)
- Type of change
- Testing done
- Screenshots (if UI changes)

### PR Checklist

Before submitting:
- [ ] Self-reviewed code
- [ ] Tests pass locally
- [ ] No linting errors
- [ ] Documentation updated (if needed)
- [ ] No hardcoded secrets
- [ ] PR description complete

### Automated Checks

All PRs must pass:
- Lint check
- Unit tests
- Build
- Security scan

---

## Code Review

### For Authors

- Respond to feedback promptly
- Explain decisions when needed
- Request re-review after changes

### For Reviewers

**Review within**:
- P0/P1 bugs: 2 hours
- Standard PRs: 24 hours

**Review for**:
- Correctness
- Code quality
- Test coverage
- Security concerns
- Documentation

**Approval requirements**:
- Bug fixes: 1 approval
- Features: 2 approvals
- Core changes: Tech Lead approval

---

## Release Process

### Standard Release (Every 2 Weeks)

1. **Feature Freeze** (2 days before release)
   - No new features merged to `staging`
   - Only bug fixes allowed

2. **QA Period**
   - Full regression testing
   - Bug fixes as needed

3. **Release Day**
   - Final approval from QA
   - Merge `staging` → `main`
   - Tag release
   - Monitor deployment

### Hotfix Release

For critical production bugs:

1. Branch from `main`
2. Fix with expedited review
3. Merge to `main` + tag
4. Cherry-pick to `develop` and `staging`

---

## Getting Help

- **Slack**: #engineering
- **Linear**: Comment on issues
- **Documentation**: Check /docs folder

---

## Quick Reference

### Commands

```bash
# Run tests
npm test

# Run linter
npm run lint

# Format code
npm run format

# Build
npm run build

# Start dev server
npm run dev
```

### Useful Links

- [Linear Board](https://linear.app/your-team)
- [CI/CD Dashboard](https://github.com/your-org/your-repo/actions)
- [Documentation](./README.md)
