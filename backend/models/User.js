const mongoose = require('mongoose');
const bcrypt = require('bcrypt');

const ResourceSchema = new mongoose.Schema({
    title: { type: String, required: true },
    url: { type: String, required: true },
    type: { type: String, required: true } // video, documento, ejercicios, simulacro
});

const QuestionSchema = new mongoose.Schema({
    questionText: { type: String, required: true },
    answers: [{ type: String, required: true }], // Array de 4 opciones
    correctAnswerIndex: { type: Number, required: true, min: 0, max: 3 }
});

const LessonSchema = new mongoose.Schema({
    title: { type: String, required: true },
    estimatedHours: { type: Number, required: true },
    description: { type: String, required: true },
    resources: [ResourceSchema],
    questions: [QuestionSchema],
    completed: { type: Boolean, default: false }
});

const StudyRouteSchema = new mongoose.Schema({
    name: { type: String, required: true },
    subject: { type: String, required: true, enum: ['español', 'biología'] },
    totalHours: { type: Number, required: true },
    estimatedCompletion: { type: String, required: true },
    currentLevel: { type: String, required: true }, // Básico, Intermedio, Avanzado
    createdAt: { type: Date, default: Date.now },
    lessons: [LessonSchema]
});

const userSchema = new mongoose.Schema({
    name: { type: String, required: true },
    email: { type: String, required: true, unique: true },
    password: { type: String, required: true },
    studyRoutes: [StudyRouteSchema],
    lastLesson: { type: Number, default: 0 }, // Cambié de int a Number
    createdAt: { type: Date, default: Date.now },
    updatedAt: { type: Date, default: Date.now }
});

// Middleware para actualizar updatedAt
userSchema.pre('save', function(next) {
    this.updatedAt = new Date();
    next();
});

// Hash password before saving
userSchema.pre("save", async function (next) {
    if (!this.isModified("password")) return next();
    try {
        const salt = await bcrypt.genSalt(10);
        this.password = await bcrypt.hash(this.password, salt);
        next();
    } catch (error) {
        next(error);
    }
});

// Compare password method
userSchema.methods.comparePassword = async function (candidatePassword) {
    return bcrypt.compare(candidatePassword, this.password);
};

// Method to get current study route
userSchema.methods.getCurrentStudyRoute = function() {
    if (this.studyRoutes.length === 0) return null;
    return this.studyRoutes[this.studyRoutes.length - 1];
};

// Method to get progress percentage
userSchema.methods.getProgressPercentage = function() {
    const currentRoute = this.getCurrentStudyRoute();
    if (!currentRoute) return 0;
    return Math.round((this.lastLesson / currentRoute.lessons.length) * 100);
};

module.exports = mongoose.model("User", userSchema);
