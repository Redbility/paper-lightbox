Polymer
	is: 'paper-lightbox'

	ready: ->
		module = @

		@async(->
			setTimeout (->
				module._onLoad()
			), 0
		)

	_createPopup: ->
		popup = document.createElement 'paper-lightbox-popup'
		popup.setAttribute('type', @getAttribute 'type')
		popup.setAttribute('src', @getAttribute 'src')

		document.body.appendChild popup

	_onLoad: ->
		module = @

		module.listen module.$$('button'), 'tap', '_createPopup'

	open: ->
		@_createPopup()
