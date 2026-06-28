# Supabase Migration Guide

This guide will walk you through migrating your LinkedIn AI Content Automation Platform from Google Sheets to Supabase.

## 1. Setup Supabase
1. Create a free account at [Supabase.com](https://supabase.com).
2. Create a new project.
3. Once your project is ready, navigate to the **SQL Editor** in the left sidebar.
4. Copy the entire contents of `supabase/schema.sql` from this repository.
5. Paste it into the SQL Editor and click **Run**. This will create your `calendar` and `logs` tables with all the correct columns and indexes.

## 2. Get Your Supabase Credentials
1. In your Supabase dashboard, go to **Project Settings** (the gear icon) > **API**.
2. Copy the **Project URL**. This is your `SUPABASE_URL`.
3. Scroll down to **Project API Keys** and copy the **service_role** secret. This is your `SUPABASE_SERVICE_ROLE_KEY`. (Do NOT use the anon public key, as the service role bypasses RLS for backend automation).
4. Paste these into your `.env` file for n8n.

## 3. Migrate Existing Data (Optional)
If you have existing posts in your Google Sheet that you want to keep:
1. Export your Google Sheet as a CSV.
2. In Supabase, go to the **Table Editor**, select the `calendar` table.
3. Click **Insert > Import data from CSV**.
4. Map the columns from your CSV to the SQL columns (e.g., `Date` -> `post_date`, `Time` -> `post_time`). You can ignore columns that don't perfectly map, or clean up the CSV before uploading.

## 4. Update n8n Workflow
1. Import the new `workflow/n8n_workflow.json` into your n8n instance.
2. Configure the **Supabase** credentials inside n8n:
   - Add a new Supabase API credential using the URL and Service Role Key you copied earlier.
3. Ensure your **Google Gemini** and **Buffer** credentials are still connected.
4. Configure the **OpenRouter** credentials (using the generic OpenAI node, but overriding the base URL to `https://openrouter.ai/api/v1`).
5. For **Ollama**, ensure it is running locally. If n8n is running in Docker, you may need to use `http://host.docker.internal:11434` as the base URL.

## 5. Test the Setup
Add a test row directly into the Supabase `calendar` table using the Table Editor, setting `status` to `Not Posted`. Run the n8n workflow manually to ensure it picks up the row, queries all 3 AI models, judges the result, and posts to Buffer.
