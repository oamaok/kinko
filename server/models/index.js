const fs = require('mz/fs');
const path = require('path');
const Sequelize = require('sequelize');

module.exports = (app) => {
  const config = app.config.db;

  const sequelize = new Sequelize(
    config.name,
    config.username,
    config.password,
    {
      host: config.host,
      dialect: 'postgres',
      logging: false,
    }
  );

  const entries = fs.readdirSync(__dirname);

  /* eslint-disable import/no-dynamic-require */
  /* eslint-disable global-require */
  const modelDefinitions = entries
    .filter(entry => entry.substr(-3) === '.js' && entry !== 'index.js')
    .map(entry => require(path.resolve(__dirname, entry)));

  // Initialize the model definitions
  const models = modelDefinitions
    .map(m => m.define(app, Sequelize, sequelize))
    .reduce((obj, model) => Object.assign(obj, { [model.name]: model }), {});

  // Expand the model definitions
  modelDefinitions
    .filter(m => typeof m.expand === 'function')
    .forEach(m => m.expand(app, Sequelize, models));

  Object.assign(app, { models, sequelize });
};
