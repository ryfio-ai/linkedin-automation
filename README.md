# 🚀 LinkedIn AI Content Automation Platform

A complete, end-to-end automation platform for managing, improving, and scheduling LinkedIn content. This project bridges **Google Sheets**, **Google Gemini AI**, and **Buffer** using **n8n** to create a robust content engine.

## ✨ Features

- **Google Sheets as a CMS**: Manage your content calendar in a simple, collaborative spreadsheet interface.
- **AI-Powered Content Refinement**: Automatically rewrites your draft posts using Gemini, adopting a professional tone, concise paragraphs, and generating relevant hooks and hashtags. Versioned prompts ensure quality tracking.
- **Robust Error Handling**: 
  - Verifies image URLs before attempting to post.
  - Intermediate `"Posting"` state locks rows to prevent duplicate posts during slow API responses or retries.
  - Built-in Buffer API retries (3 retries with 30s backoff).
  - Explicit Error handling nodes catch failures and log them back to Google Sheets.
- **Date & Time Intelligence**: Normalizes date formats directly from Google Sheets to ensure reliable scheduling.
- **Full Traceability & Logging**: Automatically logs the generated `LinkedIn URL`, `Buffer ID`, `Error Messages`, and `AI Version` back into the Google Sheet for auditing.
- **Environment Variable Driven**: No hardcoded IDs, enabling easy deployment and sharing.

## 🏗 Architecture

See the `docs/` folder for architecture and workflow diagrams.

## 🛠 Prerequisites

1. **Node.js** (LTS version recommended)
2. **n8n** (`npm install -g n8n`)
3. **Google Cloud Service Account** (with Google Sheets API enabled)
4. **Buffer Account** (Free tier is sufficient for one social profile)
5. **Google Gemini API Key**

## 🚀 Setup Guide

### 1. Database Setup
Copy the `sheets/template.csv` file into Google Drive and convert it to Google Sheets. Create a second sheet named `Logs` for execution tracking. Share the sheet with your Google Cloud Service Account email.

### 2. Environment Variables
Copy `.env.example` to `.env` in your n8n working directory and populate it with your specific IDs.

### 3. Workflow Import
- Run `n8n` in your terminal and navigate to `http://localhost:5678`.
- Create a new workflow.
- Click the **menu** in the top right -> **Import from File**.
- Select the `workflow/n8n_workflow.json` file provided in this repository.

### 4. Connect Credentials
Double click the nodes to add your API keys:
- **Google Sheets**: Authenticate using your Service Account JSON.
- **Buffer**: Connect your Buffer account via OAuth.
- **Google Gemini**: Input your API key.

## 🌟 Future Roadmap
- Generate LinkedIn posts directly from article titles.
- Multi-version generation: Prompt Gemini for 3 variants and pick the best.
- Automatic image generation via Ideogram or Canva APIs.
- Auto-replies to comments using AI context.
- GitHub commit-to-LinkedIn post generation.
