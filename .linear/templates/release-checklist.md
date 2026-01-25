# Release Checklist - v[X.Y.Z]

**Release Date**: YYYY-MM-DD
**Release Manager**: @[name]
**Linear Project**: [Link to release project]

---

## Pre-Release (T-3 days)

### Code Freeze
- [ ] All features for this release are merged to `dev`
- [ ] Release branch created: `release/vX.Y.Z`
- [ ] No new features allowed (only bug fixes)

### Version & Documentation
- [ ] Version bumped in `package.json` / `pyproject.toml`
- [ ] CHANGELOG.md updated with all changes
- [ ] Release notes drafted
- [ ] API documentation updated (if applicable)
- [ ] Migration guide written (if breaking changes)

### Staging Deployment
- [ ] Release branch deployed to staging
- [ ] Deployment completed without errors
- [ ] Environment variables verified

---

## QA Phase (T-2 to T-1 days)

### Automated Testing
- [ ] All unit tests passing
- [ ] All integration tests passing
- [ ] All E2E tests passing
- [ ] Code coverage meets threshold (≥80%)

### Manual Testing
- [ ] Critical user flows tested
- [ ] Edge cases verified
- [ ] Cross-browser testing completed
- [ ] Mobile responsiveness verified
- [ ] Accessibility checks passed

### Performance
- [ ] Load testing completed
- [ ] No performance regression vs baseline
- [ ] Core Web Vitals acceptable

### Security
- [ ] Security scan completed
- [ ] No high/critical vulnerabilities
- [ ] Dependency audit passed
- [ ] Secrets scan passed

### Sign-offs
- [ ] QA team sign-off
- [ ] Product owner sign-off
- [ ] Tech lead sign-off

---

## Release Day (T-0)

### Final Checks
- [ ] All blockers resolved
- [ ] No P0/P1 bugs open for this release
- [ ] Staging environment stable

### Merge & Tag
- [ ] PR created: `release/vX.Y.Z` → `main`
- [ ] PR approved and merged
- [ ] Release tag created: `vX.Y.Z`
- [ ] Tag pushed to remote

### Production Deployment
- [ ] Deployment initiated
- [ ] Deployment completed successfully
- [ ] Smoke tests passing
- [ ] No errors in logs

### Monitoring (First 30 minutes)
- [ ] Error rates normal
- [ ] Response times normal
- [ ] No alerts triggered
- [ ] User reports monitored

---

## Post-Release

### Communication
- [ ] Internal announcement posted (#releases)
- [ ] External release notes published
- [ ] Customer communication sent (if applicable)
- [ ] Social media update (if applicable)

### Cleanup
- [ ] Release branch merged back to `dev`
- [ ] Release branch deleted
- [ ] Linear project marked as completed
- [ ] Old feature branches cleaned up

### Documentation
- [ ] Production URLs documented
- [ ] Any config changes documented
- [ ] Runbook updated (if needed)

### Retrospective
- [ ] Schedule retrospective (if significant release)
- [ ] Document lessons learned
- [ ] Update processes as needed

---

## Rollback Plan

### Criteria for Rollback
- Critical functionality broken
- Data integrity at risk
- Security vulnerability discovered
- Error rate > 5%

### Rollback Steps
1. [ ] Revert to previous release tag
2. [ ] Deploy previous version
3. [ ] Verify rollback successful
4. [ ] Notify stakeholders
5. [ ] Create incident issue

### Rollback Contact
- **Primary**: @[on-call engineer]
- **Secondary**: @[tech lead]
- **Escalation**: @[engineering manager]

---

## Release Notes Draft

### New Features
- [ ] Feature 1 (LIN-XXX)
- [ ] Feature 2 (LIN-XXX)

### Improvements
- [ ] Improvement 1 (LIN-XXX)
- [ ] Improvement 2 (LIN-XXX)

### Bug Fixes
- [ ] Fix 1 (LIN-XXX)
- [ ] Fix 2 (LIN-XXX)

### Breaking Changes
- [ ] Change 1 - Migration steps: ...
- [ ] Change 2 - Migration steps: ...

### Known Issues
- [ ] Issue 1 (LIN-XXX) - Workaround: ...

---

## Metrics to Track

Post-release, monitor for 24-48 hours:

| Metric | Baseline | Actual | Status |
|--------|----------|--------|--------|
| Error rate | <1% | | |
| P95 latency | <200ms | | |
| Successful deployments | 100% | | |
| Customer complaints | 0 | | |
