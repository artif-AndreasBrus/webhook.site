#!/usr/bin/env bash
set -euo pipefail

say() { printf "\n==> %s\n" "$*"; }

devexec() { ddev exec "$@"; }

say "Starting ddev..."
ddev start

say "PHP/Composer info:"
devexec php -v || true
devexec composer --version || true

say "Installing/updating Composer dependencies (this may take a while)..."
# Prefer update to refresh lock after framework bump
devexec composer update --no-interaction --prefer-dist

say "Clearing/refreshing Laravel caches..."
devexec php artisan config:clear || true

devexec php artisan cache:clear || true

devexec php artisan view:clear || true

devexec php artisan route:clear || true

say "Running database migrations..."
# Use --force to run in non-interactive environment
( devexec php artisan migrate --force ) || true

say "Node.js info inside container:"
devexec node -v || true
devexec npm -v || true

say "Installing/updating npm dependencies..."
# Try clean install first, fall back to install if lock incompatible
( devexec npm ci ) || devexec npm install

say "Attempting to auto-fix npm audit issues..."
( devexec npm audit fix ) || true

say "Building frontend assets with Laravel Mix..."
devexec npm run build

say "Basic Laravel verification..."
devexec php artisan about || true

echo
say "Routes (first 60 lines):"
devexec php artisan route:list | head -n 60 || true

echo
say "Done. Open the site and verify functionality:"
echo "  https://$(ddev describe --json | jq -r '.raw.httpURL' 2>/dev/null || echo "<project>.ddev.site")"
echo "If errors occur, copy the output above into an issue/comment."
