const app = require('../server');

app.sequelize.sync({ force: true })
.then(() => {
  console.log('Models synced!');
  process.exit(0);
})
.catch((err) => {
  console.error(err);
  process.exit(1);
});
