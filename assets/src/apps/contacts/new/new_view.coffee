ContactManager.module 'ContactsApp.New',
  (New, ContactManager, Backbone, Marionette, $, _) ->
    class New.Contact extends ContactManager.ContactsApp.Common.Views.Form
      initialize: ->
        @title = "New Contact"