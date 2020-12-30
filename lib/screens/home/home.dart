import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_recipes/database/recipe_data_manager.dart';
import 'package:my_recipes/widgets/app_bar.dart';
import 'package:my_recipes/widgets/buttons/button_add_recipe_floating_action.dart';
import 'package:my_recipes/widgets/dismissible_background.dart';
import 'package:my_recipes/widgets/list_items/list_item_recipe.dart';

import '../../model/recipe.dart';
import '../add_edit_recipe/add_edit_recipe.dart';

class Home extends StatefulWidget {
  Home({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Future<List<Recipe>> recipes;

  Widget getRecipeListView(AsyncSnapshot<List<Recipe>> snapshot) {
    Widget view;
    if (snapshot.hasData && snapshot.data.length > 0) {
      view = ListView.separated(
          itemBuilder: (BuildContext context, int index) {
            return Dismissible(
                direction: DismissDirection.endToStart,
                key: UniqueKey(),
                background: DismissibleBackground(),
                onDismissed: (direction) async {
                  HapticFeedback.mediumImpact();

                  await RecipeDatabaseManager.deleteRecipe(
                      snapshot.data[index]);
                  var deletedRecipe = snapshot.data[index].name;
                  snapshot.data.removeAt(index);
                  setState(() {
                    recipes = RecipeDatabaseManager.getAllRecipes();
                  });

                  Scaffold.of(context).showSnackBar(
                      SnackBar(content: Text("$deletedRecipe deleted")));
                },
                child: RecipeListItem(
                  key: UniqueKey(),
                  recipe: snapshot.data[index],
                ));
          },
          separatorBuilder: (BuildContext context, int index) => SizedBox(
                height: 10,
              ),
          itemCount: snapshot.data.length);
    } else {
      view = Text(
        'Add a recipe!',
      );
    }

    return view;
  }

  void onPressAddRecipeFAB(BuildContext context) async {
    HapticFeedback.mediumImpact();

    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddEditRecipe()),
    );

    setState(() {
      recipes = RecipeDatabaseManager.getAllRecipes();
    });
  }

  @override
  void initState() {
    super.initState();
    recipes = RecipeDatabaseManager.getAllRecipes();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Recipe>>(
      future: recipes,
      builder: (BuildContext context, AsyncSnapshot<List<Recipe>> snapshot) {
        Widget listView = getRecipeListView(snapshot);

        return Scaffold(
            appBar: RecipeAppBar(
              title: widget.title,
              allowBack: false,
            ),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(child: listView),
            ),
            backgroundColor: Theme.of(context).accentColor,
            floatingActionButton: AddRecipeFloatingActionButton(
              onPressAddRecipeFAB: this.onPressAddRecipeFAB,
            ));
      },
    );
  }
}