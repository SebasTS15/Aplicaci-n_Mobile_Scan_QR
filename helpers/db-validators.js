const { Usuarios } = require('../models/usuarios.model');

const existeEmail = async (correo = "") => {

  const existeEmail = await Usuarios.findOne({ where: { correo: correo} });

  if (existeEmail) {
    throw new Error(`El email ${correo} ya existe en la Base de Datos...`);
  }
};

const noExisteEmail = async (correo = "") => {

  const existeEmail = await Usuarios.findOne({ where: { correo: correo} });

  if (!existeEmail) {
    throw new Error(`El email ${correo} no existe en la Base de Datos...`);
  }
};


module.exports = {
  existeEmail,
  noExisteEmail
};