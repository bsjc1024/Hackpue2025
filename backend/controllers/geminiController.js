const { GoogleGenAI } = require("@google/generative-ai");
const User = require('../models/User');

const ai = new GoogleGenAI({ apiKey: process.env.GEMINI_API_KEY });

const generateResponse = async (req, res) => {
    try {
        const { 
            carrera, 
            universidad, 
            nivel_español, 
            nivel_biologia, 
            dias, 
            horas, 
            meses,
            userId 
        } = req.body;

        // Validación de datos requeridos
        if (!carrera || !universidad || !nivel_español || !nivel_biologia || !dias || !horas || !meses || !userId) {
            return res.status(400).json({ 
                error: "Faltan datos requeridos para generar el plan de estudio" 
            });
        }

        // Calcular total de horas disponibles y dividir entre las 2 materias
        const totalHoras = meses * 4 * dias * horas;
        const horasPorMateria = Math.floor(totalHoras / 2);
        
        // Prompt para generar plan de ESPAÑOL
        const promptEspanol = `Crea un plan de estudio específico para ESPAÑOL para el examen de ingreso a la universidad ${universidad}, 
        en la licenciatura ${carrera}. El estudiante tiene ${meses} meses para prepararse, con ${horasPorMateria} horas dedicadas específicamente a español. 
        Su nivel actual de español es ${nivel_español}.

        INSTRUCCIONES ESPECÍFICAS PARA ESPAÑOL:
        1. Genera EXACTAMENTE 6-8 lecciones enfocadas únicamente en español
        2. Incluye temas como: comprensión lectora, gramática, ortografía, redacción, literatura mexicana e hispanoamericana, análisis de textos
        3. Cada lección debe incluir:
           - Un título específico de español
           - 3-5 recursos educativos gratuitos para español (libros, videos, ejercicios)
           - Exactamente 5 preguntas de opción múltiple sobre el tema de español
           - La respuesta correcta identificada por su índice (0, 1, 2, o 3)

        4. Ajusta la dificultad según el nivel ${nivel_español}
        5. Enfócate en las competencias de español requeridas para ${carrera}

        FORMATO DE RESPUESTA REQUERIDO (JSON):
        {
          "studyRoute": {
            "name": "Plan de Estudio - Español para ${carrera}",
            "subject": "español",
            "totalHours": ${horasPorMateria},
            "estimatedCompletion": "${meses} meses",
            "currentLevel": "${nivel_español}",
            "lessons": [
              {
                "title": "Nombre de la Lección de Español",
                "estimatedHours": número_de_horas,
                "description": "Descripción específica del tema de español",
                "resources": [
                  {
                    "title": "Recurso de Español",
                    "url": "URL o 'Buscar en biblioteca'",
                    "type": "video/documento/ejercicios/libro"
                  }
                ],
                "questions": [
                  {
                    "questionText": "Pregunta específica de español",
                    "answers": ["Opción A", "Opción B", "Opción C", "Opción D"],
                    "correctAnswerIndex": 0
                  }
                ]
              }
            ]
          }
        }

        IMPORTANTE: Responde ÚNICAMENTE con el JSON válido para ESPAÑOL, sin texto adicional`;

        // Prompt para generar plan de BIOLOGÍA
        const promptBiologia = `Crea un plan de estudio específico para BIOLOGÍA para el examen de ingreso a la universidad ${universidad}, 
        en la licenciatura ${carrera}. El estudiante tiene ${meses} meses para prepararse, con ${horasPorMateria} horas dedicadas específicamente a biología. 
        Su nivel actual de biología es ${nivel_biologia}.

        INSTRUCCIONES ESPECÍFICAS PARA BIOLOGÍA:
        1. Genera EXACTAMENTE 6-8 lecciones enfocadas únicamente en biología
        2. Incluye temas como: célula, genética, evolución, ecología, anatomía humana, fisiología, biodiversidad, bioquímica
        3. Cada lección debe incluir:
           - Un título específico de biología
           - 3-5 recursos educativos gratuitos para biología (videos, simuladores, documentos científicos)
           - Exactamente 5 preguntas de opción múltiple sobre el tema de biología
           - La respuesta correcta identificada por su índice (0, 1, 2, o 3)

        4. Ajusta la dificultad según el nivel ${nivel_biologia}
        5. Enfócate en los conceptos de biología más relevantes para ${carrera}

        FORMATO DE RESPUESTA REQUERIDO (JSON):
        {
          "studyRoute": {
            "name": "Plan de Estudio - Biología para ${carrera}",
            "subject": "biología",
            "totalHours": ${horasPorMateria},
            "estimatedCompletion": "${meses} meses",
            "currentLevel": "${nivel_biologia}",
            "lessons": [
              {
                "title": "Nombre de la Lección de Biología",
                "estimatedHours": número_de_horas,
                "description": "Descripción específica del tema de biología",
                "resources": [
                  {
                    "title": "Recurso de Biología",
                    "url": "URL o 'Buscar en biblioteca científica'",
                    "type": "video/simulador/documento/experimento"
                  }
                ],
                "questions": [
                  {
                    "questionText": "Pregunta específica de biología",
                    "answers": ["Opción A", "Opción B", "Opción C", "Opción D"],
                    "correctAnswerIndex": 0
                  }
                ]
              }
            ]
          }
        }

        IMPORTANTE: Responde ÚNICAMENTE con el JSON válido para BIOLOGÍA, sin texto adicional`;

        const model = ai.getGenerativeModel({ model: 'gemini-1.5-flash' });

        // Generar ambos planes de estudio en paralelo
        const [resultEspanol, resultBiologia] = await Promise.all([
            model.generateContent(promptEspanol),
            model.generateContent(promptBiologia)
        ]);

        const responseEspanol = resultEspanol.response.text();
        const responseBiologia = resultBiologia.response.text();

        // Parsear las respuestas JSON
        let planEspanol, planBiologia;
        try {
            const cleanResponseEspanol = responseEspanol.replace(/```json\n?|\n?```/g, '').trim();
            const cleanResponseBiologia = responseBiologia.replace(/```json\n?|\n?```/g, '').trim();
            
            planEspanol = JSON.parse(cleanResponseEspanol);
            planBiologia = JSON.parse(cleanResponseBiologia);
        } catch (parseError) {
            console.error("Error parsing Gemini response:", parseError);
            return res.status(500).json({ 
                error: "Error al procesar la respuesta de IA",
                details: parseError.message 
            });
        }

        // Buscar al usuario y actualizar con ambos planes de estudio
        const user = await User.findById(userId);
        if (!user) {
            return res.status(404).json({ error: "Usuario no encontrado" });
        }

        // Agregar ambos planes de estudio al usuario
        user.studyRoutes.push(planEspanol.studyRoute);
        user.studyRoutes.push(planBiologia.studyRoute);
        user.lastLesson = 0; // Reiniciar progreso
        
        await user.save();

        // Respuesta exitosa con ambos planes
        res.status(200).json({ 
            success: true,
            message: "Planes de estudio generados y guardados exitosamente",
            studyPlans: {
                español: planEspanol.studyRoute,
                biología: planBiologia.studyRoute
            },
            totalRoutes: 2,
            totalLessons: {
                español: planEspanol.studyRoute.lessons.length,
                biología: planBiologia.studyRoute.lessons.length
            },
            estimatedHours: {
                español: planEspanol.studyRoute.totalHours,
                biología: planBiologia.studyRoute.totalHours,
                total: totalHoras
            }
        });

    } catch (error) {
        console.error("Error in generateResponse:", error);
        res.status(500).json({ 
            error: "Error interno del servidor",
            details: error.message 
        });
    }
};

