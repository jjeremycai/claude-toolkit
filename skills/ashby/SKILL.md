---
name: ashby
description: This skill should be used when the user asks about "Ashby API", "how to use Ashby tools", "Ashby authentication", "recruiting workflows", "candidate pipeline", "interview scheduling", "hiring process", "move candidate through pipeline", "schedule an interview", "manage applications", "track hiring progress", "source candidates", or "advance to next stage". Provides complete API reference and recruiting workflow guidance for the Ashby ATS integration.
version: 1.0.0
---

# Ashby ATS Integration

Complete guide for the Ashby ATS MCP integration: API reference, tool usage, and recruiting workflow patterns.

## Authentication

Ashby uses Basic Authentication with an API key:

1. Generate an API key in Ashby: Settings > API Keys
2. Set the environment variable: `ASHBY_API_KEY=your-api-key`
3. The MCP server handles authentication automatically

API key permission scopes:
- `candidatesRead` / `candidatesWrite` - Candidate operations
- `jobsRead` / `jobsWrite` - Job operations
- `interviewsWrite` - Interview scheduling

## Available Tools

### Candidate Management

| Tool | Purpose | Required Params |
|------|---------|-----------------|
| `candidate_create` | Create new candidate | name, email |
| `candidate_search` | Find by email/name | email or name |
| `candidate_list` | List all candidates | (optional) cursor, limit |
| `candidate_info` | Get candidate details | candidateId |
| `candidate_update` | Update candidate | candidateId |
| `candidate_add_note` | Add note to profile | candidateId, note |
| `candidate_add_tag` | Tag a candidate | candidateId, tagId |
| `candidate_list_notes` | View all notes | candidateId |

### Job Management

| Tool | Purpose | Required Params |
|------|---------|-----------------|
| `job_create` | Create new job | title |
| `job_search` | Find jobs | (optional) title, status |
| `job_list` | List all jobs | (optional) cursor, limit |
| `job_info` | Get job details | jobId |
| `job_set_status` | Update status | jobId, status |

Job statuses: `Open`, `Closed`, `Draft`, `Archived`

### Application Management

| Tool | Purpose | Required Params |
|------|---------|-----------------|
| `application_create` | Consider candidate for job | candidateId, jobId |
| `application_list` | List applications | (optional) jobId, candidateId, status |
| `application_info` | Get application details | applicationId |
| `application_change_stage` | Move in pipeline | applicationId, interviewStageId |
| `application_change_source` | Update attribution | applicationId, sourceId |
| `application_update` | Update properties | applicationId |

Application statuses: `Active`, `Hired`, `Archived`

### Interview Scheduling

| Tool | Purpose | Required Params |
|------|---------|-----------------|
| `interview_list` | List interviews | (optional) applicationId |
| `interview_schedule_create` | Schedule interview | applicationId, interviewerUserIds, startTime, endTime |
| `interview_schedule_list` | List schedules | (optional) startTimeAfter, startTimeBefore |
| `interview_schedule_update` | Modify schedule | interviewScheduleId |
| `interview_schedule_cancel` | Cancel interview | interviewScheduleId |

### Organization

| Tool | Purpose | Required Params |
|------|---------|-----------------|
| `user_list` | List team members | (optional) includeDeactivated |
| `user_search` | Find user | email or name |
| `department_list` | List departments | (optional) includeArchived |
| `location_list` | List locations | (optional) includeArchived |

### Offers

| Tool | Purpose | Required Params |
|------|---------|-----------------|
| `offer_create` | Create offer | applicationId |
| `offer_list` | List offers | (optional) applicationId |

### Utilities

| Tool | Purpose | Required Params |
|------|---------|-----------------|
| `interview_stage_list` | Get pipeline stages | (optional) jobId |
| `source_list` | Get candidate sources | (optional) cursor |
| `candidate_tag_list` | Get available tags | (optional) cursor |
| `archive_reason_list` | Get rejection reasons | none |

## Recruiting Pipeline

Standard pipeline flow:

```
Sourced -> Applied -> Phone Screen -> Interview -> Offer -> Hired
                 |           |            |
              Archived    Archived     Archived
```

