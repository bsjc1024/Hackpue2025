//import { GoogleGenAI } from "@google/generative-ai";
const { GoogleGenAI } = require("@google/generative-ai");

const ai = new GoogleGenAI({ apiKey: process.env.GEMINI_API_KEY})

export const generateResponse = async (req, res) => {
    try {
        const { carrera, universidad, nivel_español, nivel_biologia, dias, horas, meses} = req.body;
        const prompt = `Crea un plan de estudio personalizado para el exámen de ingreso a la universidad ${universidad},
    en la licenciatura ${carrera}. Considera que el alumnno tiene ${meses} meses para prepararse, de los cuales
    estudiara ${dias} dias a la semana, ${horas} horas al día. Su nivel de español es ${nivel_español},
    y ${nivel_biologia} en biología. El plan debe dividirse en temas, que incluyan recursos gratuitos y confiables,
    y un quiz de 5 preguntas al final de cada tema. El plan debe ser detallado, fácil de seguir y de medir y guardar el
    progreso del estudiante.`;
    
    const response = await ai.models.generateContent({
        model: 'gemini-2.5-flash',
        contents: [{ role: 'user', text: prompt }]
    });
    
    res.json({ plan: response.text });

    } catch (error) {
        res.status(500).json({ error: error.message });
    } 
}