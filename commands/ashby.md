---
description: Search candidates, view jobs, manage pipeline, or schedule interviews in Ashby
argument-hint: [candidates|jobs|pipeline|schedule] [search-term]
allowed-tools: mcp__ashby__*
---

Ashby recruiting operations. Detect the subcommand from "$ARGUMENTS":

- **candidates [term]**: Search/list candidates
- **jobs [term]**: Search/list jobs
- **pipeline [job]**: View/manage recruiting pipeline
- **schedule [candidate]**: Schedule an interview
- **No subcommand**: Ask the user what they want to do

---

## Candidates

If search term looks like an email (contains @), use `candidate_search` with email. Otherwise search by name.

Display: name, email, location, active applications, created date.
For specific candidates also show: notes (`candidate_list_notes`), tags, applications with stages.

---

## Jobs

Search by title with `job_search`. Default to Open status only.

Display: title, status, department, location, application count.
For specific jobs: full details (`job_info`), interview stages (`interview_stage_list`), applications by stage.

Offer to: view applications, change status, view pipeline.

---

## Pipeline

Identify job by UUID or title search. Display pipeline visualization:

```
Pipeline for [Job Title]:

Lead (3)
├── Jane Smith - Applied 2 days ago
└── John Doe - Applied 5 days ago

Phone Screen (2)
└── Bob Wilson - In stage 3 days

Onsite (1)
└── Eve Johnson - In stage 2 days
```

Actions: move candidate, view details, archive/reject, schedule interview, add note.

For stage changes: use `application_change_stage`. For archiving: get reasons via `archive_reason_list`.

---

## Schedule

Identify application by ID or candidate search. Gather:

1. **Date/time**: YYYY-MM-DD, HH:MM, duration (default 60 min)
2. **Interviewers**: search with `user_search` or list with `user_list`
3. **Stage** (optional): from `interview_stage_list`

Create with `interview_schedule_create`. For rescheduling: `interview_schedule_update` or `interview_schedule_cancel`.
