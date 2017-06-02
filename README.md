# Paper-lightbox

### Description

Polymer element for launch a popup with a image, iframe, inline or ajax content.

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
```

### Attributes

| Attribute Name | Functionality | Type | Default |
|----------------|-------------|-------------|-------------|
| type | Popup content type | String | undefined |

### Methods

| Method Name | Explanation |
|-------------|-------------|
| open() | Launch the popup |
