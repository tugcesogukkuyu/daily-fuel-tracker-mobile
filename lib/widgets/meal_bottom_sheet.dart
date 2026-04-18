import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../data/models/food_item_model.dart';
import '../data/services/food_data_service.dart';
import '../data/store/daily_tracker_store.dart';

class MealBottomSheet extends StatefulWidget {
  const MealBottomSheet({super.key});

  @override
  State<MealBottomSheet> createState() => _MealBottomSheetState();
}

class _MealBottomSheetState extends State<MealBottomSheet> {
  final TextEditingController searchController = TextEditingController();
  final FoodDataService foodDataService = const FoodDataService();

  List<FoodItemModel> allFoods = [];
  List<FoodItemModel> filteredFoods = [];
  List<String> categories = ['Tümü'];

  String selectedCategory = 'Tümü';
  String selectedMealType = 'Öğün';
  FoodItemModel? selectedFood;

  bool isLoading = true;
  bool isSubmitting = false;
  String? errorMessage;
  String? statusMessage;
  bool isSuccessMessage = false;


  @override
  void initState() {
    super.initState();
    loadFoods();
    searchController.addListener(applyFilters);
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> loadFoods() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final loadedFoods = await foodDataService.loadFoods();
      final loadedCategories = foodDataService.getCategories(loadedFoods);

      setState(() {
        allFoods = loadedFoods;
        categories = loadedCategories;
        filteredFoods = loadedFoods;
        isLoading = false;
      });
    } catch (error) {
      setState(() {
        errorMessage = error.toString().replaceFirst('Exception: ', '');
        isLoading = false;
      });
    }
  }

  void applyFilters() {
    final query = searchController.text.trim().toLowerCase();

    final result = allFoods.where((food) {
      final matchesCategory =
          selectedCategory == 'Tümü' || food.category == selectedCategory;

      final matchesSearch =
          food.name.toLowerCase().contains(query) ||
          food.category.toLowerCase().contains(query);

      return matchesCategory && matchesSearch;
    }).toList();

    setState(() {
      filteredFoods = result;
      if (selectedFood != null &&
          !result.any((food) => food.id == selectedFood!.id)) {
        selectedFood = null;
      }
    });
  }

  void selectCategory(String category) {
    setState(() {
      selectedCategory = category;
    });
    applyFilters();
  }

  void selectMealType(String mealType) {
    setState(() {
      selectedMealType = mealType;
    });
  }

  void selectFood(FoodItemModel food) {
    setState(() {
      selectedFood = food;
    });
  }

  Future<void> addSelectedFood() async {
  final food = selectedFood;
  if (food == null || isSubmitting) return;

  setState(() {
    isSubmitting = true;
    statusMessage = null;
  });

  final isSuccess = await dailyTrackerStore.addMealFromFood(
    food: food,
    mealType: selectedMealType,
  );

  if (!mounted) return;

  setState(() {
    isSubmitting = false;
    isSuccessMessage = isSuccess;
    statusMessage = isSuccess ? 'Öğün eklendi.' : 'Öğün eklenemedi.';
    if (isSuccess) {
      selectedFood = null;
    }
  });
}


  @override
  Widget build(BuildContext context) {
    final mealTypes = ['Kahvaltı', 'Öğle', 'Akşam', 'Ara Öğün'];

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
              'Öğün Ekle',
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
                hintText: 'Besin ara',
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
            const SizedBox(height: 14),
            SizedBox(
              height: 38,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: mealTypes.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final mealType = mealTypes[index];
                  final isSelected = selectedMealType == mealType;

                  return ChoiceChip(
                    label: Text(mealType),
                    selected: isSelected,
                    onSelected: (_) => selectMealType(mealType),
                    selectedColor: AppColors.primary,
                    backgroundColor: AppColors.card,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : AppColors.textDark,
                      fontWeight: FontWeight.w700,
                    ),
                    side: BorderSide.none,
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 38,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final category = categories[index];
                  final isSelected = selectedCategory == category;

                  return ChoiceChip(
                    label: Text(category),
                    selected: isSelected,
                    onSelected: (_) => selectCategory(category),
                    selectedColor: AppColors.accentBlue,
                    backgroundColor: AppColors.card,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : AppColors.textDark,
                      fontWeight: FontWeight.w700,
                    ),
                    side: BorderSide.none,
                  );
                },
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
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              errorMessage!,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: AppColors.textMuted,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 14),
                            ElevatedButton(
                              onPressed: loadFoods,
                              child: const Text('Tekrar Dene'),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  if (filteredFoods.isEmpty) {
                    return const Center(
                      child: Text(
                        'Sonuç bulunamadı.',
                        style: TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    );
                  }

                  return ListView.separated(
                    itemCount: filteredFoods.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final food = filteredFoods[index];
                      final isSelected = selectedFood?.id == food.id;

                      return InkWell(
                        onTap: () => selectFood(food),
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
                          child: Row(
                            children: [
                              Container(
                                width: 42,
                                height: 42,
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(
                                  isSelected
                                      ? Icons.check_rounded
                                      : Icons.restaurant_rounded,
                                  color: AppColors.primary,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      food.name,
                                      style: const TextStyle(
                                        color: AppColors.textDark,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${food.category} • ${food.servingLabel}',
                                      style: const TextStyle(
                                        color: AppColors.textMuted,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '${food.calories} kcal',
                                style: const TextStyle(
                                  color: AppColors.primary,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w800,
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
                onPressed: selectedFood == null || isSubmitting
                    ? null
                    : addSelectedFood,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: AppColors.border,
                  minimumSize: const Size.fromHeight(48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  isSubmitting ? 'Ekleniyor...' : 'Öğünü Ekle',
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
