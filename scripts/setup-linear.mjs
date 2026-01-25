#!/usr/bin/env node
/**
 * Linear Setup Script
 * Creates issue templates and configures workflow via Linear API
 *
 * Usage: LINEAR_API_KEY=your_key node scripts/setup-linear.mjs
 */

const LINEAR_API = 'https://api.linear.app/graphql';
const API_KEY = process.env.LINEAR_API_KEY;

if (!API_KEY) {
  console.error('❌ Missing LINEAR_API_KEY environment variable');
  console.error('Usage: LINEAR_API_KEY=your_key node scripts/setup-linear.mjs');
  process.exit(1);
}

// GraphQL helper
async function linearQuery(query, variables = {}) {
  const response = await fetch(LINEAR_API, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      'Authorization': API_KEY,
    },
    body: JSON.stringify({ query, variables }),
  });

  const json = await response.json();
  if (json.errors) {
    throw new Error(json.errors.map(e => e.message).join(', '));
  }
  return json.data;
}

// Get team ID
async function getTeamId() {
  const data = await linearQuery(`
    query {
      teams {
        nodes {
          id
          name
          key
        }
      }
    }
  `);

  const team = data.teams.nodes[0];
  if (!team) {
    throw new Error('No teams found in workspace');
  }
  console.log(`📋 Found team: ${team.name} (${team.key})`);
  return team.id;
}

// Create issue template
async function createTemplate(teamId, template) {
  try {
    const data = await linearQuery(`
      mutation CreateTemplate($input: TemplateCreateInput!) {
        templateCreate(input: $input) {
          success
          template {
            id
            name
          }
        }
      }
    `, {
      input: {
        teamId,
        type: 'issue',
        name: template.name,
        description: template.description,
        templateData: {
          description: template.content,
          ...(template.labelIds && { labelIds: template.labelIds }),
          ...(template.priority && { priority: template.priority }),
        },
      },
    });

    if (data.templateCreate.success) {
      console.log(`  ✅ Created: ${template.name}`);
      return data.templateCreate.template;
    }
  } catch (error) {
    if (error.message.includes('already exists')) {
      console.log(`  ⏭️  Skipped: ${template.name} (already exists)`);
    } else {
      console.error(`  ❌ Failed: ${template.name} - ${error.message}`);
    }
  }
}

