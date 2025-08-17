// const express = require("express");
// const { registerUser} = require("../controllers/userController");
// const User = require("../models/User");

// const router = express.Router();

// // Registrar usuario
// router.post("/register", async (req, res) => {
//   try {
//     const { name, email, password } = req.body;

//     // Validar
//     if (!name || !email || !password) {
//       return res.status(400).json({ message: "Todos los campos son obligatorios" });
//     }

//     // Crear usuario
//     const newUser = new User({ name, email, password });
//     await newUser.save();

//     res.status(201).json({ message: "Usuario creado exitosamente", user: newUser });
//   } catch (err) {
//     res.status(500).json({ message: "Error en el servidor", error: err.message });
//   }
// });

// module.exports = router;

const express = require('express');
const { registerUser } = require('../controllers/userController');

const router = express.Router();

// Register user route
router.post('/register', registerUser);

module.exports = router;
