-- Safely create roles and database
-- This script runs before the main dump to ensure roles/DB exists

-- Create role postgres if it doesn't exist (super-user)
SELECT 'CREATE ROLE postgres WITH SUPERUSER LOGIN'
WHERE NOT EXISTS (SELECT FROM pg_catalog.pg_roles WHERE rolname = 'postgres') \gexec

-- Grant ROLE_GUEST to the guest user if not already present
-- This ensures the web app (using guest:guest) can access WFS features
-- This must be done AFTER the main dump, so we use a separate file or a DO block
