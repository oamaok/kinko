const path = require('path');
const fs = require('mz/fs');

module.exports = (app, router) => {
  router
  .get('/files', async (ctx, next) => {
    await next();

    const { dataDirectory } = app.config;
    const entries = fs.readdirSync(dataDirectory)
      .map((entry) => {
        const stats = fs.statSync(path.join(dataDirectory, entry));

        const isDirectory = stats.isDirectory();
        return {
          id: Math.random().toString(),
          name: entry,
          isDirectory,
        };
      });

    ctx.body = entries;
  });
};
