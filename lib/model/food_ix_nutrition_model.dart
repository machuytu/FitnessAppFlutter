import 'food_list_nutrition_model.dart';

class FoodIXNutrition {
  final String food_name;
  final double nf_total_fat, nf_calories, nf_total_carbohydrate, nf_protein;

  FoodIXNutrition(
      {this.food_name,
      this.nf_calories,
      this.nf_protein,
      this.nf_total_fat,
      this.nf_total_carbohydrate});

//This class has an ID which allows us to get the Recipes and other info
//Such as title and Image URL

/*
Factory Constructor Meal.fromMap parses the decoded JSON data to get the
values of the meal, and returns the Meal Object
*/

  factory FoodIXNutrition.fromMap(Map<String, dynamic> map) {
    return FoodIXNutrition(
      food_name: map['food_name'],
      nf_calories: map['nf_calories'],
      nf_protein: map['nf_protein'],
      nf_total_fat: map['nf_total_fat'],
      nf_total_carbohydrate: map['nf_total_carbohydrate'],
    );
  }
}
