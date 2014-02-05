'use strict';

class backbone.Views.CanvasView extends Backbone.View
  
  el: '#canvasContainer'
  
  template: JST['app/scripts/templates/canvas.ejs']
  
  events:
    'click .loadImage': 'loadImage'
    'click .saveImage': 'saveImage'

  initialize: () ->
    @render()
    @canvas = new backbone.Models.CanvasModel
  
  applyFx: (formula) ->
    @canvas.applyFx(formula)

  saveImage: ->
    @canvas.canvas('canvas', 'editImage')
    image = canvas.toDataURL("image/png").replace("image/png", "image/octet-stream")
    window.location.href=image
  
  render: ->
    @$el.html(@template)
    @

  toggleColorPicker: ->
    $('#colorPicker').fadeToggle('medium')