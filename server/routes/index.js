const Router = require('koa-router');

const auth = require('./auth');
const files = require('./files');
const links = require('./links');

module.exports = (app) => {
  const router = new Router({
    prefix: '/api',
  });

  auth(app, router);
  files(app, router);
  links(app, router);

  // Apply the routes
  app.use(router.routes());
};
