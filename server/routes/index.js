const {
  delay,
} = require('../utils');

module.exports = (app) => {
  const {
    User,
  } = app.models;

  app.use(async (ctx, next) => {
    await next();

    if (ctx.request.url === '/api/login') {
      try {
        const {
          user,
          accessToken,
        } = await User.login(ctx.request.body.username, ctx.request.body.password);

        ctx.body = {
          token: accessToken.id,
          username: user.username,
          roles: user.Roles.map(role => role.name),
        };
      } catch (err) {
        ctx.throw(err, 401);
      }
    }
  });
};
