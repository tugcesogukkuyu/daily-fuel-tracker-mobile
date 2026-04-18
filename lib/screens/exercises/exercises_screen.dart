import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/utils/date_helper.dart';
import '../../data/models/tracked_exercise_model.dart';
import '../../data/store/daily_tracker_store.dart';
import '../../widgets/app_calendar_sheet.dart';
import '../../widgets/exercise_bottom_sheet.dart';

class ExercisesScreen extends StatefulWidget {
  const ExercisesScreen({super.key});

  @override
  State<ExercisesScreen> createState() => _ExercisesScreenState();
}

class _ExercisesScreenState extends State<ExercisesScreen> {
  @override
  void initState() {
    super.initState();
    dailyTrackerStore.addListener(updateScreen);
  }

  @override
  void dispose() {
    dailyTrackerStore.removeListener(updateScreen);
    super.dispose();
  }

  void updateScreen() {
    setState(() {});
  }

  void openCalendarSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: AppColors.primary.withValues(alpha: 0.22),
      builder: (context) {
        return AppCalendarSheet(
          selectedDate: dailyTrackerStore.selectedDate,
          onDateSelected: dailyTrackerStore.changeSelectedDate,
        );
      },
    );
  }

  void openExerciseBottomSheet() {
    showModalBottomSheet(
  context: context,
  isScrollControlled: true,
  backgroundColor: Colors.transparent,
  builder: (_) => const ExerciseBottomSheet(),
   );
  }

  @override
  Widget build(BuildContext context) {
    final List<TrackedExerciseModel> exercises =
        dailyTrackerStore.exercisesForSelectedDate;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 18, 18, 0),
          child: Column(
            children: [
              _ExercisesHeader(
                selectedDate: dailyTrackerStore.selectedDate,
                onDatePressed: openCalendarSheet,
                onAddPressed: openExerciseBottomSheet,
              ),
              const SizedBox(height: 14),
              _ExercisesSummaryCard(
                totalCount: exercises.length,
                totalDuration: exercises.fold(
                  0,
                  (total, exercise) => total + exercise.durationMinutes,
                ),
                totalCalories: dailyTrackerStore.totalBurnedCalories,
              ),
              const SizedBox(height: 12),
              Expanded(
                child: exercises.isEmpty
                    ? _EmptyExercisesState(onAddPressed: openExerciseBottomSheet)
                    : ListView.separated(
                        padding: const EdgeInsets.only(bottom: 100),
                        itemCount: exercises.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 10),
                        itemBuilder: (context, index) {
                          return _ExerciseDetailCard(
                            exercise: exercises[index],
                            onDeletePressed: () {
                              dailyTrackerStore.deleteExercise(exercises[index].id);
                            },
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ExercisesHeader extends StatelessWidget {
  final DateTime selectedDate;
  final VoidCallback onDatePressed;
  final VoidCallback onAddPressed;

  const _ExercisesHeader({
    required this.selectedDate,
    required this.onDatePressed,
    required this.onAddPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        OutlinedButton.icon(
          onPressed: onDatePressed,
          icon: const Icon(
            Icons.calendar_month_rounded,
            color: AppColors.accentBlue,
            size: 18,
          ),
          label: Text(
            DateHelper.formatDayMonthYear(selectedDate),
            style: const TextStyle(
              color: AppColors.textDark,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
          style: OutlinedButton.styleFrom(
            backgroundColor: AppColors.card,
            side: const BorderSide(color: AppColors.border),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),
          ),
        ),
        const Spacer(),
        SizedBox(
          height: 38,
          child: ElevatedButton(
            onPressed: onAddPressed,
            style: ElevatedButton.styleFrom(
              elevation: 0,
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text(
              'Egzersiz Ekle +',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800),
            ),
          ),
        ),
      ],
    );
  }
}

class _ExercisesSummaryCard extends StatelessWidget {
  final int totalCount;
  final int totalDuration;
  final int totalCalories;

  const _ExercisesSummaryCard({
    required this.totalCount,
    required this.totalDuration,
    required this.totalCalories,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 58,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(9),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(child: _SummaryColumn(title: 'Toplam Kayıt', value: '$totalCount')),
          const _DividerLine(),
          Expanded(child: _SummaryColumn(title: 'Toplam Süre', value: '$totalDuration dk')),
          const _DividerLine(),
          Expanded(child: _SummaryColumn(title: 'Yakılan Kalori', value: '$totalCalories kcal')),
        ],
      ),
    );
  }
}

class _SummaryColumn extends StatelessWidget {
  final String title;
  final String value;

  const _SummaryColumn({
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: AppColors.textMuted,
            fontSize: 10,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: AppColors.textDark,
            fontSize: 15,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

class _DividerLine extends StatelessWidget {
  const _DividerLine();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 36,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      color: AppColors.border,
    );
  }
}

class _ExerciseDetailCard extends StatelessWidget {
  final TrackedExerciseModel exercise;
  final VoidCallback onDeletePressed;

  const _ExerciseDetailCard({
    required this.exercise,
    required this.onDeletePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 112),
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _ExerciseTag(text: exercise.category),
              const Spacer(),
              Text(
                '${exercise.burnedCalories} kcal',
                style: const TextStyle(
                  color: AppColors.textDark,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            exercise.name,
            style: const TextStyle(
              color: AppColors.textDark,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            DateHelper.formatDayMonthHour(exercise.date),
            style: const TextStyle(
              color: AppColors.textMuted,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              _ExerciseInfo(
                icon: Icons.timer_rounded,
                text: '${exercise.durationMinutes} dk',
              ),
              const SizedBox(width: 12),
              _ExerciseInfo(
                icon: Icons.local_fire_department_rounded,
                text: '${exercise.burnedCalories} kcal',
              ),
              const Spacer(),
              _DeleteButton(onPressed: onDeletePressed),
            ],
          ),
        ],
      ),
    );
  }
}

class _ExerciseTag extends StatelessWidget {
  final String text;

  const _ExerciseTag({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFE6F0FF),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: AppColors.accentBlue,
          fontSize: 10,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _ExerciseInfo extends StatelessWidget {
  final IconData icon;
  final String text;

  const _ExerciseInfo({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppColors.textMuted, size: 15),
        const SizedBox(width: 4),
        Text(
          text,
          style: const TextStyle(
            color: AppColors.textMuted,
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _DeleteButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _DeleteButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 28,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: const Icon(Icons.delete_rounded, size: 13),
        label: const Text('Sil'),
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.textMuted,
          side: const BorderSide(color: AppColors.border),
          padding: const EdgeInsets.symmetric(horizontal: 10),
          textStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }
}

class _EmptyExercisesState extends StatelessWidget {
  final VoidCallback onAddPressed;

  const _EmptyExercisesState({required this.onAddPressed});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.fitness_center_rounded,
              color: AppColors.accentBlue,
              size: 48,
            ),
            const SizedBox(height: 10),
            const Text(
              'Bu tarihte egzersiz kaydı yok',
              style: TextStyle(
                color: AppColors.textDark,
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Egzersiz ekleyerek günlük hareket takibini başlatabilirsin.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textMuted,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 14),
            SizedBox(
              height: 42,
              width: 175,
              child: ElevatedButton(
                onPressed: onAddPressed,
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: AppColors.accentBlue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text(
                  'Egzersiz Ekle +',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
