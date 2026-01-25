# Release Management

## Overview

This document defines the release management process, versioning strategy, and deployment workflow across all environments.

---

## Versioning Strategy

### Semantic Versioning (SemVer)

```
MAJOR.MINOR.PATCH[-PRERELEASE][+BUILD]

Examples:
  1.0.0         - First stable release
  1.1.0         - New feature added
  1.1.1         - Bug fix
  2.0.0         - Breaking change
  1.2.0-beta.1  - Beta release
  1.2.0-rc.1    - Release candidate
```

### Version Increment Rules

| Change Type | Version Bump | Example |
|-------------|--------------|---------|
| Breaking API change | MAJOR | 1.x.x → 2.0.0 |
| New feature (backward compatible) | MINOR | 1.1.x → 1.2.0 |
| Bug fix | PATCH | 1.1.1 → 1.1.2 |
| Hotfix to production | PATCH | 1.1.1 → 1.1.2 |

---

## Environment Promotion Flow

```
┌─────────────┐    ┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│  PROTOTYPE  │───▶│   DEVELOP   │───▶│   STAGING   │───▶│ PRODUCTION  │
│             │    │             │    │             │    │             │
│ Feature     │    │ Integration │    │ QA/UAT      │    │ Live        │
│ branches    │    │ testing     │    │ testing     │    │ customers   │
│             │    │             │    │             │    │             │
│ v0.x.x-dev  │    │ v0.x.x-dev  │    │ v1.x.x-rc   │    │ v1.x.x      │
└─────────────┘    └─────────────┘    └─────────────┘    └─────────────┘
      │                  │                  │                  │
      └──────────────────┴──────────────────┴──────────────────┘
                    Code flows left to right
                    Hotfixes can go directly to any environment
```

---

## Branch Strategy

### Branch Types

| Branch | Purpose | Naming | Merges To |
|--------|---------|--------|-----------|
| `main` | Production-ready code | - | - |
| `staging` | QA/UAT environment | - | `main` |
| `dev` | Integration branch | - | `staging` |
| `feature/*` | New features | `feature/LIN-XXX-description` | `dev` |
| `fix/*` | Bug fixes | `fix/LIN-XXX-description` | `dev` |
| `hotfix/*` | Production fixes | `hotfix/LIN-XXX-description` | `main` + `dev` |
| `release/*` | Release preparation | `release/v1.2.0` | `main` + `dev` |

### Branch Flow Diagram

```
main ─────────●─────────────●─────────────●─────────── (v1.0) ───●──── (v1.1)
              │             ▲             ▲                      ▲
              │             │             │                      │
staging ──────┼─────────────●─────────────●──────────────────────●────
              │             ▲             ▲                      ▲
              │             │             │                      │
dev ──────┼──●──●──●────●──●──●──●────●──●──●──●──●──●──●────●────
              │  ▲  ▲  ▲       ▲  ▲  ▲       ▲  ▲  ▲  ▲  ▲  ▲
              │  │  │  │       │  │  │       │  │  │  │  │  │
feature/* ────┴──┴──┴──┴───────┴──┴──┴───────┴──┴──┴──┴──┴──┴────────
```

---

## Release Types

### 1. Standard Release

Scheduled releases with new features and improvements.

**Cadence**: Every 2 weeks (end of sprint)

**Process**:
```
1. Create release branch from dev
   └─▶ git checkout -b release/v1.2.0 dev

2. Version bump & changelog
   └─▶ Update version in package.json/pyproject.toml
   └─▶ Update CHANGELOG.md

3. Deploy to Staging
   └─▶ CI/CD auto-deploys release/* to staging

4. QA Testing (2-3 days)
   └─▶ Run test suites
   └─▶ Manual testing
   └─▶ UAT with stakeholders

5. Fix any issues on release branch
   └─▶ Cherry-pick critical fixes only

6. Merge to main
   └─▶ Create PR: release/v1.2.0 → main
   └─▶ Tag: v1.2.0

7. Deploy to Production
   └─▶ Triggered by tag

8. Merge back to dev
   └─▶ Ensure dev has release fixes
```

### 2. Hotfix Release

Emergency fixes for production issues.

**Trigger**: P0/P1 production bugs

**Process**:
```
1. Create hotfix branch from main
   └─▶ git checkout -b hotfix/LIN-XXX-description main

2. Implement fix + tests

3. Fast-track code review
   └─▶ Minimum 1 reviewer
   └─▶ Tech Lead approval for P0

4. Merge to main + tag
   └─▶ Version bump (patch)
   └─▶ Tag: v1.1.1

5. Deploy to Production immediately

6. Cherry-pick to dev and staging
   └─▶ Ensure fix is in all branches
```

### 3. Rollback

When a release causes critical issues.

**Process**:
```
1. Identify rollback target
   └─▶ Previous stable version

2. Deploy previous version
   └─▶ Use existing artifact/image

3. Create incident issue in Linear
   └─▶ Type: type:incident
   └─▶ Priority: P0

4. Communicate
   └─▶ #incidents channel
   └─▶ Status page update (if customer-facing)

5. Post-mortem required
```

---

## Linear Release Project Setup

### Creating a Release Project

For each release, create a Linear Project:

