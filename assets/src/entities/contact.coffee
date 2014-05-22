ContactManager.module 'Entities',
  (Entities, ContactManager, Backbone, Marionette, $, _) ->
    class Entities.Contact extends Backbone.Model
      urlRoot: 'contacts'

      defaults:
        firstName: ''
        lastName: ''
        phoneNumber: ''
      validate: (attrs, options) ->
        errors = {}
        errors.firstName = "can't be blank" unless attrs.firstName
        errors.lastName = "can't be blank" unless attrs.lastName
        errors.lastName = "is too short" unless attrs.lastName && attrs.lastName.length > 1

        return errors unless _.isEmpty errors

    Entities.configureStorage(Entities.Contact)

    class Entities.ContactCollection extends Backbone.Collection
      url: 'contacts'
      model: Entities.Contact
      comparator: 'firstName'

    Entities.configureStorage(Entities.ContactCollection)

    contacts = null
    initializeContacts = ->
      contacts = new Entities.ContactCollection [
        { id: 1, firstName: 'Alice', lastName: 'Arten', phoneNumber: '555-0184' },
        { id: 2, firstName: 'Bob', lastName: 'Brigham', phoneNumber: '555-0163' },
        { id: 3, firstName: 'Charlie', lastName: 'Campbell', phoneNumber: '555-0129' }
      ]

      contacts.forEach( (contact) -> contact.save() )
      return contacts.models

    API =
      getContactEntities: ->
        contacts = new Entities.ContactCollection()
        defer = $.Deferred()
        contacts.fetch
          success: (data) ->
            defer.resolve(data)

        promise = defer.promise()

        $.when(promise).done (contacts) ->
          if (contacts.length is 0)
            models = initializeContacts()
            contacts.reset(models)

        return contacts

      getContactEntity: (contactId) ->
        contact = new Entities.Contact( { id: contactId })
        defer = $.Deferred()
        setTimeout( ->
          contact.fetch
            success: (data) ->
              defer.resolve(data)
            error: (data) ->
              defer.resolve(undefined)
        , 500)

        return defer.promise()

    ContactManager.reqres.setHandler('contact:entities', ->
      API.getContactEntities())

    ContactManager.reqres.setHandler('contact:entity', (id) ->
      API.getContactEntity(id))