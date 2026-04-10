---
title: "Skills as Digital Commons"
description: "Why skills are digital commons: the hyperskill format encodes complete, portable skills in URLs. Berne Convention, traceability, Ed25519 signatures."
date: "2026-04-10"
author: "@jeanbaptiste"
source: "https://blog.hyperskills.net/hyperskills-as-commons.html"
---

# Skills as Digital Commons

A hyperskill is a URL that contains a complete, portable skill. Not a link to a skill stored on a server somewhere -- the skill itself, encoded in the URL. Any knowledge artifact -- SQL recipe, Markdown guide, agent workflow, UI composition -- becomes shareable, versionable, and ownerless.

## Why skills are digital commons

Digital commons theory, built on Elinor Ostrom's work and adapted for the web, identifies three conditions for a resource to be a commons: it must be **non-excludable** (no one can be prevented from using it), **non-rival** (one person's use doesn't diminish another's), and **collectively governed** rather than controlled by a single owner who can restrict or monetise access unilaterally.

A hyperskill satisfies all three conditions structurally -- not by political declaration, but because the format makes it impossible to be otherwise. It is non-excludable because it lives in a URL anyone with the link can open. It is non-rival because sharing a recipe doesn't degrade it -- a thousand people can use the same skill simultaneously without anyone being worse off. And it has no central owner because the content lives in the URL itself, not on any server that could be taken down, paywalled, or acquired.

> What circulates as a common is not an interface, not a tool -- it's *procedural knowledge*: how to query this dataset, how to structure this workflow, how to compose this view.

This is what distinguishes a hyperskill from a shareable document. A recipe shared as a PDF or a GitHub Gist is a common in spirit -- you can copy it and distribute it. But it requires a platform to host it (GitHub, Google Drive, a file server), an account to access it in many cases, and a human to retrieve and apply it manually. A hyperskill is *executable by an agent*: loading it means the agent can immediately use the knowledge it encodes. The skill is simultaneously its own documentation and its own delivery mechanism.

## Traceability without a central authority

One objection to URL-encoded content is trust: how do you know the skill hasn't been tampered with? How do you track versions? How do you establish authorship? HyperSkills answers all three questions with cryptography, not with a platform.

The **SHA-256 hash** is computed over the source URL concatenated with the content. This means the same content published at two different URLs produces two different hashes -- provenance is part of identity. A hash mismatch tells you immediately that the URL, the content, or both have changed since the hash was computed.

**Version chaining** works like Git commits: each version of a skill can embed the hash of the previous one in its metadata. Following the chain reconstructs the full history of a recipe without any central repository. Any tool implementing the format can verify the chain locally.

**Ed25519 signatures** let authors sign their hashes. The signature is optional -- HyperSkills work without it -- but it provides a strong proof of authorship for skills where that matters (legal, medical, institutional knowledge).

```
# Hyperskill traceability -- all optional but chainable
hash:         a3f7c2d9e1b84f6c...  # SHA-256(source_url + content)
previousHash: 9b1e44f10c723a8d...  # links to previous version
signature:    Ed25519:4a7f...       # author signs the hash
```

This architecture gives HyperSkills something rare: **decentralised provenance**. You can verify the origin and integrity of a skill without trusting any third party. The cryptography is the trust model.

## A skill's lifecycle in practice

