---
source_url: "{{source_url}}"
ingested: {{date}}
source_sha256: <auto>
title: "{{title}}"
author: "{{author}}"
tags: [article{{#tags}}, {{name}}{{/tags}}]
type: raw-article
service: readwise
readwise_id: "{{id}}"
readwise_url: "{{readwise_url}}"
agent_visibility: full
---

# {{title}}

**Author:** {{author}}
**Source:** [{{source_url}}]({{source_url}})
**Saved:** {{date}}
**Readwise:** [Open in Reader]({{readwise_url}})

## Highlights
{{#highlights}}
> {{text}}
{{#note}}
— *Note:* {{note}}
{{/note}}

{{/highlights}}

## Notes
{{#annotations}}
- {{text}}
{{/annotations}}

## Full Content
{{article_content}}
