---
title: "Three Ways to Integrate Your Components with webmcp-auto-ui"
description: "Integration guide for webmcp-auto-ui: create a WebMCP server with Svelte, integrate native widgets, or build a Material UI library."
date: "2026-04-11"
author: "@jeanbaptiste"
source: "https://blog.hyperskills.net/webmcp-tutorials.html"
---

# Three ways to integrate your components with webmcp-auto-ui

Documentation — Phase 8 · v2.1.1

Create a WebMCP server with Svelte, integrate native widgets into your existing project, or build a Material UI library — three approaches, one protocol.

Published April 11, 2026 · By [@jeanbaptiste](https://github.com/jeanbaptiste) · v2.1.1

**Table of contents:**

1. **Svelte components** — Build a full WebMCP server with your own Svelte widgets
2. **Native autoui integration** — Drop native widgets into your existing project
3. **Material UI server** — Build your own designkit_webmcp_* library

---

## Tutorial 01 — Add your own Svelte components

Create a WebMCP server with your Svelte widgets and expose them to the LLM through recipes — from component to system prompt in five steps.

### Step 01 — Install packages & create the structure

Add `@webmcp-auto-ui/core` for `createWebMcpServer` and `@webmcp-auto-ui/agent` for the agent loop and the built-in `autoui` server.

```bash
npm install @webmcp-auto-ui/core @webmcp-auto-ui/agent
```

```
src/
  widgets/
    KanbanBoard.svelte   # your component
    kanban.recipe.md     # the recipe for the LLM
    Timeline.svelte
    timeline.recipe.md
  server.ts              # WebMCP server definition
  main.ts
```

> The recipe is for the LLM, the component is for rendering. They stay separate until `registerWidget`.

### Step 02 — Write the component Props interface

The TypeScript `Props` interface is the **single source of truth**. The JSON schema is auto-generated via `ts-json-schema-generator` — never write it by hand.

```svelte
<script lang="ts">
  // Source of truth → JSON schema auto-generated from here
  interface Props {
    title:    string;
    columns:  Array<{
      id:     string;
      label:  string;
      cards:  string[];
    }>;
    theme?:   'light' | 'dark';
    compact?: boolean;
  }
  let { title, columns, theme = 'light' }: Props = $props();
</script>

<section class={theme}>
  <h2>{title}</h2>
  {#each columns as col}
    <div class="column">...</div>
  {/each}
</section>
```

> `ts-json-schema-generator` reads pure TypeScript — compatible with Svelte 5, React, Vue and any framework exposing a TS Props interface.

### Step 03 — Create the recipe `.md`

The frontmatter `schema:` is auto-injected. Write only the body — your documentation for the LLM. The `widget:` field is required.

```markdown
---
widget: KanbanBoard
description: Kanban board with draggable columns and cards,
  ideal for a workflow or agile backlog.
schema: <auto-injected by sync:schemas>
---

## When to use this widget
Display a backlog or any set of tasks organized into columns.

## How to fetch data
Call `myproject_mcp_get_tasks`, map by status into `columns[]`.

mywidgets_webmcp_widget_display({
  name: "KanbanBoard",
  params: {
    title: "Sprint 4",
    columns: [
      { id: "todo",  label: "To do",        cards: ["Task A"] },
      { id: "doing", label: "In progress",  cards: ["Task B"] }
    ]
  }
})
```

> `widget_display` takes `name` and `params` — not a single merged object.

### Step 04 — Register the WebMCP server

Associate recipe + component in `server.ts`, then add the layer to the agent loop.

```ts
// server.ts
import { createWebMcpServer } from '@webmcp-auto-ui/core';
import kanbanRecipe   from './widgets/kanban.recipe.md';
import timelineRecipe from './widgets/timeline.recipe.md';
import KanbanBoard    from './widgets/KanbanBoard.svelte';
import Timeline       from './widgets/Timeline.svelte';

export const mywidgets = createWebMcpServer('mywidgets', {
  description: 'My Application Svelte Widgets'
});

mywidgets.registerWidget(kanbanRecipe,  KanbanBoard);
mywidgets.registerWidget(timelineRecipe, Timeline);
```

```ts
// main.ts
import { runAgentLoop, AnthropicProvider, autoui } from '@webmcp-auto-ui/agent';
import { mywidgets } from './server';
import myDataClient from './data-client';

const result = await runAgentLoop('Show the board', {
  provider: new AnthropicProvider({ proxyUrl: '/api/chat' }),
  layers: [
    myDataClient.layer(),  // mydata_mcp_*   → data
    autoui.layer(),        // autoui_webmcp_* → native widgets
    mywidgets.layer(),     // mywidgets_webmcp_*  → your widgets
  ],
  callbacks: {
    onWidget: (type, data) => renderWidget(type, data),
    onText:   (text)       => appendText(text),
  },
});
```

> The LLM will automatically see `mywidgets_webmcp_search_recipes`, `mywidgets_webmcp_get_recipe` and `mywidgets_webmcp_widget_display`.

### Step 05 — Sync schemas & validate in CI

Fully automated pipeline — one source of truth from dev to LLM.

**Flow:**

1. `interface Props` — you write here
2. `npm run sync:schemas` ↓
3. `recipe.md frontmatter.schema` — auto-injected
4. ↓ consumed by
5. `get_recipe · widget_display · search_recipes` — read & validated

```bash
# Development — injects schemas into .md files
npm run sync:schemas

# CI — fails if .md files are out of sync
npm run sync:schemas --check
```

---

## Tutorial 02 — Integrate the native autoui widgets

Use the `autoui` server built into `@webmcp-auto-ui/agent` to access all 31 native widgets without configuring a custom WebMCP server.

### Step 01 — Install the agent package

`@webmcp-auto-ui/agent` directly exports `autoui` — a pre-configured WebMCP server with all native widgets registered (stat, table, chart, timeline, hemicycle...).

```bash
npm install @webmcp-auto-ui/agent
```

```ts
// immediate usage
import { autoui } from '@webmcp-auto-ui/agent';

// autoui = WebMcpServer with all native widgets already registered
const layer = autoui.layer();
// → { protocol: 'webmcp', serverName: 'autoui', tools: [...] }
```

### Step 02 — Connect the agent with `runAgentLoop`

`runAgentLoop` takes the user message as its first argument, then an options object.

```ts
// agent.ts
import { autoui, runAgentLoop, AnthropicProvider } from '@webmcp-auto-ui/agent';
import monApi from './api-client';

const result = await runAgentLoop('Show me sales data', {
  provider: new AnthropicProvider({ proxyUrl: '/api/chat' }),
  layers: [
    monApi.layer(),   // myapi_mcp_*   → your data
    autoui.layer(),   // autoui_webmcp_* → 31 native widgets
  ],
  maxIterations: 5,
  callbacks: {
    onWidget: (type, data) => {
      // type = widget name, data = validated parameters
      renderWidget(type, data);
      return { id: 'widget-1' };
    },
    onText: (text) => appendToChat(text),
  },
});
```

> `onWidget` replaces the old `onBlock` (deprecated alias). It receives the type and schema-validated data.

### Step 03 — Set up the SvelteKit API proxy

`AnthropicProvider` sends requests to a local endpoint that holds the API key.

```ts
// src/routes/api/chat/+server.ts
import { env } from '$env/dynamic/private';
import type { RequestHandler } from './$types';

export const POST: RequestHandler = async ({ request }) => {
  const body = await request.json();
  const apiKey = body.__apiKey || env.ANTHROPIC_API_KEY;
  delete body.__apiKey;
  const res = await fetch('https://api.anthropic.com/v1/messages', {
    method: 'POST',
    headers: {
      'x-api-key': apiKey,
      'anthropic-version': '2023-06-01',
      'Content-Type': 'application/json',
    },
    body: JSON.stringify(body),
  });
  return Response.json(await res.json());
};
```

> The key is read from `ANTHROPIC_API_KEY` in `.env`, or passed at runtime via `body.__apiKey`.

---

## Tutorial 03 — Build a WebMCP server with Material UI

Build your own MUI component library and expose it as a distinct `designkit_webmcp_*` server.

### Step 01 — Install dependencies

```bash
npm install @webmcp-auto-ui/core @webmcp-auto-ui/agent \
         @mui/material @emotion/react @emotion/styled \
         @mui/x-data-grid
```

### Step 02 — Create a React component with a Props interface

The TypeScript interface is the source of truth for the JSON schema — same principle as Svelte.

```tsx
// widgets/DataTable.tsx
import { DataGrid } from '@mui/x-data-grid';
import Typography   from '@mui/material/Typography';

// Source of truth → JSON schema auto-generated from here
export interface DataTableProps {
  rows:      Record<string, unknown>[];
  columns:   Array<{ field: string; headerName: string; width?: number }>;
  title?:    string;
  pageSize?: number;
}

export function DataTable({ rows, columns, title, pageSize = 10 }: DataTableProps) {
  return (
    <div style={{ padding: '16px' }}>
      {title && <Typography variant="h6" gutterBottom>{title}</Typography>}
      <DataGrid rows={rows} columns={columns}
        pageSize={pageSize} autoHeight disableSelectionOnClick />
    </div>
  );
}
```

### Step 03 — Create the recipe & sync the schema

```markdown
---
widget: DataTable
description: MUI grid with pagination
  and sorting.
schema: <auto-injected>
---

## When to use
Long lists with sorting.

## Data
Fetch via `*_mcp_list_*` → `rows[]`.
```

```bash
npm run sync:schemas

# CI check
npm run sync:schemas --check
```

> CI fails if `DataTableProps` diverges from the `schema:` in the `.md`.

### Step 04 — Create the designkit server

```ts
// designkit-server.ts
import { createWebMcpServer } from '@webmcp-auto-ui/core';
import dataTableRecipe from './widgets/data-table.recipe.md';
import { DataTable }   from './widgets/DataTable';
import { setMuiTheme } from './theme';

export const designkit = createWebMcpServer('designkit', {
  description: 'Material Design components (DataTable, Dialog...)'
});

designkit.registerWidget(dataTableRecipe, DataTable);

// Custom tool — called directly by the LLM
designkit.addTool({
  name: 'theme',
  description: 'Switch between light and dark Material theme',
  inputSchema: { type: 'object',
    properties: { mode: { enum: ['light', 'dark'] } },
    required: ['mode']
  },
  execute: async ({ mode }) => setMuiTheme(mode)
});
```

### Step 05 — Assemble the layers & watch the LLM in action

Three servers coexist in the same loop. The LLM sees all of them and picks the right one based on context.

```ts
// main.ts
import { runAgentLoop, AnthropicProvider, autoui } from '@webmcp-auto-ui/agent';
import { designkit } from './designkit-server';
import myApiClient from './api-client';

const result = await runAgentLoop("Show this month's orders", {
  provider: new AnthropicProvider({ proxyUrl: '/api/chat' }),
  layers: [
    myApiClient.layer(),  // myapi_mcp_*      → business data
    autoui.layer(),       // autoui_webmcp_*   → 31 native widgets
    designkit.layer(),    // designkit_webmcp_* → your MUI components
  ],
  callbacks: {
    onWidget: (type, data) => renderWidget(type, data),
  },
});
```

**Automatic LLM call sequence:**

```js
designkit_webmcp_search_recipes({ query: "table" })
designkit_webmcp_get_recipe({ name: "DataTable" })
myapi_mcp_list_orders({ month: "2026-04", limit: 100 })
designkit_webmcp_widget_display({
  name:   "DataTable",
  params: {
    title: "Orders — April 2026",
    rows: [...],
    columns: [
      { field: "id",     headerName: "#",       width: 80  },
      { field: "client", headerName: "Client",  width: 200 },
      { field: "total",  headerName: "Total $", width: 120 },
    ]
  }
})
// → your MUI component renders via onWidget
```
