# Bug Tracking System

## Overview

This document outlines the bug tracking process for both internal and external bug reports.

---

## Bug Classification

### By Source

```
┌─────────────────────────────────────────────────────────────────┐
│                         BUG SOURCES                              │
├─────────────────────┬─────────────────────┬─────────────────────┤
│      INTERNAL       │      EXTERNAL       │     AUTOMATED       │
├─────────────────────┼─────────────────────┼─────────────────────┤
│ • Team members      │ • Customer reports  │ • Error monitoring  │
│ • QA testing        │ • User feedback     │ • Health checks     │
│ • Code review       │ • Support tickets   │ • CI/CD failures    │
│ • Security audits   │ • Public issues     │ • Performance alerts│
└─────────────────────┴─────────────────────┴─────────────────────┘
```

### By Severity

| Severity | Impact | Example |
|----------|--------|---------|
| **Critical (P0)** | System down, data loss, security breach | Production API returning 500 |
| **High (P1)** | Major feature broken, significant user impact | Login failing for subset of users |
| **Medium (P2)** | Feature degraded, workaround exists | Export taking 10x longer than expected |
| **Low (P3)** | Minor issue, cosmetic | Button misaligned on mobile |
| **Trivial (P4)** | Negligible impact | Typo in error message |

---

## Internal Bug Workflow

### Intake Process

```
Developer/QA Finds Bug
        │
        ▼
┌───────────────────┐
│  Create Issue in  │
│  Linear with:     │
│  - type:bug-internal
│  - source:internal│
│  - env:[affected] │
└────────┬──────────┘
         │
         ▼
┌───────────────────┐
│  Auto-assigned to │
│  Triage state     │
└────────┬──────────┘
         │
         ▼
┌───────────────────┐
│  Triage owner     │
│  sets priority    │
│  and assigns      │
└───────────────────┘
```

### Internal Bug Template

```markdown
**Bug Title**: [Component] Brief description

## Environment
- **Found In**: [Prototype/Develop/Staging/Production]
- **Version/Commit**:
- **Browser/Device**: (if applicable)

## Description
[What's happening]

## Steps to Reproduce
1.
2.
3.

## Expected vs Actual
- **Expected**:
- **Actual**:

## Evidence
- [ ] Screenshot attached
- [ ] Console logs attached
- [ ] Network logs attached

## Root Cause Analysis (if known)
[Initial thoughts on cause]

## Suggested Fix (if known)
[Potential solution]

---
**Reporter**: @[your-name]
**Found During**: [Development/Code Review/QA/Monitoring]
```

---

## External Bug Workflow

### Intake Process

```
Customer Reports Bug
        │
        ▼
┌───────────────────┐
│  Support creates  │
│  Linear issue     │◄── Auto-import from:
│                   │    • Zendesk
└────────┬──────────┘    • Intercom
         │               • GitHub Issues
         ▼
┌───────────────────┐
│  Auto-labeled:    │
│  - type:bug-external
│  - source:external│
│  - P1 (default)   │
└────────┬──────────┘
         │
         ▼
┌───────────────────┐
│  Notify:          │
│  - #bugs channel  │
│  - On-call eng    │
└────────┬──────────┘
         │
         ▼
┌───────────────────┐
│  SLA clock starts │
│  2hr first response
└───────────────────┘
```

### External Bug Template

```markdown
**Bug Title**: [EXTERNAL] Brief description

## Customer Information
- **Customer ID**:
- **Account Type**: [Free/Pro/Enterprise]
- **Contact**: [email/ticket#]
- **Reported Via**: [Support/Email/Twitter/GitHub]

## Environment
- **Reported Environment**: Production
- **Customer's Browser/Device**:
- **Customer's OS**:

## Customer's Description
> [Paste customer's original report]

## Steps to Reproduce (Verified)
- [ ] Reproduced internally
1.
2.
3.

## Impact Assessment
- **Users Affected**: [Count/Percentage]
- **Revenue Impact**: [High/Medium/Low/None]
- **Workaround Available**: [Yes/No - describe]

## Evidence
- [ ] Customer screenshot attached
- [ ] Internal reproduction screenshot
- [ ] Relevant logs pulled

## Communication Log
| Date | Update | Communicated to Customer |
|------|--------|-------------------------|
| | | [ ] Yes [ ] No |

---
**Support Contact**: @[support-name]
**Assigned Engineer**: @[engineer-name]
**SLA Status**: [On Track/At Risk/Breached]
```

