---
title: "The Dance of Know-how in the Age of AI"
description: "Hyper-recipes as the medium of the post-LLM web. Skills travel as URLs, every layer stays legible."
date: "2026-04-10"
author: "@jeanbaptiste"
source: "https://blog.hyperskills.net/the-dance-of-know-how.html"
---

# The Dance of Know-how in the Age of AI

*Hyper-recipes as the medium of the post-LLM web.*

I want to describe something that does not exist yet and should.

For three years now, the industry has settled on a single answer to the question of what the right form of interaction with an LLM looks like. A chatbot. A text rectangle in a window. You type, the agent answers. Sometimes it calls a tool behind the curtain and rephrases the result. In every case, it is a process in a box and you stay on the other side.

We are watching a ballet. We are not dancing.

The web of 1994 had the same problem before Mosaic (the first web browser). Gopher worked. Nobody remembers it because what came after was more relevant. The chatbot in its current form is the Gopher of the post-LLM web. It will function for a few years. Then something different will appear.

I want that new paradigm to be a commons, not a rent. That is why I am writing this.

## 1. A scene that contains the whole problem

A parliamentary assistant in Paris. Her deputy sits on the Social Affairs committee. Tomorrow morning they examine a bill on disability. Before 6pm she needs to produce a document showing four things: who filed which amendments on this topic in six months, how each group voted, which associations were heard, and a comparison with the previous three parliaments.

She has three options. Everything by hand -- four hours, an unreadable spreadsheet. A proprietary tool -- several thousand euros a year, she sees what the vendor decided to show her. Or a chatbot -- the table comes out clean, but she cannot modify it, cannot share it interactively, and cannot verify where the numbers come from.

None of the three is enough. And they all miss the problem for the same reason.

The real problem is not how to answer the question. It is how to produce together an object that will outlive the conversation. An object a human thought up, an agent helped compose, that another human can open, modify, archive, and verify. What is missing is not a smarter AI. It is *the object*.

## 2. The missing object

I call it a hyper-recipe. Its properties are as follows.

It contains a composed state. One or more widgets, each tied to a data source, in a certain order, with certain possible interactions between them. Not a conversation. A state.

It is addressed by its content. Two identical hyper-recipes have the same address. Change one character and the address changes. This is what git does for commits, IPFS for files.

It fits in a URL. Literally. A string of characters you send by SMS, paste into an email. The link is the object, encoded. When you click, your browser decodes and reconstructs the state. No hyper-recipe server. No database.

It can be modified. You receive a hyper-recipe from a colleague. You open it. You change a widget. You freeze a new version. The new version knows the old one by its hash. The chain is traceable.

It survives. Its author. Its server. The tool that composed it. Like a static HTML page from 1996, it will open in twenty years provided the data sources it references are still there. This object is not new. It is what Ted Nelson called a hypertextual object in 1965.

## 3. The web we lost without deciding to

The web of 1994-2005 had a property we have forgotten. Anyone could publish a page on shared hosting for fifty francs a month. Anyone in the world could read it without permission. That web was distributed, egalitarian, persistent.

We lost all that. Not by decision. By accumulation of small commercial choices that each seemed reasonable. You publish a photo on Instagram -- it is not your photo, it is a representation hosted at Meta. Same for your Google Docs, your Notion pages, your ChatGPT artifacts. Every object you produce with a modern tool is hosted, not hypertextual. If the tool disappears or bans you, the object disappears.

The post-LLM web, as it is settling in before us, reproduces this slide one layer up. Your conversations with LLMs are hosted. Your artifacts are hosted. When you share an artifact with a colleague, you share a link pointing to a proprietary server that may change tomorrow.

I want the other web. Not identically. Its topology, applied to a new object: the composition of interaction between a human, an agent and data.

## 4. The five-year test

Take a Claude artifact you liked. Note the date. In five years, will it still be accessible exactly as you published it? The honest answer is no. The infrastructure will have changed. Retention policies will have been revised.

