Polymer
	is: 'paper-lightbox'

	behaviors: [
		Polymer.IronResizableBehavior
	]

	listeners:
		'iron-resize': '_onResize'

	_createPopup: ->
		# set vars
		module = this

		# create container
		container = document.createElement 'div'
		container.classList.add 'paper-lightbox-popup'

		# create close button
		close = document.createElement 'iron-icon'
		close.classList.add 'paper-lightbox-popup_close'
		close.setAttribute 'icon', 'icons:close'

		# create window
		module.window = document.createElement 'div'
		module.window.classList.add 'paper-lightbox-popup_window'
		module.window.appendChild close
		container.appendChild module.window

		# create overlay
		overlay = document.createElement 'div'
		overlay.classList.add 'paper-lightbox-popup_overlay'
		container.appendChild overlay

		# container.innerHTML = module.ajaxResponse
		module.appendChild container

	_getImageRatio: (width, height) ->
		module = this

		if width > height
			module.window.classList.add 'landscape'
		else
			module.window.classList.add 'portrait'

	_isAjax: ->
		# set vars
		module = this

		if @_getType() == 'ajax'
			return true

	_parseAjax: (content) ->
		# set vars
		module = this
		capsule = document.createElement 'div'
		capsule.innerHTML = content

		[].forEach.call capsule.children, (val, key) ->
			module.window.appendChild val

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

		# add type class
		module.window.classList.add 'paper-lightbox-popup_window-ajax'

		# close popup event
		@_closePopup()

	_createImage: ->
		# set vars
		module = this
		image = new Image()

		# create image
		image.onload = ->
			# create popup and parse content
			module._createPopup()
			module._getImageRatio(image.naturalWidth, image.naturalHeight)

			# add type class
			module.window.classList.add 'paper-lightbox-popup_window-image'

			# append image after is loaded
			module.window.appendChild image

			# fire resize event
			module._onResize()

			# close popup event
			module._closePopup()

		image.src = module.getAttribute 'src'

	_createIframe: ->
		# set vars
		module = this
		url = module.getAttribute 'src'
		iframe = document.createElement('iframe')
		newYtbUrl = url.replace('/watch?v=', '/embed/')
		iframe.setAttribute 'frameborder', '0'
		iframe.setAttribute 'allowfullscreen', ''

		# create iframe wrapper
		iframeWrapper = document.createElement('div')
		iframeWrapper.classList.add 'paper-lightbox_iframeWrapper'

		# if url is a youtube web
		if url.indexOf('youtube.com/watch?v=') > -1
			iframe.setAttribute 'src', newYtbUrl
		else
			iframe.setAttribute 'src', url

		# create popup and parse content
		@_createPopup()

		# add type class
		module.window.classList.add 'paper-lightbox-popup_window-iframe'

		# append iframe
		iframeWrapper.appendChild iframe
		module.window.appendChild iframeWrapper

		# close popup event
		@_closePopup()

	_createInline: ->
		# set vars
		module = this
		content = document.querySelector module.getAttribute 'src'

		# create popup and parse content
		@_createPopup()

		# add type class
		module.window.classList.add 'paper-lightbox-popup_window-inline'

		# append cloned content
		module.window.appendChild content.cloneNode true

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
				module.listen module.$$('button'), 'tap', '_createInline'
			when 'iframe'
				module.listen module.$$('button'), 'tap', '_createIframe'

	_removePopup: ->
		# set vars
		module = this
		popup = module.querySelector('.paper-lightbox-popup')
		@window = undefined

		# remove popup window
		popup.remove()

	_closePopup: ->
		# set vars
		module = this
		overlay = module.querySelector('.paper-lightbox-popup_overlay')
		close = module.querySelector('.paper-lightbox-popup_close')

		# add overlay listener
		module.listen overlay, 'tap', '_removePopup'
		module.listen close, 'tap', '_removePopup'

	_onResize: ->
		# if popup is open
		if @window

			# if image has portrait ratio
			if @window.classList.contains 'portrait'
				image = @window.querySelector('img')

				# limits image height
				image.style.maxHeight = (window.innerHeight * 0.8) + 'px'

	ready: ->
		@_launchPopup()

	onAjaxContentLoaded: ->

	onImageLoaded: ->

	open: ->
		module = @

		switch @_getType()
			when 'ajax'
				@_createAjax()
			when 'image'
				@_createImage()
			when 'inline'
				@_createInline()
			when 'iframe'
				@_createIframe()
