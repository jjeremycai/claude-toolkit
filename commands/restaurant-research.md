---
name: restaurant-research
description: Research restaurants with comprehensive review data, pricing, and recommendations
shouldInvokeAgentImmediately: true
arguments:
  - name: location
    description: City or specific area (e.g., "Hong Kong TST", "Tokyo Shibuya")
    required: false
  - name: cuisine
    description: Type of cuisine (optional, will ask if not provided)
    required: false
---

# Restaurant Research

A comprehensive restaurant research assistant that searches across multiple review platforms, compiles ratings, pricing, and provides detailed recommendations.

## Process

1. **Gather Requirements**
   - If location not provided as argument, ask for it
   - Ask multiple choice questions about dining preferences:
     - Dining style (Fine dining / Upscale casual / Casual / Street food)
     - Cuisine preference (if not provided)
     - Dietary requirements (None / Vegetarian options needed / Vegan options needed / Other)
     - Party size (1-2 / 3-4 / 5-6 / 7+)
     - Occasion (Special celebration / Business dinner / Casual meal / Date night / Other)
     - Distance/Area preference (Walking distance only / Within 15 min transit / Anywhere in city / Specific area - please specify)

2. **Research Strategy**
   - Use WebSearch to find restaurants matching criteria
   - **Fetch latest forex rates:** Before presenting prices, search for current exchange rate (e.g., "HKD to USD exchange rate today") to provide accurate USD conversions
   - Search across multiple platforms based on location:
     - **Global:** Google Maps reviews, Yelp, Michelin Guide, TripAdvisor, Reddit
     - **Asia:** Tabelog (Japan), OpenRice (Hong Kong), Dianping (China)
     - **Regional:** Local review platforms as relevant
   - **IMPORTANT:** Always include Reddit searches using queries like:
     - "best restaurants [location] reddit"
     - "[cuisine] restaurant recommendations [location] site:reddit.com"
     - "where to eat [location] reddit 2026"
   - Reddit provides authentic local insights, hidden gems, and candid reviews from actual diners
   - Look for:
     - Review ratings and count
     - Price range/estimates
     - Michelin recognition
     - Dietary accommodation capabilities
     - Location/distance from specified area
     - Reddit user recommendations and experiences

**Subagent Usage for Parallel Research:**

Consider using the Task tool to spawn subagents for parallel execution when:
- **Researching 5+ restaurants**: Spawn one subagent per restaurant to gather reviews, pricing, and details in parallel
- **Multi-platform searches**: Spawn subagents to search Google Maps, Reddit, OpenRice/Tabelog, and Michelin Guide simultaneously
- **Availability checks**: Spawn one subagent per restaurant to check booking availability in parallel using agent-browser

Example subagent delegation:
```
Task tool with subagent_type="Explore" for:
- "Research [Restaurant Name] reviews on OpenRice, Google Maps, and Reddit"
- "Find pricing and Michelin status for [Restaurant Name]"
- "Check booking availability for [Restaurant Name] on [date]"
```

Benefits:
- **Speed**: Research 6 restaurants in parallel instead of sequentially
- **Thoroughness**: Each subagent can dive deep into specific platforms
- **Efficiency**: Better context usage through distributed work

When NOT to use subagents:
- Simple 1-2 restaurant queries
- User explicitly wants step-by-step research
- Initial requirements gathering phase

3. **Output Format**

**CRITICAL: You MUST present results in a markdown table format as the PRIMARY output.**

The table is MANDATORY and must be shown FIRST, before any other content. Use this exact format:

```markdown
| Restaurant | Cuisine | Michelin | Google | Yelp | Tabelog/Local | Price/Person | Distance | Link |
|------------|---------|----------|--------|------|---------------|--------------|----------|------|
| [Name] | [Type] | ⭐⭐/Guide/— | 4.5★ (1.2k) | 4.0★ (200) | 4.2★ (500) | HKD 500 (~$64) | X.X km | [Link](url) |
```

