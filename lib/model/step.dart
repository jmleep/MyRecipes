import 'package:my_recipes/model/model_list_base.dart';

class Step extends ModelListBase {
  Step({int id, int recipeId, String value})
      : super(id: id, recipeId: recipeId, value: value);
}