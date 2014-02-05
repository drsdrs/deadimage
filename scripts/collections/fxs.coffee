'use strict';

class backbone.Collections.FxsCollection extends Backbone.Collection
  
  model: backbone.Models.FxModel

  localStorage: new Backbone.LocalStorage("FxsCollection")