Now take a static HTML page written in 1996. In almost every case it opens today exactly as it did then. Not because the infrastructure was preserved -- the infrastructure is dead. It opens because the object carries everything it needs to render itself.

That self-sufficiency defines hypertext. Not the presence of links. Not the formatting. The capacity of an object to exist without its origin server. A hyper-recipe is an HTML page from 2026 enriched with a connection to data and an agent. Everything else follows from that.

## 5. Why now

Two ingredients were missing. They arrived together in 2024-2026.

The first is the Model Context Protocol, or MCP. Anthropic published it in late 2024. JSON-RPC over HTTP, about fifteen methods. Its spec fits in a few pages. Its importance is not in the technology -- it is in the fact that it was adopted. Hundreds of public MCP servers exist today: French parliamentary data, iNaturalist observations, Hacker News archives, data.gouv, Wikipedia, OpenStreetMap. Before MCP, exposing a data source to an agent was custom work. After MCP, it is a standard exercise.

The second is WebMCP. The browser-side counterpart. A web page can expose its components as tools, symmetrically. The W3C published a draft in spring 2026. Chrome Canary 146 is beginning to implement it natively. With WebMCP, the interface itself exposes its capabilities -- the agent can interact with the interface in a structured way, not just display results.

These two building blocks change what is possible inside a web page. And they are so recent that the right abstractions above them are not yet settled. The industry has not decided. This is a window. I want to write in that window before it closes.

## 6. Bellard's standard

Before going into the code, a quality standard. Without one, everything above is just positioning.

Fabrice Bellard understood what *making things simple* means when it could be confused with making them less. TinyCC is a complete C compiler in 100 KB. It compiles all of C89 and most of C99. Its generated code is slower than GCC's -- but it compiles the same language. It does not say *I don't support unions*. QuickJS implements the full ES2023 and passes test262 at over 99%. What it loses against V8 is speed on hot loops. It does not say *I implement a subset*.

The pattern is always the same: do the same thing as the incumbent, or more, in a hundred times less code, with a hundred times fewer dependencies, without cutting the functional surface. What Bellard compresses is the implementation. What he never cuts is the spec.

That is the discipline needed to build an honest post-LLM web. The easy temptation, when building a new system, is to reduce ambitions to simplify. Remove a feature to fit in a demo. Work around an edge case to ship faster. Each cut seems reasonable. Together they rebuild mediocrity.

This is the rule I impose on `webmcp-auto-ui`. The `core` package is 2569 lines of TypeScript. Zero runtime dependencies. It implements the 17 MUST features from the W3C WebMCP draft of March 27, 2026, plus an MCP Streamable HTTP client, plus a JSON Schema validator. The equivalent official SDK, with its dependencies, weighs ten times more for comparable coverage. I claim this difference as an ethical position, not a technical feat.

Emmanuel belongs to the same lineage. His twenty years working on French public data commons -- OpenFisca, data.gouv, now Moulineuse and Tricoteuses -- is marked by the same economy of means and the same rigor.

## 7. Four blocks of context

When an LLM agent receives its system prompt, that prompt contains a description of what it can do. The usual form is a flat list of tools. This causes a problem that is invisible at ten tools and becomes painful at thirty -- the tools are not of the same type. A tool that queries a parliamentary database and a tool that displays a chart share nothing, except that they are callable.

In `webmcp-auto-ui`, the context is structured into four named blocks.

```
mcp.tools       tools exposed by connected MCP servers
mcp.recipes     pre-written recipes provided by those servers
webmcp.tools    UI components registered locally via the polyfill
webmcp.recipes  view-composition recipes
```

This structure materializes the data/view separation directly inside the prompt. An agent reading this context understands in one pass that `mcp.*` serves to *obtain* information and that `webmcp.*` serves to *display* information. One thing to remember: **the structure of the system prompt teaches the agent the architecture of the system.**

