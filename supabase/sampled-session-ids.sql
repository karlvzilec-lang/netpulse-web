-- Efficient distinct-session lookup for NetPulse Web.
--
-- The dashboard needs the set of drive sessions that actually have GPS samples,
-- so it can distinguish real drive tests from metadata-only sessions.
--
-- Without this function the client falls back to fetching up to 10,000
-- `drive_samples.session_id` rows and de-duplicating in the browser. This RPC
-- returns the DISTINCT ids server-side instead — a few rows over the wire
-- rather than thousands. The frontend calls it via `db.rpc('sampled_session_ids')`
-- and automatically falls back to the row scan if this function isn't present,
-- so deploying it is safe and non-breaking.
--
-- Run this once in the Supabase SQL editor (project bauiffaqfboqlqnmxffc).

create or replace function public.sampled_session_ids()
returns table (session_id bigint)
language sql
stable
security invoker
set search_path = public
as $$
  select distinct session_id::bigint
  from public.drive_samples
  where session_id is not null
$$;

-- Allow the dashboard's anon (and authenticated) clients to call it.
grant execute on function public.sampled_session_ids() to anon, authenticated;
