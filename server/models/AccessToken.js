module.exports = {
  name: 'AccessToken',

  properties: {
    id: {
      type: 'uuid',
      primaryKey: true,
      defaultFn: 'uuidv4',
    },
    ttl: {
      type: 'integer',
      required: true,
    },
    expired: {
      type: 'boolean',
      required: true,
      default: false,
    },
    userId: {
      type: 'uuid',
      required: 'true',
    },
  },

  relations: {
    user: {
      model: 'User',
      type: 'belongsTo',
      foreignKey: 'userId',
    },
  },
};
