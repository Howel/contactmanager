ContactManager.module 'ContactsApp.Common.Views',
  (Views, ContactManager, Backbone, Marionette, $, _) ->
    class Views.Form extends Marionette.ItemView
      template: '#contact-form'

      events:
        'click button.js-submit': 'submitClicked'

      submitClicked: (e) ->
        e.preventDefault()
        data = Backbone.Syphon.serialize(@)
        @trigger 'form:submit', data

      onRender: ->
        if not @options.asModal
          $title = $('<h1>', { text: @title })
          @$el.prepend($title)

      onShow: ->
        if @options.asModal
          @$el.dialog
            modal: true,
            title: @title,
            width: 'auto'

      onFormDataInvalid: (errors) ->
        $view = @$el

        clearFormErrors = ->
          $form = $view.find('form')
          $form.find('.help-inline.error').each(-> $(@).remove())
          $form.find('.control-group.error').each(-> $(@).removeClass('error'))

        markErrors = (value, key) ->
          $controlGroup = $view.find("#contact-#{key}").parent()
          $errorEl = $("<span>", { class: "help-inline error", text: value })
          $controlGroup.append($errorEl).addClass('error')

        clearFormErrors()
        _.each(errors, markErrors)

    class Views.Loading extends Marionette.ItemView
      template: '#loading-view'

      initialize: (options) ->
        options ||= {}
        @title = options.title || 'Loading Data'
        @message = options.message || 'Please wait, data is loading.'

      serializeData: ->
        return {
          title: @title
          message: @message
        }

      onShow: ->
        opts =
          lines: 13
          length: 20
          width: 10
          radius: 30
          corners: 1
          rotate: 0
          direction: 1
          color: '#000'
          speed: 1
          trail: 60
          shadow: false
          hwaccel: false
          className: 'spinner'
          zIndex: 2e9
          top: '30px'
          left: 'auto'

        $('#spinner').spin(opts)