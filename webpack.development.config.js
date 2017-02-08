const path = require('path');
const autoprefixer = require('autoprefixer');
const webpack = require('webpack');

const HtmlWebpackPlugin = require('html-webpack-plugin');
const ExtractTextPlugin = require('extract-text-webpack-plugin');

const plugins = [
  // Injects the JS files into the template HTML file
  new HtmlWebpackPlugin({
    template: path.join(__dirname, 'client/index.html'),
    inject: 'body',
    filename: 'index.html',
  }),

  new webpack.HotModuleReplacementPlugin(),

  new webpack.LoaderOptionsPlugin({
    options: {
      postcss: () => [autoprefixer],
    },
  }),
];

module.exports = {
  entry: [
    path.resolve(__dirname, 'client/index'),
    path.resolve(__dirname, 'client/sass/main'),
    'webpack-hot-middleware/client',
  ],

  plugins,

  output: {
    path: path.join(__dirname, 'build/'),
    filename: '[name].[hash].js',
    publicPath: '/',
  },

  devtool: 'eval-source-map',

  resolve: {
    extensions: ['.elm', '.js', '.sass'],
  },

  module: {
    loaders: [
      {
        test: /\.elm$/,
        loader: 'elm-hot-loader!elm-webpack-loader?verbose=true&warn=true&debug=true',
      },
      {
        test: /\.s[ac]ss$/,
        loaders: [
          'style-loader',
          'css-loader',
          'postcss-loader',
          'sass-loader',
        ],
      },
      {
        test: /\.(png|jpg|jpeg|gif|ttf|eot|woff2|woff)$/,
        loader: 'url-loader',
      },
    ],
  }
};