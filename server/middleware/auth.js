
module.exports = (app) => {
  const {
    User,
    Role,
    AccessToken,
  } = app.models;

  app.use(async (ctx, next) => {
    await next();
    const authToken = ctx.cookies.get('token');
    Object.assign(ctx, { user: null, accessToken: null });

    const token = await AccessToken.findById(authToken, { include: {
      model: User,
      as: 'user',
      include: {
        model: Role,
        as: 'roles',
      },
    } });

    if (!token) {
      return;
    }

    const updatedAt = new Date(token.updatedAt);
    const expiresAt = new Date(updatedAt.getTime() + (token.ttl * 1000));
    const now = new Date();

    if (token.expired || expiresAt < now) {
      return;
    }

    // Update the expirydate
    token.changed('updatedAt', true);
    await token.save();

    ctx.cookies.set('token', token.id, {
      expires: new Date(now.getTime() + (token.ttl * 1000)),
      overwrite: true,
    });

    const user = token.user;

    Object.assign(ctx, {
      user: {
        id: user.id,
        username: user.username,
        roles: user.roles.map(role => role.name),
      },
      accessToken: {
        id: token.id,
        ttl: token.ttl,
        updatedAt,
      },
    });
  });
};
