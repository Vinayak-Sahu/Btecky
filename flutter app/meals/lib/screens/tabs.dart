import 'package:flutter/material.dart';
import 'package:meals/provider/favourites_provider.dart';
import 'package:meals/screens/categories.dart';
import 'package:meals/screens/filters.dart';
import 'package:meals/screens/meals.dart';
import 'package:meals/widgets/main_drawer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals/provider/meals_provider.dart';

const kinitialFilters = {
  Filter.glutenfree: false,
  Filter.lactosefree: false,
  Filter.vegan: false,
  Filter.vegetarian: false,
};

class TabsScreeen extends ConsumerStatefulWidget {
  const TabsScreeen({super.key});

  @override
  ConsumerState<TabsScreeen> createState() => _TabsScreeenState();
}

class _TabsScreeenState extends ConsumerState<TabsScreeen> {
  Map<Filter, bool> _selectedFilters = kinitialFilters;
  int _selectedPageIndex = 0;


  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  void _setScreen(String type) async {
    Navigator.of(context).pop();
    if (type == 'filters') {
      final result = await Navigator.of(context).push<Map<Filter, bool>>(
        MaterialPageRoute(
          builder: (ctx) => FiltersScreen(
            currentfilters: _selectedFilters,
          ),
        ),
      );
      setState(() {
        _selectedFilters = result ?? kinitialFilters;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final meals = ref.watch(mealsProvider);
    final availableMeals = meals.where((meal) {
      if (_selectedFilters[Filter.glutenfree]! && !meal.isGlutenFree) {
        return false;
      }
      if (_selectedFilters[Filter.lactosefree]! && !meal.isLactoseFree) {
        return false;
      }
      if (_selectedFilters[Filter.vegetarian]! && !meal.isVegetarian) {
        return false;
      }
      if (_selectedFilters[Filter.vegan]! && !meal.isVegan) {
        return false;
      }
      return true;
    }).toList();
    Widget activePage = CategoriesScreen(
      
      availableMeals: availableMeals,
    );
    var activePageTitle = 'Categories';
    if (_selectedPageIndex == 1) {
      final favouritemeal = ref.watch(favoriteMealsProvider);
      activePage = MealsScreen(
        meals: favouritemeal,
     
      );
      activePageTitle = 'Your Favourites';
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(activePageTitle),
      ),
      drawer: MainDrawer(
        ontapoption: _setScreen,
      ),
      body: activePage,
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        currentIndex: _selectedPageIndex,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.set_meal), label: "Categories"),
          BottomNavigationBarItem(icon: Icon(Icons.star), label: "Favourites"),
        ],
      ),
    );
  }
}
