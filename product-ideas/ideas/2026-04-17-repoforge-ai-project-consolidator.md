# RepoForge — AI Project Consolidator

**Date:** 2026-04-17
**Category:** productivity, ai, infrastructure
**Maturity:** raw

## The Problem

AI coding tools (Claude Code, GitHub Copilot, Cursor, Replit) have made it trivially easy to spin up projects. The result: developers and power users now have dozens — sometimes hundreds — of half-finished repos, one-off scripts, prototype apps, and experimental projects scattered across their local machines. Most of these solve real problems, but they're written as throwaway code: no structure, no reusability, hardcoded values, duplicated logic across projects. The useful ones get rebuilt from scratch the next time a similar need comes up because no one remembers they already solved this. There's no tool that helps you look across everything you've built, find the patterns, and turn the good stuff into something reusable and scalable.

## The Idea

A developer tool that scans your local projects and repos, understands what each one does, identifies reusable patterns and overlaps, and helps you refactor and consolidate them into well-structured, scalable code — in as few steps as possible.

**Scan and catalog:**

- Point it at your machine (or a set of directories) and it discovers all projects — git repos, standalone scripts, Jupyter notebooks, app scaffolds
- AI reads through each project and generates a summary: what it does, what problem it solves, what tech stack it uses, how complete it is
- Tags projects automatically: one-off vs. repeatable, prototype vs. production-ready, similar use cases grouped together

**Detect patterns and overlaps:**

- Identifies projects that solve similar problems or share overlapping logic
- Flags code that gets reinvented across projects (e.g., three different repos each have their own CSV parser or API client wrapper)
- Groups projects by use case, tech stack, and domain so the user can see the big picture

**Refactor and consolidate:**

- For projects worth keeping, the tool proposes a refactored, scalable version: proper project structure, config externalized, hardcoded values parameterized, reusable functions extracted
- Can merge logic from multiple related projects into one consolidated, well-structured repo
- Suggests turning frequently-used patterns into personal libraries, CLI tools, or templates
- Does the refactoring work for you — not just suggestions, but actual code changes with review/approval

**Personal task assistant layer:**

- Learns from your project history what kinds of problems you solve repeatedly
- When you start a new project, suggests relevant prior work: "You built something similar 3 months ago — want to start from that?"
- Maintains a personal catalog of your reusable building blocks — your own toolkit, built from your own work

## Why Now?

- AI coding assistants have created a project sprawl problem that didn't exist two years ago — people now generate code faster than they can organize it
- LLMs can read and understand codebases well enough to summarize, compare, and refactor code across languages and frameworks
- The shift toward agentic coding means the refactoring can actually be done, not just suggested — the tool can make the changes
- Developers are starting to feel the pain of "I know I built this before, but where?"

## Who Benefits?

- **Primary users:** Developers and power users who actively use AI coding tools and have accumulated a mess of local projects. Solo developers, indie hackers, consultants, and prototypers especially
- **Secondary beneficiaries:** Small teams where multiple people prototype independently and need to consolidate; enterprises wanting to harvest reusable components from internal innovation/hackathon projects

## Existing Alternatives

- **Manual cleanup** — Periodically going through folders and reorganizing. Nobody actually does this
- **GitHub search / local grep** — Can find specific code but doesn't understand what projects do or how they relate
- **Sourcegraph / code search tools** — Built for large codebases, not for discovering and consolidating scattered local projects
- **AI coding assistants themselves** — Can refactor code if you point them at it, but don't scan, discover, catalog, or consolidate across projects

**What's missing:** A tool that treats your entire collection of local projects as a portfolio to be understood, curated, and made useful — not just individual repos to work on one at a time.

## Key Technical Building Blocks

- File system scanner with project detection heuristics (git repos, package.json, requirements.txt, Cargo.toml, etc.)
- LLM-powered code understanding for summarization, use-case extraction, and similarity detection
- AST parsing for structural code analysis (identifying reusable functions, shared patterns, dead code)
- Refactoring engine — either LLM-driven or hybrid (AST transforms + LLM for the hard parts)
- Project graph / catalog UI — visual map of all your projects, their relationships, and reuse opportunities
- Local-first architecture — code never leaves the machine unless the user opts in (privacy is critical for a tool scanning all your code)

## Monetization

- **Freemium** — Scan and catalog for free (up to N projects); refactoring, consolidation, and personal toolkit features are premium
- **Pro tier** — Unlimited projects, advanced refactoring, cross-project merging, personal library generation
- **Team tier** — Shared catalog across a team, deduplication across team members' projects
- **Marketplace** — Users could publish generalized versions of their refactored tools/templates for others

## Open Questions

- Privacy is paramount — how to make users comfortable with a tool that reads all their code? Must be strictly local-first with optional cloud sync
- How deep should the refactoring go? Light touch (parameterize, extract functions) vs. deep (restructure architecture)?
- Language/framework coverage — start with the most common AI-generated stacks (Python, TypeScript, React) and expand?
- How to handle projects that are intentionally throwaway? The tool should know when to leave things alone
- Should it integrate directly with AI coding tools (Claude Code, Copilot, Cursor) to catalog projects as they're created?
- How to handle the "I don't remember what this does" problem for very old projects — is the AI summary enough, or does it need to try running the project?

## Rating — 7.5/10

*Rated: 2026-04-17*

| Dimension | Score | Notes |
|-----------|-------|-------|
| Problem clarity | 9/10 | Extremely relatable for anyone using AI coding tools — project sprawl is a universal pain |
| Market size | 7/10 | Every developer using AI tools, but monetization targets power users and teams. Growing market as AI coding adoption spreads |
| Uniqueness | 8/10 | Nothing does this today. Code search tools exist but none scan, catalog, understand, and refactor across scattered local projects |
| Feasibility | 7/10 | LLMs can summarize and refactor. Cross-project pattern detection is harder but tractable. Local-first architecture adds complexity |
| Monetization | 6/10 | Developer tools are notoriously hard to monetize. Freemium can work, but conversion rates tend to be low. Team tier is more promising |
| Emotional pull | 7/10 | The "I know I built this before" frustration is real and growing. Scratches an itch every prolific coder feels |

**Verdict:** Highly relatable problem with a clear gap in tooling. The market is growing fast as AI coding tools proliferate. Main risk is developer-tool monetization — the per-user revenue may be low unless the team/enterprise tier lands. Could also work as a feature within an existing AI coding platform rather than standalone. Strong candidate for a developer-focused launch.

## Notes / Raw Thoughts

This is a meta-problem created by AI coding tools themselves. The better the tools get at helping you start projects, the worse the sprawl problem becomes. Nobody is solving the "after the prototype" problem — what happens to all those repos after you hit your goal or move on?

Think of it as Marie Kondo for your codebase. Scan everything, understand what sparks joy (or reuse), consolidate the good stuff, and let go of the rest — with the AI doing the heavy lifting.

The personal task assistant angle is powerful: the tool learns what you build repeatedly and pre-loads your next project with your own prior art. Over time it becomes a personalized developer toolkit that grows with you.

Local-first is non-negotiable. Developers will not send all their code to a cloud service. The AI processing needs to happen on-device or with strong guarantees about data handling.
