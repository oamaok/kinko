module.exports = {
  name: 'File',

  properties: {
    id: {
      type: 'uuid',
      primaryKey: true,
      defaultFn: 'uuidv4',
    },
    path: {
      type: 'text',
      required: true,
      unique: true,
    },
    name: {
      type: 'text',
      required: true,
    },
    isDirectory: {
      type: 'boolean',
      required: true,
    },
  },

  relations: {
    children: {
      model: 'File',
      type: 'hasMany',
      foreignKey: 'parentId',
    },
    accessibleTo: {
      model: 'User',
      type: 'belongsToMany',
      through: 'FilePermission',
    },
  },
};
