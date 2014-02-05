'use strict';

class backbone.Views.FxListView extends Backbone.View

  el: '#listContainer'

  events:
    'click label[for=newItem]': 'addNewItem'
    'click label[for=showMenu]': 'toggleMenu'
    'click label[for=saveImage]': 'saveImage'
    'click label[for=bgColor]': 'toggleColorPicker'

  inEdit: false

  childViews:[]

  initialize: (args) ->
    @fxs = args.fxs
    @canvasView = args.canvasView
    @fxEditView = new backbone.Views.FxEditView(listView: @)
    @addCategroies()
    @applyFx()

  applyFx: (formula) ->
    @canvasView.applyFx(formula)

  saveImage: ->
    canvas = document.getElementById('editImage')
    image = canvas.toDataURL("image/png").replace("image/png", "image/octet-stream")
    window.location.href=image

  toggleMenu: (e) ->
    $('ul').slideToggle("fast")
    e.preventDefault()

  toggleColorPicker: ->
    @canvasView.toggleColorPicker()

  addNewItem: ->
    if @inEdit==true then return
    fx = new backbone.Models.FxModel
    @fxEditView.newItem(fx)

  addItem: (fx) ->
    itemView = new backbone.Views.ItemView(fx: fx, fxEditView: @fxEditView, canvasView: @canvasView)
    @childViews.push(itemView)
    @$el.find("ul").append(itemView.render().el)

  addCategroies: ->
    that = @
    @removeAllItemViews()
    $('#fxList').empty()
    @fxs.each (fx) ->
      category = fx.get('category')
      if category
        existendCategory = $('ul .' + category)
        if existendCategory.length == 0
          $('ul').append('<li class="'+category+'"><a>' + category + '</a></li>')
          that.addItemsInCategroies(category)
      else
        existendCategory = $('ul')
  addItemsInCategroies: (category) ->
    $('.' + category).append('<ol></ol>')
    query = @fxs.where({category: category})
    len = query.length
    while(len--)
      itemView = new backbone.Views.ItemView(fx: query[len], fxEditView: @fxEditView, canvasView: @canvasView)
      @childViews.push(itemView)
      $('.' + category).find('ol').append(itemView.render().el)


  setItem: (fx, action) ->
    if action=='create'
      @fxs.add(fx)
      @addItem(fx)
    else if action=='update'
      id = fx.get('id')
      @fxs.where({id: id})[0] = fx
    @inEdit = false
    @addCategroies()

  removeAllItemViews: ->
    len = @childViews.length
    while(len--)
      @childViews[len].remove()

