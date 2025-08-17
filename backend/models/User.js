const mongoose = require('mongoose');
const bcrypt = require('bcrypt');

const QuestionSchema = new mongoose.Schema({
    questionText: { type: String, required: true },
    answers: [{ type: String, required: true }],
    correctAnswerIndex: { type: Number, required: true },
});

const LessonSchema = new mongoose.Schema({
    title: { type: String, required: true },
    questions: [QuestionSchema]
});

const StudyRouteSchema = new mongoose.Schema({
    name: { type: String, required: true },
    lessons: [LessonSchema]
});

const userSchema = new mongoose.Schema({
    name: {type: String, required: true},
    email: {type: String, required: true, unique: true},
    password: {type: String, required: true},
    studyRoutes: [StudyRouteSchema]
});

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


userSchema.methods.comparePassword = async function (candidatePassword) {
  return bcrypt.compare(candidatePassword, this.password);
};



module.exports = mongoose.model("User", userSchema);