**Table Requirements:**
- Include 5-8 restaurants in the table
- Fill in ALL columns with data (use "—" if data not available)
- Michelin: Use ⭐ symbols for stars, "Guide" for listed, "Bib Gourmand", or "—"
- **Reviews: MUST specify source** - Each rating column is labeled by platform (Google, Yelp, Tabelog/Local). Format as "X.X★ (count)" e.g., "4.5★ (1.2k)". NEVER mix ratings from different sources or use ratings without verifying the source platform.
- **Price: Show local currency with USD equivalent** - Format as "HKD 500 (~$64)" using latest forex rates
- Distance: From specified hotel/area, or "—" if location is "anywhere"
- Links: Direct to restaurant website or booking page

**After the comparison table**, provide:

### Detailed Recommendations

For each restaurant in the table, include:
- **Rationale:** Why this restaurant fits the criteria (1-2 sentences)
- **Highlights:** Standout dishes, unique features (2-3 items)
- **Considerations:** Dress code, reservation difficulty, dietary accommodation notes

### Top Picks

Provide 1-2 "Editor's Choice" recommendations with clear reasoning for why they're the best options given the user's criteria.

4. **Booking Availability Check (When Requested)**

When the user asks to check booking availability:

**Primary Method - agent-browser:**
- Use `agent-browser` CLI tool first for speed
- **Run availability checks IN PARALLEL** for all restaurants using multiple bash commands
- For each restaurant:
  ```bash
  agent-browser open "[booking-url]" && sleep 5 && agent-browser snapshot
  ```
- Look for calendar widgets, date pickers, available time slots

**Fallback Method - Chrome Browser (when anti-bot detected):**

If agent-browser encounters any of these issues:
- "Access Denied" messages
- Cloudflare captcha or bot protection
- "Verify you are human" prompts
- Timeout errors or ERR_ABORTED
- Blank pages or 403 errors

Then switch to Chrome browser automation using Claude in Chrome tools:

1. **Get browser context:**
   ```
   tabs_context_mcp with createIfEmpty: true
   ```

2. **Create new tab for checks:**
   ```
   tabs_create_mcp
   ```

3. **For each restaurant, use the real browser:**
   ```
   navigate to booking URL
   wait 3-5 seconds for page load
   read_page to get accessibility tree
   screenshot if needed to see calendar/availability
   ```

4. **Look for:**
   - Calendar widgets showing available dates
   - Time slot selectors
   - "Fully booked" messages
   - Next available date information
   - Booking forms with date pickers

5. **Report findings** with screenshots if helpful for user to see actual availability

**Note:** Chrome browser automation bypasses anti-bot protection since it uses a real browser session, but is slower than agent-browser. Only use when necessary.

5. **Reservation Offer**

After presenting recommendations OR availability results, ask:
- "Would you like me to make a reservation at any of these restaurants?"
- If yes, ask for:
  - Which restaurant
  - Date and time
  - Party size confirmation
  - Any special requests

Then use `agent-browser` to complete the booking.

## Research Guidelines

- **Forex rates:** Always fetch the latest exchange rate before presenting prices (e.g., "JPY to USD rate today", "EUR to USD rate today")
- **Price estimates:** Show in local currency with USD equivalent in parentheses - e.g., "¥15,000 (~$97)", "€85 (~$92)", "HKD 800 (~$103)"
- **Review aggregation:** If a platform shows (4.5★ from 1,200 reviews), include both
- **Michelin stars:** Show as ⭐ symbols if applicable, or note "Bib Gourmand" or "Michelin Guide"
- **Distance:** Calculate from specified area/hotel if mentioned
- **Links:** Provide direct restaurant website or Google Maps link
- **Freshness:** Prioritize 2025-2026 information

## Review Sources by Region

### Japan
- Tabelog (primary)
- Reddit (r/Tokyo, r/JapanTravel, r/ramen)
- Google Maps
- Michelin Guide
- TripAdvisor

### Hong Kong
- OpenRice (primary)
- Reddit (r/HongKong, r/travel)
- Google Maps
- Michelin Guide
- TripAdvisor

### China (mainland)
- Dianping (primary)
- Reddit (r/China, city-specific subreddits)
- Google Maps (limited)
- Michelin Guide (major cities)

### Europe/Americas
- Reddit (city-specific subreddits like r/NYC, r/Paris)
- Google Maps
- Yelp (US)
- Michelin Guide
- TripAdvisor
- TheFork/OpenTable

