import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:spoonacular_app/model/food_ix_list_model.dart';
import 'package:spoonacular_app/model/food_ix_model.dart';
import 'package:spoonacular_app/model/food_ix_nutrition_model.dart';
import 'package:spoonacular_app/services/api_services.dart';

class FoodIXScreen extends StatefulWidget {
  //It returns a final mealPlan variable
  FoodIXList foodIXList;
  FoodIXScreen({this.foodIXList});

  @override
  _FoodIXScreen createState() => _FoodIXScreen();
}

class _FoodIXScreen extends State<FoodIXScreen> {
/*
Returns aContainer with Curved edges and a BoxShadow.
The child is a column widget that returns nutrient information in Rows
 */
  List<FoodIXNutrition> list;

  final _query = TextEditingController();
//  @override
//  Future<void> initState() async {
//    FoodIXNutrition foodIXNutrition = await ApiService.instance.generateFoodListIXNutrition(
//      food_name: widget.foodIXList.foodsix[index].food_name,
//    );
//  }

//This method below takes in parameters meal and index
  _buildMealCard(FoodIX foodIX, int index) {
    //We define a String variable mealType, that equals method called mealType
    //We return stack widget with center alignment
    Logger logger = new Logger();
    logger.d("food", foodIX.food_name.toString());

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
                image: NetworkImage(foodIX.imgURL),
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
                foodIX.food_name,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
                overflow: TextOverflow.ellipsis,
              ),
//              Text(
//                foodIXNutrition.nf_total_carbohydrate.toString(),
//                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
//                overflow: TextOverflow.ellipsis,
//              ),
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
        itemCount: widget.foodIXList.foodsix.length,
        itemBuilder: (BuildContext context, int index) {
          FoodIX foodIX = widget.foodIXList.foodsix[index];

          return index == 0 ? _searchBar() : _buildMealCard(foodIX, index);
        },
      ),
    );
  }

  _searchBar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        decoration: InputDecoration(hintText: "Search Food..."),
        onSubmitted: (text) async {
          text = text.toLowerCase();
          ApiService.instance.generateFoodListIX(query: text).then((value) {
            setState(() {
              widget.foodIXList = value;
            });
          });
        },
      ),
    );
  }
}
