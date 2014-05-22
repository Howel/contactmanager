ContactManager.module 'ContactsApp.Show',
  (Show, ContactManager, Backbone, Marionette, $, _) ->
    Show.Controller =
      showContact: (id) ->
        loadingView = new ContactManager.Common.Views.Loading
          title: 'Artificial Loading Delay'

        ContactManager.mainRegion.show(loadingView)

        fetchingContact = ContactManager.request 'contact:entity', id
        $.when(fetchingContact).done((contact) ->
          contactView = null
          if contact
            contactView = new Show.Contact
              model: contact
          else
            contactView = new Show.MissingContact()

          ContactManager.mainRegion.show contactView
        )


