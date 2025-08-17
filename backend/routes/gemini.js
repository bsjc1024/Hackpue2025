const express = require('express');
const router = express.Router();
const { 
    generateResponse, 
    getUserProgress, 
    updateLessonProgress,
    getSubjectPlan 
} = require('../controllers/geminiController');

// Ruta para generar ambos planes de estudio (español y biología)
router.post('/generate-plan', generateResponse);

// Ruta para obtener progreso del usuario (puede filtrar por materia con ?subject=español o ?subject=biología)
router.get('/progress/:userId', getUserProgress);

// Ruta para obtener plan de una materia específica
router.get('/subject/:userId/:subject', getSubjectPlan);

// Ruta para actualizar progreso de lección
router.put('/progress/:userId', updateLessonProgress);

module.exports = router;
