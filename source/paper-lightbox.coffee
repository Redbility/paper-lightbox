Polymer
	is: 'paper-lightbox'

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

	_openAnimation: ->
		# set vars
		module = this
		overlay = module.querySelector('.paper-lightbox-popup_overlay')

		windowRect = module.window.getBoundingClientRect()
		buttonRect = module.querySelector('button').getBoundingClientRect()

		module.window.style.top = buttonRect.top + 'px'
		module.window.style.width = buttonRect.width + 'px'
		module.window.style.height = buttonRect.height + 'px'
		module.window.style.left = buttonRect.left + 'px'
		module.window.style.padding = '0'
		module.window.style.transform = 'none'
		overlay.style.opacity = '0'
		[].forEach.call module.window.children, (child, key) ->
			child.style.opacity = '0'

		setTimeout (->
			module.window.style.transition = 'all 0.3s cubic-bezier(.55,0,.1,1)'
			module.window.style.top = windowRect.top + 'px'
			module.window.style.width = windowRect.width + 'px'
			module.window.style.height = windowRect.height + 'px'
			module.window.style.left = windowRect.left + 'px'
			module.window.style.padding = ''
			overlay.style.transition = 'all 0.3s cubic-bezier(.55,0,.1,1)'
			overlay.style.opacity = '0.6'
			[].forEach.call module.window.children, (child, key) ->
				child.style.transition = 'opacity 0.3s cubic-bezier(.55,0,.1,1)'
		), 0

		setTimeout (->
			module.window.style.transition = ''
			module.window.style.top = ''
			module.window.style.width = ''
			module.window.style.height = ''
			module.window.style.left = ''
			module.window.style.transform = ''
			overlay.style.opacity = ''
			[].forEach.call module.window.children, (child, key) ->
				child.style.opacity = '1'
		), 300

		setTimeout (->
			[].forEach.call module.window.children, (child, key) ->
				child.style.opacity = ''
				child.style.transition = ''
		), 600

	_closeAnimation: (popup) ->
		# set vars
		module = this
		overlay = module.querySelector('.paper-lightbox-popup_overlay')

		windowRect = module.window.getBoundingClientRect()
		buttonRect = module.querySelector('button').getBoundingClientRect()

		module.window.style.top = windowRect.top + 'px'
		module.window.style.width = windowRect.width + 'px'
		module.window.style.height = windowRect.height + 'px'
		module.window.style.left = windowRect.left + 'px'
		module.window.style.transform = 'none'
		overlay.style.opacity = '0.6'
		[].forEach.call module.window.children, (child, key) ->
			child.style.transition = 'opacity 0.15s cubic-bezier(.55,0,.1,1)'
			child.style.opacity = '0'

		setTimeout (->
			module.window.style.transition = 'all 0.3s cubic-bezier(.55,0,.1,1)'
			module.window.style.top = buttonRect.top + 'px'
			module.window.style.width = buttonRect.width + 'px'
			module.window.style.height = buttonRect.height + 'px'
			module.window.style.left = buttonRect.left + 'px'
			module.window.style.padding = '0'
			module.window.style.opacity = '0'
			overlay.style.transition = 'all 0.3s cubic-bezier(.55,0,.1,1)'
			overlay.style.opacity = '0'
		), 0

		# remove popup
		setTimeout (->
			popup.remove()
		), 300

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

		# apply animation
		@_openAnimation()

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

			# add type class
			module.window.classList.add 'paper-lightbox-popup_window-image'

			# append image after is loaded
			module.window.appendChild image

			# apply animation
			module._openAnimation()

			# close popup event
			module._closePopup()

		image.src = module.getAttribute 'src'

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

		# apply animation
		@_openAnimation()

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
				console.log()

	_removePopup: ->
		# set vars
		module = this
		popup = module.querySelector('.paper-lightbox-popup')

		@_closeAnimation(popup)

	_closePopup: ->
		# set vars
		module = this
		overlay = module.querySelector('.paper-lightbox-popup_overlay')
		close = module.querySelector('.paper-lightbox-popup_close')

		# add overlay listener
		module.listen overlay, 'tap', '_removePopup'
		module.listen close, 'tap', '_removePopup'

	onAjaxContentLoaded: ->

	ready: ->
		@_launchPopup()
