const path = require('path');
const fs = require('mz/fs');

module.exports = (app, router) => {
  const {
    File,
    FileLink,
    User,
  } = app.models;

  router
  .get('/l/:id', async (ctx, next) => {
    await next();

    // TODO: logging
    const link = await FileLink.findById(ctx.params.id, { include: File });

    if (!link) {
      return;
    }

    ctx.body = link.File.id;
  });
};
