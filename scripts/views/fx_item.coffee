'use strict';

class backbone.Views.ItemView extends Backbone.View
    
  tagName: 'li'
  
  template: JST['app/scripts/templates/fx_item.ejs']
  
  events:
    'click label': 'editItem'
    'click a': 'applyFx'

  initialize: (args) ->
    @fx = args.fx
    @fxEditView = args.fxEditView
    @canvasView = args.canvasView
    @fx.bind('change', @render, @)
    @fx.bind('destroy', @remove, @)

  applyFx: (formula) -> 
    unless formula then @canvasView.applyFx(@fx.get('formula')) else @canvasView.applyFx(@fx.get('formula'))

  render: ->
    @fx.save()
    @$el.html(@template(@fx.attributes))
    @

  remove: ->
    @$el.remove()

  close: ->
    this.remove();
    this.unbind();
    this.model.unbind("change", this.modelChanged);

  destroy: ->
    @fx.destroy()
    false

  editItem: () ->
    @fxEditView.editItem(@fx)