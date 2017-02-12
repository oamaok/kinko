require('babel-register')({
  plugins: ['transform-async-to-generator'],
});

const app = require('./server');

app.listen(app.config.port);
