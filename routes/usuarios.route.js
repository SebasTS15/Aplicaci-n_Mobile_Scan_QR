const { Router } = require('express');

const { validarJWT} = require('../middlewares/validar-jwt');
const { check } = require('express-validator');
const { validarCampos } = require('../middlewares/validar-campos');

const { existeEmail,noExisteEmail} = require('../helpers/db-validators');

const {
    usuariosPost,
    login,
    usuariosGet
} = require('../controllers/usuarios.controller');

const router = Router();

//select * from usuarios
router.get('/', 
    //Middlewares
    validarJWT,     
    usuariosGet);

// Insert - CREATE
router.post('/', 
   check('nombre','El nombre es obligatorio').not().isEmpty(),
   check('password','El password debe de ser mas de 6 letras').isLength({min:6}),
   check('correo','El correo no es valido').isEmail(),
   check('correo').custom(existeEmail),

   check('rol','No es un rol valido').isIn('ADMIN_ROLE','USER_ROLE'),

   validarCampos,    
    
   usuariosPost);

router.post('/login',
    //Valido que el correo se un correo Valido
    check('correo','El correo no es valido').isEmail(),
    check('correo').custom(noExisteEmail),   
    
    check('password','La contraseña es obligatoria').not().isEmpty(),
 
    validarCampos,
       
    login);

module.exports = router;
