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
		popup.setAttribute('closing', @getAttribute 'closing')
		popup.setAttribute('class', @getAttribute 'class')

		document.body.appendChild popup.cloneNode()

	_onLoad: ->
		module = @

		module.listen module.$$('button'), 'tap', '_createPopup'

	open: ->
		@_createPopup()

	close: ->
		popup = document.querySelector 'paper-lightbox-popup'

		popup._removePopup()
