---
name: figure-notation
description: Mermaid notation for figures in technical documents — diagram type per content shape. Read on demand when a document will carry a figure. Whether a figure is warranted is decided by technical-document.md §4-5 and §15-1.
---

# Figure Notation

Figures are Mermaid in a fenced ` ```mermaid ` block, inline. Do not also commit a rendered image.

| Content shape                             | Mermaid type                |
| ----------------------------------------- | --------------------------- |
| Time × actor, message ordering            | `sequenceDiagram`           |
| State × event, allowed transitions        | `stateDiagram-v2`           |
| Boundary × dependency, what contains what | `flowchart` with `subgraph` |
| Branching on conditions                   | `flowchart TD`              |
| Entities and their relations              | `erDiagram`                 |
| Duration and overlap                      | `gantt`                     |
| Class or type structure                   | `classDiagram`              |

- Label every edge with its condition or event; name nodes as the prose names them.
- Fall back to a checked-in SVG for precise spatial layout or annotation over a screenshot.

A project convention, or the format the repository's documents already use, wins over this file.
