module.exports = (app) => {
  app.use(async (ctx, next) => {
    await next();

    if (ctx.request.url === '/api/me') {
      ctx.body = ctx.user;
    }
  });
};
