function define(app, S, sequelize) {
  return sequelize.define('File', {
    id: {
      type: S.UUID,
      defaultValue: S.UUIDV4,
      primaryKey: true,
    },

    file: {
      type: S.STRING,
      unique: true,
      allowNull: false,
    },

    name: {
      type: S.STRING,
      allowNull: false,
    },

    isDirectory: {
      type: S.BOOLEAN,
      allowNull: false,
    },
  });
}

function expand(app, S, models) {
  const {
    File,
    User,
    FilePermission,
  } = models;

  File.hasMany(File, { as: 'Children', foreignKey: 'ParentId' });
  File.belongsToMany(User, { as: 'AccessibleTo', through: FilePermission });
}

module.exports = {
  define,
  expand,
};
