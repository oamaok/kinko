const bcrypt = require('bcryptjs');

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

  User.login = (username, password) => {
    const startTime = (new Date()).getTime();
    const error = new Error('Invalid email or password.');

    return User.findOne({ where: { username }, include: { model: Role } })
    .then((user) => {
      if (!user) {
        throw error;
      }

      const correctPassword = bcrypt.compareSync(password, user.password);

      if (!correctPassword) {
        throw error;
      }

      const pAccessToken = AccessToken.create({
        UserId: user.id,
        ttl: app.config.auth.ttl,
      });

      return Promise.all([
        user,
        pAccessToken,
      ]);
    })
    .then(([user, accessToken]) =>
      ({
        user,
        accessToken,
      })
    )
    .catch(err =>
      // Prevent timing attacks by returning errors in constant time
      new Promise((resolve, reject) => {
        const timeout = 2000 - ((new Date()).getTime() - startTime);
        setTimeout(() => reject(err), timeout);
      })
    );
  };
}

module.exports = {
  define,
  expand,
};
