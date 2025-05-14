-- PostgreSQL Maintenance Diagnostics Script
-- Author: Your Friendly Index Whisperer
-- Run as a privileged user in a test or maintenance window

SELECT usename, *
FROM pg_user
WHERE usename LIKE 'ad_%'; -- Example: Users with an 'ad_' prefix



SELECT *
FROM pg_catalog.pg_roles
WHERE rolcanlogin;

SELECT g.rolname, r.rolname AS username, *
FROM pg_auth_members am
JOIN pg_roles r ON (am.roleid = r.oid)
JOIN pg_roles g ON (am.member = g.oid)
WHERE g.rolname = 'ad_users_group'; -- Example: Members of the 'ad_users_group' role

-- 0. List All Databases (Bonus Section)
SELECT datname AS database_name,
       pg_size_pretty(pg_database_size(datname)) AS db_size,
       numbackends AS active_connections
FROM pg_stat_database
ORDER BY pg_database_size(datname) DESC;

-- 1. Vacuum & Analyze (Full Table Cleanup)
--VACUUM VERBOSE ANALYZE;

-- 2. Table Bloat Check (Dead Tuples)
SELECT NOW() AS run_time,
       relname AS table_name,
       n_live_tup,
       n_dead_tup,
       ROUND(100.0 * n_dead_tup / NULLIF(n_live_tup + n_dead_tup, 0), 2) AS dead_tuple_pct
FROM pg_stat_user_tables
ORDER BY n_dead_tup DESC
LIMIT 10;


-- 3. Index Usage Stats
SELECT NOW() AS run_time,
       relname AS table_name,
       seq_scan,
       idx_scan,
       ROUND(100.0 * idx_scan / NULLIF(seq_scan + idx_scan, 0), 2) AS index_usage_pct
FROM pg_stat_user_tables
ORDER BY index_usage_pct ASC
LIMIT 10;

-- 4. Suspected Missing Indexes
SELECT NOW() AS run_time,
       relname AS table_name,
       seq_scan,
       idx_scan,
       n_tup_ins,
       n_tup_upd,
       n_tup_del
FROM pg_stat_user_tables
WHERE idx_scan = 0
  AND seq_scan > 1000
ORDER BY seq_scan DESC;

-- 5. Autovacuum Status
SELECT NOW() AS run_time,
       relname AS table_name,
       last_autovacuum,
       n_dead_tup
FROM pg_stat_user_tables
ORDER BY last_autovacuum NULLS FIRST
LIMIT 10;

-- 6. Long-Running Queries (> 5 minutes)
SELECT NOW() AS run_time,
       pid,
       usename,
       state,
       now() - query_start AS duration,
       query
FROM pg_stat_activity
WHERE (now() - query_start) > interval '5 minutes'
  AND state != 'idle'
ORDER BY duration DESC;

-- 7. Table Size Report
SELECT NOW() AS run_time,
       relname AS table_name,
       pg_size_pretty(pg_total_relation_size(relid)) AS total_size,
       pg_size_pretty(pg_relation_size(relid)) AS table_only_size,
       pg_size_pretty(pg_total_relation_size(relid) - pg_relation_size(relid)) AS index_size
FROM pg_statio_user_tables
ORDER BY pg_total_relation_size(relid) DESC
LIMIT 10;

-- 8. Connection Usage
SELECT NOW() AS run_time,
       datname,
       numbackends AS active_connections
FROM pg_stat_database
ORDER BY numbackends DESC;

-- 9. Blocking Sessions (Bonus Round)
SELECT bl.pid AS blocked_pid,
       ka.query AS blocking_query,
       now() - ka.query_start AS blocking_duration,
       kl.pid AS locking_pid,
       a.query AS blocked_query,
       now() - a.query_start AS blocked_duration
FROM pg_locks bl
JOIN pg_stat_activity a ON bl.pid = a.pid
JOIN pg_locks kl ON bl.locktype = kl.locktype
                 AND bl.database IS NOT DISTINCT FROM kl.database
                 AND bl.relation IS NOT DISTINCT FROM kl.relation
                 AND bl.page IS NOT DISTINCT FROM kl.page
                 AND bl.tuple IS NOT DISTINCT FROM kl.tuple
                 AND bl.virtualxid IS NOT DISTINCT FROM kl.virtualxid
                 AND bl.transactionid IS NOT DISTINCT FROM kl.transactionid
                 AND bl.classid IS NOT DISTINCT FROM kl.classid
                 AND bl.objid IS NOT DISTINCT FROM kl.objid
                 AND bl.objsubid IS NOT DISTINCT FROM kl.objsubid
                 AND bl.pid != kl.pid
JOIN pg_stat_activity ka ON kl.pid = ka.pid
WHERE NOT bl.granted;
