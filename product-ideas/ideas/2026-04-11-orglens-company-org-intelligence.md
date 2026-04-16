# OrgLens — Company Org Structure Intelligence

**Date:** 2026-04-11
**Category:** ai, productivity, fintech
**Maturity:** raw

## The Problem

When investors, acquirers, and strategists try to evaluate a company, they rely on financial statements, press releases, and surface-level signals. But a company's real DNA — how it's structured, how it's investing in talent, where its bets are — is buried in its careers page. Nobody systematically analyzes this data. Manually reading hundreds of job descriptions across hundreds of companies is impossible. Meanwhile, the patterns are right there: reporting lines, dotted lines, team sizes, new functions being built, functions being cut. This is a gold mine of signal that no one is mining at scale.

## The Idea

An AI-powered intelligence platform that continuously scrapes company careers pages, reconstructs org structures from job descriptions, and correlates those structures with company performance to surface patterns of success and risk.

**Core capabilities:**

- **Org structure reconstruction** — AI parses job descriptions across a company to infer the org chart: who reports to whom, which teams are new, which are growing, which have dotted-line relationships to other functions
- **Pattern matching across companies** — Compare org structures in the same industry, same stage, same size. See which structural patterns correlate with high-performing companies
- **Performance correlation** — Cross-reference org data against public performance signals: earnings, investor relations updates, shareholder reports, analyst coverage for public companies; funding rounds, valuations, press coverage for private ones
- **Trend detection** — Spot structural shifts before they become public knowledge. A sudden spike in "AI Platform Engineer" roles. A consolidation of data and ML into one VP. An aggressive expansion of sales in a new region
- **Signal dashboard** — Track hundreds of target companies, with alerts on meaningful structural changes
- **Best practice library** — Over time, identify "this is what a well-structured Series C fintech looks like" versus "here's the structure of a mature public SaaS company at scale"

**Use cases:**

- **M&A due diligence** — Before acquiring a company, understand its real organizational health, not just what the pitch deck shows
- **Investor research** — Private equity, venture capital, and hedge funds can track portfolio and prospect companies' structural health over time
- **Competitive intelligence** — Understand how competitors are organizing, where they're investing, what they're building
- **Strategic talent planning** — Benchmark your own org structure against successful peers

## Why Now?

- LLMs can reliably parse unstructured job descriptions and extract structured entities (role, reporting line, team, location, seniority)
- Careers pages are public and scrapable at scale with modern infrastructure
- Private market transparency is a huge unmet need — acquirers and investors are desperate for better signals on private companies
- AI-first investing is maturing; funds are hungry for novel data sources that create alpha

## Who Benefits?

- **Primary users:** Private equity firms, venture capital funds, corporate development / M&A teams, hedge funds, strategic investors
- **Secondary beneficiaries:** Management consultants doing org design work; HR strategy teams benchmarking their own structures; executive recruiters; equity analysts

## Existing Alternatives

- **LinkedIn / LinkedIn Sales Navigator** — Shows individual profiles but not synthesized org structure. Doesn't correlate with performance data
- **PitchBook / Crunchbase** — Great for funding and transactional data, but no org structure analysis
- **Manual analysis** — Consultants charging six figures to produce one-off org analyses for clients
- **Job posting aggregators (Indeed, Glassdoor)** — Surface-level counts, no intelligence layer
- **Revelio Labs, Live Data Technologies** — Closest competitors — they do workforce data but focus more on hiring signals than org reconstruction and performance correlation

**What's missing:** A purpose-built intelligence layer that reconstructs org structures from public data and correlates structural patterns with company outcomes — for decision-makers who care about org health, not just headcount.

## Key Technical Building Blocks

- Web scraping infrastructure (respecting robots.txt, rate limits, handling anti-bot measures)
- LLM-powered entity extraction from job descriptions (role, seniority, reporting, team, location, required skills, responsibilities)
- Graph database for representing organizational structures (Neo4j or similar)
- Inference engine for reporting lines and dotted-line relationships (most JDs don't explicitly state "reports to CFO" — it has to be inferred from context, skill overlap, and team mentions)
- Performance data integration — SEC filings (for public cos), press releases, Crunchbase API, PitchBook data
- Change detection and diff engine to track structural evolution over time
- Dashboard and alerting UI for subscribers

## Monetization

- **Enterprise SaaS subscriptions** — Tiered pricing for PE/VC/hedge funds, corporate development teams, consulting firms. High ACV — $50k-$500k+ per year
- **Custom research reports** — On-demand deep-dive reports for specific companies or sectors
- **API access** — For quants and systematic investors who want programmatic access
- **Benchmarking products** — "Is your org structure like a top quartile or bottom quartile company in your sector?" — sold to internal HR/strategy teams

## Open Questions

- Legal landscape around scraping careers pages — hiQ vs LinkedIn precedent matters. Need clear ToS analysis
- How accurately can org structures be inferred from JDs alone? Triangulation with LinkedIn public data may be needed
- What's the minimum viable company coverage? Start with Fortune 500 + top 1000 VC-backed, expand?
- How do you handle companies that deliberately obfuscate their org structure (e.g., Apple's secrecy)?
- Data freshness — careers pages update continuously. What's the right scrape cadence?
- How much of this is "signal" vs "noise"? Needs rigorous validation that org patterns actually predict outcomes, not just correlate

## Rating — 7.5/10

*Rated: 2026-04-11*

| Dimension | Score | Notes |
|-----------|-------|-------|
| Problem clarity | 8/10 | Real gap in investor toolkits — no one is doing org-structure-as-signal systematically |
| Market size | 7/10 | Narrow (high-end investors, M&A teams, consultants) but very high willingness to pay |
| Uniqueness | 8/10 | Revelio and similar do workforce data, but org reconstruction + performance correlation is a differentiated wedge |
| Feasibility | 7/10 | LLMs make JD parsing tractable. Inference of reporting lines is hard but achievable. Legal/scraping risk is real |
| Monetization | 9/10 | Classic high-ACV enterprise SaaS with quants, PE, and M&A as customers. Strong pricing power |
| Emotional pull | 4/10 | B2B, analytical, not emotionally resonant — but the "alpha hunt" appeal for investors is real |

**Verdict:** Strong B2B idea with clear buyers and high ACV potential. The core risk is accuracy of org inference and legal/scraping sustainability. Biggest differentiator would be the performance-correlation layer that closes the loop from structure to outcome. Good fit for someone with a finance/investor network to validate demand early.

## Notes / Raw Thoughts

The key insight: your careers page is your strategy made visible. Every job description is a piece of a much larger puzzle about where the company is going, what it's prioritizing, and how it's organized to execute. Today that puzzle gets assembled in the heads of a few smart investors who read a lot of postings. This would assemble it at scale, for everyone who buys access.

The performance-correlation angle is what elevates this from "interesting data product" to "decision-making platform." If you can say "companies that consolidate data + ML under one VP tend to outperform peers by X%" — that's a real insight investors would pay for.

Good potential to start as a research product (bespoke reports) and graduate into a SaaS platform as the corpus and correlations build up.
