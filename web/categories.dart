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
        reoganizeCategories();
      })
      .catchError((error){
        print('Error initializing categories: $error');
      });
}