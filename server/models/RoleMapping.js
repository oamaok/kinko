module.exports = {
  name: 'RoleMapping',

  public: false,
  properties: {},

  relations: {
    user: {
      model: 'User',
      type: 'belongsTo',
      foreignKey: 'userId',
    },
    role: {
      model: 'Role',
      type: 'belongsTo',
      foreignKey: 'roleId',
    },
  },
};
