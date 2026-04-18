import 'dart:async';

import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../data/services/exercise_service.dart';
import '../data/store/daily_tracker_store.dart';

class ExerciseBottomSheet extends StatefulWidget {
  const ExerciseBottomSheet({super.key});

  @override
  State<ExerciseBottomSheet> createState() => _ExerciseBottomSheetState();
}

class _ExerciseBottomSheetState extends State<ExerciseBottomSheet> {
  final TextEditingController searchController = TextEditingController();
  final TextEditingController durationController =
      TextEditingController(text: '30');

  final ExerciseService exerciseService = const ExerciseService();

  List<Map<String, dynamic>> exerciseOptions = [];
  Map<String, dynamic>? selectedExercise;

  bool isLoading = false;
  bool isSubmitting = false;
  String? errorMessage;
  String? statusMessage;
  bool isSuccessMessage = false;

  Timer? searchDebounce;

  @override
  void initState() {
    super.initState();
    searchController.addListener(onSearchChanged);
    fetchExercises('yu');
  }

  @override
  void dispose() {
    searchDebounce?.cancel();
    searchController.dispose();
    durationController.dispose();
    super.dispose();
  }

  void onSearchChanged() {
    searchDebounce?.cancel();
    searchDebounce = Timer(const Duration(milliseconds: 350), () {
      final query = searchController.text.trim();

      setState(() {
        statusMessage = null;
      });

      if (query.length < 2) {
        setState(() {
          exerciseOptions = [];
          selectedExercise = null;
        });
        return;
      }

      fetchExercises(query);
    });
  }

  Future<void> fetchExercises(String query) async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final results = await exerciseService.searchExerciseCatalog(query);

      setState(() {
        exerciseOptions = results
            .map((item) => Map<String, dynamic>.from(item as Map))
            .toList();
        isLoading = false;
      });
    } catch (error) {
      setState(() {
        errorMessage = error.toString().replaceFirst('Exception: ', '');
        isLoading = false;
      });
    }
  }

  void selectExercise(Map<String, dynamic> exercise) {
    setState(() {
      selectedExercise = exercise;
      statusMessage = null;
    });
  }

  Future<void> addExercise() async {
    if (selectedExercise == null || isSubmitting) return;

    final duration = int.tryParse(durationController.text.trim()) ?? 30;
    final caloriesPerMinute =
        (selectedExercise!['caloriesPerMinute'] as num).toInt();

    setState(() {
      isSubmitting = true;
      statusMessage = null;
    });

    final isSuccess = await dailyTrackerStore.addExercise(
      name: selectedExercise!['name'] as String,
      category: selectedExercise!['categoryLabel'] as String,
      durationMinutes: duration,
      burnedCalories: duration * caloriesPerMinute,
    );

    if (!mounted) return;

    setState(() {
      isSubmitting = false;
      isSuccessMessage = isSuccess;
      statusMessage = isSuccess ? 'Egzersiz eklendi.' : 'Egzersiz eklenemedi.';
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: MediaQuery.of(context).size.height * 0.82,
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 12),
        decoration: const BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 46,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              'Egzersiz Ekle',
              style: TextStyle(
                color: AppColors.textDark,
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Egzersiz ara',
                prefixIcon: const Icon(Icons.search_rounded),
                filled: true,
                fillColor: AppColors.card,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: AppColors.primary),
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: durationController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Süre (dakika)',
                filled: true,
                fillColor: AppColors.card,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: AppColors.primary),
                ),
              ),
            ),
            const SizedBox(height: 14),
            Expanded(
              child: Builder(
                builder: (context) {
                  if (isLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (errorMessage != null) {
                    return Center(
                      child: Text(
                        errorMessage!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    );
                  }

                  if (exerciseOptions.isEmpty) {
                    return const Center(
                      child: Text(
                        'En az 2 harf girerek egzersiz ara.',
                        style: TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    );
                  }

                  return ListView.separated(
                    itemCount: exerciseOptions.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final exercise = exerciseOptions[index];
                      final isSelected =
                          selectedExercise?['id'] == exercise['id'];

                      return InkWell(
                        onTap: () => selectExercise(exercise),
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.primary.withValues(alpha: 0.10)
                                : AppColors.card,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.primary
                                  : AppColors.border,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                exercise['name'] as String,
                                style: const TextStyle(
                                  color: AppColors.textDark,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${exercise['categoryLabel']} • ${exercise['intensityLabel']}',
                                style: const TextStyle(
                                  color: AppColors.textMuted,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${exercise['caloriesPerMinute']} kcal / dk',
                                style: const TextStyle(
                                  color: AppColors.primary,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            if (statusMessage != null) ...[
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: isSuccessMessage
                      ? Colors.green.withValues(alpha: 0.10)
                      : Colors.red.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isSuccessMessage ? Colors.green : Colors.red,
                  ),
                ),
                child: Text(
                  statusMessage!,
                  style: TextStyle(
                    color: isSuccessMessage ? Colors.green : Colors.red,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: selectedExercise == null || isSubmitting
                    ? null
                    : () async => addExercise(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  isSubmitting ? 'Ekleniyor...' : 'Egzersizi Ekle',
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
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
