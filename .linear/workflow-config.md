# Linear Workflow Configuration

## Overview

This document defines the Linear workflow for **subbu_ai_prototypes**. It maps our development lifecycle across 4 environments with integrated bug tracking, PR management, and release processes.

---

## Environment-Based Workflow States

### State Flow Diagram

```
[Backlog] → [Ideate/Prototype] → [Develop] → [Staging/QA] → [Production] → [Done]
              ↑                      ↑            ↑              ↑
              └──────────────────────┴────────────┴──────────────┘
                              (Can return for fixes)
```

### Workflow States Configuration

| State | Type | Color | Description |
|-------|------|-------|-------------|
| **Backlog** | backlog | `#95a2b3` | Unscheduled work, ideas, and requests |
| **Triage** | unstarted | `#e2e2e2` | New issues awaiting prioritization |
| **Ideate/Prototype** | started | `#0ea5e9` | Early exploration, POCs, design work |
| **Develop** | started | `#f59e0b` | Active development in progress |
| **Code Review** | started | `#8b5cf6` | PR submitted, awaiting review |
| **Staging/QA** | started | `#ec4899` | Deployed to staging, under QA testing |
| **Production** | started | `#22c55e` | Deployed to production, monitoring |
| **Done** | completed | `#6b7280` | Issue completed and verified |
| **Canceled** | canceled | `#ef4444` | Issue won't be addressed |

---

## Labels Configuration

### Priority Labels (Auto-created by Linear)
- `P0 - Critical` - Production down, security breach
- `P1 - Urgent` - Major feature broken, blocking release
- `P2 - High` - Important but not blocking
- `P3 - Medium` - Standard priority
- `P4 - Low` - Nice to have, backlog items

### Type Labels

| Label | Color | Description |
|-------|-------|-------------|
| `type:feature` | `#22c55e` | New functionality |
| `type:enhancement` | `#3b82f6` | Improvement to existing feature |
| `type:bug` | `#ef4444` | Something isn't working |
| `type:bug-internal` | `#f97316` | Internal team reported bug |
| `type:bug-external` | `#dc2626` | Customer/user reported bug |
| `type:tech-debt` | `#8b5cf6` | Code quality, refactoring |
| `type:documentation` | `#06b6d4` | Documentation updates |
| `type:security` | `#991b1b` | Security related issues |
| `type:performance` | `#eab308` | Performance improvements |

### Environment Labels

| Label | Color | Description |
|-------|-------|-------------|
| `env:prototype` | `#0ea5e9` | Affects prototype environment |
| `env:dev` | `#f59e0b` | Affects development environment |
| `env:staging` | `#ec4899` | Affects staging environment |
| `env:production` | `#22c55e` | Affects production environment |

### Source Labels (Bug Origin)

| Label | Color | Description |
|-------|-------|-------------|
| `source:internal` | `#6366f1` | Reported by internal team |
| `source:external` | `#f43f5e` | Reported by customer/user |
| `source:monitoring` | `#14b8a6` | Detected by automated monitoring |
| `source:ci-cd` | `#a855f7` | Detected in CI/CD pipeline |

---

## Issue Templates

### Bug Report Template

```markdown
## Bug Description
[Clear description of the bug]

## Source
- [ ] Internal (team member)
- [ ] External (customer/user)
- [ ] Monitoring alert
- [ ] CI/CD failure

## Environment
- [ ] Prototype
- [ ] Develop
- [ ] Staging
- [ ] Production

## Steps to Reproduce
1.
2.
3.

## Expected Behavior
[What should happen]

## Actual Behavior
[What actually happens]

## Impact
- **Users Affected**: [Number/percentage]
- **Revenue Impact**: [If applicable]
- **Workaround Available**: Yes/No

## Additional Context
- Browser/Device:
- User ID/Account:
- Error logs:
- Screenshots:
```

### Feature Request Template

```markdown
## Feature Summary
[One-line description]

## Problem Statement
[What problem does this solve?]

## Proposed Solution
[How should this work?]

## User Stories
- As a [user type], I want [goal] so that [benefit]

## Acceptance Criteria
- [ ] Criterion 1
- [ ] Criterion 2
- [ ] Criterion 3

## Design Requirements
- [ ] Needs design mockups
- [ ] Needs technical spec
- [ ] Needs API changes

## Dependencies
[List any blocking issues or external dependencies]
```

---

## Cycles (Sprints) Configuration

### Recommended Cycle Settings
- **Duration**: 2 weeks
- **Cooldown**: 2 days (for planning and retro)
- **Start Day**: Monday
- **Auto-archive**: After 30 days

### Cycle Naming Convention
```
YYYY-Qn-Wnn (e.g., 2026-Q1-W03)
```

---

