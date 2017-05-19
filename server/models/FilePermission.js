module.exports = {
  name: 'FilePermission',

  public: false,
  properties: {},

  relations: {
    user: {
      model: 'User',
      type: 'belongsTo',
      foreignKey: 'userId',
    },
    role: {
      model: 'File',
      type: 'belongsTo',
      foreignKey: 'roleId',
    },
  },
};
