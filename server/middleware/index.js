const auth = require('./auth');
const acl = require('./acl');

module.exports = (app) => {
  auth(app);
  acl(app);
};
