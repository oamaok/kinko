const Koa = require('koa');
const config = require('./config');
const models = require('./models');
const middleware = require('./middleware');
const routes = require('./routes');

const app = new Koa();

// Initialize configurations
Object.assign(app, { config });

// Initialize models
models(app);

// Apply middleware
middleware(app);

// Initialize routes
routes(app);

if (require.main === module) {
  // Start the app
  app.listen(app.config.port);
} else {
  module.exports = app;
}
