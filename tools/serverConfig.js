var path = require('path');
var express = require( 'express' );
var app = express();
var url = path.join(__dirname, '../');
// var startUrl = url.indexOf('Sites/') + 5;
// var publicUrl = path.join(__dirname, '../dist/');
// var startPublicUrl = url.indexOf('Sites/') + 5;
var request = require('request');

// Definición del lenguaje del motor de renderizado
console.log(path.join(url, '../'), path.join(url, '/bower_components'));
// app.set('view engine', 'html');
// app.set('views', path.join(__dirname, '../demo'));

// Configuración de rutas estrictas para diferenciar si llevan o no slash (/) al final
app.set('strict routing', true);

// Definición de carpetas públicas
app.use( path.join(url, '../'), express.static( path.join(url, '/bower_components') ) )
app.use( express.static( path.join(url, '/demo/index.html') ) )
app.use( express.static( path.join(url, '/paper-lightbox.html') ) )
// app.use( path.join(publicUrl.substr(startUrl, startPublicUrl.length), '../'), express.static( path.join(__dirname, '/bower_components') ) );


// Configuración del enrutamiento
app.get('/:project/demo/', function (req, res) {
	res.sendFile(path.join(url, '/demo/index.html'));
});
// app.get('/:project/', function(req,res) {
// 	var section = Object.keys(req.query)[0];
// 	var project = req.params.project;

// 	var newurl = 'http://localhost/' + project + '/';
// 	if(section != undefined) {
// 		request(newurl + '?' + section).pipe(res);
// 	} else {
// 		request(newurl).pipe(res);
// 	}
// });

// app.get('/:project', function(req,res) {
// 	var project = req.params.project;

// 	res.redirect('/' + project + '/');
// });

// app.get(url.substr(startUrl, url.length), function (req, res) {
// 	var section = req.params.section;
// 	var page = req.params.page;
// 	res.render(path.join(section, page));
// });

// Inicialización del servidor a través del puerto especificado
app.listen(4000);