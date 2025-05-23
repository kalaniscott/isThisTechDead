-- Migration for improved tech_snapshots_v2 table with enhanced metrics
CREATE TABLE IF NOT EXISTS tech_snapshots_v2 (
  id BIGINT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
  tech_id TEXT REFERENCES tech_registry(id),
  tech_name TEXT NOT NULL,
  snapshot_date DATE NOT NULL,
  
  -- GitHub metrics
  github_metrics JSONB,
  github_stars INTEGER,
  github_forks INTEGER,
  github_commits_last_month INTEGER,
  github_issues_open INTEGER,
  github_issues_closed_ratio NUMERIC,
  github_days_since_last_commit INTEGER,
  github_contributors_count INTEGER,
  github_trend_direction TEXT,      -- increasing, decreasing, growing, declining, stable
  github_trend_growth_rate NUMERIC, -- Calculated growth rate
  github_quality NUMERIC,           -- Data quality score (0-1)
  
  -- Stack Overflow metrics with trend data
  so_metrics JSONB,
  so_trend_direction TEXT,        -- increasing, decreasing, growing, declining, stable
  so_trend_growth_rate NUMERIC,   -- Calculated growth rate
  so_period_counts JSONB,         -- Question distribution across time periods
  so_total_questions INTEGER,     -- Total questions in window
  so_answered_ratio NUMERIC,      -- Percentage of answered questions
  so_accepted_ratio NUMERIC,      -- Percentage with accepted answers
  so_zero_answer_ratio NUMERIC,   -- Percentage with no answers
  so_median_response_hr NUMERIC,  -- Median time to first answer
  so_last_activity_days NUMERIC,  -- Days since last activity
  so_quality NUMERIC,             -- Data quality score (0-1)
  
  -- YouTube metrics with trend data
  youtube_metrics JSONB,
  youtube_trend_direction TEXT,   -- increasing, decreasing, growing, declining, stable
  youtube_trend_growth_rate NUMERIC,  -- Calculated growth rate
  youtube_period_counts JSONB,    -- Video distribution across time periods
  youtube_video_count INTEGER,    -- Total video count
  youtube_avg_views NUMERIC,      -- Average views per video
  youtube_days_since_last INTEGER,-- Days since last video
  youtube_quality NUMERIC,        -- Data quality score (0-1)
  
  -- Reddit metrics
  reddit_metrics JSONB,
  reddit_post_count INTEGER,      -- Total posts in window
  reddit_avg_upvotes NUMERIC,     -- Average upvotes per post
  reddit_comments_per_post NUMERIC, -- Average comments per post
  reddit_days_since_last INTEGER, -- Days since last post
  reddit_trend_direction TEXT,    -- increasing, decreasing, growing, declining, stable
  reddit_trend_growth_rate NUMERIC, -- Calculated growth rate
  reddit_quality NUMERIC,         -- Data quality score (0-1)
  
  -- HackerNews metrics
  hn_metrics JSONB,
  hn_post_count INTEGER,          -- Total posts in window
  hn_avg_points NUMERIC,          -- Average points per post
  hn_avg_comments NUMERIC,        -- Average comments per post
  hn_days_since_last INTEGER,     -- Days since last post
  hn_trend_direction TEXT,        -- increasing, decreasing, growing, declining, stable
  hn_quality NUMERIC,             -- Data quality score (0-1)
  
  -- StackShare metrics
  stackshare_metrics JSONB,
  stackshare_stacks_count INTEGER, -- Number of stacks using this tech
  stackshare_followers INTEGER,    -- Number of followers
  stackshare_upvotes INTEGER,      -- Number of upvotes
  stackshare_mentions INTEGER,     -- Number of mentions
  stackshare_quality NUMERIC,      -- Data quality score (0-1)
  
  -- Google Jobs metrics
  google_jobs JSONB,
  google_jobs_count INTEGER,      -- Number of job postings
  google_jobs_trend_direction TEXT, -- increasing, decreasing, growing, declining, stable
  google_jobs_trend_growth_rate NUMERIC, -- Calculated growth rate
  google_jobs_quality NUMERIC,    -- Data quality score (0-1)
  
  -- Overall scores
  deaditude_score NUMERIC,
  component_scores JSONB,
  confidence_score INTEGER,       -- Overall confidence (0-100)
  verdict TEXT,                   -- Very Alive, Alive, Stable, Declining, Dead
  
  -- Metadata
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create indexes for performance
CREATE INDEX IF NOT EXISTS idx_tech_snapshots_v2_tech_id ON tech_snapshots_v2(tech_id);
CREATE INDEX IF NOT EXISTS idx_tech_snapshots_v2_snapshot_date ON tech_snapshots_v2(snapshot_date);
CREATE INDEX IF NOT EXISTS idx_tech_snapshots_v2_verdict ON tech_snapshots_v2(verdict);

-- Add migration info to log
INSERT INTO public.schema_migrations (version, inserted_at)
VALUES ('004_tech_snapshots_v2', NOW())
ON CONFLICT DO NOTHING;

COMMENT ON TABLE tech_snapshots_v2 IS 'Enhanced snapshot table with granular trend metrics'; 