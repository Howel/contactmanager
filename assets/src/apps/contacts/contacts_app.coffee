ContactManager.module 'ContactsApp',
  (ContactsApp, ContactManager, Backbone, Marionette, $, _) ->
    class ContactsApp.Router extends Marionette.AppRouter
      appRoutes:
        'contacts': 'listContacts'
        'contacts/:id': 'showContact'
        'contacts/:id/edit': 'editContact'

      API =
        listContacts: ->
          ContactsApp.List.Controller.listContacts()
        showContact: (id) ->
          ContactsApp.Show.Controller.showContact(id)
        editContact: (id) ->
          ContactsApp.Edit.Controller.editContact(id)

      ContactManager.on 'contacts:list', ->
        ContactManager.navigate 'contacts'
        API.listContacts()

      ContactManager.on 'contact:show', (id) ->
        ContactManager.navigate "contacts/#{id}"
        API.showContact(id)

      ContactManager.on 'contact:edit', (id) ->
        ContactManager.navigate "contacts/#{id}/edit"
        API.editContact(id)


      ContactManager.addInitializer ->
        new ContactsApp.Router
          controller: API