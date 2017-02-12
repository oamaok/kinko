const app = require('../server');

const {
  Role,
} = app.models;

const pFindOrCreateMany = (model, data) =>
  Promise.all(data.map(v => model.findOrCreate({ where: v })));

const pFixtures = [];

const pRoles = pFindOrCreateMany(Role, [
  { name: 'admin' },
])
.then(roles => ['roles', roles]);

pFixtures.push(pRoles);


Promise.all(pFixtures)
.then((fixtures) => {
  fixtures.forEach(([name, objects]) => {
    console.log(`Created the following ${name}:`, objects.filter(obj => obj[1]).map(obj => obj[0].dataValues));
  });

  process.exit(0);
})
.catch((err) => {
  console.error(err);
  process.exit(1);
});

