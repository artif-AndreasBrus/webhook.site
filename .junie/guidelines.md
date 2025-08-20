Project: webhook.site – Frontend build migration and vulnerability mitigation

Overview
- Build pipeline migrated from Gulp/Elixir to Laravel Mix 6 (Webpack 5).
- Node runtime: Use Node v22 inside ddev (preferred). Dockerfile currently uses Node 18 for multi-stage builds; this does not affect ddev usage.
- Goal: Reduce npm audit vulnerabilities while minimizing breaking changes in a legacy Laravel 5.4 + AngularJS stack.

How to work inside ddev (Node 22)
- Install dependencies:
  ddev exec npm ci || ddev exec npm install
- Run audit fix:
  ddev exec npm audit fix
- Build assets:
  ddev exec npm run build
- Optional: inspect full audit report:
  ddev exec npm audit --json

Key dependency updates (security-oriented)
- angular: ^1.8.3 (from 1.4.5)
- angular-ui-router: ^0.4.3
- angular-highlightjs: ^0.7.3
- jquery: ^3.7.1 (from 3.4.1)
- bootstrap-sass: ^3.4.1 (fixes known XSS issues in 3.3.x)
- moment: ^2.30.1
- clipboard: ^2.0.11
- copy-to-clipboard: ^3.3.3
- highlight.js: ^9.18.5 (last v9 line; reduces CVEs vs 9.15.x)
- json-bigint: ^1.0.0
- pusher-js: ^5.1.1
- socket.io-client: ^2.5.0
- Build toolchain devDependencies:
  - laravel-mix ^6.0.49, webpack ^5.94.0, webpack-cli ^4.10.0, sass ^1.77.8, sass-loader ^13.3.3, postcss ^8.4.47, cross-env ^7.0.3

Build configuration
- webpack.mix.js is the single source of truth for assets.
- Output directory: public
- SASS: resources/assets/sass/app.scss -> public/css/app.css
- JS bundles:
  - resources/assets/js/libs.js -> public/js/libs.js
  - [echo.js, app.js] combined -> public/js/bundle.js
- Copied vendor assets:
  - node_modules/bootstrap-sass/assets/fonts/bootstrap -> public/fonts/bootstrap
  - node_modules/socket.io-client/dist/* -> public/js (socket.io.js, etc.)

Views and asset paths
- resources/views/app.php includes:
  - <script src="js/socket.io.js"></script>
  - <script src="js/libs.js"></script>
  - <script src="js/bundle.js"></script>
- These paths are preserved by webpack.mix.js copy/build rules.

Code adjustments
- resources/assets/js/libs.js:
  - Fixed highlight.js XML registration: require('highlight.js/lib/languages/xml') instead of accidentally pointing to javascript.
  - Continue using v9 API: require('highlight.js/lib/highlight') then registerLanguage for 'javascript' and 'xml'.

Using Node 22
- The current dependency set is compatible with Node 22 and npm v10 (as used by ddev images). If audit reports remain:
  - Consider using npm "overrides" in package.json to pin vulnerable transitive dependencies to patched versions.
  - Re-run: ddev exec npm install; ddev exec npm audit fix

Troubleshooting
- If build errors mention missing modules:
  - Ensure node_modules present (ddev exec npm ci)
  - Remove node_modules and package-lock.json, then reinstall.
- If highlight.js fails at runtime, ensure bundles rebuilt: ddev exec npm run build

Longer-term notes
- AngularJS is EOL; remaining vulnerabilities may persist due to legacy packages. Full eradication may require larger refactors or upgrading to newer frameworks/libraries.
- Dockerfile currently uses Node 18 for the asset build stage; ddev local workflow can keep Node 22. We can update Dockerfile to Node 22 in a later PR if desired.

Audit workflow
1) ddev exec npm ci
2) ddev exec npm audit
3) ddev exec npm audit fix
4) ddev exec npm run build
5) If issues remain, share audit output; we can add package.json overrides or bump specific transitive deps.