## Projects Configuration

### Project Types

1. **Epics** - Large initiatives spanning multiple cycles
2. **Releases** - Versioned releases (v1.0.0, v1.1.0, etc.)
3. **Initiatives** - Business objectives/OKRs

### Project Status Flow
```
Planning → In Progress → Completed → Archived
```

---

## Automations (Workflows)

### Auto-Triage Rules

```yaml
# When issue is created without assignee
trigger: issue.created
condition: assignee == null
action:
  - set_state: "Triage"
  - add_label: "needs-triage"
```

### State Transitions

```yaml
# When PR is opened, move to Code Review
trigger: issue.pr_opened
action:
  - set_state: "Code Review"

# When PR is merged to ideate, move to Ideate/Prototype
trigger: issue.pr_merged
condition: target_branch == "ideate"
action:
  - set_state: "Ideate/Prototype"
  - add_comment: "Deployed to prototype environment"

# When PR is merged to dev, move to Develop
trigger: issue.pr_merged
condition: target_branch == "dev"
action:
  - set_state: "Develop"
  - add_comment: "Deployed to development environment"

# When PR is merged to staging, move to Staging/QA
trigger: issue.pr_merged
condition: target_branch == "staging"
action:
  - set_state: "Staging/QA"
  - add_comment: "Deployed to staging environment"

# When PR is merged to main, move to Production
trigger: issue.pr_merged
condition: target_branch == "main"
action:
  - set_state: "Production"
  - add_comment: "Deployed to production environment"

# Alternative: When deployed to production via label
trigger: label.added
condition: label == "deployed:production"
action:
  - set_state: "Production"
  - add_comment: "Deployed to production"
```

### Bug Auto-labeling

```yaml
# Auto-label based on description keywords
trigger: issue.created
condition:
  - type == "Bug"
  - description contains "customer reported"
action:
  - add_label: "source:external"
  - add_label: "type:bug-external"
  - set_priority: "P1"
```

---

## SLA Configuration

### Response Time SLAs

| Priority | First Response | Resolution Target |
|----------|---------------|-------------------|
| P0 - Critical | 15 minutes | 4 hours |
| P1 - Urgent | 1 hour | 24 hours |
| P2 - High | 4 hours | 1 week |
| P3 - Medium | 1 day | 2 weeks |
| P4 - Low | 3 days | Backlog |

### External Bug SLA
- **First Response**: 2 hours (business hours)
- **Update Frequency**: Daily until resolved
- **Escalation**: Auto-escalate to P1 if no update in 24h

---

## Team Structure

### Recommended Teams

1. **Engineering** - Core development team
2. **QA** - Quality assurance team
3. **DevOps** - Infrastructure and deployment
4. **Support** - Customer-facing bug intake

### Triage Rotation
- Weekly rotation for triage duty
- Triage owner reviews all new issues daily
- Escalation path: Triage → Tech Lead → Engineering Manager

---

## Integration Points

### GitHub Integration
- Link PRs to Linear issues using `Fixes LIN-XXX` in PR description
- Auto-transition issues based on PR status
- Sync labels bidirectionally

### Slack Integration
- New P0/P1 issues → #alerts-critical
- Bug reports → #bugs
- Release notes → #releases
- Daily digest → #engineering

### CI/CD Integration
- Deployment notifications update issue status
- Failed deployments auto-create bug issues
- Test failures linked to related issues

---

## Metrics & Reporting

### Key Metrics to Track

1. **Cycle Time** - Time from started to done
2. **Lead Time** - Time from created to done
3. **Bug Resolution Time** - Average time to fix bugs
4. **External Bug SLA Compliance** - % meeting response SLA
5. **Throughput** - Issues completed per cycle
6. **Bug Escape Rate** - Bugs found in production vs staging

### Dashboard Views

1. **Triage Board** - All unassigned/new issues
2. **Sprint Board** - Current cycle work
3. **Bug Tracker** - All open bugs by priority
4. **Release Board** - Issues targeted for next release
5. **Customer Issues** - External bug reports

---

## Quick Reference

### State Shortcuts
| Current State | Keyboard | Next State |
|---------------|----------|------------|
| Backlog | `1` | Triage |
| Triage | `2` | Ideate/Prototype |
| Ideate/Prototype | `3` | Develop |
| Develop | `4` | Code Review |
| Code Review | `5` | Staging/QA |
| Staging/QA | `6` | Production |
| Production | `7` | Done |

### Common Label Combos
- **External Bug**: `type:bug-external` + `source:external` + `env:production`
- **Internal Bug**: `type:bug-internal` + `source:internal`
- **Hotfix**: `type:bug` + `P0` or `P1` + `env:production`
- **Tech Debt**: `type:tech-debt` + `source:internal`