// Función para obtener el progreso del usuario (actualizada para manejar múltiples materias)
const getUserProgress = async (req, res) => {
    try {
        const { userId } = req.params;
        const { subject } = req.query; // 'español' o 'biología'

        const user = await User.findById(userId).select('studyRoutes lastLesson name');
        if (!user) {
            return res.status(404).json({ error: "Usuario no encontrado" });
        }

        if (user.studyRoutes.length === 0) {
            return res.status(404).json({ error: "No hay planes de estudio disponibles" });
        }

        // Filtrar por materia si se especifica
        let studyRoutes = user.studyRoutes;
        if (subject) {
            studyRoutes = user.studyRoutes.filter(route => route.subject === subject);
            if (studyRoutes.length === 0) {
                return res.status(404).json({ error: `No hay plan de estudio para ${subject}` });
            }
        }

        // Si se solicita una materia específica, devolver solo esa
        if (subject) {
            const route = studyRoutes[0];
            const progress = {
                userName: user.name,
                subject: route.subject,
                currentLesson: user.lastLesson,
                totalLessons: route.lessons.length,
                progressPercentage: Math.round((user.lastLesson / route.lessons.length) * 100),
                studyPlan: route
            };
            return res.status(200).json(progress);
        }

        // Devolver progreso de ambas materias
        const progressData = {
            userName: user.name,
            subjects: user.studyRoutes.map(route => ({
                subject: route.subject,
                name: route.name,
                totalLessons: route.lessons.length,
                totalHours: route.totalHours,
                currentLevel: route.currentLevel,
                progressPercentage: Math.round((user.lastLesson / route.lessons.length) * 100)
            })),
            overallProgress: {
                currentLesson: user.lastLesson,
                totalRoutes: user.studyRoutes.length
            }
        };

        res.status(200).json(progressData);

    } catch (error) {
        console.error("Error getting user progress:", error);
        res.status(500).json({ 
            error: "Error al obtener progreso del usuario",
            details: error.message 
        });
    }
};

// Función para actualizar el progreso de lección (actualizada)
const updateLessonProgress = async (req, res) => {
    try {
        const { userId } = req.params;
        const { lessonIndex, subject } = req.body;

        const user = await User.findById(userId);
        if (!user) {
            return res.status(404).json({ error: "Usuario no encontrado" });
        }

        // Actualizar la lección actual
        user.lastLesson = lessonIndex;
        await user.save();

        res.status(200).json({ 
            success: true,
            message: `Progreso actualizado para ${subject}`,
            currentLesson: user.lastLesson,
            subject: subject
        });

    } catch (error) {
        console.error("Error updating lesson progress:", error);
        res.status(500).json({ 
            error: "Error al actualizar progreso",
            details: error.message 
        });
    }
};

// Función adicional para obtener una materia específica
const getSubjectPlan = async (req, res) => {
    try {
        const { userId, subject } = req.params;

        const user = await User.findById(userId).select('studyRoutes name');
        if (!user) {
            return res.status(404).json({ error: "Usuario no encontrado" });
        }

        const subjectRoute = user.studyRoutes.find(route => route.subject === subject);
        if (!subjectRoute) {
            return res.status(404).json({ error: `No se encontró plan de estudio para ${subject}` });
        }

        res.status(200).json({
            success: true,
            userName: user.name,
            studyPlan: subjectRoute
        });

    } catch (error) {
        console.error("Error getting subject plan:", error);
        res.status(500).json({ 
            error: "Error al obtener plan de la materia",
            details: error.message 
        });
    }
};

module.exports = { 
    generateResponse, 
    getUserProgress, 
    updateLessonProgress,
    getSubjectPlan
};