The best existing example of HyperSkills in production is [tricoteuses.fr](https://tricoteuses.fr) -- a civic tech platform for querying French parliamentary data. Its SQL recipes circulate as hyperskill URLs. A user who finds a recipe for analysing amendments can open it, see the full SQL in the viewer, adapt it to their needs, and share their modified version as a new URL. The chain of hashes connects all versions without any repository.

Another implementation -- **webmcp-auto-ui** -- shows what this looks like for UI compositions. A user connects the tool to any MCP server, asks a question in natural language, and gets a dashboard assembled from typed blocks (stat cards, charts, tables, timelines). They can then export the entire composition as a hyperskill: the block structure, the data, the MCP server URL, the LLM context, all encoded in a single sharable URL. A colleague opens the URL, gets the same composition against their own data, modifies it, and reshares.

**The key pattern:** In both cases, what circulates is not a screenshot or an export -- it's the procedural knowledge of *how to do the thing*. The skill carries everything needed to reproduce the result in a new context, with new data, without any platform dependency.

## How HyperSkills compare to existing approaches

Every existing approach to sharing AI knowledge has a platform dependency built in. HyperSkills removes it.

| Approach | Self-contained | No platform | Versionable | Agent-executable |
|---|---|---|---|---|
| **HyperSkill URL** | Yes | Yes | Hash chain | Yes |
| GitHub Gist / file | No | GitHub | Git | No |
| Claude Artifacts | No | claude.ai | No | Partial |
| MCP server resource | No | Server required | Depends | Yes |
| Agent Skills folder | No | File system | Git | Yes |
| Prompt library (SaaS) | No | Vendor lock-in | If available | Partial |

The closest relative to a hyperskill is an [Agent Skills](https://agentskills.io) folder -- a directory of instructions and scripts that agents can load. Agent Skills is the recommended format for the *content* of a hyperskill. But a folder requires a file system or a repository. A hyperskill is the URL-portable version: the same knowledge, no infrastructure required.

## Building with HyperSkills

The spec is at [hyperskills.net](https://hyperskills.net), which also includes a live encoder/decoder. Any application can add hyperskill support with a few dozen lines of code: read the `?hs=` parameter on page load, base64-decode it (and decompress if prefixed `gz.` or `br.`), parse the content, and display or execute it. Encoding goes the other direction: serialise, compress if large, base64-encode, append to the current URL.

If you don't want to reimplement the format yourself, the reference implementation is published on npm as [`hyperskills`](https://www.npmjs.com/package/hyperskills) (source: [github.com/jeanbaptiste/hyperskills](https://github.com/jeanbaptiste/hyperskills), licensed CC-BY-SA-4.0 -- Copyright CERI SAS). It is a small zero-dependency ES module that runs in any modern browser and in Node.js >= 18. It exposes the whole format in a handful of functions: `encode(sourceUrl, content, { compress })`, `decode(urlOrParam)`, `hash(sourceUrl, content, previousHash)`, `createVersion()`, plus `sign()`, `verify()` and `generateKeyPair()` for Ed25519 signatures, and `getHsParam()` to read the current browser URL. Install it the usual way:

```javascript
# Install from npm
npm install hyperskills

# Encode a skill, then decode it back
import { encode, decode, hash } from 'hyperskills';

const sourceUrl = 'https://tricoteuses.fr/recettes/analyser_amendements';
const content   = '-- SQL recipe...\nSELECT * FROM assemblee.amendements;';

// gzip compression for larger skills
const url = await encode(sourceUrl, content, { compress: 'gz' });
// -> https://tricoteuses.fr/recettes/analyser_amendements?hs=gz.H4sIAA...

const { url: src, content: skill } = await decode(url);
const h = await hash(src, skill);  // SHA-256(sourceUrl + content)
```

Below is what the decoding path looks like when you reimplement it by hand, without the package -- useful to understand what the `hyperskills` module is actually doing, and to port the format to languages other than JavaScript:

```javascript
// Minimal decode -- works in any browser
async function decodeHyperSkill(url) {
  const param = new URL(url).searchParams.get('hs');
  if (!param) return null;

  if (param.startsWith('gz.')) {
    // gzip-compressed skill
    const binary = Uint8Array.from(atob(param.slice(3)), c => c.charCodeAt(0));
    const ds = new DecompressionStream('gzip');
    ds.writable.getWriter().write(binary);
    return await new Response(ds.readable).text();
  }

  return decodeURIComponent(escape(atob(param)));
}
```

[**webmcp-auto-ui**](https://github.com/jeanbaptiste/webmcp-auto-ui) is one example of a complete implementation built directly on top of the `hyperskills` package. It is a monorepo of browser apps that compose UIs dynamically from any MCP server: an LLM reads the available tools, fetches data, then calls `render_*` tools to assemble a dashboard from typed blocks -- stat cards, tables, charts, timelines, window manager layouts. Each block auto-registers as a live WebMCP tool that agents can read and update. Two of its apps are worth looking at specifically because they show the two sides of the hyperskill lifecycle:

The **viewer** app is a dedicated frontend for a single hyperskill URL. Paste any `?hs=` link and it decodes the content, shows it in context, lets you edit it inline, recomputes the SHA-256, chains the new hash to the previous one, and gives you back a new URL to share. Diff, versioning and SHA-256 chain are all handled client-side -- no backend, no account. It is the clearest existing illustration of a hyperskill as a self-contained editable artifact.

The **composer** (also called *flex*) goes the other direction. You connect it to any MCP server, ask a question in natural language, and an agent loop composes a live dashboard from the typed blocks. Once the dashboard looks right, one click exports the whole composition -- block tree, data bindings, MCP server URL, LLM context -- as a single hyperskill URL. A colleague opens the link, gets the same composition wired to their own data, edits it, and reshares a new URL. What circulates between people is not a screenshot or a dump: it is the full procedural recipe to rebuild the view.

## Skills, hyperskills and the Berne Convention

A natural question, once skills start circulating as URLs, is: who owns them? The answer sits more clearly in copyright law than most people assume. Skills and recipes are *processes*: methods, know-how, sequences of operations. The [Berne Convention](https://en.wikipedia.org/wiki/Berne_Convention) -- the international treaty that harmonises copyright across most of the world -- protects works of the mind in their *expression*, not the ideas or the processes they describe. A skill describes a process: as a rule, it sits outside copyright. Only a particularly original formulation -- specific wording, a distinctive narrative, creative prose around the recipe -- could attract protection, and only for that exact expression. Sharing a skill is sharing common knowledge.

This is what makes the hyperskill format coherent with what it carries. A URL that encodes a procedure is a vehicle for something that was already, by its nature, closer to a public good than to a private work. The cryptographic traceability (SHA-256 chain, Ed25519 signatures) is about *authorship attribution and integrity*, not about ownership: it tells you who wrote this version and that nothing was altered, without claiming any exclusive right over the procedure itself.

**Try it now:** [hyperskills.net](https://hyperskills.net) includes a live encoder and decoder. Paste any text content, get a hyperskill URL. Paste a hyperskill URL, get the decoded content. The [analyser_amendements](https://tricoteuses.fr/recettes/analyser_amendements) recipe from tricoteuses.fr is a real production example.

---

CC BY-SA 4.0 -- Copyright CERI SAS -- 2026