### Middle East
- Reddit (r/Dubai, r/travel)
- Zomato
- Google Maps
- TripAdvisor

### Key Subreddits for Restaurant Research
- City-specific: r/[CityName] (e.g., r/Tokyo, r/Paris, r/NYC)
- Regional: r/AskNYC, r/JapanTravel, r/travel
- Food-focused: r/FoodNYC, r/ramen, r/sushi
- Use search query format: "site:reddit.com best restaurants [location]"

## Example Output

**The output MUST start with the comparison table:**

# [Location] Vegan-Friendly Restaurant Guide

## Complete Comparison Table

| Restaurant | Cuisine | Michelin | Google | Yelp | OpenRice | Price/Person | Distance | Link |
|------------|---------|----------|--------|------|----------|--------------|----------|------|
| Yè Shanghai | Shanghainese | Guide | 4.1★ (850) | 4.0★ (120) | 4.2★ (500) | HKD 250 (~$32) | 0.2 km | [Link](#) |
| Lai Ching Heen | Cantonese | ⭐⭐ | 4.6★ (1.2k) | 4.5★ (80) | 4.7★ (900) | HKD 2,288 (~$294) | 0.4 km | [Link](#) |
| CHAAT | Indian | ⭐ | 4.5★ (215) | — | — | HKD 588 (~$75) | In hotel | [Link](#) |

---

### Detailed Recommendations

**Yè Shanghai**
- **Rationale:** Excellent value Michelin Guide restaurant with explicit vegetarian menu. Art Deco atmosphere evokes 1930s Shanghai. Reddit users on r/HongKong frequently recommend for authentic Shanghai cuisine.
- **Highlights:** Chilled pork chops, stir-fried river prawns, chicken in Shaoxing wine. Vegetarian menu available.
- **Considerations:** 10% service charge. Book ahead for dinner. Located in K11 Musea mall.

**Lai Ching Heen**
- **Rationale:** Two Michelin stars with confirmed vegetarian options and stunning harbor views. Top-tier Cantonese fine dining. Multiple Reddit threads praise the harbor view dining experience.
- **Highlights:** Executive chef's tasting menu, jade-themed interior, Victoria Harbour views.
- **Considerations:** Smart elegant dress code required (closed-toe shoes, long trousers). Higher price point but exceptional quality.

### Top Picks

🏆 **For Value:** Yè Shanghai - Michelin quality at 1/6th the price of 2-star options, explicit vegetarian menu, closest location.

🏆 **For Celebration:** Lai Ching Heen - Two Michelin stars, romantic harbor views, impeccable service worthy of special occasions.

---

Would you like me to make a reservation at either of these restaurants?

## Implementation Notes

- **ALWAYS start output with the comparison table** - this is non-negotiable
- **ALWAYS verify review sources** - Only use ratings from the platform specified in the column header (Google column = Google Maps rating). Never use Fresha, booking platform, or aggregated ratings without explicitly labeling the source.
- **ALWAYS fetch latest forex rate** - Search for current exchange rate before presenting prices (e.g., "HKD USD exchange rate")
- **ALWAYS show dual currency** - Format prices as "HKD 500 (~$64)" with USD in parentheses
- Use `WebSearch` tool for research across platforms
- **ALWAYS include Reddit searches** - Use queries like "[location] restaurant recommendations site:reddit.com" or "best [cuisine] [location] reddit"
- Reddit often surfaces hidden gems and authentic local favorites not found on tourist sites
- Use `AskUserQuestion` with multiple choice options for preference gathering
- **Booking availability checks:** Try agent-browser first (faster), switch to Chrome browser automation if anti-bot protection detected
- Store location/cuisine as context for follow-up questions
- Include source links at the bottom of the output for transparency (including relevant Reddit threads)
- Fill in ALL table columns - use "—" if data is unavailable rather than leaving blank
- The table must include 5-8 restaurants minimum for good comparison
- When Reddit users mention specific restaurants repeatedly, prioritize those in recommendations
- **Consider using subagents** - For 5+ restaurants or parallel availability checks, spawn Task tool subagents to work in parallel
