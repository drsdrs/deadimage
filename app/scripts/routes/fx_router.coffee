'use strict';

class backbone.Routers.FxRouter extends Backbone.Router

  initialize: ->
    console.log "router init"
    window.lg = (log) ->
      console.log log

    Backbone.history.start()

  routes:
    '': 'index'


  index: ->
    fxs = new backbone.Collections.FxsCollection
    fxs.fetch()

    canvasView = new backbone.Views.CanvasView()
    fxListView = new backbone.Views.FxListView(fxs: fxs, canvasView: canvasView)
    fxListView.render()
    #fxStatsView = new backbone.Views.FxStatsView(fxs: fxs)
    # fxView = new backbone.Views.FxView(
      # fxs: fxs,
      # fxListView: fxListView,
      # #fxStatsView: fxStatsView
    # )
