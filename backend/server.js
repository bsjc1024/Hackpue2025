require('dotenv').config();
const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');

const app = express();
app.use(cors());
app.use(express.json());

// Conectar MongoDB
mongoose.connect(process.env.MONGO_URI, {
  useNewUrlParser: true,
  useUnifiedTopology: true,
})
.then(() => {
  console.log(" Conectado a MongoDB Atlas");
  app.listen(5000, () => console.log("Servidor corriendo en puerto 5000"));
})
.catch((err) => console.error(" Error al conectar a MongoDB:", err));

// Importar rutas
const userRoutes = require('./routes/users');
const geminiRoutes = require('./routes/gemini');

app.use('/users', userRoutes);
app.use('/gemini', geminiRoutes);

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => console.log(Server running on port ${PORT}));
