import 'food_list_nutrition_model.dart';

class FoodIX {
  final String food_name, imgURL;

  FoodIX({this.food_name, this.imgURL});

//This class has an ID which allows us to get the Recipes and other info
//Such as title and Image URL

/*
Factory Constructor Meal.fromMap parses the decoded JSON data to get the
values of the meal, and returns the Meal Object
*/

  factory FoodIX.fromMap(Map<String, dynamic> map) {
    return FoodIX(
      food_name: map['food_name'],
      imgURL: map['photo']['thumb'],
    );
  }
}
