//This file will handle all our API calls to the
//Spoonacular API

import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:spoonacular_app/model/food_ix_list_model.dart';
import 'package:spoonacular_app/model/food_ix_nutrition_model.dart';
import 'package:spoonacular_app/model/food_list_model.dart';
import 'package:spoonacular_app/model/food_model.dart';
import 'package:spoonacular_app/model/meal_plan_model.dart';
import 'package:spoonacular_app/model/recipe_model.dart';

class ApiService {
  // The API service will be a singleton, therefore create a private constructor
  // ApiService._instantiate(), and a static instance variable
  ApiService._instantiate();
  static final ApiService instance = ApiService._instantiate();

  // Add base URL for the spoonacular API, endpoint and API Key as a constant
  final String _baseURL = "api.spoonacular.com";
  static const String API_KEY = "eaaf7b5535a44068ad0c818eeee4d0b9";

  // Add base URL for the nutritionix API
  final String _baseURLIX = "trackapi.nutritionix.com";
  static const String API_ID_IX = "03ec51c4";
  static const String API_KEY_IX = "6dd7550cf2d47e287a47bbb7aa34a27e";

  Future<FoodIXNutrition> generateFoodListIXNutrition(
      {String food_name}) async {
    Map data1 = {
      'query': food_name,
    };

    var body = json.encode(data1);
    //The Uri consists of the base url, the endpoint we are going to use. It has also
    //parameters
    Uri uri = Uri.https(
      _baseURLIX,
      '/v2/natural/nutrients',
    );

    //Our header specifies that we want the request to return a json object
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
      'x-app-id': API_ID_IX,
      'x-app-key': API_KEY_IX,
      'x-remote-user-id': '0',
    };

    try {
      //http.get to retrieve the response
      var response = await http.post(uri, headers: headers, body: body);
      //decode the body of the response into a map
      Map<String, dynamic> data = json.decode(response.body);
      //convert the map into a MealPlan Object using the factory constructor,
      //MealPlan.fromMap
      Logger logger = new Logger();
      logger.d("data nutrition", data);
      FoodIXNutrition foodIXNutrition = FoodIXNutrition.fromMap(data);
      return foodIXNutrition;
    } catch (err) {
      //If our response has error, we throw an error message
      throw err.toString();
    }
  }

  Future<FoodIXList> generateFoodListIX({String query}) async {
    Map<String, String> parameters = {
      'query': query,
      'branded': 'true',
    };

    //The Uri consists of the base url, the endpoint we are going to use. It has also
    //parameters
    Uri uri = Uri.https(
      _baseURLIX,
      '/v2/search/instant',
      parameters,
    );

    //Our header specifies that we want the request to return a json object
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
      'x-app-id': API_ID_IX,
      'x-app-key': API_KEY_IX,
    };

    try {
      //http.get to retrieve the response
      var response = await http.get(uri, headers: headers);
      //decode the body of the response into a map
      Map<String, dynamic> data = json.decode(response.body);
      //convert the map into a MealPlan Object using the factory constructor,
      //MealPlan.fromMap
      Logger logger = new Logger();
      logger.d("data", data);
      FoodIXList foodIxList = FoodIXList.fromMap(data);
      return foodIxList;
    } catch (err) {
      //If our response has error, we throw an error message
      throw err.toString();
    }
  }

  Future<FoodList> generateFoodList({String query}) async {
    Map<String, String> parameters = {
      'query': query,
      'number': '4',
      'minCarbs': '0',
      'minProtein': '0',
      'minFat': '0',
      'minCalories': '0',
      'apiKey': API_KEY,
    };

    //The Uri consists of the base url, the endpoint we are going to use. It has also
    //parameters
    Uri uri = Uri.https(
      _baseURL,
      '/recipes/complexSearch',
      parameters,
    );

    //Our header specifies that we want the request to return a json object
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
    };

    try {
      //http.get to retrieve the response
      var response = await http.get(uri, headers: headers);
      //decode the body of the response into a map
      Map<String, dynamic> data = json.decode(response.body);
      //convert the map into a MealPlan Object using the factory constructor,
      //MealPlan.fromMap
      Logger logger = new Logger();
      logger.d("data", data);
      FoodList foodList = FoodList.fromMap(data);
      return foodList;
    } catch (err) {
      //If our response has error, we throw an error message
      throw err.toString();
    }
  }

  //We create async function to generate meal plan which takes in
  //timeFrame, targetCalories, diet and apiKey

  //If diet is none, we set the diet into an empty string

  //timeFrame parameter sets our meals into 3 meals, which are daily meals.
  //that's why it's set to day

  Future<MealPlan> generateMealPlan({int targetCalories, String diet}) async {
    //check if diet is null
    if (diet == 'None') diet = '';
    Map<String, String> parameters = {
      'timeFrame': 'day', //to get 3 meals
      'targetCalories': targetCalories.toString(),
      'diet': diet,
      'apiKey': API_KEY,
    };

    //The Uri consists of the base url, the endpoint we are going to use. It has also
    //parameters
    Uri uri = Uri.https(
      _baseURL,
      '/mealplanner/generate',
      parameters,
    );

    //Our header specifies that we want the request to return a json object
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
    };

    /*
    Our try catch uses http.get to retrieve response.
    It then decodes the body of the response into a map,
    and converts the map into a mealPlan object
    by using the facory constructor MealPlan.fromMap
    */
    try {
      //http.get to retrieve the response
      var response = await http.get(uri, headers: headers);
      //decode the body of the response into a map
      Map<String, dynamic> data = json.decode(response.body);
      //convert the map into a MealPlan Object using the factory constructor,
      //MealPlan.fromMap

      MealPlan mealPlan = MealPlan.fromMap(data);
      return mealPlan;
    } catch (err) {
      //If our response has error, we throw an error message
      throw err.toString();
    }
  }

  //the fetchRecipe takes in the id of the recipe we want to get the info for
  //We also specify in the parameters that we don't want to include the nutritional
  //information
  //We also parse in our API key
  Future<Recipe> fetchRecipe(String id) async {
    Map<String, String> parameters = {
      'includeNutrition': 'false',
      'apiKey': API_KEY,
    };

    //we call in our recipe id in the Uri, and parse in our parameters
    Uri uri = Uri.https(
      _baseURL,
      '/recipes/$id/information',
      parameters,
    );

    //And also specify that we want our header to return a json object
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
    };

    //finally, we put our response in a try catch block
    try {
      var response = await http.get(uri, headers: headers);
      Map<String, dynamic> data = json.decode(response.body);
      Recipe recipe = Recipe.fromMap(data);
      return recipe;
    } catch (err) {
      throw err.toString();
    }
  }
}
