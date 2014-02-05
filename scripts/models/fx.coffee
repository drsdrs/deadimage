'use strict';

class backbone.Models.FxModel extends Backbone.Model
  defaults:
    title: "lalla"
    formula: "d&d>>2"
    category: "new"
    
  initialize: ->
    console.log "FXmodel init"
    
  clear: ->
    @destroy()
    @view.remove()
      