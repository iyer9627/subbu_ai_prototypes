# Branching Strategy

## Overview

This project uses a modified GitFlow strategy optimized for continuous delivery across four environments.

---

## Branch Types

```
main (production)
  │
  └── staging (QA/UAT)
        │
        └── develop (integration)
              │
              └── ideate (prototype/POC)
                    │
                    ├── prototype/* (experimental features)
                    ├── feature/* (new features)
                    ├── fix/* (bug fixes)
                    └── chore/* (maintenance)

hotfix/* branches from main for emergency fixes
release/* branches for release preparation
```

---

## Branch Descriptions

### Protected Branches

| Branch | Environment | Deploy | Protection |
|--------|-------------|--------|------------|
| `main` | Production | Auto on merge | Requires PR, 2 approvals, passing CI |
| `staging` | Staging | Auto on merge | Requires PR, 1 approval, passing CI |
| `develop` | Development | Auto on merge | Requires PR, passing CI |
| `ideate` | Prototype | Auto on merge | Requires PR, passing CI (relaxed) |

### Working Branches

| Pattern | Purpose | Base | Target |
|---------|---------|------|--------|
| `prototype/LIN-*` | Experimental POCs | `ideate` | `ideate` |
| `feature/LIN-*` | New features | `ideate` or `develop` | `ideate` or `develop` |
| `fix/LIN-*` | Bug fixes | `develop` | `develop` |
| `hotfix/LIN-*` | Production fixes | `main` | `main` + `develop` |
| `release/v*` | Release prep | `develop` | `main` + `develop` |
| `chore/LIN-*` | Maintenance | `develop` | `develop` |
| `docs/LIN-*` | Documentation | `develop` | `develop` |

---

## Workflows

### Prototype Development (Ideation Phase)

```bash
# 1. Start from latest ideate branch
git checkout ideate
git pull origin ideate

# 2. Create prototype branch
git checkout -b prototype/LIN-100-ai-recommendation-poc

# 3. Work on prototype (commit often, experimentation encouraged)
git add .
git commit -m "[LIN-100] prototype: initial recommendation engine POC"

# 4. Keep up to date with ideate
git fetch origin ideate
git rebase origin/ideate

# 5. Push and create PR to ideate
git push -u origin prototype/LIN-100-ai-recommendation-poc
# Create PR: prototype/LIN-100 → ideate

# 6. After validation, promote to develop
# Create PR: ideate → develop (for validated prototypes)
```

### Feature Development

```bash
# 1. Start from latest develop (or ideate for new features)
git checkout develop  # or: git checkout ideate
git pull origin develop

# 2. Create feature branch
git checkout -b feature/LIN-123-user-authentication

# 3. Work on feature (commit often)
git add .
git commit -m "[LIN-123] feat: add login endpoint"

# 4. Keep up to date with develop
git fetch origin develop
git rebase origin/develop

# 5. Push and create PR
git push -u origin feature/LIN-123-user-authentication
# Create PR: feature/LIN-123 → develop

# 6. After merge, delete branch
git checkout develop
git pull origin develop
git branch -d feature/LIN-123-user-authentication
```

### Bug Fix

```bash
# Same as feature, but use fix/ prefix
git checkout -b fix/LIN-456-login-error
```

### Hotfix (Production Emergency)

```bash
# 1. Branch from main
git checkout main
git pull origin main
git checkout -b hotfix/LIN-789-security-patch

# 2. Fix the issue
git add .
git commit -m "[LIN-789] fix: patch XSS vulnerability"

# 3. Push and create PR to main
git push -u origin hotfix/LIN-789-security-patch
# Create PR: hotfix/LIN-789 → main

# 4. After merge to main, cherry-pick to develop
git checkout develop
git pull origin develop
git cherry-pick <commit-sha>
git push origin develop
```

### Release Process

