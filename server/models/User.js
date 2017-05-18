const bcrypt = require('bcryptjs');
const {
  delay,
} = require('../utils');

module.exports = {
  name: 'User',

  properties: {
    id: {
      type: 'uuid',
      primaryKey: true,
      defaultFn: 'uuidv4',
    },
    username: {
      type: 'text',
      required: true,
      unique: true,
    },
    password: {
      type: 'text',
      hidden: true,
      setter: plain => bcrypt.hashSync(plain, bcrypt.genSaltSync(12)),
    },
    deleted: {
      type: 'boolean',
      required: true,
      default: false,
    },
  },

  relations: {
    roles: {
      model: 'Role',
      type: 'belongsToMany',
      foreignKey: 'userId',
      through: 'RoleMapping',
    },
  },

  extend: (app) => {
    const {
      User,
      Role,
      AccessToken,
    } = app.models;

    async function login(username, password) {
      const startTime = (new Date()).getTime();
      const error = new Error('Invalid username or password.');

      try {
        const user = await User.findOne({ where: { username }, include: { model: Role, as: 'roles' } });

        if (!user) {
          throw error;
        }

        const correctPassword = bcrypt.compareSync(password, user.password);

        if (!correctPassword) {
          throw error;
        }

        const accessToken = await AccessToken.create({
          userId: user.id,
          ttl: app.config.auth.ttl,
        });

        return {
          accessToken,
          user,
        };
      } catch (err) {
        console.log(err);
        await delay(1500 - ((new Date()).getTime() - startTime));
        throw err;
      }
    }

    return {
      login,
    };
  },
};

/*
  User.defineSetter('password', value => value);

  User.login =
};

*/
