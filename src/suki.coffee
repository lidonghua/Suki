express = require 'express'
path    = require 'path'
fs      = require 'fs'
utils   = require './utils'
config  = require 'config'

Sequelize  = require 'sequelize'

requireDirectory = (directory) ->
  files = fs.readdirSync directory
  files = files.filter (name) ->
    '.coffee' is path.extname name
  files = files.map    (name) ->
    instance = require path.join directory, name
    instance.moduleName = path.basename name.toLowerCase(), path.extname name
    instance

Suki = (option = {}) ->
  # Make `Suki` as a global var
  app = express()

  unless option.skipUse
    app.use express.bodyParser()
    app.use express.methodOverride()

  appDirectory =
    option.appDirectory or path.dirname module.parent.parent.filename

  # Load controllers
  controllers =
    requireDirectory path.join appDirectory, 'app', 'controllers'

  for controller in controllers
    controller.initialize()
    controller._mapToRoute app, option

  if config.sequelize
    # Connect to Database via sequelize
    sequelize = new Sequelize config.sequelize.database,
      config.sequelize.username,
      config.sequelize.password,
      config.sequelize

    # Sync Database
    if config.sequelize.sync
      sequelize.sync()

  if config.mongoose
    'pass'

  # Load models
  models =
    requireDirectory(path.join appDirectory, 'app', 'models')

  for model in models
    if model._type is 'Sequelize'
      throw new Error 'Missing config for sequelize' unless sequelize
      model._initModel Sequelize, sequelize

    app.set model.modelName, model.model

  # Init associations for Sequelize
  for model in models then model._initAssociations?()
  app

Suki.Controller = require './Controller'
Suki.SequelizeModel = require './SequelizeModel'

global.Suki = module.exports = Suki
