function define(app, S, sequelize) {
  return sequelize.define('Event', {
    type: {
      type: S.INTEGER,
      allowNull: false,
    },
  });
}

function expand(app, S, models) { }

module.exports = {
  define,
  expand,
};
