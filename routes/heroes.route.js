const { Router } = require('express');

const { heroesGet,
        heroeIdGet,
        heroesComoGet,
        heroesPost,
        heroePut,
        heroeDelete,
} = require('../controllers/heroes.controller');

//const { validarJWT} = require('../middlewares/validar-jwt');

const router = Router();

//3 Retrieve
/* router.get('/', 
    validarJWT,
    heroesGet);

router.get('/:id', heroeIdGet);

router.get('/como/:termino', 
    validarJWT,
    heroesComoGet);
 */

router.get('/', heroesGet);
router.get('/:id', heroeIdGet);
router.get('/como/:termino', heroesComoGet);

//CREATE
router.post('/', heroesPost);

//UPDATE
router.put('/:id', heroePut);

//DELETE
router.delete('/:id', heroeDelete);


module.exports = router;