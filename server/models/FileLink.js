function define(app, S, sequelize) {
  return sequelize.define('FileLink', {
    id: {
      type: S.UUID,
      defaultValue: S.UUIDV4,
      primaryKey: true,
    },
  });
}

function expand(app, S, models) {
  const {
    File,
    FileLink,
  } = models;

  FileLink.belongsTo(File);
}

module.exports = {
  define,
  expand,
};
