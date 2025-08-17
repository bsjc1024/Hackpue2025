import express from "express";
import User from "../models/User.js";

const router = express.Router();

// Registrar usuario
router.post("/register", async (req, res) => {
  try {
    const { nombre, correo, contrasena } = req.body;

    // Validar
    if (!nombre || !correo || !contrasena) {
      return res.status(400).json({ message: "Todos los campos son obligatorios" });
    }

    // Crear usuario
    const newUser = new User({ nombre, correo, contrasena });
    await newUser.save();

    res.status(201).json({ message: "Usuario creado exitosamente", user: newUser });
  } catch (err) {
    res.status(500).json({ message: "Error en el servidor", error: err.message });
  }
});

export default router;