## 8. Recipes -- on both sides

A recipe is an object, whatever its exact format, that helps the agent do something better, faster, or with fewer errors when tools are involved. That is all. No complicated ontology. A recipe is an executable aide-memoire.

Recipes exist on both sides of the symmetry. On the MCP side, the Moulineuse server exposes pre-written recipes for common parliamentary queries. An agent can call `top_votes_par_groupe` without knowing how to build the underlying SQL query. On the WebMCP side, a view recipe describes how to compose components for a recurring use case.

A practitioner who has spent three years analyzing parliamentary data knows better than any developer how to present that data. If you ask them to write JavaScript, they will not do it. If you ask them to edit a twenty-line YAML file following a template, they will.

## 9. Composing a view, concretely

You open `demos.hyperskills.net/flex`. If it is your first time, you choose a model: Claude Haiku running on Anthropic's servers, fast but requires an API key; or Gemma 4 E2B running entirely in your browser, free but requires an initial 2GB download. You choose Gemma for sensitive data, Haiku when you want speed.

You type your intention in the chat: *Show me the votes from the last three divisions in the National Assembly by political group, with a chart and a timeline.*

The agent reads. It consults its four context blocks. It builds a plan. You don't see this plan -- it stays internal. What you see is the result appearing progressively on the canvas. A title. A bar chart. A timeline. The vertical bar chart does not work for you -- the group names are long. You click on it. A menu appears. You choose horizontal bars. The widget transforms instantly. No need to speak to the agent. Direct manipulation.

You click *Freeze this skill*. A modal appears. Size: 12 KB raw, 4 KB gzipped. Full URL: `https://demos.hyperskills.net/flex/?hs=` followed by a long base64 string. You copy the URL. You send it to your deputy via Signal.

Three hours later, your deputy clicks. Their phone opens the browser. The browser decodes the URL, reconstructs the state. They see exactly what you froze. The interface is in consumer mode by default -- no chat, no distracting panels. They click *Composer mode*, type their request, freeze a new version, send you the URL back.

## 10. The lineage

If you know the history of hypertextual ideas, you will have recognized several patterns. I am deliberately positioning myself within a lineage.

**Ted Nelson** named hypertext in 1965. His dream -- Xanadu -- was a system of universal interconnection where any document could transclude any other, with version and author traceability. Berners-Lee's web realized a more modest version, and that is precisely why it was adopted. But Nelson was right about the essential: a digital object should know its origins and survive its servers. The hyper-recipe is an attempt to recover that property without waiting for Xanadu.

**Tim Berners-Lee** made concrete in 1989 what Nelson dreamed. The choices he made were criticized -- no transclusion, no versioning, unidirectional and breakable links. But those choices let the web spread. In 2016, he created Solid to rebuild a web where users own their data in personal pods. Solid did not reach mass adoption. I share Solid's ambition and apply it to a slightly different object: not ownership of data, but ownership of compositions of interaction.

**Bret Victor** did not create a protocol. He wrote, spoke, made demos. His essays between 2011 and 2019 -- *Learnable Programming, Magic Ink, Up and Down the Ladder of Abstraction, Seeing Spaces* -- form a critical body of work on the mediocrity of contemporary interfaces. Victor reproaches development tools for forcing a detour through text. In his tools, you manipulate the representation directly. My debt to Victor is the direction: direct manipulation of widgets, no detour through a code editor, immediate feedback.

**Alan Kay** is behind almost all of what precedes. Smalltalk at Xerox PARC in the 1970s. The Dynabook, which in 1972 described a portable personal computer for children's education, twenty years before technology made it possible. The notion of the computer as medium, not as tool. Kay is a fierce critic of ambient mediocrity and a tireless defender of intellectual ambition in designing digital tools. My debt to him is, simply, the conviction that it should be better. Not a little better. A lot better.

