function define(app, S, sequelize) {
  return sequelize.define('FilePermission', { });
}

function expand(app, S, models) {
  const {
    FilePermission,
    File,
    User,
  } = models;

  FilePermission.belongsTo(User);
  FilePermission.belongsTo(File);
}

module.exports = {
  define,
  expand,
};
