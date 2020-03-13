import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:spoonacular_app/model/food_list_model.dart';
import 'package:spoonacular_app/model/food_list_nutrition_model.dart';
import 'package:spoonacular_app/model/food_model.dart';
import 'package:spoonacular_app/model/recipe_model.dart';
import 'package:spoonacular_app/screens/recipe_screen.dart';
import 'package:spoonacular_app/services/api_services.dart';

class FoodScreen extends StatefulWidget {
  //It returns a final mealPlan variable
  final FirebaseUser user;
  FoodList foodList;
  FoodScreen({this.foodList, this.user});

  @override
  _FoodScreen createState() => _FoodScreen();
}

class _FoodScreen extends State<FoodScreen> {
/*
Returns aContainer with Curved edges and a BoxShadow.
The child is a column widget that returns nutrient information in Rows
 */
  Logger logger = new Logger();
  double caloriesCount;
  double proteinCount;
  double fatCount;
  double carbsCount;

  Firestore db = Firestore.instance;
  GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  DatabaseReference reference = FirebaseDatabase.instance.reference();

  static String _strDate = DateFormat("yyyy-MM-dd").format(DateTime.now());

  @override
  initState() {
    super.initState();
    reference
        .child('Overview')
        .child(widget.user.uid)
        .child(_strDate)
        .once()
        .then((DataSnapshot snapshot) {
      setState(() {
        if (snapshot.value == null) {
          caloriesCount = 0;
          proteinCount = 0;
          fatCount = 0;
          carbsCount = 0;
        } else {
          caloriesCount = double.parse(snapshot.value['Calories'].toString());
          proteinCount = double.parse(snapshot.value['Protein'].toString());
          fatCount = double.parse(snapshot.value['Fat'].toString());
          carbsCount = double.parse(snapshot.value['Carbs'].toString());
        }
      });
      logger.d('test', caloriesCount);
    });
  }

  //This method below takes in parameters meal and index
  _buildMealCard(Food food, int index) {
    //We define a String variable mealType, that equals method called mealType
    //We return stack widget with center alignment
    return GestureDetector(
      //We wrap our stack with gesture detector to navigate to webview page

      /*
      The async onTap function will fetch the recipe by id using the
      fetchRecipe method.
      It will then navigate to RecipeScreen, while parsing in our mealType and recipe
       */
      onTap: () async {
//        Recipe recipe =
//            await ApiService.instance.fetchRecipe(food.id.toString());
//        Navigator.push(
//            context,
//            MaterialPageRoute(
//                builder: (_) => RecipeScreen(
//                      recipe: recipe,
//                    )));
      },
      child: Stack(alignment: Alignment.center, children: <Widget>[
        //First widget is a container that loads decoration image
        Container(
          height: 240,
          width: double.infinity,
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          decoration: BoxDecoration(
              color: Colors.white,
              image: DecorationImage(
                image: NetworkImage(food.imgURL),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                    color: Colors.black12, offset: Offset(0, 2), blurRadius: 6)
              ]),
        ),
        //Second widget is a Container that has 2 text widgets
        Container(
          margin: EdgeInsets.all(60),
          padding: EdgeInsets.all(10),
          color: Colors.white70,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Text(
                food.title,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
                overflow: TextOverflow.ellipsis,
              ),
              ListView.builder(
                  shrinkWrap: true,
                  itemCount: widget.foodList.foods[index].nutritions.length,
                  itemBuilder: (BuildContext context, int index1) {
                    Nutrition nutrition =
                        widget.foodList.foods[index].nutritions[index1];
                    return Container(
                      child: Column(
                        children: <Widget>[
                          Text(
                            nutrition.title +
                                ": " +
                                nutrition.amount.toString(),
                            style: TextStyle(
                                fontSize: 13, fontWeight: FontWeight.w600),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    );
                  }),
              RaisedButton(
                onPressed: () {
                  addFood(food, index);
                },
                color: Colors.green,
                child: Text("add"),
              ),
            ],
//            mainAxisAlignment: MainAxisAlignment.spaceBetween,
          ),
        )
      ]),
    );
  }

  /*
  mealType returns Breakfast, Lunch or Dinner, depending on the index value
  */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //has an appBar
      appBar: AppBar(title: Text('Food')),
      //and body as a ListView builder
      body: ListView.builder(
          /*
            We set itemCount to 1 + no. of meals, which based on our API call,
            the no. of meals should always be 3
            */
          shrinkWrap: true,
          itemCount: widget.foodList.foods.length,
          itemBuilder: (BuildContext context, int index) {
            /*
                Otherwise, we return a buildMealCard method that takes in the meal,
                and index - 1
                */
            Food food = widget.foodList.foods[index];
            return index == 0 ? _searchBar() : _buildMealCard(food, index);
          }),
    );
  }

  _searchBar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        decoration: InputDecoration(hintText: "Search Food..."),
        onSubmitted: (text) {
          text = text.toLowerCase();
          ApiService.instance.generateFoodList(query: text).then((value) {
            setState(() {
              widget.foodList = value;
            });
          });
        },
      ),
    );
  }

  addFood(Food food, int index) async {
    for (int i = 0; i <= food.nutritions.length; i++) {
      if (i == 0) {
        caloriesCount += food.nutritions[i].amount;
      }
      if (i == 1) {
        proteinCount += food.nutritions[i].amount;
      }
      if (i == 2) {
        fatCount += food.nutritions[i].amount;
      }
      if (i == 3) {
        carbsCount += food.nutritions[i].amount;
      }
    }
    reference.child('Overview').child(widget.user.uid).child(_strDate).set({
      "Calories": caloriesCount,
      "Protein": proteinCount,
      "Fat": fatCount,
      "Carbs": carbsCount
    });
  }
}
