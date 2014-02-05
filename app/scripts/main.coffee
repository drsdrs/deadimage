window.backbone =
  Models: {}
  Collections: {}
  Views: {}
  Routers: {}
  init: ->
    'use strict'
    new backbone.Routers.FxRouter

$ ->
  'use strict'
  backbone.init();