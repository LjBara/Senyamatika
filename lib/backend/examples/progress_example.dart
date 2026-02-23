/// Example implementations for progress tracking

import 'package:flutter/material.dart';
import '../services/firestore_service.dart';
import '../models/progress_model.dart';
import '../models/quiz_model.dart';

class ProgressExamples {
  final FirestoreService _firestoreService = FirestoreService();

  /// Example: Save topic progress
  Future<void> saveProgressExample(String userId) async {
    try {
      final progress = ProgressModel(
        userId: userId,
        topicId: 'fractions',
        topicName: 'Fractions',
        completionPercentage: 75.0,
        lastAccessed: DateTime.now(),
        timeSpentMinutes: 30,
        isCompleted: false,
      );

      await _firestoreService.saveProgress(progress);
      print('Progress saved successfully!');
    } catch (e) {
      print('Error saving progress: $e');
    }
  }

  /// Example: Get user progress
  Future<void> getUserProgressExample(String userId) async {
    try {
      final progressList = await _firestoreService.getUserProgress(userId);

      print('Total topics: ${progressList.length}');
      for (var progress in progressList) {
        print('${progress.topicName}: ${progress.completionPercentage}%');
      }
    } catch (e) {
      print('Error getting progress: $e');
    }
  }

  /// Example: Save quiz attempt
  Future<void> saveQuizAttemptExample(String userId) async {
    try {
      final quizAttempt = QuizAttemptModel(
        userId: userId,
        quizId: 'fractions_quiz_1',
        topicId: 'fractions',
        score: 8,
        totalQuestions: 10,
        timestamp: DateTime.now(),
        timeSpentSeconds: 120,
      );

      await _firestoreService.saveQuizAttempt(quizAttempt);
      print('Quiz attempt saved! Score: ${quizAttempt.percentage}%');
    } catch (e) {
      print('Error saving quiz attempt: $e');
    }
  }

  /// Example: Get quiz history
  Future<void> getQuizHistoryExample(String userId) async {
    try {
      final attempts = await _firestoreService.getQuizAttempts(userId);

      print('Total quiz attempts: ${attempts.length}');
      for (var attempt in attempts) {
        print('Quiz: ${attempt.quizId}, Score: ${attempt.score}/${attempt.totalQuestions}');
      }
    } catch (e) {
      print('Error getting quiz history: $e');
    }
  }

  /// Example: Get user statistics
  Future<void> getUserStatisticsExample(String userId) async {
    try {
      final stats = await _firestoreService.getUserStatistics(userId);

      print('=== User Statistics ===');
      print('Total Topics: ${stats['totalTopics']}');
      print('Completed Topics: ${stats['completedTopics']}');
      print('Time Spent: ${stats['totalTimeSpentMinutes']} minutes');
      print('Total Quizzes: ${stats['totalQuizzes']}');
      print('Average Score: ${stats['averageScore'].toStringAsFixed(1)}%');
    } catch (e) {
      print('Error getting statistics: $e');
    }
  }

  /// Example: Display progress in UI
  Widget buildProgressWidget(BuildContext context, String userId) {
    return StreamBuilder<List<ProgressModel>>(
      stream: _firestoreService.getUserProgressStream(userId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        final progressList = snapshot.data ?? [];

        if (progressList.isEmpty) {
          return const Text('No progress yet. Start learning!');
        }

        return ListView.builder(
          itemCount: progressList.length,
          itemBuilder: (context, index) {
            final progress = progressList[index];
            return ListTile(
              title: Text(progress.topicName),
              subtitle: Text(
                '${progress.completionPercentage.toStringAsFixed(0)}% complete',
              ),
              trailing: progress.isCompleted
                  ? const Icon(Icons.check_circle, color: Colors.green)
                  : null,
            );
          },
        );
      },
    );
  }
}
