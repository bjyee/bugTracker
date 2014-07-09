import 'dart:html';
import 'dart:convert' show JSON;
import 'dart:async' show Future;

import 'package:animation/animation.dart';

class Category{
  String name;

    static List<String> names = [];
    
    Category(this.name);
    
    static Future readyTheCategories(){
     var path = 'json/content.json'; 
     return HttpRequest.getString(path)
          .then(_parseCategoriesFromJSON);
    }
    
    static List<String> _parseCategoriesFromJSON(String jsonString){
        Map content = JSON.decode(jsonString);
          names = content['categories'];
          return names;
      }
}

void createCategories(List<String> categories){
  //create categories on all the boards.
  var boards = querySelectorAll(".boardListings");
  for(int i = 0; i < categories.length; i++){
     DivElement div = new DivElement();
     div.attributes = {
       "class" : "categoriesZoomOut",
       "data-category-id" : i.toString()
     };
  };
}

void animateSelection(){
  
}

void reoganizeCategories(){
  
}

void initCategories(){
  Category.readyTheCategories()
      .then((value) {
        //on success
        createCategories(value);
//        reoganizeCategories();
      })
      .catchError((error){
        print('Error initializing categories: $error');
      });
}