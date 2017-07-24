var path = require('path');
var express = require( 'express' );
var app = express();
var url = path.join(__dirname, '../');
var request = require('request');

// Configuración de rutas estrictas para diferenciar si llevan o no slash (/) al final
app.set('strict routing', true);

// Definición de carpetas públicas
app.use( '/:project/demo', express.static('../demo') );
app.use( '/:project', express.static('../') );
app.use( '/', express.static('../bower_components') );

// Inicialización del servidor a través del puerto especificado
app.listen(4000);