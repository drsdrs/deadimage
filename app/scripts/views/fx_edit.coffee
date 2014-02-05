'use strict';

class backbone.Views.FxEditView extends Backbone.View
    
  el: '#editItem'
 
  created: false
 
  events:
    'click #saveItem': 'saveItem'
    'click #testItem': 'testItem'
    'click #cancelEdit': 'cancelEdit'
    'click #deleteItem': 'deleteItem'
    'keyup textarea': 'checkKeyUp'

  formula: $('#editItem textarea')
  itemName: $('#editItem #itemName')
  itemCategory: $('#editItem #itemCategory')
  
  initialize: (args) ->
    @listView = args.listView
   
  checkKeyUp: (e) ->
    key = e.keyCode
    if key==18 # altGr for testing Picture
      e.preventDefault()
      @testItem()
      return
      
    console.log(e.keyCode)
     
  testItem: ->
    @listView.applyFx(@formula.val())
      
  saveItem: () ->
    title = @itemName.val()
    formula = @formula.val()
    category = @itemCategory.val()
    if formula=='' || title=='' 
      alert('Fill out name, formula and category.')
      return
    if category.length>=20 || title.length>=20 
      alert('Please less than 20 letters in name and category.')
      return
    lg category.length
    @fx.set(formula: formula)
    @fx.set(title: title)
    @fx.set(category: category)
    
    @hideEditView()
    if @created==false
      @listView.setItem(@fx, 'update')
    else
      @listView.setItem(@fx, 'create')
      
  cancelEdit: () ->
    console.log(@listView)
    @listView.setItem(null, 'cancel')
    @hideEditView()

  deleteItem: ->
    @fx.destroy()
    @hideEditView()

  render: () ->
    #$(@el).html "hello model"#"<span>#{@model.get 'title'} #{@model.get 'formula'}!</span>"

  editItem: (fx) ->
    @created=false
    @showEditView()
    @fx = fx
    @formula.val(fx.get('formula'))
    @itemName.val(fx.get('title'))
    @itemCategory.val(fx.get('category'))

  newItem: (fx)->
    @created=true
    @showEditView()
    @fx = fx
    @formula.val('')
    @itemName.val('')
    @itemCategory.val('')



  showEditView: ->
    $('#fxList').hide()
    $('#editItem').slideDown()
    $('.filterList').slideUp()
    #$('.canvasArea canvas').addClass("editOn")
    #$('.canvasArea #loader').addClass("editOn")
    $('body').addClass('editOn')
    $('#itemName').focus()
    
  hideEditView: ->
    $('#fxList').show()
    $('#editItem').slideUp()
    $('.filterList').slideDown("slow")
    $('body').removeClass('editOn')
    #$('.canvasArea canvas').removeClass("editOn")
    #$('.canvasArea #loader').removeClass("editOn")
