[![Published on webcomponents.org](https://img.shields.io/badge/webcomponents.org-published-blue.svg?style=flat-square)](https://beta.webcomponents.org/element/oscarsolas/paper-lightbox)

# Paper-lightbox

### Description

Polymer element for launch a popup with a image, iframe, inline or ajax content.

### Install

First you need bower, [see their site](http://bower.io/) for details

```sh
bower install --save Redbility/paper-lightbox
```

### Examples

A simple example of its use:
<!---
```
<custom-element-demo>
  <template>
    <script src="../webcomponentsjs/webcomponents-lite.js"></script>
    <link rel="import" href="paper-lightbox.html">
	 <next-code-block></next-code-block>
  </template>
</custom-element-demo>
```
-->
```html
<!-- LAUNCH AJAX POPUP -->
<paper-lightbox src="content.html" type="ajax">launch ajax popup</paper-lightbox>

<!-- LAUNCH IMAGE POPUP -->
<paper-lightbox src="https://unsplash.it/800/500/?image=257" type="image">launch image popup</paper-lightbox>

<!-- LAUNCH INLINE POPUP -->
<paper-lightbox src=".inline-content" type="inline">launch inline popup</paper-lightbox>

<!-- LAUNCH IFRAME POPUP -->
<paper-lightbox src="https://www.youtube.com/watch?v=assSM3rlvZ8" type="iframe">launch iframe popup</paper-lightbox>

<div style="display: none;">
  <div class="inline-content">inline content example</div>
</div>
```

### Attributes

| Attribute Name | Functionality | Type | Default |
|----------------|-------------|-------------|-------------|
| type | Popup content type | String | undefined |
| openingTime | The time of initial animation in miliseconds | Number | undefined |
| closingTime | The time of final animation in miliseconds | Number | undefined |

### Methods

| Method Name | Explanation |
|-------------|-------------|
| open() | Launch the popup |

### Events

| Method Name | Explanation |
|-------------|-------------|
| onbeforeopen | Calls before modal is opened |
| onafteropen | Calls after modal is opened and its content is loaded |
| onbeforeclose | Calls before modal is closed |
| onafterclose | Calls after modal is close |
