# Post-Mortem Template

## Incident Overview

| Field | Value |
|-------|-------|
| **Incident Title** | [Brief description] |
| **Linear Issue** | LIN-XXX |
| **Severity** | P0 / P1 / P2 |
| **Date/Time Detected** | YYYY-MM-DD HH:MM UTC |
| **Date/Time Resolved** | YYYY-MM-DD HH:MM UTC |
| **Duration** | X hours Y minutes |
| **Affected Environment** | Production / Staging |
| **Incident Commander** | @[name] |
| **Post-Mortem Author** | @[name] |
| **Post-Mortem Date** | YYYY-MM-DD |

---

## Executive Summary

[2-3 sentence summary of what happened, impact, and resolution]

---

## Timeline

| Time (UTC) | Event |
|------------|-------|
| HH:MM | [First indication of problem] |
| HH:MM | [Alert fired / Customer reported] |
| HH:MM | [On-call engineer notified] |
| HH:MM | [Investigation started] |
| HH:MM | [Root cause identified] |
| HH:MM | [Fix implemented] |
| HH:MM | [Fix deployed] |
| HH:MM | [Incident resolved] |
| HH:MM | [All-clear communicated] |

---

## Impact

### User Impact
- **Users Affected**: [Number or percentage]
- **Requests Failed**: [Number or percentage]
- **Error Rate**: [X% vs normal Y%]

### Business Impact
- **Revenue Impact**: [$ amount or N/A]
- **SLA Breach**: [Yes/No - details]
- **Customer Escalations**: [Number]

### Technical Impact
- **Services Affected**: [List services]
- **Data Impact**: [Any data loss or corruption]

---

## Root Cause Analysis

### What Happened
[Detailed technical explanation of what went wrong]

### Why It Happened
[Use 5 Whys technique]

1. **Why?** [First level answer]
2. **Why?** [Second level answer]
3. **Why?** [Third level answer]
4. **Why?** [Fourth level answer]
5. **Why?** [Root cause]

### Contributing Factors
- [ ] Code change
- [ ] Configuration change
- [ ] Infrastructure issue
- [ ] External dependency
- [ ] Human error
- [ ] Other: ___

---

## Detection

### How Was It Detected?
- [ ] Automated monitoring/alerting
- [ ] Customer report
- [ ] Internal testing
- [ ] Other: ___

### Detection Gap Analysis
- **Time to Detect (TTD)**: [X minutes]
- **Could we have detected sooner?**: [Yes/No - how]

---

## Response

### What Went Well
1. [Positive aspect of response]
2. [Positive aspect of response]
3. [Positive aspect of response]

### What Could Be Improved
1. [Improvement opportunity]
2. [Improvement opportunity]
3. [Improvement opportunity]

### Response Metrics
- **Time to Acknowledge (TTA)**: [X minutes]
- **Time to Mitigate (TTM)**: [X minutes]
- **Time to Resolve (TTR)**: [X minutes]

---

## Resolution

### Immediate Fix
[What was done to stop the bleeding]

### Permanent Fix
[What will prevent this from happening again]

---

## Action Items

| Priority | Action | Owner | Due Date | Status |
|----------|--------|-------|----------|--------|
| P0 | [Critical action] | @[name] | YYYY-MM-DD | [ ] |
| P1 | [High priority action] | @[name] | YYYY-MM-DD | [ ] |
| P2 | [Medium priority action] | @[name] | YYYY-MM-DD | [ ] |
| P3 | [Low priority action] | @[name] | YYYY-MM-DD | [ ] |

### Action Item Categories
- [ ] **Prevent**: Stop this from happening
- [ ] **Detect**: Catch it faster next time
- [ ] **Respond**: Handle it better next time
- [ ] **Recover**: Reduce recovery time

---

## Lessons Learned

### Key Takeaways
1. [Lesson 1]
2. [Lesson 2]
3. [Lesson 3]

### Process Changes
[Any changes to processes or procedures]

### Documentation Updates
[Any documentation that needs to be created or updated]

---

## Appendix

### Relevant Links
- [Link to logs]
- [Link to dashboards]
- [Link to related PRs]
- [Link to Slack thread]

### Screenshots/Graphs
[Include relevant visuals]

---

## Sign-Off

| Role | Name | Date |
|------|------|------|
| Incident Commander | @[name] | YYYY-MM-DD |
| Engineering Lead | @[name] | YYYY-MM-DD |
| Product Owner | @[name] | YYYY-MM-DD |
