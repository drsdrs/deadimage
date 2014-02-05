'use strict';

class backbone.Models.CanvasModel extends Backbone.Model

  origImageData: null

  testImg: backbone.testImg

  canvas: (returnVal, canvasId)->
    canvas = document.getElementById(canvasId)
    return canvas if returnVal=='canvas'
    ctx = canvas.getContext("2d")
    return ctx if returnVal=='ctx'
    'not valid call of canvas function in origCanvas'

  initialize: () ->
    @drawOrigImage()
    @fileReader()

  applyFx: (formula) ->
    @processData(formula)

  workerstring: 'this.onmessage=function(e){var t,n,r,i,s,o,u,a,f,l,c,h,p,d;i=e.data;l=i.p;t=i.L;c=i.w;u=i.h;d=4;o=i.formula;f=function(e){return new Function("x, y, c, l, d, p, L, w, h","return "+e)};s=f(o);a=0;p=0;while(p<u){h=0;while(h<c){n=0;while(n<d){r=l[a];l[a]=s(h,p,n,a,r,l,t,c,u);n++;a++}h++}p++}return postMessage(l)}'

  processData: (formula) ->
    canvas = @canvas('canvas', 'editImage')
    ctx = @canvas('ctx', 'editImage')
    ctxOrig = @canvas('ctx', 'origImage')
    w = canvas.width
    h = canvas.height
    z = 4 #color deph

    imageData = ctxOrig.getImageData(0, 0, w, h)
    p = imageData.data
    L = p.byteLength

    blob = new Blob([@workerstring]);

    blobURL = window.URL.createObjectURL(blob);

    worker = new Worker(blobURL);

    #worker = new Worker 'workers/worker.js'
    that = @
    # listen for messages from the worker
    obj = (p: p, L: L, w: w, h: h, formula: formula)
    startWorker= ->
      if typeof(formula)!='undefined'
        that.showLoader()
        worker.postMessage obj
    worker.onmessage = (event) ->
      lg 'onmessage'
      d = event.data
      p = imageData.data
      len = p.byteLength
      while(len--)
         p[len] = d[len]
      ctx.putImageData imageData, 0, 0
      that.hideLoader()
    startWorker()



  showLoader: ->
    height = $('.span6').height()
    $('.loading').fadeIn('fast').height(height)

  hideLoader: ->
    $('.loading').hide()

  drawOrigImage: (imageBuffer) ->
    canvas = @canvas('canvas', 'origImage')
    lg canvas
    ctx = @canvas('ctx', 'origImage')
    img = new Image()
    that = @
    unless imageBuffer
      img.src = backbone.testImg
    else
      img.src = imageBuffer
    img.onload = ->
      canvas.width = img.width
      canvas.height = img.height
      ctx.drawImage img, 0, 0
      that.origImageData = img
      that.origToEditImage()
      that.hideLoader()


  origToEditImage: ->
    origImageCanvas = @canvas('canvas', 'origImage')
    editImageCanvas = @canvas('canvas', 'editImage')
    editImageCtx = @canvas('ctx', 'editImage')
    editImageCanvas.width = origImageCanvas.width
    editImageCanvas.height = origImageCanvas.height
    editImageCtx.drawImage(@origImageData, 0, 0)

  fileReader: ->
    that= @
    handleFileSelect = (evt) ->
      lg evt
      reader = new FileReader()
      reader.onerror = (e) ->
        console.log "Fileerror", e
      reader.onload = (e) ->
        that.origImageData = e.target.result
        that.drawOrigImage(e.target.result)
      reader.onloadstart = (e) ->
        that.showLoader()

      # Read in the image file as a binary string.
      reader.readAsDataURL evt.target.files[0]
    reader = undefined
    fileElement = document.getElementById("loadImage")
    fileElement.addEventListener "change", handleFileSelect, false  if fileElement
