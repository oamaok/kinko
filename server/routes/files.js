const path = require('path');
const fs = require('mz/fs');

module.exports = (app, router) => {
  const {
    File,
    FileLink,
    User,
  } = app.models;

  router
  .get('/f/list', async (ctx, next) => {
    await next();

    const {
      user,
    } = ctx;

    if (!user) {
      return;
    }

    const isAdmin = user.roles.some(role => role === 'admin');

    const { dataDirectory } = app.config;
    const pFiles = fs
      .readdirSync(dataDirectory)
      .map((entry) => {
        const absolutePath = path.join(dataDirectory, entry);
        const stats = fs.statSync(absolutePath);
        const isDirectory = stats.isDirectory();

        return File.findOrCreate({
          where: {
            file: absolutePath,
            isDirectory,
          },
          defaults: {
            name: entry,
          },
          include: {
            model: User,
            as: 'AccessibleTo',
          },
        });
      });

    const files = (await Promise.all(pFiles))
      .map(result => result[0])
      .filter(file => file.AccessibleTo.some(u => u.id === user.id) || isAdmin);

    ctx.body = files
      .map(file => ({
        id: file.id,
        name: file.name,
        isDirectory: file.isDirectory,
      }));
  })
  .get('/f/:id/link', async (ctx, next) => {
    await next();

    const {
      user,
    } = ctx;

    if (!user) {
      return;
    }

    const file = await File.findById(ctx.params.id, {
      include: {
        model: User,
        as: 'AccessibleTo',
      },
    });

    if (!file) {
      return;
    }

    const isAccessible = file.AccessibleTo.some(u => u.id === user.id);
    const isAdmin = user.roles.some(role => role === 'admin');

    if (!(isAccessible || isAdmin)) {
      return;
    }

    const link = await FileLink.create({
      FileId: file.id,
    });

    ctx.body = link.id;
  })
  .post('/f/:id/rename', async (ctx, next) => { })
  .get('/f/:id/download', async (ctx, next) => { })
  .get('/f/:id/expand', async (ctx, next) => { })
};
