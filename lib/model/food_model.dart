import 'food_list_nutrition_model.dart';

class Food {
  final List<Nutrition> nutritions;
  final int id;
  final String title, imgURL;

  Food({this.nutritions, this.id, this.title, this.imgURL});

//This class has an ID which allows us to get the Recipes and other info
//Such as title and Image URL

/*
Factory Constructor Meal.fromMap parses the decoded JSON data to get the
values of the meal, and returns the Meal Object
*/

  factory Food.fromMap(Map<String, dynamic> map) {
    List<Nutrition> nutritions = [];
    map['nutrition'].forEach(
        (nutritionMap) => nutritions.add(Nutrition.fromMap(nutritionMap)));
    return Food(
      nutritions: nutritions,
      id: map['id'],
      title: map['title'],
      imgURL: map['image'],
    );
  }
}
