---
title: "Raghav"
date: 2026-05-10
type: note
area: people
status: active
tags: [type/note, area/people, status/active, topic/ai]
---

# Raghav

## Who They Are
AI consulting collaborator and newsletter author. Writes *Cash & Cache* on Substack, covering AI research and implementation guides. Built Claude Skills with Thomas's assistance. No surname recorded in vault.

## Relationship to Thomas
Active AI consulting collaboration. Thomas built Skills for Raghav's newsletter workflow (Newsletter Ideation + Presentation Builder). Raghav also authored a public reference piece: "I Analyzed 40+ Claude Skills Failures" — used by Thomas as a credibility signal in his consulting positioning.

## Appearances in Vault
- 2026-05-10 — [[Areas/People/Raghav Skills]] — Profile note documenting his Claude Skills for newsletter workflow
- 2026-05-14 — [[_about-thomas]] — Listed as active AI consulting collaborator

## Last Known Context
Active collaboration as of May 2026. Newsletter actively published.

## Notes
- Substack: https://cashandcache.substack.com — *Cash & Cache*
- Surname not recorded in vault
- Two Skills built: Newsletter Ideation (SCAMPER + JTBD frameworks) + Presentation Builder
- Published: "I Analyzed 40+ Claude Skills Failures" — useful reference for Thomas's consulting

---

## Claude Skills Documentation

Here are a couple of Skills that form an intrinsic part of my workflow in writing my *Cash & Cache*, a newsletter covering AI research and implementation guides.

[https://cashandcache.substack.com](https://cashandcache.substack.com) 

## **Skill 1: Newsletter Ideation**

**What the Skill does**  
Generates 5-7 unique angles for newsletter topics using systematic design thinking frameworks—[SCAMPER](https://www.interaction-design.org/literature/article/learn-how-to-use-the-best-ideation-methods-scamper#:~:text=SCAMPER%20is%20an%20acronym%20formed,helps%20you%20explore%20new%20possibilities.), Jobs-to-be-Done, Contrarian Angle Generator, Time-Horizon Shifts, and Stakeholder Perspective Rotation. Each angle comes with a headline, which framework generated it, target audience, and value proposition.

**What problem I'm solving**

I would know the general topic—"something about AI agents"—but couldn't find a fresh angle. I would resort to the obvious take, then discover three other newsletters published the same piece that week. The real problem wasn't lack of ideas—it was lack of a systematic way to explore the idea space.

**Context around my workflow**

I trigger this skill by saying "ideate on this topic" or "brainstorm angles." It asks whether I'm starting with a specific topic, a trend, or a vague direction—then selects appropriate frameworks. For specific topics, it uses SCAMPER and Intersection Discovery. For trends, it applies Time-Horizon Shifts. For vague ideas, it uses Jobs-to-be-Done to find focused angles.

**Why it works for me**

The 8 frameworks in the reference file force me to look at topics from angles I wouldn't naturally consider. The Contrarian Angle Generator alone has saved several pieces from being forgettable—it systematically challenges consensus views and finds the hidden assumption worth questioning. The audience-specific filtering (AI practitioners, tech leaders, product managers, VC professionals) keeps me grounded with clear value propositions. Read our full deep-dive on this framework in [this article](https://cashandcache.substack.com/p/the-20-minute-idea-funnel-from-blank). 

**What didn't work initially:** My first version generated too many similar angles—variations on the same theme. Adding the requirement to note which framework generated each angle forced more variety.

---

## **Skill 2: Presentation Builder**

**What the Skill does**

Transforms ideas, outlines, or documents into structured slide content with clear titles, 3-5 bullet points per slide, visual placeholders, and optional speaker notes. It adapts structure to presentation type—pitch decks get a different template than business reviews or technical workshops.

**What problem I'm solving**

I would spend the first hour staring at a blank slide, unsure how to structure content. Then I'd overload slides with 8 bullets each, bury the key message on slide 15, and realize I had too many slides for my time slot. The problem wasn't ideas—it was translating ideas into presentation structure efficiently.

**Context around my workflow**

I create presentations for sponsor outreach, community workshops, and project reviews. Now I say "create slides for my sponsor pitch" or "build a deck about this research," and the skill asks targeted questions (audience, duration, purpose), then generates structured content. The reference file includes complete examples for an investor pitch, a business review, and a technical workshop. I can now use the output with Gamma or NotebookLM to make a visual asset for my presentation content.

**Why it works for me**

The formatting rules are specific: slide titles should be 5-10 words and state the takeaway (not the topic), maximum 5 bullets per slide. The structure templates are the real unlock—when I say "pitch deck," it knows the flow: Problem → Solution → Market → Traction → Team → Ask. I don't have to remember the structure.

**What didn't work initially:** My first version generated too many slides and too much text per slide. Adding explicit slide count guidelines (5 minutes \= 5-7 slides) and the "if you have 8 bullets, you have 2 slides" rule dramatically improved output quality.

We drafted an explanatory post on how one can create Skills that activate reliably and produce quality output long-term. Read it here: [I Analyzed 40+ Claude Skills Failures: Here Are the 5 Fixes That Actually Work](https://cashandcache.substack.com/p/i-analyzed-40-claude-skills-failures)

---

