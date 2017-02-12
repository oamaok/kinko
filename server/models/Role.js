function define(app, S, sequelize) {
  return sequelize.define('Role', {
    name: {
      type: S.TEXT,
      allowNull: false,
    },
  });
}

function expand(app, S, models) {
  const {
    User,
    Role,
    RoleMapping,
  } = models;

  Role.belongsToMany(User, { through: RoleMapping });
}

module.exports = {
  define,
  expand,
};
