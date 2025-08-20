# [Webhook.site](https://webhook.site)

[![Docker Cloud Build Status](https://img.shields.io/docker/cloud/build/fredsted/webhook.site.svg)](https://hub.docker.com/r/fredsted/webhook.site)
[![GitHub last commit](https://img.shields.io/github/last-commit/fredsted/webhook.site.svg)](https://github.com/fredsted/webhook.site/commits/master)

With [Webhook.site](https://webhook.site), you instantly get a unique, random URL that you can use to test and debug Webhooks and HTTP requests, as well as to create your own workflows using the Custom Actions graphical editor or WebhookScript, a simple scripting language, to transform, validate and process HTTP requests.

## What are people using it for?

* Receive Webhooks without needing an internet-facing Web server
* Send Webhooks to a server that’s behind a firewall or private subnet
* Transforming Webhooks into other formats, and re-sending them to different systems
* Connect different APIs that aren’t compatible
* Building contact forms that send emails
* Instantly build APIs without needing infrastructure
Built by Simon Fredsted (@fredsted).

## Open Source

There are two versions of Webhook.site:

* The completely open-source, MIT-licensed version is available on Github, which can be self-hosted using e.g. Docker, is great for testing Webhooks, but doesn’t include features like Custom Actions.

* The cloud version at [https://webhook.site](https://webhook.site) which has more features, some of them requiring a paid subscription.

## Acknowledgements

* The app was built with [Laravel](https://laravel.com) for the API and Angular.js for the frontend SPA.
* WebhookScript based on [Primi](https://github.com/smuuf/Primi) Copyright (c) Přemysl Karbula.
* The WebhookScript editor is using the [Ace](https://ace.c9.io/).
* JSONPath extraction provided by [FlowCommunications](https://github.com/FlowCommunications/JSONPath).
* This documentation site uses [Just the Docs](https://github.com/pmarsceill/just-the-docs), a documentation theme for Jekyll.

**[Full Documentation at docs.webhook.site](https://docs.webhook.site)**


## Complete the upgrade and verify (ddev)

Prerequisites:
- DDEV installed and running on your machine.
- Run these commands from the project root.

Node.js runtime inside ddev:
- This repo pins Node.js 22 for the web container via .ddev/config.yaml (nodejs_version: "22"). If your containers were already running, restart them: ddev restart

One‑liner (recommended):
- bash scripts/complete-upgrade.sh
  - If you get a permission error: chmod +x scripts/complete-upgrade.sh && ./scripts/complete-upgrade.sh

What the script does:
- ddev start
- Composer update, then clears Laravel caches and runs database migrations
- npm ci (or npm install), npm audit fix, npm run build (Laravel Mix 6)
- Basic verification: php artisan about and route:list

Manual commands (alternative):
- ddev start
- ddev exec composer update --no-interaction --prefer-dist
- ddev exec php artisan config:clear && ddev exec php artisan cache:clear && ddev exec php artisan view:clear && ddev exec php artisan route:clear
- ddev exec php artisan migrate --force
- ddev exec npm ci || ddev exec npm install
- ddev exec npm audit fix || true
- ddev exec npm run build

Open the site:
- Run ddev describe and open the provided URL (typically https://<project>.ddev.site)

Notes:
- Asset output paths are preserved: public/js/libs.js, public/js/bundle.js, public/css/app.css
- resources/views/app.php already references js/socket.io.js, js/libs.js, js/bundle.js
- If highlight.js or other frontend scripts misbehave, run ddev exec npm run build again.
