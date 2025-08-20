const mix = require('laravel-mix');

// Output options
mix.setPublicPath('public');

// Copy assets similar to old Elixir setup
mix.copy('node_modules/bootstrap-sass/assets/fonts/bootstrap', 'public/fonts/bootstrap');
mix.copy('node_modules/socket.io-client/dist/*', 'public/js');

// Compile SASS
mix.sass('resources/assets/sass/app.scss', 'public/css/app.css');

// Build JS bundles
// libs.js as its own bundle
mix.js('resources/assets/js/libs.js', 'public/js/libs.js');

// echo.js and app.js combined into one bundle (equivalent to Elixir browserify([...]))
mix.js([
  'resources/assets/js/echo.js',
  'resources/assets/js/app.js'
], 'public/js/bundle.js');

// Version in production
if (mix.inProduction()) {
  mix.version();
}
