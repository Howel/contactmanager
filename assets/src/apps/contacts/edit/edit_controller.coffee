ContactManager.module 'ContactsApp.Edit',
  (Edit, ContactManager, Backbone, Marionette, $, _) ->
    Edit.Controller =
      editContact: (id) ->
        loadingView = new ContactManager.Common.Views.Loading
          title: 'Artificial Loading delay'
        ContactManager.mainRegion.show loadingView

        fetchingContact = ContactManager.request 'contact:entity', id
        $.when(fetchingContact).done (contact) ->
          contactView = null
          if contact
            contactView = new Edit.Contact
              model: contact

            contactView.on 'form:submit', (data) ->
              if contact.save(data)
                ContactManager.trigger 'contact:show', contact.get('id')
              else
                contactView.triggerMethod 'form:data:invalid', contact.validationError
          else
            contactView = new ContactManager.ContactsApp.Show.MissingContact()

          ContactManager.mainRegion.show contactView