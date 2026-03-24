const express = require('express')
const cors = require('cors')

//const { bdmysql } = require('../database/MariaDbConnection');
const { bdmysql,bdmysqlNube } = require('../database/mySqlConnection');

class Server {

    constructor() {
        this.app = express();
        this.port = process.env.PORT;

        
        this.pathsMySql = {
            auth: '/api/auth',
            prueba: '/api/prueba',
            
            //Aqui defino la ruta de HEROES
            heroes: '/api/heroes',

            //Aqui defino la ruta de USUARIOS
            usuarios: '/api/usuarios',

        }

    
        this.app.get('/', function (req, res) {
            res.send('Hola Mundo a todos... Desde la Clase...')
        })
       
        //Aqui me conecto a la BD
        this.dbConnection();

        //Middlewares
        this.middlewares();

        //Routes
        this.routes();

    }

       
    async dbConnection() {
        try {
            await bdmysqlNube.authenticate();
            console.log('Connection OK a MySQL.');
        } catch (error) {
            console.error('No se pudo Conectar a la BD MySQL', error);
        }
    }
    
    routes() {
        //this.app.use(this.pathsMySql.auth, require('../routes/MySqlAuth'));
        //this.app.use(this.pathsMySql.prueba, require('../routes/prueba'));
        this.app.use(this.pathsMySql.heroes, require('../routes/heroes.route'));
        this.app.use(this.pathsMySql.usuarios, require('../routes/usuarios.route'));
    }
    
    
    middlewares() {
    //  CORS configurado para aceptar cualquier origen
    this.app.use(cors({
        origin: '*',
        methods: ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS'],
        allowedHeaders: ['Content-Type', 'Authorization']
    }));

    //  Lectura y parseo del body
    this.app.use(express.json());

    //  Directorio público (si lo usas)
    this.app.use(express.static('public'));
}
   
    listen() {
        this.app.listen(this.port, () => {
            console.log('Servidor corriendo en puerto', this.port);
        });
    }

}

module.exports = Server;