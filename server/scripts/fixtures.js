const app = require('../server');

const {
  Role,
} = app.models;

const pFindOrCreateMany = (model, data) =>
  Promise.all(data.map(v => model.findOrCreate({ where: v })));

pFindOrCreateMany(Role, [
  { name: 'admin' },
])
.then((roles) => {
  console.log('Created the following roles: ', roles.filter(r => r[1]).map(r => r[0].dataValues));
});

