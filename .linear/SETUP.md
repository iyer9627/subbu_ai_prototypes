# Linear Setup Guide

This guide walks you through setting up Linear with the workflow configuration defined in this repository.

---

## Quick Start Checklist

- [ ] Create Linear workspace
- [ ] Configure workflow states
- [ ] Set up labels
- [ ] Enable GitHub integration
- [ ] Configure Slack integration
- [ ] Set up automations
- [ ] Create initial projects
- [ ] Invite team members

---

## Step 1: Create Workspace & Team

1. Go to [linear.app](https://linear.app) and create a workspace
2. Create your main team (e.g., "Engineering")
3. Note your team identifier (e.g., "ENG") - this becomes your issue prefix

---

## Step 2: Configure Workflow States

Navigate to **Settings > Team > Workflow**

### Add these states in order:

| State Name | Category | Position |
|------------|----------|----------|
| Backlog | Backlog | 1 |
| Triage | Unstarted | 2 |
| Ideate/Prototype | Started | 3 |
| Develop | Started | 4 |
| Code Review | Started | 5 |
| Staging/QA | Started | 6 |
| Production | Started | 7 |
| Done | Completed | 8 |
| Canceled | Canceled | 9 |

### State Colors (optional but recommended):
- Triage: `#e2e2e2`
- Ideate/Prototype: `#0ea5e9`
- Develop: `#f59e0b`
- Code Review: `#8b5cf6`
- Staging/QA: `#ec4899`
- Production: `#22c55e`

---

## Step 3: Create Labels

Navigate to **Settings > Team > Labels**

### Type Labels
```
type:feature        #22c55e (green)
type:enhancement    #3b82f6 (blue)
type:bug           #ef4444 (red)
type:bug-internal  #f97316 (orange)
type:bug-external  #dc2626 (dark red)
type:tech-debt     #8b5cf6 (purple)
type:documentation #06b6d4 (cyan)
type:security      #991b1b (dark red)
type:performance   #eab308 (yellow)
```

### Environment Labels
```
env:prototype      #0ea5e9 (sky blue)
env:dev        #f59e0b (amber)
env:staging        #ec4899 (pink)
env:production     #22c55e (green)
```

### Source Labels
```
source:internal    #6366f1 (indigo)
source:external    #f43f5e (rose)
source:monitoring  #14b8a6 (teal)
source:ci-cd       #a855f7 (purple)
```

### Other Useful Labels
```
needs-triage       #9ca3af (gray)
blocked            #ef4444 (red)
needs-design       #f472b6 (pink)
needs-spec         #818cf8 (indigo)
```

---

## Step 4: Enable GitHub Integration

Navigate to **Settings > Integrations > GitHub**

1. Click "Connect GitHub"
2. Authorize Linear to access your organization
3. Select the repositories to connect
4. Configure these settings:

### PR Linking
- Enable "Link pull requests to issues"
- Use keyword: `Fixes`, `Closes`, `Part of`, `Related to`

### Auto-close
- Enable "Auto-close issues when PR is merged"
- Set target branch: `main`
- Set completion state: `Done`

### Branch Settings
- Enable "Move issue to started when branch is created"
- Branch format: `feature/ENG-123-description`

---

## Step 5: Set Up Automations

Navigate to **Settings > Team > Workflow > Automations**

### Automation 1: Auto-triage new issues
```
When: Issue is created
If: Assignee is empty
Then: Set state to "Triage"
      Add label "needs-triage"
```

### Automation 2: Move to Code Review on PR
```
When: Pull request is opened
Then: Set state to "Code Review"
```

### Automation 3: Move to Staging on merge to dev
```
When: Pull request is merged
If: Target branch is "dev" or "staging"
Then: Set state to "Staging/QA"
```

### Automation 4: Move to Production on merge to main
```
When: Pull request is merged
If: Target branch is "main"
Then: Set state to "Production"
```

### Automation 5: Auto-prioritize external bugs
```
When: Label is added
If: Label is "type:bug-external"
Then: Set priority to "High"
```

---

## Step 6: Configure Slack Integration

Navigate to **Settings > Integrations > Slack**

1. Click "Connect Slack"
2. Set up these channel notifications:

| Event | Channel |
|-------|---------|
| New P0/P1 issues | #alerts-critical |
| New bug reports | #bugs |
| Release updates | #releases |
| Daily digest | #engineering |

### Slash Commands
Once connected, you can use:
- `/linear create` - Create new issue
- `/linear search` - Search issues
- `/linear me` - See your assigned issues

---

## Step 7: Create Projects

### Release Projects
For each planned release:
1. Go to **Projects** > **Create Project**
2. Name: "Release v1.0.0"
3. Set target date
4. Add milestone dates:
   - Feature Complete
   - Code Freeze
   - QA Complete
   - Release

### Initiative Projects (Optional)
For larger business initiatives:
1. Create project for each major initiative
2. Link related issues
3. Track progress across multiple cycles

---

## Step 8: Configure Cycles (Sprints)

Navigate to **Settings > Team > Cycles**

Recommended settings:
- **Duration**: 2 weeks
- **Cooldown**: 2 days
- **Start day**: Monday
- **Auto-create**: Enabled

---

## Step 9: Set Up Views

Create these saved views for your team:

### Triage Queue
- Filter: `state:Triage`
- Sort: Created (oldest first)

### My Work
- Filter: `assignee:@me AND NOT state:Done,Canceled`
- Sort: Priority

### External Bugs
- Filter: `label:type:bug-external AND NOT state:Done`
- Group: Priority

### Current Sprint
- Filter: `cycle:current`
- Group: State

### Release Board
- Filter: `project:"Release v1.0.0"`
- Group: State

---

## Step 10: Team Onboarding

### Invite Members
1. Go to **Settings > Members**
2. Invite by email
3. Assign roles (Admin, Member)

### Share These Resources
- This SETUP.md guide
- workflow-config.md for reference
- bug-tracking.md for bug procedures
- release-management.md for release procedures

### Quick Training Topics
1. How to create issues
2. How to link PRs to issues
3. How to use keyboard shortcuts
4. How to update issue status
5. How to use filters and views

---

## Keyboard Shortcuts Reference

| Action | Shortcut |
|--------|----------|
| New issue | `C` |
| Search | `Cmd/Ctrl + K` |
| My issues | `G` then `M` |
| Inbox | `G` then `I` |
| Set status | `S` |
| Set priority | `P` |
| Set assignee | `A` |
| Add label | `L` |
| Copy issue ID | `Cmd/Ctrl + .` |

---

## Troubleshooting

### GitHub integration not syncing
1. Check integration is still authorized
2. Verify repository is connected
3. Check webhook delivery in GitHub settings

### Issues not auto-transitioning
1. Verify automation rules are enabled
2. Check branch naming matches pattern
3. Ensure PR description contains issue ID

### Slack notifications not working
1. Re-authorize Slack integration
2. Check channel permissions
3. Verify notification rules

---

## Support

- Linear Documentation: https://linear.app/docs
- Linear API: https://developers.linear.app
- Community: https://linear.app/community
