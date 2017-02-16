module.exports = (app) => {
  const {
    User,
    AccessToken,
  } = app.models;

  app.use(async (ctx, next) => {
    await next();

    if (ctx.request.url === '/api/login') {
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
          roles: user.Roles.map(role => role.name),
        };
      } catch (err) {
        ctx.throw(err, 401);
      }
    }

    if (ctx.request.url === '/api/me') {
      ctx.body = ctx.user;
    }


    if (ctx.request.url === '/api/logout') {
      ctx.cookies.set('token', '', {
        expires: new Date(0),
        overwrite: true,
      });
      try {
        await AccessToken.destroy({ where: { id: ctx.accessToken.id } });
        ctx.body = true;
      } catch (err) {
        console.error(err);
        ctx.body = false;
      }
    }
  });
};
