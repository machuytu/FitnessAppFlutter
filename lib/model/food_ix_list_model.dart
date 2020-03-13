import 'food_ix_model.dart';

class FoodIXList {
  final List<FoodIX> foodsix;

  FoodIXList({this.foodsix});

//This class has an ID which allows us to get the Recipes and other info
//Such as title and Image URL

/*
Factory Constructor Meal.fromMap parses the decoded JSON data to get the
values of the meal, and returns the Meal Object
*/
  factory FoodIXList.fromMap(Map<String, dynamic> map) {
    List<FoodIX> foodsix = [];
    map['branded'].forEach((foodMap) => foodsix.add(FoodIX.fromMap(foodMap)));
    //MealPlan object with information we want
    return FoodIXList(
      foodsix: foodsix,
    );
  }
}
