const express = require('express');
const cors = require('cors');

const app = express();
const PORT = 3000;

// Middleware
app.use(cors());
app.use(express.json());

// Sample route
app.get('/', (req, res) => {
    res.json({ message: "Servidor Node.js funcionando!" });
});

app.post("/data", (req, res) => {
    const {nombre} = req.body;
    res.json({ message: `Hola, ${nombre}!, recibí tus datos` });
});

// Start the server
app.listen(PORT, () => {
    console.log(`Servidor corriendo en http://localhost:${PORT}`);
});