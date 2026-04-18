import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/utils/date_helper.dart';
import '../../data/models/food_item_model.dart';
import '../../data/models/tracked_meal_model.dart';
import '../../data/store/daily_tracker_store.dart';
import '../../widgets/app_calendar_sheet.dart';
import '../../widgets/meal_bottom_sheet.dart';

class MealsScreen extends StatefulWidget {
  const MealsScreen({super.key});

  @override
  State<MealsScreen> createState() => _MealsScreenState();
}

class _MealsScreenState extends State<MealsScreen> {
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

  void openMealBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const MealBottomSheet(),
   );
  }

  void addMeal(FoodItemModel food) {
    dailyTrackerStore.addMealFromFood(
      food: food,
      mealType: 'Öğün',
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<TrackedMealModel> meals = dailyTrackerStore.mealsForSelectedDate;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 18, 18, 0),
          child: Column(
            children: [
              _MealsHeader(
                selectedDate: dailyTrackerStore.selectedDate,
                onDatePressed: openCalendarSheet,
                onAddPressed: openMealBottomSheet,
              ),
              const SizedBox(height: 14),
              _MealsSummaryCard(
                totalCount: meals.length,
                totalCalories: dailyTrackerStore.totalMealCalories,
              ),
              const SizedBox(height: 10),
              _MealsMacroBar(
                protein: dailyTrackerStore.totalProtein,
                carbs: dailyTrackerStore.totalCarbs,
                fat: dailyTrackerStore.totalFat,
              ),
              const SizedBox(height: 12),
              Expanded(
                child: meals.isEmpty
                    ? _EmptyMealsState(onAddPressed: openMealBottomSheet)
                    : ListView.separated(
                        padding: const EdgeInsets.only(bottom: 100),
                        itemCount: meals.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 10),
                        itemBuilder: (context, index) {
                          return _MealDetailCard(
                            meal: meals[index],
                            onDeletePressed: () {
                              dailyTrackerStore.deleteMeal(meals[index].id);
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

class _MealsHeader extends StatelessWidget {
  final DateTime selectedDate;
  final VoidCallback onDatePressed;
  final VoidCallback onAddPressed;

  const _MealsHeader({
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
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(9),
            ),
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
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text(
              'Öğün Ekle +',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _MealsSummaryCard extends StatelessWidget {
  final int totalCount;
  final int totalCalories;

  const _MealsSummaryCard({
    required this.totalCount,
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
          Expanded(
            child: _SummaryColumn(
              title: 'Toplam Kayıt',
              value: '$totalCount',
            ),
          ),
          const _DividerLine(),
          Expanded(
            child: _SummaryColumn(
              title: 'Toplam Kalori',
              value: '$totalCalories kcal',
            ),
          ),
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
          style: const TextStyle(
            color: AppColors.textMuted,
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          value,
          style: const TextStyle(
            color: AppColors.textDark,
            fontSize: 18,
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
      margin: const EdgeInsets.symmetric(horizontal: 12),
      color: AppColors.border,
    );
  }
}

class _MealsMacroBar extends StatelessWidget {
  final double protein;
  final double carbs;
  final double fat;

  const _MealsMacroBar({
    required this.protein,
    required this.carbs,
    required this.fat,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 54,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(9),
      ),
      child: Row(
        children: [
          Expanded(
            child: _MacroInfo(
              color: AppColors.protein,
              value: '${protein.toStringAsFixed(0)}g',
              label: 'Protein',
            ),
          ),
          const _DividerLine(),
          Expanded(
            child: _MacroInfo(
              color: AppColors.carbohydrate,
              value: '${carbs.toStringAsFixed(0)}g',
              label: 'Karbonhidrat',
            ),
          ),
          const _DividerLine(),
          Expanded(
            child: _MacroInfo(
              color: AppColors.fat,
              value: '${fat.toStringAsFixed(0)}g',
              label: 'Yağ',
            ),
          ),
        ],
      ),
    );
  }
}

class _MacroInfo extends StatelessWidget {
  final Color color;
  final String value;
  final String label;

  const _MacroInfo({
    required this.color,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(radius: 4, backgroundColor: color),
        const SizedBox(width: 7),
        Flexible(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: const TextStyle(
                  color: AppColors.textDark,
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                label,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _MealDetailCard extends StatelessWidget {
  final TrackedMealModel meal;
  final VoidCallback onDeletePressed;

  const _MealDetailCard({
    required this.meal,
    required this.onDeletePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 116),
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
              _MealTypeTag(text: meal.mealType),
              const Spacer(),
              Text(
                '${meal.calories} kcal',
                style: const TextStyle(
                  color: AppColors.textDark,
                  fontSize: 19,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            meal.name,
            style: const TextStyle(
              color: AppColors.textDark,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            DateHelper.formatDayMonthHour(meal.date),
            style: const TextStyle(
              color: AppColors.textMuted,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            meal.servingLabel,
            style: const TextStyle(
              color: AppColors.textMuted,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 10,
            runSpacing: 5,
            children: [
              _NutritionText(text: '${meal.protein.toStringAsFixed(0)}g Protein'),
              _NutritionText(text: '${meal.carbs.toStringAsFixed(0)}g Karbonhidrat'),
              _NutritionText(text: '${meal.fat.toStringAsFixed(0)}g Yağ'),
            ],
          ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerRight,
            child: _DeleteButton(onPressed: onDeletePressed),
          ),
        ],
      ),
    );
  }
}

class _MealTypeTag extends StatelessWidget {
  final String text;

  const _MealTypeTag({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFE0F4ED),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Color(0xFF40916C),
          fontSize: 10,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _NutritionText extends StatelessWidget {
  final String text;

  const _NutritionText({required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: AppColors.textMuted,
        fontSize: 11,
        fontWeight: FontWeight.w600,
      ),
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
          textStyle: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}

class _EmptyMealsState extends StatelessWidget {
  final VoidCallback onAddPressed;

  const _EmptyMealsState({required this.onAddPressed});

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
              Icons.rice_bowl_rounded,
              color: AppColors.accentOrange,
              size: 48,
            ),
            const SizedBox(height: 10),
            const Text(
              'Bu tarihte öğün kaydı yok',
              style: TextStyle(
                color: AppColors.textDark,
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Öğün ekleyerek günlük beslenme takibini başlatabilirsin.',
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
              width: 160,
              child: ElevatedButton(
                onPressed: onAddPressed,
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: AppColors.accentOrange,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Öğün Ekle +',
                  style: TextStyle(
                    fontSize: 13,
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
