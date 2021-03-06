// Generated by CoffeeScript 1.7.1
ContactManager.module('ContactsApp.List', function(List, ContactManager, Backbone, Marionette, $, _) {
  return List.Controller = {
    listContacts: function() {
      var contactsListLayout, contactsListPanel, fetchingContacts;
      fetchingContacts = ContactManager.request('contact:entities');
      contactsListLayout = new List.Layout();
      contactsListPanel = new List.Panel();
      return $.when(fetchingContacts).done(function(contacts) {
        var contactsListView;
        contactsListView = new List.Contacts({
          collection: contacts
        });
        contactsListPanel.on('contacts:filter', function(filterCriterion) {
          return console.log("Handling criterion " + filterCriterion);
        });
        contactsListLayout.on('show', function() {
          contactsListLayout.panelRegion.show(contactsListPanel);
          return contactsListLayout.contactsRegion.show(contactsListView);
        });
        contactsListPanel.on('contact:new', function() {
          var newContact, view;
          newContact = new ContactManager.Entities.Contact();
          view = new ContactManager.ContactsApp.New.Contact({
            model: newContact,
            asModal: true
          });
          view.on('form:submit', function(data) {
            var highestId;
            if (contacts.length > 0) {
              highestId = contacts.max(function(c) {
                return c.id;
              }).get("id");
              data.id = highestId + 1;
            } else {
              data.id = 1;
            }
            if (newContact.save(data)) {
              contacts.add(newContact);
              ContactManager.dialogRegion.close();
              return contactsListView.children.findByModel(newContact).flash("success");
            } else {
              return view.triggerMethod('form:data:invalid', newContact.validationError);
            }
          });
          return ContactManager.dialogRegion.show(view);
        });
        contactsListView.on('itemview:contact:delete', function(childView, model) {
          return model.destroy();
        });
        contactsListView.on('itemview:contact:show', function(childView, model) {
          return ContactManager.trigger('contact:show', model.get('id'));
        });
        contactsListView.on('itemview:contact:edit', function(childView, model) {
          var view;
          view = new ContactManager.ContactsApp.Edit.Contact({
            model: model,
            asModal: true
          });
          view.on('form:submit', function(data) {
            if (model.save(data)) {
              childView.render();
              ContactManager.dialogRegion.close();
              return childView.flash('success');
            } else {
              return view.triggerMethod('form:data:invalid', model.validationError);
            }
          });
          return ContactManager.dialogRegion.show(view);
        });
        return ContactManager.mainRegion.show(contactsListLayout);
      });
    }
  };
});