```bash
# 1. Create release branch from develop
git checkout develop
git pull origin develop
git checkout -b release/v1.2.0

# 2. Bump version
npm version 1.2.0 --no-git-tag-version
git add package.json package-lock.json
git commit -m "chore: bump version to 1.2.0"

# 3. Push and deploy to staging for QA
git push -u origin release/v1.2.0
# CI deploys to staging automatically

# 4. Fix any issues on release branch
git commit -m "[LIN-XXX] fix: resolve QA issue"

# 5. When ready, merge to main
# Create PR: release/v1.2.0 → main
# After merge, tag the release:
git checkout main
git pull origin main
git tag -a v1.2.0 -m "Release v1.2.0"
git push origin v1.2.0

# 6. Merge back to develop
git checkout develop
git merge release/v1.2.0
git push origin develop

# 7. Delete release branch
git branch -d release/v1.2.0
git push origin --delete release/v1.2.0
```

---

## Environment Promotion

```
Prototype Branch → ideate → develop → staging → main
                      │         │         │        │
                      ▼         ▼         ▼        ▼
                 Prototype   Dev Env   Staging  Production
```

### Promotion Rules

| From | To | Trigger | Requirements |
|------|-----|---------|--------------|
| prototype/* | ideate | PR merge | CI passes (relaxed) |
| ideate | develop | PR merge | CI passes, 1 approval, prototype validated |
| feature/* | develop | PR merge | CI passes, 1 approval |
| develop | staging | Manual/scheduled | All develop tests pass |
| staging | main | Release approval | QA sign-off, all tests pass |
| hotfix/* | main | PR merge | CI passes, Tech Lead approval |

---

## Branch Naming Convention

### Format
```
{type}/LIN-{issue-number}-{short-description}
```

### Examples
```
prototype/LIN-100-ai-recommendation-poc
feature/LIN-123-user-authentication
fix/LIN-456-login-validation-error
hotfix/LIN-789-security-patch
chore/LIN-101-update-dependencies
docs/LIN-202-api-documentation
release/v1.2.0
```

### Rules
- Use lowercase
- Use hyphens (not underscores)
- Keep description short (3-5 words)
- Always include Linear issue ID

---

## Merge Strategies

| Merge Type | When | Method |
|------------|------|--------|
| Feature → develop | Normal features | Squash merge |
| Fix → develop | Bug fixes | Squash merge |
| develop → staging | Environment promotion | Merge commit |
| staging → main | Release | Merge commit |
| Hotfix → main | Emergency fix | Merge commit |
| Release → main | Release | Merge commit |

### Why Squash for Features?

- Cleaner history on develop
- One commit per feature/fix
- Easier to revert

### Why Merge Commit for Promotions?

- Preserve full history
- Clear audit trail
- Easy to see what was promoted

---

## Git Commands Reference

```bash
# Sync with remote
git fetch origin
git pull origin <branch>

# Rebase feature on develop
git checkout feature/LIN-123
git rebase origin/develop

# Interactive rebase to clean commits
git rebase -i HEAD~3

# Cherry-pick a commit
git cherry-pick <commit-sha>

# Undo last commit (keep changes)
git reset --soft HEAD~1

# View branch graph
git log --oneline --graph --all

# Delete remote branch
git push origin --delete <branch-name>

# List merged branches
git branch --merged develop
```

---

## CI/CD Integration

### Branch → Environment Mapping

```yaml
# In CI/CD config
branches:
  ideate:
    deploy_to: prototype
  develop:
    deploy_to: development
  staging:
    deploy_to: staging
  main:
    deploy_to: production
  release/*:
    deploy_to: staging
```

### Automated Actions

| Event | Action |
|-------|--------|
| PR opened | Run tests, lint, build |
| PR merged to ideate | Deploy to prototype environment |
| PR merged to develop | Deploy to dev environment |
| PR merged to staging | Deploy to staging, run E2E tests |
| Tag pushed (v*) | Deploy to production, create release |

---

## Troubleshooting

### Merge Conflicts

```bash
# During rebase
git rebase origin/develop
# Fix conflicts in files
git add <fixed-files>
git rebase --continue

# Abort if needed
git rebase --abort
```

### Accidental Commit to Wrong Branch

```bash
# Move last commit to correct branch
git checkout correct-branch
git cherry-pick <commit-sha>
git checkout wrong-branch
git reset --hard HEAD~1
```

### Need to Update PR After Review

```bash
# Add new commits (preferred)
git add .
git commit -m "[LIN-123] fix: address review feedback"
git push

# Or amend last commit (if minor change)
git add .
git commit --amend --no-edit
git push --force-with-lease
```