```markdown
**Project Name**: Release v1.2.0
**Target Date**: [Release date]
**Lead**: @[release-manager]

**Milestones**:
1. Feature Complete - [Date]
2. Code Freeze - [Date]
3. QA Complete - [Date]
4. Release - [Date]

**Included Issues**:
[Link all issues targeted for this release]
```

### Release Labels

| Label | Purpose |
|-------|---------|
| `release:v1.2.0` | Issues targeted for v1.2.0 |
| `release:next` | Issues for the next release |
| `release:blocked` | Blocking the release |
| `release:nice-to-have` | Can be cut if needed |

### Release Checklist Issue

Create for each release:

```markdown
# Release v1.2.0 Checklist

## Pre-Release
- [ ] All targeted issues are Done
- [ ] No P0/P1 bugs open for this release
- [ ] Version bumped in all config files
- [ ] CHANGELOG.md updated
- [ ] Release notes drafted
- [ ] Staging deployment successful
- [ ] All automated tests passing
- [ ] QA sign-off obtained
- [ ] Performance benchmarks acceptable
- [ ] Security scan clean
- [ ] Documentation updated

## Release Day
- [ ] Create release branch/tag
- [ ] Production deployment initiated
- [ ] Smoke tests passing
- [ ] Monitoring dashboards checked
- [ ] No error spike in logs

## Post-Release
- [ ] Release notes published
- [ ] Customers notified (if applicable)
- [ ] Internal announcement (#releases)
- [ ] Merge release branch back to dev
- [ ] Delete release branch
- [ ] Update Linear project status to Completed
- [ ] Schedule retrospective if needed
```

---

## PR Management

### PR Workflow with Linear

```
Developer creates branch
         │
         ▼
┌──────────────────┐
│ Work on feature  │
│ (Linear: Develop)│
└────────┬─────────┘
         │
         ▼
┌──────────────────┐
│ Open PR with:    │
│ "Fixes LIN-XXX"  │
│ or "Part of      │
│ LIN-XXX"         │
└────────┬─────────┘
         │
         ▼
┌──────────────────┐
│ Linear auto-     │
│ moves to:        │
│ Code Review      │
└────────┬─────────┘
         │
         ▼
┌──────────────────┐
│ PR reviewed &    │
│ approved         │
└────────┬─────────┘
         │
         ▼
┌──────────────────┐
│ PR merged        │
│ Linear auto-     │
│ moves to:        │
│ Staging/QA       │
└──────────────────┘
```

### PR Title Convention

```
[LIN-XXX] type: description

Types:
  feat:     New feature
  fix:      Bug fix
  docs:     Documentation
  style:    Formatting, no code change
  refactor: Code restructuring
  test:     Adding tests
  chore:    Maintenance tasks

Examples:
  [LIN-123] feat: add user authentication
  [LIN-456] fix: resolve memory leak in cache
  [LIN-789] docs: update API documentation
```

### PR Description Template

```markdown
## Summary
[Brief description of changes]

## Linear Issue
Fixes LIN-XXX

## Type of Change
- [ ] Feature
- [ ] Bug fix
- [ ] Refactor
- [ ] Documentation
- [ ] Other: ___

## Changes Made
- Change 1
- Change 2

## Testing
- [ ] Unit tests added/updated
- [ ] Integration tests added/updated
- [ ] Manual testing completed

## Screenshots (if applicable)
[Add screenshots]

## Checklist
- [ ] Code follows project style guidelines
- [ ] Self-review completed
- [ ] Comments added for complex logic
- [ ] Documentation updated
- [ ] No console.log/print statements
- [ ] No hardcoded secrets
```

---

## Deployment Gates

### Develop → Staging

| Gate | Requirement |
|------|-------------|
| Tests | All unit tests pass |
| Linting | No linting errors |
| Build | Successful build |
| Coverage | ≥ 80% code coverage |

### Staging → Production

| Gate | Requirement |
|------|-------------|
| QA Sign-off | QA team approval |
| Staging Tests | All E2E tests pass |
| Performance | No regression vs baseline |
| Security | No high/critical vulnerabilities |
| Stakeholder | Product owner approval |

---

## Release Communication

### Internal Communication

```markdown
## Release Announcement - v1.2.0

**Release Date**: [Date]
**Release Manager**: @[name]

### What's New
- Feature 1 (LIN-XXX)
- Feature 2 (LIN-XXX)

### Bug Fixes
- Fix 1 (LIN-XXX)
- Fix 2 (LIN-XXX)

### Known Issues
- Issue 1 (LIN-XXX) - Workaround: ...

### Rollback Plan
In case of critical issues, rollback to v1.1.x

### Questions?
Reach out in #releases
```

### External Communication (Changelog)

```markdown
# Changelog

## [1.2.0] - 2026-01-25

### Added
- New feature description (#123)

### Changed
- Updated behavior description (#124)

### Fixed
- Bug fix description (#125)

### Security
- Security fix description (#126)
```

---

## Metrics

### Release Metrics

| Metric | Target | Description |
|--------|--------|-------------|
| Release Frequency | 2 weeks | Time between releases |
| Lead Time | < 1 week | Commit to production |
| Deploy Frequency | Daily | Deploys to staging |
| Change Failure Rate | < 5% | Releases causing incidents |
| MTTR | < 1 hour | Time to recover from failure |

### Release Health Dashboard

Track in Linear:
- Issues completed per release
- Bug escape rate per release
- Rollback frequency
- Hotfix frequency
