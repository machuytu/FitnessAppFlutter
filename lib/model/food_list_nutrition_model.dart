import 'dart:ffi';

import 'package:spoonacular_app/model/food_list_model.dart';

class Nutrition {
  final String title;
  final double amount;

  Nutrition({this.title, this.amount});

//This class has an ID which allows us to get the Recipes and other info
//Such as title and Image URL

/*
Factory Constructor Meal.fromMap parses the decoded JSON data to get the
values of the meal, and returns the Meal Object
*/
  factory Nutrition.fromMap(Map<String, dynamic> map) {
    //MealPlan object with information we want
    return Nutrition(
      title: map['title'],
      amount: map['amount'],
    );
  }
}
