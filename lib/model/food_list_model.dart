import 'package:spoonacular_app/model/food_list_nutrition_model.dart';

import 'food_model.dart';

class FoodList {
  final List<Food> foods;

  FoodList({this.foods});

//This class has an ID which allows us to get the Recipes and other info
//Such as title and Image URL

/*
Factory Constructor Meal.fromMap parses the decoded JSON data to get the
values of the meal, and returns the Meal Object
*/
  factory FoodList.fromMap(Map<String, dynamic> map) {
    List<Food> foods = [];
    map['results'].forEach((foodMap) => foods.add(Food.fromMap(foodMap)));
    //MealPlan object with information we want
    return FoodList(
      foods: foods,
    );
  }
}
