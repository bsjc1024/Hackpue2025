import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../services/gemini_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Map<String, dynamic>? userData;
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _loadUserProgress();
  }

  Future<void> _loadUserProgress() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final userId = userProvider.userId;

    if (userId == null) {
      setState(() {
        error = "Usuario no encontrado";
        isLoading = false;
      });
      return;
    }

    try {
      final result = await GeminiService.getUserProgress(userId);
      
      if (result['error'] != null) {
        setState(() {
          error = result['error'];
          isLoading = false;
        });
      } else {
        setState(() {
          userData = result;
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        error = "Error al cargar datos: $e";
        isLoading = false;
      });
    }
  }

  Future<void> _refreshData() async {
    setState(() {
      isLoading = true;
      error = null;
    });
    await _loadUserProgress();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (error != null) {
      return Scaffold(
        body: Center(child: Text(error!)),
      );
    }

    final studyRoutes = userData!['studyRoutes'] as List<dynamic>;

    return Scaffold(
      appBar: AppBar(
        title: Text(userData!['name'] ?? 'Usuario'),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: studyRoutes.length,
          itemBuilder: (context, index) {
            final route = studyRoutes[index];
            return GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/${route['subject']}');
              },
              child: Container(
                padding: const EdgeInsets.all(20),
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: route['subject'] == 'español' ? Colors.blue[100] : Colors.green[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      route['subject'].toString(),
                      style: const TextStyle(fontSize: 18),
                    ),
                    Text("${route['progress']}%", style: const TextStyle(fontSize: 18)),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

extension StringExtension on String {
  String capitalize() => "${this[0].toUpperCase()}${substring(1)}";
}