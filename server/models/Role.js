module.exports = {
  name: 'Role',

  properties: {
    name: {
      type: 'text',
      required: true,
      unique: true,
    },
  },

  relations: {
    users: {
      model: 'User',
      type: 'belongsToMany',
      foreignKey: 'roleId',
      through: 'RoleMapping',
    },
  },
};
