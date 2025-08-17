import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PreguntasScreen extends StatefulWidget {
  const PreguntasScreen({super.key});

  @override
  State<PreguntasScreen> createState() => _PreguntasScreenState();
}

class _PreguntasScreenState extends State<PreguntasScreen> {
  // Lesson data received from previous screen
  Map<String, dynamic>? lesson;
  String? subject;
  int? lessonIndex;
  Color? subjectColor;

  // Question state
  int currentQuestionIndex = 0;
  List<dynamic> questions = [];
  String? selectedAnswer;
  bool showResult = false;
  bool isCorrect = false;
  int correctAnswers = 0;
  int totalQuestions = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    
    // Get arguments passed from previous screen
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null) {
      lesson = args['lesson'];
      subject = args['subject'];
      lessonIndex = args['lessonIndex'];
      subjectColor = args['subjectColor'];
      questions = lesson?['questions'] as List<dynamic>? ?? [];
      totalQuestions = questions.length;
    }
  }

  void _selectAnswer(String answer) {
    if (showResult) return; // Prevent selecting after showing result
    
    setState(() {
      selectedAnswer = answer;
    });
  }

  void _checkAnswer() {
    if (selectedAnswer == null) return;

    final currentQuestion = questions[currentQuestionIndex];
    final correctAnswerIndex = currentQuestion['correctAnswerIndex'] ?? 0;
    final correctAnswer = currentQuestion['answers'][correctAnswerIndex];
    
    setState(() {
      isCorrect = selectedAnswer == correctAnswer;
      if (isCorrect) {
        correctAnswers++;
      }
      showResult = true;
    });
  }

  void _nextQuestion() {
    if (currentQuestionIndex < questions.length - 1) {
      setState(() {
        currentQuestionIndex++;
        selectedAnswer = null;
        showResult = false;
        isCorrect = false;
      });
    } else {
      _finishLesson();
    }
  }

  void _finishLesson() {
    // Calculate score
    final score = (correctAnswers / totalQuestions * 100).round();
    
    // Show completion dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1B475D),
          title: Text(
            "¡Lección Completada!",
            style: GoogleFonts.righteous(
              color: const Color(0xFFFAD564),
              fontSize: 24,
            ),
            textAlign: TextAlign.center,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                score >= 70 ? Icons.celebration : Icons.school,
                color: score >= 70 ? const Color(0xFF8EBD9D) : Colors.orange,
                size: 60,
              ),
              const SizedBox(height: 20),
              Text(
                "Respuestas correctas: $correctAnswers de $totalQuestions",
                style: GoogleFonts.openSans(
                  color: const Color(0xFFFFF5D0),
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                "Puntuación: $score%",
                style: GoogleFonts.righteous(
                  color: subjectColor ?? const Color(0xFF8EBD9D),
                  fontSize: 20,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                score >= 70 
                    ? "¡Excelente trabajo!" 
                    : "Sigue practicando, ¡puedes mejorar!",
                style: GoogleFonts.openSans(
                  color: const Color(0xFFFFF5D0),
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8EBD9D),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context); // Close dialog
                  Navigator.pop(context, {
                    'completed': true,
                    'lessonIndex': lessonIndex,
                    'score': score,
                  }); // Return to resources screen with completion data
                },
                child: Text(
                  "Continuar",
                  style: GoogleFonts.righteous(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Color _getAnswerColor(String answer) {
    if (!showResult) {
      return selectedAnswer == answer 
          ? (subjectColor ?? Colors.blue).withOpacity(0.3)
          : Colors.transparent;
    }
    
    final currentQuestion = questions[currentQuestionIndex];
    final correctAnswerIndex = currentQuestion['correctAnswerIndex'] ?? 0;
    final correctAnswer = currentQuestion['answers'][correctAnswerIndex];
    
    if (answer == correctAnswer) {
      return Colors.green.withOpacity(0.3);
    } else if (answer == selectedAnswer && !isCorrect) {
      return Colors.red.withOpacity(0.3);
    }
    
    return Colors.transparent;
  }

  Color _getAnswerBorderColor(String answer) {
    if (!showResult) {
      return selectedAnswer == answer 
          ? (subjectColor ?? Colors.blue)
          : Colors.grey.withOpacity(0.3);
    }
    
    final currentQuestion = questions[currentQuestionIndex];
    final correctAnswerIndex = currentQuestion['correctAnswerIndex'] ?? 0;
    final correctAnswer = currentQuestion['answers'][correctAnswerIndex];
    
    if (answer == correctAnswer) {
      return Colors.green;
    } else if (answer == selectedAnswer && !isCorrect) {
      return Colors.red;
    }
    
    return Colors.grey.withOpacity(0.3);
  }

  @override
  Widget build(BuildContext context) {
    if (questions.isEmpty) {
      return Scaffold(
        backgroundColor: const Color(0xFF1B475D),
        appBar: AppBar(
          backgroundColor: const Color(0xFF1B475D),
          elevation: 0,
          title: Text(
            "No hay preguntas disponibles",
            style: GoogleFonts.righteous(
              color: const Color(0xFFFAD564),
              fontSize: 20,
            ),
          ),
          iconTheme: const IconThemeData(color: Color(0xFFFFF5D0)),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.quiz_outlined,
                size: 80,
                color: Color(0xFF8EBD9D),
              ),
              const SizedBox(height: 20),
              Text(
                "Esta lección no tiene preguntas disponibles",
                style: GoogleFonts.openSans(
                  color: const Color(0xFFFFF5D0),
                  fontSize: 18,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8EBD9D),
                ),
                onPressed: () => Navigator.pop(context),
                child: Text(
                  "Volver",
                  style: GoogleFonts.righteous(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    final currentQuestion = questions[currentQuestionIndex];
    final questionText = currentQuestion['questionText'] ?? '';
    final answers = currentQuestion['answers'] as List<dynamic>? ?? [];

    return Scaffold(
      backgroundColor: const Color(0xFF1B475D),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1B475D),
        elevation: 0,
        title: Text(
          "${(subject ?? 'Materia').toUpperCase()} - Lección ${(lessonIndex ?? 0) + 1}",
          style: GoogleFonts.righteous(
            color: const Color(0xFFFAD564),
            fontSize: 18,
          ),
        ),
        iconTheme: const IconThemeData(color: Color(0xFFFFF5D0)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Progress indicator
            Row(
              children: [
                Expanded(
                  child: LinearProgressIndicator(
                    value: (currentQuestionIndex + 1) / questions.length,
                    backgroundColor: Colors.grey.withOpacity(0.3),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      subjectColor ?? const Color(0xFF8EBD9D)
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  "${currentQuestionIndex + 1}/${questions.length}",
                  style: GoogleFonts.righteous(
                    color: const Color(0xFFFFF5D0),
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 30),

            // Score tracker
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: (subjectColor ?? Colors.blue).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: (subjectColor ?? Colors.blue).withOpacity(0.3),
                ),
              ),
              child: Text(
                "Correctas: $correctAnswers de ${currentQuestionIndex + (showResult ? 1 : 0)}",
                style: GoogleFonts.openSans(
                  color: const Color(0xFFFFF5D0),
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),

            const SizedBox(height: 30),

            // Question text
            Text(
              questionText,
              style: GoogleFonts.openSans(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: const Color(0xFFFFF5D0),
                height: 1.4,
              ),
            ),
            
            const SizedBox(height: 30),

            // Answer options
            Expanded(
              child: ListView.builder(
                itemCount: answers.length,
                itemBuilder: (context, index) {
                  final answer = answers[index].toString();
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: InkWell(
                      onTap: showResult ? null : () => _selectAnswer(answer),
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: _getAnswerColor(answer),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: _getAnswerBorderColor(answer),
                            width: 2,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _getAnswerBorderColor(answer),
                              ),
                              child: Center(
                                child: Text(
                                  String.fromCharCode(65 + index), // A, B, C, D
                                  style: GoogleFonts.righteous(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                answer,
                                style: GoogleFonts.openSans(
                                  fontSize: 16,
                                  color: const Color(0xFFFFF5D0),
                                  height: 1.3,
                                ),
                              ),
                            ),
                            if (showResult) ...[
                              const SizedBox(width: 16),
                              Icon(
                                _getAnswerBorderColor(answer) == Colors.green
                                    ? Icons.check_circle
                                    : _getAnswerBorderColor(answer) == Colors.red
                                        ? Icons.cancel
                                        : null,
                                color: _getAnswerBorderColor(answer),
                                size: 24,
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

            // Action button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8EBD9D),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: selectedAnswer == null 
                    ? null 
                    : showResult 
                        ? _nextQuestion 
                        : _checkAnswer,
                child: Text(
                  selectedAnswer == null
                      ? "Selecciona una respuesta"
                      : showResult
                          ? (currentQuestionIndex == questions.length - 1
                              ? "Finalizar Lección"
                              : "Siguiente Pregunta")
                          : "Verificar Respuesta",
                  style: GoogleFonts.righteous(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: selectedAnswer == null ? Colors.grey : Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}