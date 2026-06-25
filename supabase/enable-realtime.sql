-- NetPulse Web — Enable Realtime on all telemetry tables
-- Run this once in the Supabase SQL editor for project bauiffaqfboqlqnmxffc

ALTER PUBLICATION supabase_realtime ADD TABLE networkxp_data;
ALTER PUBLICATION supabase_realtime ADD TABLE cx_experience_log;
ALTER PUBLICATION supabase_realtime ADD TABLE opensignal_scores;
ALTER PUBLICATION supabase_realtime ADD TABLE drive_sessions;
ALTER PUBLICATION supabase_realtime ADD TABLE drive_samples;

-- Verify
SELECT schemaname, tablename
FROM pg_publication_tables
WHERE pubname = 'supabase_realtime'
ORDER BY tablename;
