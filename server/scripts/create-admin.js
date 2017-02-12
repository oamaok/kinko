const app = require('../server');
const readline = require('readline');

const {
  User,
  Role,
  RoleMapping,
} = app.models;

const rl = readline.createInterface({
  input: process.stdin,
  output: process.stdout,
});

Role.findOne({ where: { name: 'admin' } })
.then((role) => {
  if (!role) {
    console.log('No admin role found. Create fixtures first.');
    process.exit();
  }

  const admin = {};

  const fields = ['username', 'password'];
  let field = fields.shift();
  console.log(`${field}: `);

  rl.on('line', (line) => {
    admin[field] = line;
    field = fields.shift();
    if (!field) {
      process.stdout.write('Creating the user... ');

      User.create(admin)
      .then(user =>
        RoleMapping.create({
          UserId: user.id,
          RoleId: role.id,
        })
      )
      .then(() => {
        console.log('Done!\n');
        process.exit(0);
      })
      .catch((err) => {
        console.error(err);
        process.exit(1);
      });
      return;
    }
    process.stdout.write(`${field}: \n`);
  });
});
