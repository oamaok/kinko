/* eslint-disable import/no-extraneous-dependencies */
const webpack = require('webpack');
const nodemon = require('nodemon');
const WebpackDevServer = require('webpack-dev-server');

const config = require('../webpack.development.config.js');

const PORT = 3000;

config.entry.app.unshift(`webpack-dev-server/client?http://localhost:${PORT}/`, 'webpack/hot/dev-server');

const compiler = webpack(config);
const server = new WebpackDevServer(compiler, {
  hot: true,
  proxy: {
    '/api': {
      target: {
        port: 3001,
      },
    },
  },
  stats: {
    colors: true,
    hash: false,
    timings: true,
    chunks: false,
    chunkModules: false,
    modules: false,
  },
});

server.listen(PORT);

const backend = nodemon({
  exec: 'node',
  restartable: 'rs',
  script: './server/server',
  verbose: true,
  watch: [
    './server/',
  ],
  env: {
    NODE_ENV: 'development',
  },
  ext: 'js json',
});

backend.on('crash', () => {
  process.stderr.write('Backend crashed!\n');
});

backend.on('restart', () => {
  process.stdout.write('Changes in files detected, restarting backend.\n');
});

const handleExit = () => {
  server.close(() => process.exit(0));
};

process.on('SIGINT', handleExit);
