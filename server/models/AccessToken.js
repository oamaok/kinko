const crypto = require('crypto');

module.exports = {
  name: 'AccessToken',

  properties: {
    id: {
      type: 'text',
      primaryKey: true,
      default: () => crypto.randomBytes(128).toString('base64'),
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