// Template definitions
const templates = [
  {
    name: 'Bug Report - Internal',
    description: 'For bugs found by the team',
    content: `## Bug Description
[Clear description of the bug]

## Environment
- [ ] Prototype
- [ ] Dev
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

## Evidence
- [ ] Screenshot attached
- [ ] Console logs attached
- [ ] Network logs attached

## Root Cause Analysis (if known)
[Initial thoughts on cause]

---
**Reporter**: @[your-name]
**Found During**: [Development/Code Review/QA/Monitoring]`,
  },
  {
    name: 'Bug Report - External',
    description: 'For customer-reported bugs',
    priority: 2, // High priority for external bugs
    content: `## Customer Information
- **Customer ID**:
- **Account Type**: [Free/Pro/Enterprise]
- **Contact**: [email/ticket#]
- **Reported Via**: [Support/Email/Twitter/GitHub]

## Customer's Description
> [Paste customer's original report]

## Environment
Production

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
**SLA Status**: [On Track/At Risk/Breached]`,
  },
  {
    name: 'Feature Request',
    description: 'For new feature proposals',
    content: `## Feature Summary
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

## Effort Estimate
- [ ] Small (< 1 day)
- [ ] Medium (1-3 days)
- [ ] Large (3-5 days)
- [ ] Extra Large (> 5 days)`,
  },
  {
    name: 'Technical Debt',
    description: 'For code quality improvements',
    content: `## Summary
[Brief description of the technical debt]

## Current State
[Describe the current implementation and its problems]

## Desired State
[Describe the ideal implementation]

## Why This Matters
[Impact on: codebase health, developer experience, performance, security]

## Affected Areas
-
-

## Proposed Approach
[High-level approach to address this]

## Effort Estimate
- [ ] Small (< 1 day)
- [ ] Medium (1-3 days)
- [ ] Large (3-5 days)
- [ ] Extra Large (> 5 days)

## Risk Assessment
- [ ] Low risk - isolated change
- [ ] Medium risk - touches multiple components
- [ ] High risk - core functionality

## Definition of Done
- [ ]
- [ ]
- [ ]`,
  },
  {
    name: 'Post-Mortem',
    description: 'For incident post-mortems',
    content: `## Incident Overview

| Field | Value |
|-------|-------|
| **Incident Title** | [Brief description] |
| **Severity** | P0 / P1 / P2 |
| **Date/Time Detected** | YYYY-MM-DD HH:MM UTC |
| **Date/Time Resolved** | YYYY-MM-DD HH:MM UTC |
| **Duration** | X hours Y minutes |
| **Incident Commander** | @[name] |

## Executive Summary
[2-3 sentence summary of what happened, impact, and resolution]

## Timeline
| Time (UTC) | Event |
|------------|-------|
| HH:MM | [First indication of problem] |
| HH:MM | [Alert fired / Customer reported] |
| HH:MM | [Root cause identified] |
| HH:MM | [Fix deployed] |
| HH:MM | [Incident resolved] |

## Impact
- **Users Affected**:
- **Revenue Impact**:
- **SLA Breach**: Yes/No

## Root Cause Analysis
### What Happened
[Detailed technical explanation]

### 5 Whys
1. **Why?**
2. **Why?**
3. **Why?**
4. **Why?**
5. **Why?** (Root cause)

## Action Items
| Priority | Action | Owner | Due Date |
|----------|--------|-------|----------|
| P0 | | @[name] | |
| P1 | | @[name] | |

## Lessons Learned
1.
2.
3.`,
  },
  {
    name: 'Release Checklist',
    description: 'For release preparation',
    content: `## Release Information

| Field | Value |
|-------|-------|
| **Version** | vX.Y.Z |
| **Release Date** | YYYY-MM-DD |
| **Release Manager** | @[name] |
| **Type** | Major / Minor / Patch |

## Pre-Release Checklist

### Code Readiness
- [ ] All features for this release merged to \`dev\`
- [ ] Feature freeze in effect
- [ ] No critical bugs open
- [ ] All tests passing

### QA Checklist
- [ ] Regression testing complete
- [ ] New features tested
- [ ] Performance testing (if applicable)
- [ ] Security review (if applicable)

### Documentation
- [ ] CHANGELOG updated
- [ ] API docs updated (if applicable)
- [ ] User docs updated (if applicable)
- [ ] Release notes drafted

## Release Steps
- [ ] Create release branch \`release/vX.Y.Z\`
- [ ] Bump version numbers
- [ ] Deploy to staging
- [ ] Final QA sign-off
- [ ] Merge to \`main\`
- [ ] Tag release
- [ ] Deploy to production
- [ ] Verify deployment
- [ ] Publish release notes
- [ ] Notify stakeholders

## Post-Release
- [ ] Monitor error rates
- [ ] Monitor performance
- [ ] Customer feedback reviewed
- [ ] Merge release branch back to \`dev\`

## Rollback Plan
[Document rollback procedure if needed]`,
  },
];

// Main execution
async function main() {
  console.log('🚀 Linear Setup Script\n');

  try {
    // Get team
    const teamId = await getTeamId();

    // Create templates
    console.log('\n📝 Creating issue templates...');
    for (const template of templates) {
      await createTemplate(teamId, template);
    }

    console.log('\n✨ Setup complete!');
    console.log('\nNext steps:');
    console.log('1. Go to Linear Settings → Team → Templates to review');
    console.log('2. Add labels to templates as needed');
    console.log('3. Set up workflow automations');

  } catch (error) {
    console.error('\n❌ Setup failed:', error.message);
    process.exit(1);
  }
}

main();
