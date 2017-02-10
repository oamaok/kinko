function define(app, S, sequelize) {
  return sequelize.define('RoleMapping', { });
}

function expand(app, S, models) {
  const {
    RoleMapping,
    Role,
    User,
  } = models;

  RoleMapping.belongsTo(User);
  RoleMapping.belongsTo(Role);
}

module.exports = {
  define,
  expand,
};
