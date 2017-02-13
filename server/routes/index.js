const {
  delay,
} = require('../utils');

module.exports = (app) => {
  app.use(async (ctx, next) => {
    await next();

    if (ctx.request.url === '/api/me') {
      await delay(2000);
      ctx.body = ctx.user;
    }
  });
};
