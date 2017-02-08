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

  new webpack.LoaderOptionsPlugin({
    options: {
      postcss: () => [autoprefixer],
    },
  }),

  new ExtractTextPlugin('[contenthash].css'),
];

module.exports = {
  entry: [
    path.resolve(__dirname, 'client/index'),
    path.resolve(__dirname, 'client/sass/main'),
  ],

  plugins,

  output: {
    path: path.join(__dirname, 'build/'),
    filename: 'bundle.[hash].js',
    publicPath: '/',
  },

  devtool: '',

  resolve: {
    extensions: ['.elm', '.js', '.sass'],
  },

  module: {
    loaders: [
      {
        test: /\.elm$/,
        loader: 'elm-webpack-loader',
      },
      {
        test: /\.s[ac]ss$/,
        loader: ExtractTextPlugin.extract('css-loader!postcss-loader!sass-loader'),
      },
    ],
  }
};