ContactManager.module 'ContactsApp.Show',
  (Show, ContactManager, Backbon, Marionette, $, _) ->
    class Show.MissingContact extends Marionette.ItemView
      template: '#missing-contact-view'

    class Show.Contact extends Marionette.ItemView
      template: '#contact-view'