module.exports = (app, router) => {
  const {
    User,
    AccessToken,
  } = app.models;

  router
  .get('/me', async (ctx, next) => {
    await next();

    ctx.body = ctx.user;
  })
  .post('/login', async (ctx, next) => {
    await next();

    try {
      const {
        user,
        accessToken,
      } = await User.login(ctx.request.body.username, ctx.request.body.password);


      ctx.cookies.set('token', accessToken.id, {
        expires: new Date((new Date()).getTime() + (accessToken.ttl * 1000)),
        overwrite: true,
      });

      ctx.body = {
        id: user.id,
        username: user.username,
        roles: user.roles.map(role => role.name),
      };
    } catch (err) {
      ctx.throw(401, err);
    }
  })
  .get('/logout', async (ctx, next) => {
    await next();

    ctx.cookies.set('token', '', {
      expires: new Date(0),
      overwrite: true,
    });

    try {
      await AccessToken.destroy({ where: { id: ctx.accessToken.id } });
      ctx.body = true;
    } catch (err) {
      ctx.body = false;
    }
  });
};
