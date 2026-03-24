/*

const express = require('express')
const app = express()

app.get('/', function (req, res) {
  res.send('Hola Mundo. a Todos ustedes')
})

app.listen(8080)
console.log('Corriendo en el puerto 8080');

*/

//Reconfiguro el proyecto para realizarlo a travez de la Clase Server
require('dotenv').config();

const Server = require('./models/server')
const server = new Server();

server.listen();
