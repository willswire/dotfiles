---
name: jira-issue-writer
description: Writes Jira issue descriptions in the user's preferred house style — a fenced code block of Jira wiki markup with two sections: "h2. Background" (a fast 0-to-100 overview so any senior engineer can pick up the work cold) and "h2. DoD" (Definition of Done — the concrete deliverables). It also proposes a Summary/title and recognizes STUB tickets (a skeleton with bracketed placeholders when context is thin) and SPIKE tickets (time-boxed investigation/discovery work). Use this skill whenever the user asks to create, write, draft, format, or "turn notes into" a Jira issue, ticket, story, task, bug, STUB, or SPIKE — even if they just paste a dump of context and say "make this a ticket."
---

# Jira Issue Writer

Turn a dump of context into a clean, pick-up-able Jira ticket in the user's house style.

## Who this is for

The user is the tech lead of a small platform/infra team of senior engineers. The audience for every ticket is **senior platform engineers and senior software developers** — peers and reports who are deeply fluent technically but who may have **zero prior context on this specific task**. Write peer-to-peer: skip the 101-level explanations of what Kubernetes or CI is, but never assume the reader was in the room when the work was scoped. The whole point of the Background section is that someone can grab the ticket cold and get moving.

## The output

Produce **two things**, in this order:

1. **A suggested Summary** (the ticket title) on its own line, so it's easy to copy into the Summary field. Keep it short, specific, and imperative — what the ticket accomplishes, not a vague topic. Prefix it when the ticket is a STUB or SPIKE (see "Ticket types").

2. **The description**, inside a fenced code block, written in **Jira wiki markup** (the `h2.`-style notation, not Markdown). The code block matters: it lets the user copy the raw markup straight into Jira's text field without the chat client reinterpreting it.

The description always has exactly these two sections, in this order:

```
h2. Background

<prose>

h2. DoD

 - <deliverable>
 - <deliverable>
```

### Background

A tight, 0-to-100 narrative that orients a fresh reader: what's the situation, why does this ticket exist, what's the relevant history, and what's at stake or blocked. Favor a short paragraph (or two) of prose over bullets — Background is a story, not a checklist.

Lean on the reader's seniority for *technical* depth, but spell out the *situational* context they can't infer: which related ticket this came out of, who agreed to what, what's blocking what. Concretely:
- Reference related tickets by key (e.g. `TFN-323`) — Jira auto-links bare keys.
- Mention people with `[~username]` only when the user supplies the Jira username explicitly. If only a real name is given, write the person's name in plain text and append a bracketed placeholder, e.g. `Dr. Joe Bob [~username]`. Never guess or infer a username from a real name — a wrong mention silently notifies the wrong person.
- Use the team's real acronyms and project shorthand as-is; the audience knows them.

### DoD (Definition of Done)

The expected deliverables / outcomes — what must be true for this ticket to be closed. This is a bulleted list. Match the user's bullet style exactly: a leading space, then `- `, then the item:

```
 - Perform discovery on X
 - Demo Y working end to end
 - Write and get sign-off on an EDD/ADR for Z
```

Keep each item outcome-oriented and verifiable ("Demo deploying the template with the new approach"), not a vague activity ("look into secrets"). Aim for the smallest set of bullets that fully defines "done."

## Ticket types

Decide the type from the work itself, and reflect it in the Summary prefix. Default prefix style is `PREFIX: <title>` — but this is the user's convention, so confirm it if unsure rather than assuming a different delimiter.

- **Normal ticket** — concrete, well-understood implementation work. No prefix.
- **SPIKE** — time-boxed **investigation / discovery / proof-of-concept** work whose output is *knowledge or a decision*, not shipped functionality. Tells: the ask is to "figure out," "evaluate," "explore," "prototype," or to produce an EDD/ADR/recommendation. Prefix the Summary with `SPIKE`. The DoD for a spike is usually findings, a demo, and/or a written-and-accepted decision doc. SPIKEs almost always result in follow-on tickets being created for any implementation work uncovered -- include "Create follow-on tickets for implementation work identified" as a DoD item. Do not put production code in a SPIKE DoD.
- **STUB** — used when **there isn't enough context yet to write a complete ticket.** Capture the skeleton of what's known and drop **bracketed placeholders** for everything that still needs refinement, e.g. `[link to the ADR once it exists]` or `[confirm with ~ericwyles whether this blocks TFN-323]`. The placeholder should name *what's missing and who/what resolves it*, so a future editor knows exactly what to fill. Prefix the Summary with `STUB`.

A ticket can be thin *and* investigative — if so, lead with the prefix that's most useful to the user (usually `STUB`, since incompleteness is the more urgent signal) and let the bracketed placeholders carry the rest.

### When context is thin

This is the common case for STUBs. Don't stall by interrogating the user — draft the STUB with everything you *do* know in place, and use bracketed placeholders for the gaps. A good STUB is immediately useful: it preserves the context the user has in their head right now (which is otherwise lost), and makes the remaining unknowns explicit and assignable. Brackets render as link-ish text in Jira; that's fine and actually makes placeholders stand out, but keep their content plain so it's obvious they're TODOs, not real links.

## Jira wiki markup cheat sheet

Use only what the content needs — don't decorate.

| Element | Markup |
| --- | --- |
| Heading 2 | `h2. Title` |
| Bold / italic / strikethrough | `*bold*` `_italic_` `-strike-` |
| Bullet list | `- item` (the user prefers a leading space: ` - item`) |
| Numbered list | `# item` |
| Inline code / code block | `{{code}}` / `{code}...{code}` |
| Link | `[text|https://url]` |
| User mention | `[~username]` |
| Issue reference | bare key like `TFN-323` (auto-links) |
| Quote | `{quote}...{quote}` |

Note on strikethrough: `-text-` renders as struck-through. Use it only when the *content* genuinely calls for showing a correction (e.g. "we moved from -approach A- to approach B"). Do not leave editing scaffolding in a finished ticket unless the strike is meaningful to the reader.

## Worked example

This is the target quality and shape. Note the imperative, outcome-focused DoD and the Background that explains the history and the blocking relationship without assuming the reader knew any of it.

**Summary:** `SPIKE: Adopt ClusterExternalSecret/ClusterSecretStore for UDS Packages`

**Description:**

```
h2. Background

While creating the Argo Workflow Tenant for M&SWP in TFN-323, I ran into limitations around External Secret CRs. Eric and I agreed to pursue the conversation on shifting to ClusterExternalSecret and ClusterSecretStore resources for UDS Packages in PBME. This will be blocking for TFN-323, unless SUBMEPP wishes to prioritize this effort (in which case we will implement a workaround solution in the Argo Workflow Template to incorporate the existing pattern for External Secrets).

h2. DoD

 - Perform discovery work on copying the approach for DBeaver + UDS Tofu Provider for External Secrets
 - Demo deploying the Mission App Template with this new approach
 - Write, propose and accept an EDD/ADR on the new ClusterES/SS approach
 - Create follow-on tickets for any implementation work identified
```

## Writing style

Never use em-dashes (--) in the ticket output. Use a comma, semicolon, parentheses, or restructure the sentence instead. This applies to both Background prose and DoD bullets.

## Process

1. Read the user's notes and identify: the core ask, the type (normal / SPIKE / STUB), related tickets, people, and what "done" means.
2. Draft the Summary (with prefix if needed).
3. Write Background as orienting prose, then DoD as outcome bullets.
4. Output the Summary line, then the description in a fenced code block.
5. If anything material is genuinely unknown and the ticket can't stand without it, prefer a STUB with bracketed placeholders over guessing -- but fill in everything you reasonably can first.