**Christopher Alexander**. *A Pattern Language* in 1977. *The Timeless Way of Building* in 1979. His thesis: the inhabitants of a building must be involved in its design, because they know things about their daily lives that the architect cannot guess. The architect's role is not to design for them but to provide a vocabulary of possibilities -- the patterns -- and accompany them in their choices. This is a political position on the power to design one's environment. It applies to digital tools.

**Ivan Sutherland**. *Sketchpad* in 1963. *The Ultimate Display* in 1965. Sutherland wrote that the role of a display is to be a looking-glass into a mathematical wonderland. An object that lets you become familiar with concepts that have no equivalent in the physical world. His deeper thesis is that the computer serves to understand things you cannot understand without it -- not to automate tasks you would do without it, only slower. Hyper-recipes, at their best, are this kind of looking-glass. A parliamentary assistant composing a view is not doing a job she would do by hand more slowly. She is doing a job she could not do at all without this tool.

**Emmanuel**. For the initial framing. The `component()` refactor of April 8. The MCP/WebMCP symmetry of recipes. Specification rigor. Twenty years of work on French public data commons. The stubbornness to name patterns he sees rather than be carried by fashion. This text and this project would not take this form without him.

## 11. What remains to do

I have not solved everything. The line-by-line audit of the `core` polyfill. The 2569 lines claim to cover the 17 MUST features of the W3C draft -- nobody has verified this claim feature by feature. I need to add a coverage trace, either in structured comments in the code or in a separate document.

The portability of the UI contract beyond Svelte. Today the `ui` package is entirely Svelte. For the project to be adoptable beyond Svelte developers, the contract that an alternative implementation -- React, Vue, vanilla -- must respect needs to be documented. This contract should live separately, as a document, not as code.

Public measurements. The README contains no numbers. Minified size compared to the official MCP SDK. Spec coverage. Number of dependencies per package. Typical size of a hyper-recipe in bytes. Without these numbers, nobody can judge the project without reading all the code. It is anti-Bellardian in the communication.

The full-scale test. The target is the National Assembly hackathon. A demo where parliamentarians, assistants and administrators compose together, freeze, share. If this demo runs before a hundred people without collapsing and without prior explanations, the project has passed its test.

## Epilogue

Sutherland wrote in 1965 that a computer screen can be a looking-glass into a mathematical wonderland. A window into things you cannot know otherwise.

I believe hyper-recipes can be a window into another territory. Not mathematical. Civic. A window into public data you cannot understand without tools, and which today's proprietary tools present in the form that serves their own interests.

I want this mirror built in common. I want it to outlive its authors. I want it simple enough for a parliamentary assistant to use without training, and open enough for a programmer to extend without asking permission.

The code is at [github.com/jeanbaptiste/webmcp-auto-ui](https://github.com/jeanbaptiste/webmcp-auto-ui). The demos are at [demos.hyperskills.net](https://demos.hyperskills.net). The format spec is at [hyperskills.net](https://hyperskills.net).

If you read this and you see what I see, write to me. The project is small. It can grow.

---

## References

- Ivan E. Sutherland, [The Ultimate Display](https://worrydream.com/refs/Sutherland_1965_-_The_Ultimate_Display.pdf), IFIP Congress, 1965.
- Ted Nelson, [Project Xanadu](http://www.xanadu.com), since 1965.
- Christopher Alexander, *A Pattern Language*, Oxford University Press, 1977.
- W3C, [WebMCP Working Draft](https://www.w3.org/TR/webmcp/), March 27, 2026.
- Anthropic, [Model Context Protocol](https://modelcontextprotocol.io), November 2024.
- Emmanuel Raviart, [Moulineuse](https://github.com/eraviart/moulineuse) -- MCP server for French parliamentary data.
- Hackerspaces, [Design Patterns](https://wiki.hackerspaces.org/Design_Patterns).
- Lucy Suchman, *Plans and Situated Actions*, Cambridge University Press, 1987.

---

CC BY-SA 4.0 -- Copyright CERI SAS
