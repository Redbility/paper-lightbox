Polymer
	is: 'paper-lightbox'

	_createPopup: ->
		# set vars
		module = this

		# create container
		container = document.createElement 'div'
		container.classList.add 'paper-lightbox-popup'

		# create window
		module.window = document.createElement 'div'
		module.window.classList.add 'paper-lightbox-popup_window'
		container.appendChild module.window

		# create overlay
		overlay = document.createElement 'div'
		overlay.classList.add 'paper-lightbox-popup_overlay'
		container.appendChild overlay

		# container.innerHTML = module.ajaxResponse
		module.appendChild container

	_parseAjax: (content) ->
		# set vars
		module = this

		module.window.innerHTML = content

	_ajaxResponse: (data) ->
		# set vars
		module = this

		# save response
		module.ajaxResponse = data.target.lastResponse

	_createAjax: ->
		# set vars
		module = this

		# create popup and parse content
		@_createPopup()
		@_parseAjax(module.ajaxResponse)

		# close popup event
		@_closePopup()

	_createImage: ->
		# set vars
		module = this
		image = new Image()

		# create image
		image.onload = ->
			# append image after is loaded
			module.window.appendChild image
		image.src = module.getAttribute 'src'

		# create popup and parse content
		@_createPopup()

		# close popup event
		@_closePopup()

	_getType: ->
		# set vars
		module = this

		# get popup type
		return module.getAttribute 'type'

	_launchPopup: ->
		# set vars
		module = this

		# launch each popup type
		switch @_getType()
			when 'ajax'
				module.listen module.$$('button'), 'tap', '_createAjax'
			when 'image'
				module.listen module.$$('button'), 'tap', '_createImage'
			when 'inline'
				console.log()
			when 'iframe'
				console.log()

	_removePopup: ->
		# set vars
		module = this
		popup = module.querySelector('.paper-lightbox-popup')

		# remove popup
		popup.remove()

	_closePopup: ->
		# set vars
		module = this
		overlay = module.querySelector('.paper-lightbox-popup_overlay')

		# add overlay listener
		module.listen overlay, 'tap', '_removePopup'

	onAjaxContentLoaded: ->

	attached: ->
		@_launchPopup()
