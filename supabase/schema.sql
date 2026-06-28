-- Create the Calendar table
CREATE TABLE public.calendar (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    post_date DATE NOT NULL,
    post_time TIME NOT NULL,
    draft_post TEXT NOT NULL,
    image_url TEXT,
    status VARCHAR(50) DEFAULT 'Not Posted',
    posted_at TIMESTAMP WITH TIME ZONE,
    buffer_id TEXT,
    linkedin_url TEXT,
    gemini_variant TEXT,
    ollama_variant TEXT,
    openrouter_variant TEXT,
    winning_ai_version VARCHAR(50),
    error_message TEXT,
    retry_count INTEGER DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create the Logs table
CREATE TABLE public.logs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    execution_date TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    workflow_name VARCHAR(100) NOT NULL,
    status VARCHAR(50) NOT NULL,
    linkedin_url TEXT,
    error_message TEXT,
    calendar_id UUID REFERENCES public.calendar(id) ON DELETE SET NULL
);

-- Function to update 'updated_at' automatically
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Trigger to call the function before update
CREATE TRIGGER update_calendar_updated_at
BEFORE UPDATE ON public.calendar
FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column();

-- Create Indexes for performance on commonly queried columns
CREATE INDEX idx_calendar_status ON public.calendar(status);
CREATE INDEX idx_calendar_post_date ON public.calendar(post_date);
