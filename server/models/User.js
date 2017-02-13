const bcrypt = require('bcryptjs');
const {
  delay,
} = require('../utils');

function define(app, S, sequelize) {
  return sequelize.define('User', {
    id: {
      type: S.UUID,
      defaultValue: S.UUIDV4,
      primaryKey: true,
    },

    username: {
      type: S.TEXT,
      allowNull: false,
      unique: true,
      validate: {
        isAlphanumeric: true,
        len: [3, 20],
      },
    },

    password: {
      type: S.TEXT,
      allowNull: false,

      // Automatically hash the password any time it is set.
      set: function passwordSetter(plain) {
        return this.setDataValue(
          'password',
          bcrypt.hashSync(plain, bcrypt.genSaltSync(12))
        );
      },
    },
  });
}

function expand(app, S, models) {
  const {
    User,
    Role,
    RoleMapping,
    AccessToken,
  } = models;

  User.belongsToMany(Role, { through: RoleMapping });
  User.hasMany(AccessToken);

  User.login = async (username, password) => {
    const startTime = (new Date()).getTime();
    const error = new Error('Invalid email or password.');

    try {
      const user = await User.findOne({ where: { username }, include: { model: Role } });

      if (!user) {
        throw error;
      }

      const correctPassword = bcrypt.compareSync(password, user.password);

      if (!correctPassword) {
        throw error;
      }

      const accessToken = await AccessToken.create({
        UserId: user.id,
        ttl: app.config.auth.ttl,
      });

      return {
        accessToken,
        user,
      };
    } catch (err) {
      await delay(2000 - ((new Date()).getTime() - startTime));
      throw err;
    }
  };
}

module.exports = {
  define,
  expand,
};
