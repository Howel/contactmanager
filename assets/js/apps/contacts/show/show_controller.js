// Generated by CoffeeScript 1.7.1
ContactManager.module('ContactsApp.Show', function(Show, ContactManager, Backbone, Marionette, $, _) {
  return Show.Controller = {
    showContact: function(id) {
      var fetchingContact, loadingView;
      loadingView = new ContactManager.Common.Views.Loading({
        title: 'Artificial Loading Delay'
      });
      ContactManager.mainRegion.show(loadingView);
      fetchingContact = ContactManager.request('contact:entity', id);
      return $.when(fetchingContact).done(function(contact) {
        var contactView;
        contactView = null;
        if (contact) {
          contactView = new Show.Contact({
            model: contact
          });
        } else {
          contactView = new Show.MissingContact();
        }
        return ContactManager.mainRegion.show(contactView);
      });
    }
  };
});