# Routing Rules — Manual Seed

> Hand-seeded from dispatch analysis (BD-9, Week 2).
> Date: 2026-05-11
> Source: 20+ dispatches in latest Yahoo digest + cumulative dispatch history since May 9.

---

## 3 Most Common Routing Errors

### Error #1: Apple Private Relay name-fallback gaps

Emails routed through Apple's Private Relay (`privaterelay.appleid.com`) bypass domain-based matching because all relayed emails share the same sender domain. The name-based fallback (`RELAY_NAME_ROUTES` in `yahoo-digest-run.py`) currently covers only 12 senders, leaving many commercial senders in To Sort.

**Explicit rules to add (next batch):**

| Sender name | Destination | Importance |
|-------------|------------|------------|
| bulk (Bulk™) | Shopping/Brand Mail | Noise |
| support, jabra | Notifications/Other Auto | Noise |
| vintage, tapasbar | Newsletters/Other | Noise |
| amphitryon | Newsletters/Other | Noise |
| thefork | Newsletters/Other | Noise |
| flying.blue | Newsletters/Other | Noise |
| thebirdyclub | Newsletters/Other | Noise |

**Script locations** (both need updating):
- `C:/Users/thoma/.hermes/scripts/yahoo-digest-run.py` — `RELAY_NAME_ROUTES` dict (line ~199)
- `C:/Users/thoma/.hermes/scripts/email-triage-run.py` — add sender-name fallback for Apple relay

### Error #2: Skiplagged/SoundCloud routing failure despite existing rules

Skiplagged (`Travel/Other Trips`) and SoundCloud (`Newsletters/Other`) both have entries in RELAY_NAME_ROUTES but appeared in To Sort on the last run. This suggests either:
- The relay check condition (`"privaterelay.appleid.com" in str(from_field).lower()`) doesn't trigger for certain From header formats
- Or these are re-fetched old emails from a previous failed run

**Action**: Investigate the `route()` function's relay detection regex. The current approach uses a broad `from_field` string check which should work for standard formats. If the issue persists, add direct sender-domain rules for any known non-relay email aliases these senders use.

### Error #3: Unmatched sender domains (new/unseen)

New senders that don't match any existing domain rule and don't come through Apple Relay. Latest batch: `Vintage Tapasbar & Wijn` (restaurant newsletter from external system). These are legitimate To Sort items that need domain-based rules after 2+ appearances.

**Pattern to formalize**: Any sender appearing in To Sort 2+ times across consecutive digest runs should be evaluated for a routing rule. This is what the distillation process will automate.

---

## Custom Fields Decision

**Decision: Wire up `Source` only, skip the rest.**

| Field | Decision | Rationale |
|-------|----------|-----------|
| Estimated time | SKIP | Routing is fast (~3-4s/email). No actionable insight from timing per email. |
| Confidence | SKIP | Not useful at dispatch time — confidence is implicit in the match type (domain > subject > relay name). |
| Source | WIRE UP | Tracks which method routed each email (domain, subject, relay-name, fallback). Useful for spotting routing gaps in digest output. Add a `[via:domain]`, `[via:relay]`, `[via:subject]` tag to each digest line. |
| Reasoning | SKIP | Over-engineered for the current volume. Would be useful during distillation but adds complexity now for zero immediate value. |

**Implementation**: Add a `source` field to the routing entry in `yahoo-digest-run.py` and `gmail-digest-run.py`. Include a brief source tag in the digest line (e.g., `[relay]`, `[domain]`, `[subject]`) so Thomas can see at a glance why an email landed where it did. This also provides training data for the planned distillation process.

**Implementation status: DONE (2026-05-11)**
- `route()` in all 3 scripts now returns `(folder, important, via)` with source method: domain/relay/subject/manual/fallback/unmatched
- RELAY_NAME_ROUTES updated in `yahoo-digest-run.py` + `email-triage-run.py` with new bulk/support/jabra/vintage/tapasbar entries
- Apple Private Relay sender-name fallback added to `email-triage-run.py` route function
- To Sort items in digest show `[via:method]` tag
- Routed noise summary shows `[via:m]:N` distribution breakdown
- Gmail digest also tracks and displays via source
