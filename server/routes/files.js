const fs = require('mz/fs');

module.exports = (app, router) => {
  router
  .get('/files', async (ctx, next) => {
    await next();

    const { dataDir } = app.config;
    const entries = fs.readdirSync(dataDir)
      .map(entry => entry);

    ctx.body = entries;
  });
};
