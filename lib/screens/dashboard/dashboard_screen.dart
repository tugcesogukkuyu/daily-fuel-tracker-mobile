import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/utils/date_helper.dart';
import '../../data/models/food_item_model.dart';
import '../../data/store/daily_tracker_store.dart';
import '../../widgets/app_calendar_sheet.dart';
import '../../widgets/exercise_bottom_sheet.dart';
import '../../widgets/main_bottom_navigation.dart';
import '../../widgets/meal_bottom_sheet.dart';
import '../../widgets/metric_card.dart';
import '../../widgets/profile_menu_sheet.dart';
import '../auth/login_screen.dart';
import '../blog/blog_screen.dart';
import '../exercises/exercises_screen.dart';
import '../meals/meals_screen.dart';
import '../profile/change_password_screen.dart';

class DashboardScreen extends StatefulWidget {
  final String userName;

  const DashboardScreen({
    super.key,
    this.userName = 'Kullanıcı',
  });

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int selectedBottomIndex = 0;

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

  void addMealToDashboard(FoodItemModel food) {
    dailyTrackerStore.addMealFromFood(
      food: food,
      mealType: 'Öğün',
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

  void addWater() {
    dailyTrackerStore.addWaterGlass();
  }

  void removeWater() {
    dailyTrackerStore.removeWaterGlass();
  }

  void openQuickAddMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: AppColors.primary.withValues(alpha: 0.20),
      builder: (context) {
        return Container(
          margin: const EdgeInsets.fromLTRB(22, 0, 22, 104),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.16),
                blurRadius: 24,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: SafeArea(
            top: false,
            child: Wrap(
              children: [
                ListTile(
                  leading: const Icon(
                    Icons.restaurant_rounded,
                    color: AppColors.primary,
                  ),
                  title: const Text(
                    'Öğün Ekle',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    openMealBottomSheet();
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.fitness_center_rounded,
                    color: AppColors.primary,
                  ),
                  title: const Text(
                    'Egzersiz Ekle',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    openExerciseBottomSheet();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void openProfileMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: AppColors.primary.withValues(alpha: 0.20),
      builder: (context) {
        return ProfileMenuSheet(
          fullName: 'Tugce Sogukkuyu',
          email: 'tugce@example.com',
          onChangePasswordPressed: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ChangePasswordScreen(),
              ),
            );
          },
          onDeleteAccountPressed: () {
            Navigator.pop(context);
            showDeleteAccountDialog();
          },
          onLogoutPressed: () {
            Navigator.pop(context);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const LoginScreen(),
              ),
            );
          },
        );
      },
    );
  }

  void showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Hesabı Sil'),
          content: const Text(
            'Hesabını silmek istediğine emin misin? Bu işlem geri alınamaz.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Vazgeç'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Hesap silme işlemi backend ile tamamlanacak.'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              child: const Text(
                'Hesabımı Sil',
                style: TextStyle(color: AppColors.danger),
              ),
            ),
          ],
        );
      },
    );
  }

  void handleBottomNavigation(int index) {
    setState(() {
      selectedBottomIndex = index;
    });

    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const MealsScreen()),
      );
    }

    if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ExercisesScreen()),
      );
    }

    if (index == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const BlogScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final double consumedWaterLiter = dailyTrackerStore.consumedWaterLiter;
    final double targetWaterLiter = dailyTrackerStore.targetWaterLiter;
    final double waterProgress = dailyTrackerStore.waterProgress;

    final List<DateTime> weekDates = DateHelper.getWeekDates(
      dailyTrackerStore.selectedDate,
    );

    final List<_SummaryItem> mealItems = dailyTrackerStore.mealsForSelectedDate
        .take(2)
        .map(
          (meal) => _SummaryItem(
            name: meal.name,
            detail: '${meal.calories} kcal',
          ),
        )
        .toList();

    final List<_SummaryItem> exerciseItems = dailyTrackerStore.exercisesForSelectedDate
        .take(2)
        .map(
          (exercise) => _SummaryItem(
            name: exercise.name,
            detail: '${exercise.durationMinutes} dk',
          ),
        )
        .toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 104),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _DashboardHeader(
                    userName: widget.userName,
                    onProfilePressed: openProfileMenu,
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Beslenme ve egzersiz sürecini kontrol et',
                    style: TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _CalendarStrip(
                    weekDates: weekDates,
                    selectedDate: dailyTrackerStore.selectedDate,
                    onDateSelected: dailyTrackerStore.changeSelectedDate,
                  ),
                  Center(
                    child: _MonthButton(
                      selectedDate: dailyTrackerStore.selectedDate,
                      onPressed: openCalendarSheet,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      MetricCard(
                        title: 'Alınan Kalori',
                        value: '${dailyTrackerStore.totalMealCalories}',
                        unit: 'kcal',
                        progressColor: AppColors.accentBlue,
                      ),
                      const SizedBox(width: 4),
                      MetricCard(
                        title: 'Yakılan Kalori',
                        value: '${dailyTrackerStore.totalBurnedCalories}',
                        unit: 'kcal',
                        progressColor: const Color(0xFF9FC7FF),
                      ),
                      const SizedBox(width: 4),
                      MetricCard(
                        title: 'Net Kalori',
                        value: '${dailyTrackerStore.netCalories}',
                        unit: 'kcal',
                        progressColor: const Color(0xFFFFC8B8),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  _MacroSummaryBar(
                    protein: dailyTrackerStore.totalProtein,
                    carbs: dailyTrackerStore.totalCarbs,
                    fat: dailyTrackerStore.totalFat,
                  ),
                  const SizedBox(height: 10),
                  _WaterCard(
                    consumedWaterLiter: consumedWaterLiter,
                    targetWaterLiter: targetWaterLiter,
                    progress: waterProgress.clamp(0, 1),
                    onAddWater: addWater,
                    onRemoveWater: removeWater,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: _DailySummaryCard(
                          title: 'Bugünkü\nÖğünler',
                          imageIcon: Icons.rice_bowl_rounded,
                          buttonText: 'Öğün Ekle',
                          buttonColor: AppColors.accentOrange,
                          items: mealItems,
                          onAddPressed: openMealBottomSheet,
                          onSeeAllPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const MealsScreen(),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _DailySummaryCard(
                          title: 'Bugünkü\nEgzersizler',
                          imageIcon: Icons.fitness_center_rounded,
                          buttonText: 'Egzersiz Ekle',
                          buttonColor: AppColors.accentBlue,
                          items: exerciseItems,
                          onAddPressed: openExerciseBottomSheet,
                          onSeeAllPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ExercisesScreen(),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: MainBottomNavigation(
                selectedIndex: selectedBottomIndex,
                onItemSelected: handleBottomNavigation,
                onAddPressed: openQuickAddMenu,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DashboardHeader extends StatelessWidget {
  final String userName;
  final VoidCallback onProfilePressed;

  const _DashboardHeader({
    required this.userName,
    required this.onProfilePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: RichText(
            text: TextSpan(
              style: const TextStyle(
                color: AppColors.textDark,
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
              children: [
                const TextSpan(text: 'Hoş geldin, '),
                TextSpan(
                  text: '$userName!',
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
              ],
            ),
          ),
        ),
        IconButton(
          onPressed: () {},
          style: IconButton.styleFrom(
            backgroundColor: AppColors.card,
            fixedSize: const Size(38, 38),
          ),
          icon: const Icon(
            Icons.notifications_none_rounded,
            color: AppColors.primary,
            size: 21,
          ),
        ),
        const SizedBox(width: 8),
        IconButton(
          onPressed: onProfilePressed,
          style: IconButton.styleFrom(
            backgroundColor: AppColors.card,
            fixedSize: const Size(42, 42),
          ),
          icon: const Icon(
            Icons.person_rounded,
            color: AppColors.primary,
            size: 22,
          ),
        ),
      ],
    );
  }
}

class _CalendarStrip extends StatelessWidget {
  final List<DateTime> weekDates;
  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateSelected;

  const _CalendarStrip({
    required this.weekDates,
    required this.selectedDate,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 58,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(7),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.06),
            blurRadius: 14,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Row(
        children: weekDates.map((date) {
          final bool isSelected = DateHelper.isSameDate(
            date,
            selectedDate,
          );

          return Expanded(
            child: GestureDetector(
              onTap: () => onDateSelected(date),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 6),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.accentBlue : Colors.transparent,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      DateHelper.getShortWeekdayName(date),
                      style: TextStyle(
                        color: isSelected ? Colors.white : AppColors.textMuted,
                        fontSize: 11,
                        fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${date.day}',
                      style: TextStyle(
                        color: isSelected ? Colors.white : AppColors.textMuted,
                        fontSize: 12,
                        fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _MonthButton extends StatelessWidget {
  final DateTime selectedDate;
  final VoidCallback onPressed;

  const _MonthButton({
    required this.selectedDate,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: const Offset(0, -5),
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: AppColors.card,
          side: const BorderSide(color: AppColors.border),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          minimumSize: const Size(0, 28),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.calendar_month_rounded,
              color: AppColors.accentBlue,
              size: 14,
            ),
            const SizedBox(width: 5),
            Text(
              DateHelper.formatMonthYear(selectedDate),
              style: const TextStyle(
                color: AppColors.textDark,
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(width: 4),
            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.textMuted,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}

class _MacroSummaryBar extends StatelessWidget {
  final double protein;
  final double carbs;
  final double fat;

  const _MacroSummaryBar({
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
        borderRadius: BorderRadius.circular(7),
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
            child: _MacroItem(
              color: AppColors.protein,
              value: '${protein.toStringAsFixed(0)}g',
              label: 'Protein',
            ),
          ),
          const _VerticalDivider(),
          Expanded(
            child: _MacroItem(
              color: AppColors.carbohydrate,
              value: '${carbs.toStringAsFixed(0)}g',
              label: 'Karbonhidrat',
            ),
          ),
          const _VerticalDivider(),
          Expanded(
            child: _MacroItem(
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

class _MacroItem extends StatelessWidget {
  final Color color;
  final String value;
  final String label;

  const _MacroItem({
    required this.color,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(radius: 4, backgroundColor: color),
        const SizedBox(width: 6),
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

class _VerticalDivider extends StatelessWidget {
  const _VerticalDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 34,
      color: AppColors.border,
    );
  }
}

class _WaterCard extends StatefulWidget {
  final double consumedWaterLiter;
  final double targetWaterLiter;
  final double progress;
  final VoidCallback onAddWater;
  final VoidCallback onRemoveWater;

  const _WaterCard({
    required this.consumedWaterLiter,
    required this.targetWaterLiter,
    required this.progress,
    required this.onAddWater,
    required this.onRemoveWater,
  });

  @override
  State<_WaterCard> createState() => _WaterCardState();
}

class _WaterCardState extends State<_WaterCard> with SingleTickerProviderStateMixin {
  late final AnimationController animationController;
  late final Animation<double> scaleAnimation;

  @override
  void initState() {
    super.initState();

    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 160),
    );

    scaleAnimation = Tween<double>(begin: 1, end: 1.08).animate(
      CurvedAnimation(parent: animationController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  void handleWaterTap() {
    widget.onAddWater();
    animationController.forward(from: 0).then((_) {
      animationController.reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 124,
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 10),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.07),
            blurRadius: 18,
            offset: const Offset(0, 9),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Text(
                'Su Takibi',
                style: TextStyle(
                  color: AppColors.textDark,
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: widget.onRemoveWater,
                constraints: const BoxConstraints.tightFor(width: 30, height: 30),
                padding: EdgeInsets.zero,
                icon: const Icon(
                  Icons.remove_circle_outline,
                  color: AppColors.primary,
                  size: 20,
                ),
              ),
              Text(
                '${widget.consumedWaterLiter.toStringAsFixed(1)} / ${widget.targetWaterLiter.toStringAsFixed(1)} L',
                style: const TextStyle(
                  color: AppColors.textDark,
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const Icon(
                Icons.chevron_right,
                color: AppColors.textMuted,
                size: 22,
              ),
            ],
          ),
          const SizedBox(height: 2),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: LinearProgressIndicator(
                      value: widget.progress,
                      minHeight: 13,
                      backgroundColor: const Color(0xFFD8ECFB),
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Color(0xFF62B9EC),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                GestureDetector(
                  onTap: handleWaterTap,
                  child: ScaleTransition(
                    scale: scaleAnimation,
                    child: Container(
                      width: 62,
                      height: 72,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE4F6FF),
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(
                          color: const Color(0xFF90D4F5),
                          width: 2,
                        ),
                      ),
                      child: const Icon(
                        Icons.water_drop_rounded,
                        color: Color(0xFF61B9EC),
                        size: 42,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Text(
            'Harika! Hedefe az kaldı',
            style: TextStyle(
              color: AppColors.textMuted,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _DailySummaryCard extends StatelessWidget {
  final String title;
  final IconData imageIcon;
  final String buttonText;
  final Color buttonColor;
  final List<_SummaryItem> items;
  final VoidCallback onAddPressed;
  final VoidCallback onSeeAllPressed;

  const _DailySummaryCard({
    required this.title,
    required this.imageIcon,
    required this.buttonText,
    required this.buttonColor,
    required this.items,
    required this.onAddPressed,
    required this.onSeeAllPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 214,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.07),
            blurRadius: 18,
            offset: const Offset(0, 9),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: AppColors.textDark,
              fontSize: 15,
              height: 1.0,
              fontWeight: FontWeight.w800,
            ),
          ),
          const Spacer(),
          Center(
            child: Icon(
              imageIcon,
              color: buttonColor.withValues(alpha: 0.85),
              size: 48,
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 28,
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onAddPressed,
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: buttonColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(7),
                ),
              ),
              child: Text(
                '$buttonText  +',
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          if (items.isEmpty)
            const Text(
              'Bu tarihte kayıt yok',
              style: TextStyle(
                color: AppColors.textMuted,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            )
          else
            ...items.map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        item.name,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: AppColors.textDark,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Text(
                      item.detail,
                      style: const TextStyle(
                        color: AppColors.textDark,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          GestureDetector(
            onTap: onSeeAllPressed,
            child: const Text(
              'Tümünü Gör  ›',
              style: TextStyle(
                color: AppColors.primary,
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryItem {
  final String name;
  final String detail;

  const _SummaryItem({
    required this.name,
    required this.detail,
  });
}
