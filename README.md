# subbu_ai_prototypes

AI prototyping playground with structured development workflow.

## Prototypes

| App | Platforms | Description |
|-----|-----------|-------------|
| [Life in Numbers](apps/life-in-numbers/) | macOS, iPhone | Your life quantified in real time — heartbeats, breaths, a life-in-weeks grid, milestones, and an on-device open-source LLM (Qwen via MLX) that writes reflections on your numbers. SwiftUI multiplatform + tested Swift package core. |

## Development Workflow

This project uses Linear for project management with a 4-environment deployment pipeline.

### Environments

| Environment | Purpose | Branch |
|-------------|---------|--------|
| **Prototype** | Early exploration, POCs | feature branches |
| **Develop** | Active development | `dev` |
| **Staging** | QA and testing | `staging` |
| **Production** | Live customers | `main` |

### Quick Links

- [Linear Setup Guide](.linear/SETUP.md)
- [Workflow Configuration](.linear/workflow-config.md)
- [Bug Tracking Process](.linear/bug-tracking.md)
- [Release Management](.linear/release-management.md)
- [Contributing Guide](docs/CONTRIBUTING.md)
- [Branching Strategy](docs/BRANCHING_STRATEGY.md)

## Getting Started

```bash
# Clone the repository
git clone <repository-url>
cd subbu_ai_prototypes

# Install dependencies
npm install

# Start development
npm run dev
```

## Project Structure

```
.
├── .github/                    # GitHub configuration
│   ├── ISSUE_TEMPLATE/         # Issue templates
│   ├── workflows/              # CI/CD workflows
│   └── PULL_REQUEST_TEMPLATE.md
├── .linear/                    # Linear workflow configuration
│   ├── workflow-config.md      # States, labels, automations
│   ├── bug-tracking.md         # Bug tracking process
│   ├── release-management.md   # Release process
│   ├── SETUP.md               # Setup guide
│   └── templates/              # Issue/PR templates
├── docs/                       # Documentation
│   ├── CONTRIBUTING.md        # Contributing guide
│   └── BRANCHING_STRATEGY.md  # Git branching strategy
└── README.md
```

## Workflow States

```
Backlog → Triage → Ideate/Prototype → Develop → Code Review → Staging/QA → Production → Done
```

## Issue Types

- `type:feature` - New functionality
- `type:bug-internal` - Team-reported bugs
- `type:bug-external` - Customer-reported bugs
- `type:tech-debt` - Code improvements
- `type:documentation` - Docs updates

## Contributing

See [CONTRIBUTING.md](docs/CONTRIBUTING.md) for development guidelines.

## License

[Add license]
