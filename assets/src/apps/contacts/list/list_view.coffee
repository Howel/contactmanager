ContactManager.module 'ContactsApp.List',
  (List, ContactManager, Backbone, Marionette, $, _) ->
    class List.Layout extends Marionette.Layout
      template: '#contact-list-layout'

      regions:
        panelRegion: '#panel-region'
        contactsRegion: '#contacts-region'

    class List.Panel extends Marionette.ItemView
      template: '#contact-list-panel'

      triggers:
        'click button.js-new': 'contact:new'

      events:
        'submit #filter-form': 'filterContacts'

      filterContacts: (e) ->
        e.preventDefault()
        criterion = @$('.js-filter-criterion').val()
        @trigger 'contacts:filter', criterion

    class List.Contact extends Marionette.ItemView
      tagName: 'tr'
      template: '#contact-list-item'

      events:
        'click': 'highlightName'
        'click button.js-remove': 'deleteClicked'
        'click td a.js-show': 'showClicked'
        'click td a.js-edit': 'editClicked'

      remove: ->
         @$el.fadeOut =>
            Marionette.ItemView.prototype.remove.call(@)

      highlightName: ->
         @$el.toggleClass 'danger'

      flash: (cssClass) ->
        $view = @$el
        $view.hide().toggleClass(cssClass).fadeIn(800, ->
          setTimeout(->
            $view.toggleClass(cssClass)
          , 500 ))

      deleteClicked: (e) ->
         e.stopPropagation()
         @trigger 'contact:delete', @model

      showClicked: (e) ->
        e.preventDefault()
        e.stopPropagation()
        @trigger 'contact:show', @model

      editClicked: (e) ->
        e.preventDefault()
        e.stopPropagation()
        @trigger 'contact:edit', @model

    class List.Contacts extends Marionette.CompositeView
      tagName: 'table'
      className: 'table table-hover'
      template: '#contact-list'
      itemView: List.Contact
      itemViewContainer: 'tbody'
