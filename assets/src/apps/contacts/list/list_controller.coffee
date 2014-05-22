ContactManager.module 'ContactsApp.List',
  (List, ContactManager, Backbone, Marionette, $, _) ->
    List.Controller =
      listContacts: ->
        fetchingContacts = ContactManager.request('contact:entities')

        contactsListLayout = new List.Layout()
        contactsListPanel = new List.Panel()


        $.when(fetchingContacts).done (contacts) ->
          contactsListView = new List.Contacts
            collection: contacts

          contactsListPanel.on 'contacts:filter', (filterCriterion) ->
            console.log "Handling criterion #{filterCriterion}"

          contactsListLayout.on 'show', ->
            contactsListLayout.panelRegion.show contactsListPanel
            contactsListLayout.contactsRegion.show contactsListView

          contactsListPanel.on 'contact:new', ->
            newContact = new ContactManager.Entities.Contact()

            view = new ContactManager.ContactsApp.New.Contact
              model: newContact
              asModal: true

            view.on 'form:submit', (data) ->
              if (contacts.length > 0)
                highestId = contacts.max((c) ->  return c.id ).get("id")
                data.id = highestId + 1
              else
                data.id = 1

              if newContact.save data
                contacts.add(newContact)
                ContactManager.dialogRegion.close()
                contactsListView.children.findByModel(newContact)
                  .flash("success");
              else
                view.triggerMethod 'form:data:invalid', newContact.validationError

            ContactManager.dialogRegion.show(view)

          contactsListView.on 'itemview:contact:delete', (childView, model) ->
            model.destroy()

          contactsListView.on 'itemview:contact:show', (childView, model) ->
            ContactManager.trigger 'contact:show', model.get('id')

          contactsListView.on 'itemview:contact:edit', (childView, model) ->
            view = new ContactManager.ContactsApp.Edit.Contact
              model: model
              asModal: true

            view.on 'form:submit', (data) ->
              if model.save data
                childView.render()
                ContactManager.dialogRegion.close()
                childView.flash 'success'
              else
                view.triggerMethod 'form:data:invalid', model.validationError

            ContactManager.dialogRegion.show(view)


          ContactManager.mainRegion.show(contactsListLayout)
