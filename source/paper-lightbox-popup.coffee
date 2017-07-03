Polymer
	is: 'paper-lightbox-popup'

	behaviors: [
		Polymer.IronResizableBehavior
	]

	listeners:
		'iron-resize': '_onResize'

	_createPopup: ->
		# set vars
		module = this

		# remove focus of background elements
		@_removeBackgroundFocus()

		# create container
		@container = document.createElement 'div'
		@container.classList.add 'paper-lightbox-popup'

		# opening animation
		if @_getType() != 'ajax'
			@container.classList.add('opening')

		# create close button
		close = document.createElement 'iron-icon'
		close.classList.add 'paper-lightbox-popup_close'
		close.setAttribute 'icon', 'icons:close'
		close.setAttribute 'tabindex', '0'

		# create window
		module.window = document.createElement 'div'
		module.window.classList.add 'paper-lightbox-popup_window'
		module.window.appendChild close
		@container.appendChild module.window

		# create overlay
		overlay = document.createElement 'div'
		overlay.classList.add 'paper-lightbox-popup_overlay'
		@container.appendChild overlay

		# parse container
		module.appendChild @container

		# locking background scroll on mobile devices
		lockLayer = document.querySelector '.paper-lightbox-lockScroll'

		if lockLayer == undefined || lockLayer == null
			module._removeScrolling()

	_getImageRatio: (width, height) ->
		module = this

		if width > height
			module.window.classList.add 'landscape'
		else
			module.window.classList.add 'portrait'

	_isAjax: (type) ->
		# set vars
		module = this

		if type == 'ajax'
			return true

	_parseAjax: (content) ->
		# set vars
		module = this
		capsule = document.createElement 'div'
		capsule.innerHTML = content

		[].forEach.call capsule.children, (val, key) ->
			module.window.appendChild val

			# add animation after content is loaded
			module.container.classList.add('opening')

	_ajaxResponse: (data) ->
		# set vars
		module = this

		# save response
		module.ajaxResponse = data.target.lastResponse

		@_createAjax()

	_createAjax: ->
		# set vars
		module = this

		# fire event before open
		@_fireCustomEvents('onBeforeOpen')

		# create popup and parse content
		@_createPopup()
		@_parseAjax(module.ajaxResponse)

		# add type class
		module.window.classList.add 'paper-lightbox-popup_window-ajax'

		# fire event after open
		@_fireCustomEvents('onAfterOpen')

		# close popup event
		@_closePopupEvent()

	_createImage: ->
		# set vars
		module = this
		image = new Image()

		# fire event before open
		@_fireCustomEvents('onBeforeOpen')

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

			# fire event after open
			module._fireCustomEvents('onAfterOpen')

			# close popup event
			module._closePopupEvent()

		image.src = module.getAttribute 'src'

	_createIframe: ->
		# set vars
		module = this
		url = module.getAttribute 'src'
		iframe = document.createElement('iframe')
		newYtbUrl = url.replace('/watch?v=', '/embed/')
		iframe.setAttribute 'frameborder', '0'
		iframe.setAttribute 'allowfullscreen', ''

		# fire event before open
		@_fireCustomEvents('onBeforeOpen')

		# create iframe wrapper
		iframeWrapper = document.createElement('div')
		iframeWrapper.classList.add 'paper-lightbox_iframeWrapper'

		# if url is a youtube web
		if url.indexOf('youtube.com/watch?v=') > -1
			iframe.setAttribute 'src', newYtbUrl + '?autoplay=1'
		else
			iframe.setAttribute 'src', url + '?autoplay=1'

		# create popup and parse content
		@_createPopup()

		# add type class
		module.window.classList.add 'paper-lightbox-popup_window-iframe'

		# append iframe
		setTimeout (->
			iframeWrapper.appendChild iframe
			module.window.appendChild iframeWrapper
		), 100

		# fire event after open
		@_fireCustomEvents('onAfterOpen')

		# close popup event
		@_closePopupEvent()

	_createInline: ->
		# set vars
		module = this
		content = document.querySelector module.getAttribute 'src'

		# fire event before open
		@_fireCustomEvents('onBeforeOpen')

		# create popup and parse content
		@_createPopup()

		# add type class
		module.window.classList.add 'paper-lightbox-popup_window-inline'

		# append cloned content
		module.window.appendChild content.cloneNode true

		# fire event after open
		@_fireCustomEvents('onAfterOpen')

		# close popup event
		@_closePopupEvent()

	_getType: ->
		# set vars
		module = this

		# get popup type
		return module.getAttribute 'type'

	_launchPopup: ->
		module = @

		switch @_getType()
			when 'image'
				@_createImage()
			when 'inline'
				@_createInline()
			when 'iframe'
				@_createIframe()

	_removePopup: ->
		# set vars
		module = this
		popup = @container
		@window = undefined
		closingTime = 0
		if module.getAttribute('closing') != null && module.getAttribute('closing') != undefined
			closingTime = module.getAttribute('closing')

		# reset focus of background elements
		@_resetBackgroundFocus()

		# remove close event listener
		module.unlisten document, 'keyup', '_closeWithEsc'

		# fire event before close
		@_fireCustomEvents('onBeforeClose')

		# remove animation
		popup.classList.remove('opening')
		setTimeout (->
			popup.classList.add('closing')
		), 0

		setTimeout (->
			# remove scrolling
			module._addScrolling()

			# remove popup
			document.body.removeChild(module)

			# fire event after close
			module._fireCustomEvents('onAfterClose')
		), closingTime

	_closePopupEvent: ->
		# set vars
		module = this
		overlay = module.querySelector('.paper-lightbox-popup_overlay')
		close = module.querySelector('.paper-lightbox-popup_close')

		# add overlay listener
		module.listen overlay, 'tap', '_removePopup'
		module.listen close, 'tap', '_removePopup'

		## Accessibility enhancements
		# add close function if esc key is pressed
		module._closeWithEsc = (e) ->
			key = e.which || e.keyCode
			if key == 27
				module._removePopup()

		module.listen document, 'keyup', '_closeWithEsc'

		# add close function if press intro key when close button is focused
		close.addEventListener 'keypress', (e) ->
			key = e.which || e.keyCode
			if key == 13
				module._removePopup()

	_addScrolling: ->
		# set vars
		html = document.documentElement
		html.classList.remove('lock')
		lockLayer = document.querySelector '.paper-lightbox-lockScroll'
		lockLayerContent = lockLayer.children

		# reset lock styles
		lockLayer.style.height = ''
		html.style.height = ''
		document.body.style.height = ''
		lockLayer.style.overflow = ''

		# remove layer content
		while lockLayer.firstElementChild
			document.body.appendChild lockLayer.firstElementChild

		# set scroll position
		document.body.scrollTop = @bodyScroll

		# remove layer
		document.body.removeChild(lockLayer)
		document.body.style.overflow = ''

	_removeScrolling: ->
		# set vars
		@bodyScroll = document.body.scrollTop
		html = document.documentElement
		html.classList.add('lock')
		lockLayer = document.createElement 'div'
		lockLayer.classList.add('paper-lightbox-lockScroll')
		bodyContent = document.body.children
		bodyContentLength = bodyContent.length

		# apply lock styles
		lockLayer.style.height = '100%'
		html.style.height = '100%'
		document.body.style.height = '100%'
		lockLayer.style.overflow = 'hidden'

		# inject layer
		while document.body.firstElementChild
			lockLayer.appendChild document.body.firstElementChild

			if lockLayer.children.length == bodyContentLength
				document.body.appendChild lockLayer

				# set scroll position
				lockLayer.scrollTop = @bodyScroll
				return

	_removeBackgroundFocus: ->
		tabbableElements = 'a[href], area[href], input:not([disabled]), button:not([disabled]),select:not([disabled]), textarea:not([disabled]), iframe, object, embed, *[tabindex], *[contenteditable=true]'
		elements = document.querySelectorAll tabbableElements

		[].forEach.call elements, (element) ->
			element.oldTabIndex = element.tabIndex
			element.tabIndex = -1

	_resetBackgroundFocus: ->
		tabbableElements = 'a[href], area[href], input:not([disabled]), button:not([disabled]),select:not([disabled]), textarea:not([disabled]), iframe, object, embed, *[tabindex], *[contenteditable=true]'
		elements = document.querySelectorAll tabbableElements

		[].forEach.call elements, (element) ->
			element.tabIndex = element.oldTabIndex

	_defineCustomEvents: ->
		# define var
		module = @
		events = ['onBeforeOpen', 'onAfterOpen', 'onBeforeClose', 'onAfterClose']
		eventsLenght = events.length

		# loop to define events
		[].forEach.call events, (e) ->
			module[e] = undefined

			# create custom event
			if document.createEvent
				module[e] = document.createEvent('HTMLEvents')
				module[e].initEvent(e.toLowerCase(), true, true)
			else
				module.e = document.createEventObject()
				module.e.eventType = e.toLowerCase()

			module[e].eventName = e.toLowerCase()

	_fireCustomEvents: (customEvent) ->
		# define var
		module = @

		if module[customEvent] == undefined
			module._defineCustomEvents()

		if document.createEvent
			module.dispatchEvent(module[customEvent])
		else
			module.fireEvent('on' + module[customEvent].eventType, module[customEvent])

	_onResize: ->
		# if popup is open
		if @window

			# if image has portrait ratio
			if @window.classList.contains 'portrait'
				image = @window.querySelector('img')

				# limits image height
				image.style.maxHeight = (window.innerHeight * 0.8) + 'px'

	ready: ->
		module = @

		@async(->
			setTimeout (->
				module._defineCustomEvents()
				module._onLoad()
			), 0
		)

	_onLoad: ->
		@_launchPopup()