### External Bug SLA Tracking

```
Timeline for P1 External Bug:
────────────────────────────────────────────────────────────
0h          2h           24h          48h          72h
│           │            │            │            │
▼           ▼            ▼            ▼            ▼
Created   First      Resolution   Escalate    Executive
          Response   Target       to Lead     Review
          DUE                     if open     if open
```

---

## Bug Triage Process

### Daily Triage Meeting (15 min)

**Attendees**: Triage owner, Tech Lead, QA Lead

**Agenda**:
1. Review new bugs (5 min)
2. Prioritize and assign (5 min)
3. Review SLA breaches (5 min)

### Triage Checklist

For each new bug:
- [ ] Is this a duplicate? → Link and close
- [ ] Is this actually a bug? → Reclassify if needed
- [ ] Can we reproduce it? → Request more info if not
- [ ] What's the severity? → Set priority
- [ ] Which environment? → Add env label
- [ ] Who should own it? → Assign
- [ ] Is there a workaround? → Document in issue

### Priority Matrix

```
                    IMPACT
            Low         High
         ┌─────────┬─────────┐
    Low  │   P4    │   P2    │
URGENCY  ├─────────┼─────────┤
    High │   P3    │ P0/P1   │
         └─────────┴─────────┘
```

---

## Bug Views in Linear

### 1. Triage Queue
**Filter**: `state:Triage AND type:bug*`
**Sort**: Created date (oldest first)
**Purpose**: Daily triage review

### 2. External Bugs Dashboard
**Filter**: `type:bug-external AND NOT state:Done,Canceled`
**Group by**: Priority
**Purpose**: Track customer-reported issues

### 3. Internal Bugs Dashboard
**Filter**: `type:bug-internal AND NOT state:Done,Canceled`
**Group by**: Environment
**Purpose**: Track team-found issues

### 4. Production Bugs
**Filter**: `env:production AND type:bug* AND NOT state:Done`
**Sort**: Priority
**Purpose**: Critical production issues

### 5. SLA At Risk
**Filter**: `type:bug-external AND sla:at-risk`
**Sort**: SLA deadline
**Purpose**: Prevent SLA breaches

---

## Bug Metrics

### Key Performance Indicators

| Metric | Target | Measurement |
|--------|--------|-------------|
| Mean Time to Detect (MTTD) | < 1 hour | Time from bug occurrence to report |
| Mean Time to Acknowledge (MTTA) | < 2 hours | Time from report to first response |
| Mean Time to Resolve (MTTR) | < 24 hours (P1) | Time from report to fix deployed |
| Bug Escape Rate | < 5% | Bugs in prod / total bugs found |
| External Bug SLA Compliance | > 95% | % of external bugs meeting SLA |
| Reopen Rate | < 10% | % of bugs reopened after fix |

### Weekly Bug Report

Generate and share in #engineering:

```markdown
## Weekly Bug Report - Week of [DATE]

### Summary
- **New Bugs**: X
- **Resolved**: X
- **Open**: X
- **SLA Breaches**: X

### By Source
- Internal: X
- External: X
- Automated: X

### By Environment
- Production: X (X critical)
- Staging: X
- Develop: X

### Trends
[Graph or description of trends]

### Action Items
1.
2.
```

---

## Escalation Path

### Production Bugs (P0)

```
0-15 min     : On-call engineer notified
15-30 min    : Tech Lead notified
30-60 min    : Engineering Manager notified
1-2 hours    : VP Engineering notified
2+ hours     : Executive team notified
```

### External Bug SLA Breach

```
At risk (75% time elapsed) : Tech Lead notified
Breached                   : Engineering Manager + Customer Success notified
24h post-breach           : VP Engineering review
```

---

## Bug Fix Workflow

### Development Process

```
Bug Assigned
     │
     ▼
┌─────────────────┐
│ Create branch:  │
│ fix/LIN-XXX-desc│
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ Write fix +     │
│ regression test │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ PR with:        │
│ "Fixes LIN-XXX" │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ Code Review     │
│ (expedited for  │
│  P0/P1)         │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ Deploy to       │
│ Staging → QA    │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ Deploy to Prod  │
│ Verify fix      │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ Close issue     │
│ Notify customer │
│ (if external)   │
└─────────────────┘
```

### Post-Mortem Requirements

Required for:
- All P0 bugs
- P1 bugs affecting > 100 users
- Any security-related bugs
- Bugs causing data loss

Template in: `.linear/templates/post-mortem.md`
