# ✅ Setup & Verification Checklist

## Pre-Deployment Checklist

### Environment Setup
- `.env` file created with:
  ```env
  GOOGLE_SHEET_ID=your_actual_sheet_id
  BUFFER_PROFILE_ID=your_actual_buffer_profile_id
  GEMINI_MODEL=gemini-2.5-flash
  BUFFER_ACCOUNT=your_buffer_account_email
  ```

### Google Sheets Setup
- Main **"Calendar"** sheet created with columns: `Date, Time, Post, Image, Status, Posted At, Buffer ID, LinkedIn URL, AI Version, Error, Retry`
- **"Logs"** sheet created with columns: `Date, Workflow, Status, LinkedIn URL, Error`
- Service Account email added as collaborator to both sheets.
- `row_number` column verified as output from Google Sheets read node (check in n8n).

### n8n Credentials
- Google Sheets OAuth2 API connected.
- Google Gemini API key added.
- Buffer API account connected via OAuth.

### Workflow Import
- Old workflow deleted or archived.
- `n8n_workflow_corrected.json` imported into n8n.
- All three credential connections re-verified (they don't auto-carry over from JSON).

---

## Critical Post-Import Setup (This Makes Error Handling Work)
> [!CAUTION]
> **REQUIRED: Enable Error Workflow**
> 1. Open the workflow in n8n editor.
> 2. Click the gear icon (Settings) in the top-right.
> 3. Scroll to "Error Workflow".
> 4. Select **this workflow** from the dropdown.
> 5. Save.
> 
> Without this step, the Error Trigger node will never fire, and all errors will be silent.

---

## Testing Before Live Deployment

### Test 1: Happy Path (Post with Image)
1. Add a row to your Calendar sheet:
   - Date: today
   - Time: current hour (e.g., "08:20" if running at 8:25 AM)
   - Post: "Test post with image"
   - Image: `https://via.placeholder.com/1200x630` (valid image URL)
   - Status: "Not Posted"
2. Run the workflow manually (play button).
3. **Expected result**:
   - Row Status updates to "Posted".
   - LinkedIn URL and Buffer ID populated.
   - Entry added to Logs sheet with Status="Success".

### Test 2: Happy Path (Post Text-Only)
1. Add a row:
   - Date: today
   - Time: next hour
   - Post: "Test post text only"
   - Image: (leave blank)
   - Status: "Not Posted"
2. Run the workflow.
3. **Expected result**: Same as Test 1 (should post successfully).

### Test 3: Error Path (Invalid Image URL)
1. Add a row:
   - Date: today
   - Time: current hour
   - Post: "Test post bad image"
   - Image: `https://example.com/404-not-found.jpg` (returns 404)
   - Status: "Not Posted"
2. Run the workflow.
3. **Expected result**:
   - Row Status updates to "Failed".
   - Error column shows "HTTP 404 Not Found" or similar.
   - Entry added to Logs sheet with Status="Failed".
   - *Important: Row number in the error matches your test row, NOT row 2.*

### Test 4: Error Path (Gemini Failure)
1. Intentionally break the Gemini credential (edit the node, delete the API key, save).
2. Add a test row and run the workflow.
3. **Expected result**:
   - Row Status updates to "Failed".
   - Error shows "API key invalid" or similar.
   - Logs sheet has the error entry.
   - Row identification is correct.
4. *Fix Gemini credential after test.*

### Test 5: Time Matching Works
1. Add a row with:
   - Date: today
   - Time: "14:30" (2:30 PM)
   - Status: "Not Posted"
2. Run the workflow at any time other than 2:00 PM hour.
3. **Expected result**: Row is ignored (not processed) and Status stays "Not Posted".
4. Manually set your system time to 2:15 PM (or wait until 2 PM if you prefer) and run again.
5. **Expected result**: Row is now processed.

---

## Deployment Checklist
- [ ] All 5 tests passed.
- [ ] Error Workflow setting enabled in n8n.
- [ ] Credentials verified (Google Sheets, Gemini, Buffer).
- [ ] `.env` variables match the node references.
- [ ] At least 5 test posts added to Calendar sheet with varied dates/times.
- [ ] Cron schedule verified (8:20 AM and 6:50 PM in your timezone).
- [ ] n8n running as a service (not just in terminal).

---

## Post-Deployment Monitoring

### Daily Checks
- Check Logs sheet for "Success" or "Failed" entries.
- If any "Failed" entries, check the Error column for details.
- Check Calendar sheet Status column for any stuck "Posting" rows (should not exist).

### Weekly Checks
- Verify LinkedIn posts are appearing on your profile.
- Spot-check Buffer dashboard for scheduled posts.
- Review Google Sheets for any anomalies.

### Monthly Checks
- Archive old Logs entries (for performance).
- Review any patterns in failures.
- Update Gemini prompt if needed (update in Code node as well).

---

## Troubleshooting

### Rows Stuck on "Posting"
- **Cause**: Error Workflow not enabled, or a row failed and wasn't caught.
- **Fix**: Check n8n Settings for "Error Workflow" setting. Re-run that row manually.

### Rows Not Processing at Time
- **Cause**: Time format mismatch (12-hour vs 24-hour).
- **Fix**: Ensure Time column uses 24-hour format (e.g., "14:30", not "2:30 PM").

### Google Sheets API Errors
- **Cause**: Service Account lost access to sheet.
- **Fix**: Re-share the sheet with the Service Account email.

### Gemini Returns Errors
- **Cause**: API key expired or rate limited.
- **Fix**: Check Google AI Studio console; regenerate API key if needed.

### Buffer Fails but Error Not Logged
- **Cause**: Error Workflow not enabled.
- **Fix**: Enable Error Workflow in Settings (see above).

---

## Success Indicators
✅ **You're ready when:**
- Workflow imports without red error nodes.
- All credentials show green checkmarks.
- Test 1–5 all pass.
- Error Workflow is explicitly enabled.
- At least one post successfully scheduled and posted to LinkedIn.
- Logs sheet shows both success and error entries with correct row numbers.
