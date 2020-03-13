import 'dart:io';

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:spoonacular_app/model/food_ix_list_model.dart';
import 'package:spoonacular_app/model/food_ix_nutrition_model.dart';
import 'package:spoonacular_app/screens/food_screen.dart';
import 'package:spoonacular_app/services/api_services.dart';

import 'food_ix_screen.dart';

class SearchFoodIXScreen extends StatefulWidget {
  @override
  _SearchFoodIXScreenState createState() => _SearchFoodIXScreenState();
}

class _SearchFoodIXScreenState extends State<SearchFoodIXScreen> {
  final _query = TextEditingController();

  //This method generates a MealPlan by parsing our parameters into the
  //ApiService.instance.generateMealPlan.
  //It then pushes the Meal Screen onto the stack with Navigator.push
  void _searchFood() async {
    FoodIXList foodIXList = await ApiService.instance.generateFoodListIX(
      query: _query.text,
    );

    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => FoodIXScreen(foodIXList: foodIXList),
        ));
  }

  Widget build(BuildContext context) {
    /*
    Our build method returns Scaffold Container, which has a decoration
    image using a Network Image. The image loads and is the background of
    the page
    */
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(
                'https://images.unsplash.com/photo-1482049016688-2d3e1b311543?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=353&q=80'),
            fit: BoxFit.cover,
          ),
        ),

        //Center widget and a container as a child, and a column widget
        child: Center(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 30),
            padding: EdgeInsets.symmetric(horizontal: 30),
            height: MediaQuery.of(context).size.height * 0.55,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                //Text widget for our app's title
                Text(
                  'My Daily Meal Planner',
                  style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2),
                ),
                //space
                SizedBox(height: 20),
                //A RichText to style the target calories

                //Orange slider that sets our target calories
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    thumbColor: Theme.of(context).primaryColor,
                    inactiveTrackColor: Colors.lightBlue[100],
                    trackHeight: 6,
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Enter a search term'),
                    controller: _query,
                  ),
                ),
                //Space
                SizedBox(height: 30),
                //FlatButton where onPressed() triggers a function called _searchMealPlan
                FlatButton(
                  padding: EdgeInsets.symmetric(horizontal: 60, vertical: 8),
                  color: Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Text(
                    'Search',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  //_searchMealPlan function is above the build method
                  onPressed: _searchFood,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
