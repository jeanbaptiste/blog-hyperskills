---
title: "Twelve Minutes to Dissect a Legislative Bill"
description: "Auto-UIflex turns a simple question about the Senate agenda into a structured investigation, dynamically generating the right analysis tools for each research phase."
date: "2026-04-10"
author: "@jeanbaptiste"
source: "https://blog.hyperskills.net/enquete-parlementaire.html"
---

# Twelve Minutes to Dissect a Legislative Bill

*Augmented parliamentary inquiry -- Auto-UIflex Case Study*

**Platform:** demos.hyperskills.net
**Subject of inquiry:** Bill #79620 AI & cultural content
**Session duration:** 12 minutes
**UI blocks generated:** 20

---

A journalist opens Auto-UIflex on their smartphone and asks a simple question: "What's happening at the Senate this morning?" Within twelve minutes, they reconstruct the complete ecosystem of a bill on AI and cultural content. The tool doesn't deliver standardised text responses but dynamically generates the appropriate analysis interfaces: identity cards, actor profiles, flow diagrams, parliamentary hemicycles, lobbying tables.

This approach reveals a radically different information architecture. Auto-UIflex exposes its sources and methods -- `render_text`, `query_sql`, `render_sankey` -- along with their execution times. Every response becomes verifiable and reproducible. The process of building information becomes as transparent as its outcome.

In a multi-server MCP environment, this transparency enables systematic cross-referencing of multiple sources. A method that could redefine the standards of journalistic verification, replacing traditional editorial authority with an open and reproducible investigative process.

## Step-by-step investigation method

Ten investigation phases, from the initial question to a complete mapping of actors and verification sources.

### Phase 1 -- Identifying bills on the agenda (07:14)

> *Dis moi en plus sur le truc sur l'ia du 8 avril au senat*

From a general query, Auto-UIflex generates two distinct cards presenting the scheduled parliamentary texts: a bill on public-initiative networks (equalisation) and another on artificial intelligence and cultural content. The interface avoids the standard text list in favour of a comparative visual layout.

`render_text · 34s · 10 tools`

### Phase 2 -- Technical fact sheet of the legislative text (07:14)

Automatic generation of a complete identity sheet: bill type, procedural status, official numbering (79620), associated parliamentary report (#496), reading stage. Metadata is organised into thematic cards: cultural content protection, artificial intelligence, emergency timetable.

### Phase 3 -- Profiling institutional actors (07:16)

A people-focused query yields a structured profile: Laure Darcos (rapporteur), political affiliation (Les Independants), committee assignment (AFCL), parliamentary ID, filing dates. The tool directly queries Senate databases and reconstructs an institutional identity card.

`render_table · 47s · 12 tools`

### Phase 4 -- Strategic stakes analysis (07:18)

A structured editorial synthesis: parliamentary mandates (copyright protection vs AI providers), procedural timetable (7 days for amendments), European dimension (AI Directive, Copyright). The format shifts from factual tables to a forward-looking analysis of political and regulatory tensions.

### Phase 5 -- Mapping influence flows (07:20)

Deployment of a Sankey diagram (8 nodes, 10 flows) modelling the forces at play: creators to protection (100), AI giants to innovation (90), with negative flows for institutional friction. Visualisation of competitive dynamics between AI startups, European regulation, and the French state.

### Phase 6 -- Political composition of the committee (07:21)

A political query answered with a hemicycle. Graphical representation of the AFCL committee by coloured dots: 40 Republicans, 31 UMP (majority), 25 Socialist-Ecologist-Republican, 12 Centrist Union, 10 Left, 10 other groups, 9 RDSE. A standardised parliamentary visualisation format.

`query_sql · 8s · 2 tools`

### Phase 7 -- Flagging documentary limitations (07:23)

Display of a system alert: "Limited information on the origin of the text." Parliamentary databases do not contain detailed signatories. The tool offers three hypotheses (National Assembly origin, indexing gap, cross-cutting text) and exposes the gaps in its own documentation.

### Phase 8 -- Methodological verification guide (07:25)

Facing a documentary gap, the tool switches to methodological guide mode: a list of official sources for continuing the investigation (National Assembly, Senate, full legislative dossier). Turning a limitation into a sourcing opportunity.

`render_text · 33s · 2 tools`

### Phase 9 -- Mapping economic interests (07:25)

A two-column table of sector positions: Google, Meta, Microsoft opposed (training restrictions), SACEM, Societe des Auteurs in favour (protection), publishers Hachette, Gallimard in favour (AI remuneration), Mistral AI, Hugging Face cautious. Systematic classification of actors by direct economic interest.

### Phase 10 -- Ranking lobbying sources (07:26)

Final methodological table: "where to look / presumed influence." EU and HATVP registers (very high influence), committee hearings (high influence), corporate statements and public consultations (medium influence). The tool concludes with a self-contained verification method.

## Technical and methodological observations

### Context-adaptive interface

Each query type generates the appropriate response format: a fact sheet for a text, a profile for a person, a hemicycle for an assembly, a Sankey for relationships. The interface follows the content rather than imposing a standardised format.

### Procedural transparency

Each generation displays its technical tools (`render_text`, `query_sql`), their execution times, and their count. This exposure of the technical "inner workings" enables query reproducibility and third-party verification of methods.

### Explicit uncertainty management

The "limited information" alert is a fully-fledged interface block in its own right. Uncertainty becomes a structured response type, with its own visual codes and alternative methodological suggestions.

### Cumulative session architecture

The block counter (8 to 20) does not reset between queries. Each question stacks on top of the previous one, building a progressive investigation session rather than an isolated question-answer exchange.

## Towards a verifiable information architecture

This twelve-minute session reveals a model of parliamentary investigation where the method becomes as transparent as the outcome. Auto-UIflex doesn't just provide answers -- it exposes the process of their construction.

In a multi-server MCP environment, this approach would enable systematic cross-referencing of multiple sources and cross-verification of information -- a technical answer to the challenge of disinformation through the reproducibility of investigative methods.

---

CC BY-SA 4.0 -- Copyright CERI SAS
