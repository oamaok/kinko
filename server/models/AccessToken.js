const crypto = require('crypto');

function define(app, S, sequelize) {
  return sequelize.define('AccessToken', {
    id: {
      type: S.TEXT,
      primaryKey: true,
      defaultValue: () => crypto.randomBytes(256).toString('hex'),
    },
    ttl: S.INTEGER,
    expired: {
      type: S.BOOLEAN,
      defaultValue: false,
    },
  });
}

function expand(app, S, models) {
  const {
    AccessToken,
    User,
  } = models;

  AccessToken.belongsTo(User);
}

module.exports = {
  define,
  expand,
};