Job status lifecycle: `Draft -> Open -> Closed/Archived`

## Workflow Patterns

### Source a New Candidate

```python
# 1. Create candidate
candidate = candidate_create(
    name="Jane Smith",
    email="jane@example.com",
    phoneNumber="+1-555-0123",
    linkedInUrl="https://linkedin.com/in/janesmith",
    location="San Francisco, CA",
    sourceId="referral-source-id"
)

# 2. Apply to job
application_create(
    candidateId=candidate["id"],
    jobId="target-job-id",
    sourceId="linkedin-sourcing"
)
```

### Move Candidate Through Pipeline

```python
# 1. Get available stages
stages = interview_stage_list(jobId="...")
next_stage = next(s for s in stages["results"] if "phone" in s["name"].lower())

# 2. Advance application
application_change_stage(
    applicationId="app-id",
    interviewStageId=next_stage["id"]
)
```

### Schedule an Interview

```python
# 1. Find interviewers
interviewers = user_search(name="...")

# 2. Schedule
interview_schedule_create(
    applicationId="app-id",
    interviewerUserIds=["user-1", "user-2"],
    startTime="2024-01-15T14:00:00Z",
    endTime="2024-01-15T15:00:00Z",
    interviewStageId="stage-id"
)
```

### Reschedule / Cancel Interview

```python
# Reschedule
interview_schedule_update(
    interviewScheduleId="schedule-123",
    startTime="2024-01-16T10:00:00Z",
    endTime="2024-01-16T11:00:00Z"
)

# Cancel (always provide reason)
interview_schedule_cancel(
    interviewScheduleId="schedule-123",
    reason="Candidate requested reschedule"
)
```

### Reject (Archive) a Candidate

```python
# 1. Get archive reasons
reasons = archive_reason_list()
reason_id = next(r for r in reasons["results"] if "not qualified" in r["text"].lower())["id"]

# 2. Get archived stage
stages = interview_stage_list(jobId="...")
archived_stage = next(s for s in stages["results"] if s["type"] == "Archived")

# 3. Archive with reason
application_change_stage(
    applicationId="app-id",
    interviewStageId=archived_stage["id"],
    archiveReasonId=reason_id
)
```

### Create an Offer

```python
offer_create(
    applicationId="app-123",
    startDate="2024-02-01",
    offerDetails="Senior Engineer role, $150k base + equity"
)
```

### Pipeline Analytics

```python
# Funnel by status
active = application_list(jobId="...", status="Active")
hired = application_list(jobId="...", status="Hired")
archived = application_list(jobId="...", status="Archived")
```

## API Details

### Response Format

All tools return JSON:

```json
{
  "success": true,
  "results": { ... }
}
```

List operations include pagination:

```json
{
  "success": true,
  "results": [...],
  "moreDataAvailable": true,
  "nextCursor": "cursor-string"
}
```

Errors:

```json
{
  "success": false,
  "errors": ["error_code"]
}
```

### Pagination

Cursor-based pagination on all list endpoints:

```python
results = candidate_list(limit=50)
while results.get("moreDataAvailable"):
    results = candidate_list(limit=50, cursor=results["nextCursor"])
```

### Date/Time Format

ISO 8601 with timezone: `2024-01-15T14:00:00Z` or `2024-01-15T14:00:00-08:00`

### Error Codes

| Code | Meaning |
|------|---------|
| `invalid_input` | Missing or malformed parameter |
| `not_found` | Resource doesn't exist |
| `unauthorized` | Permission denied |
| `rate_limited` | Too many requests (limit ~100/min) |
| `already_exists` | Duplicate entry |

### ID Resolution

Most operations require resource IDs. Use search/list tools first:

```python
# Candidate ID by email
candidate = candidate_search(email="...")["results"][0]

# Job ID by title
job = job_search(title="...")["results"][0]

# Stage ID by name
stages = interview_stage_list(jobId="...")
stage = next(s for s in stages["results"] if "phone" in s["name"].lower())
```

## Reference Files

For full parameter details and additional API patterns:
- **`references/tool-reference.md`** - Complete parameter reference for all tools
- **`references/api-patterns.md`** - Pagination, error handling, batch operations, relationship traversal
