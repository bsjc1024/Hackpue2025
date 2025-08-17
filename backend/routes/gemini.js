const express = require('express');
const router = express.Router();
const { getGeminiData } = require('../controllers/geminiController');

router.get('/data', getGeminiData);

module.exports = router;