ContactManager = new Marionette.Application()

ContactManager.addRegions
  mainRegion: '#main-region'
  dialogRegion: '#dialog-region'

ContactManager.navigate = (route, options) ->
  options ||= {}
  Backbone.history.navigate route, options

ContactManager.getCurrentRoute = ->
  Backbone.history.fragment

ContactManager.on 'initialize:after', ->
  if Backbone.history
    Backbone.history.start()

    if @getCurrentRoute() is ''
      ContactManager.trigger 'contacts:list'
