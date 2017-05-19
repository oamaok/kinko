const fs = require('mz/fs');
const path = require('path');
const Sequelize = require('sequelize');
const {
  Record,
  Map,
} = require('immutable');

const Property = Record({
  name: '',
  type: '',
  primaryKey: false,
  unique: false,
  required: false,
  hidden: false,
  default: null,
  defaultFn: null,
  setter: null,
});

const Relation = Record({
  name: '',
  model: '',
  type: '',
  foreignKey: '',
  through: '',
});

const ModelDefinition = Record({
  name: '',
  properties: [],
  relations: [],
  sequelize: null,
  extend: () => {},
});

function initializeModels(app) {
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

  Object.assign(app, { sequelize });

  // Load model definitions
  const entries = fs.readdirSync(path.resolve(__dirname, 'models'));

  const definitions = entries
    .filter(entry => entry.substr(-3) === '.js')
    .map(entry => require(path.resolve(__dirname, 'models', entry)))
    .map(model => new ModelDefinition({
      name: model.name,
      properties: Object.keys(model.properties).map(key =>
        (new Property(model.properties[key])).set('name', key)
      ),
      relations: Object.keys(model.relations).map(key =>
        (new Relation(model.relations[key])).set('name', key)
      ),
      extend: model.extend || (() => {}),
    }))
    .reduce((map, model) => map.set(model.name, model), Map());

  // Validate definitions
  const modelNames = definitions.keySeq();

  const validTypes = [
    'TEXT',
    'INTEGER',
    'BIGINT',
    'FLOAT',
    'REAL',
    'DOUBLE',
    'DECIMAL',
    'DATE',
    'DATEONLY',
    'BOOLEAN',
    'JSON',
    'JSONB',
    'BLOB',
    'UUID',
    'GEOMETRY',
  ];

  const validRelations = [
    'belongsTo',
    'hasMany',
    'hasOne',
    'belongsToMany',
  ];

  definitions.forEach((model) => {
    // Validate the extend-function
    if (model.extend && typeof model.extend !== 'function') {
      throw new Error(`Model definition of '${model.name}' is invalid: the model's extend-property must be a function`);
    }
    // Validate properties
    model.properties.forEach((property) => {
      if (!validTypes.includes(property.type.toUpperCase())) {
        throw new Error(`Model definition of '${model.name}' is invalid: property '${property.name}' has an invalid type '${property.type.toUpperCase()}'`);
      }

      if (property.setter && typeof property.setter !== 'function') {
        throw new Error(`Model definition of '${model.name}' is invalid: property '${property.name}' setter must be a function`);
      }
    });
    // Validate relations
    model.relations.forEach((relation) => {
      if (!validRelations.includes(relation.type)) {
        throw new Error(`Model definition of '${model.name}' is invalid: relation '${relation.name}' has an invalid type '${relation.type}'`);
      }

      if (relation.type === 'belongsToMany' && !relation.through) {
        throw new Error(`Model definition of '${model.name}' is invalid: 'belongsToMany' relations need a 'through' model`);
      }

      if (!modelNames.includes(relation.model)) {
        throw new Error(`Model definition of '${model.name}' is invalid: model '${relation.model}' is referenced, but does not exist`);
      }

      if (relation.through && !modelNames.includes(relation.through)) {
        throw new Error(`Model definition of '${model.name}' is invalid: model '${relation.through}' is referenced, but does not exist`);
      }
    });
  });

  // Initialize Sequelize models based on the definitions
  const models = definitions
    .map(model => model.set(
      'sequelize',
      sequelize.define(
        model.name,
        model.properties.reduce(
          (object, property) => {
            const sequelizeProp = {
              type: Sequelize[property.type.toUpperCase()],
              primaryKey: property.primaryKey,
              unique: property.unique,
              allowNull: !property.required,
              defaultValue:
                property.defaultFn
                  ? Sequelize[property.defaultFn.toUpperCase()]
                  : property.default,
              autoIncrement: property.autoIncrement || false,
              set: null,
            };

            if (property.setter) {
              sequelizeProp.set = function customSetter(value) {
                return this.setDataValue(property.name, property.setter(value));
              };
            }

            return Object.assign(object, { [property.name]: sequelizeProp });
          }, {})
        )
      )
    );

  // Initialize Sequelize relations
  models.forEach((model) => {
    model.relations.forEach((relation) => {
      model.sequelize[relation.type](models.get(relation.model).sequelize, {
        as: relation.name,
        foreignKey: relation.foreignKey,
        through: relation.through,
      });
    });
  });


  Object.assign(app, {
    models: models.map(model => Object.assign(model.sequelize, { app })).toJS(),
  });

  // Extend models
  models.forEach((model) => {
    Object.assign(model.sequelize, model.extend(app));
  });
}

module.exports = initializeModels;
