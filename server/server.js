const Koa = require('koa');
const json = require('koa-json');
const errorHandler = require('koa-json-error');
const bodyParser = require('koa-bodyparser');

const config = require('./config');
const models = require('./models');
const middleware = require('./middleware');
const routes = require('./routes');

const app = new Koa();

app.use(bodyParser());
app.use(errorHandler());
app.use(json({ pretty: false }));

// Initialize configurations
Object.assign(app, { config });

// Initialize models
models(app);

// Initialize routes
routes(app);

// Apply middleware
middleware(app);

if (require.main === module) {
  // Start the app
  app.listen(app.config.port);
} else {
  module.exports = app;
}
