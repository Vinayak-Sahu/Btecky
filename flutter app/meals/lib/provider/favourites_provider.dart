import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals/model/meal.dart';

class FavouriteMealNotifier extends StateNotifier<List<Meal>> {
  FavouriteMealNotifier() : super([]);

  bool toggleMealFavouriteStatus(Meal meal) {
    final mealisFavourite = state.contains(meal);
    if (mealisFavourite) {
      state = state.where((element) => element.id != meal.id).toList();
      return false;
    } else {
      state = [...state, meal];
      return true;
    }
  }
}

final favoriteMealsProvider =
    StateNotifierProvider<FavouriteMealNotifier, List<Meal>>((ref) {
  return FavouriteMealNotifier();
});
