import 'dart:html';
import 'dart:convert' show JSON;
import 'dart:async' show Future;

import 'package:animation/animation.dart';

int currentBoard = 0;

class Board {
  String name;

  static List<String> names = [];
  
  Board(this.name);
  
  static Future readyTheBoards(){
   var path = 'json/content.json'; 
   return HttpRequest.getString(path)
        .then(_parseBoardsFromJSON);
  }
  
  static List<String> _parseBoardsFromJSON(String jsonString){
      Map content = JSON.decode(jsonString);
        names = content['boards'];
        return names;
    }
}

void createBoard(List<String> boards){
  for(int i = 0; i < boards.length; i++){
    DivElement div = new DivElement();
    div.attributes = {
      "class" : "boardBackground",
      "data-board-id" : i.toString(),
      "style" : "left:"+(window.screen.available.width * i).toString()+"px"
    };
    querySelector("#boards").children.add(div);
    boardNav(i, boards.length);
  }
}

void appendNameToBoard(String name, int id){
  
}

void setBodyWidth(){
  document.body.attributes = {"style" : "left:"+(window.screen.available.width).toString()+"px"};
}

void onWindowResize(){
  window.onResize.listen((Event e) {
    //resize the body
    document.body.attributes = {"style" : "left:"+(window.screen.available.width).toString()+"px"};
    //resize position
    var boards = querySelector("#boards");
    boards.children.forEach((childElement){
      childElement.setAttribute("style", "left:"+(window.screen.available.width * int.parse(childElement.getAttribute("data-board-id"))).toString()+"px");
    });
    //reposition boards
    var multiplier = 0 - currentBoard;
    querySelector("#boards").setAttribute("style", "left:"+(window.screen.available.width * multiplier).toString()+"px");
  });
}

void boardNav(int i, int length){
  var board = querySelector("*[data-board-id='"+i.toString()+"']");
  
  DivElement left = new DivElement();
  DivElement right = new DivElement();
  
  ImageElement leftArrow = new ImageElement();
  leftArrow.src = "img/chevronLeft.png";
  ImageElement rightArrow = new ImageElement();
  rightArrow.src = "img/chevronRight.png";
  
  left.children.add(leftArrow);
  right.children.add(rightArrow);
  
  if(i == 0){
    //if first
    right.attributes = {
      "class" : "rightBoardNav",
      "data-nav-id" : i.toString(),
    };
    right.onClick.listen((MouseEvent e) {animateScroll(i, "right"); currentBoard = i+1;});
    board.append(right);
  }else if(i == (length-1) ){
    //if last
    left.attributes = {
      "class" : "leftBoardNav",
      "data-nav-id" : i.toString(),
    };
    board.append(left);
    left.onClick.listen((MouseEvent e) {animateScroll(i, "left"); currentBoard = i-1;});
  }else{
    //every one else
    right.attributes = {
      "class" : "rightBoardNav",
      "data-nav-id" : i.toString(),
    };
    left.attributes = {
      "class" : "leftBoardNav",
      "data-nav-id" : i.toString(),
    };
    board.append(left);
    left.onClick.listen((MouseEvent e){animateScroll(i, "left"); currentBoard = i-1;});
    board.append(right);
    right.onClick.listen((MouseEvent e) {animateScroll(i, "right"); currentBoard = i+1;});
  }
}

void animateScroll(int i, String direction){
  var body = querySelector("#boards");
  var newLeft = 0;
  
  if(direction == "right"){
    newLeft = body.offsetLeft - window.screen.available.width;
  }else{
    newLeft = body.offsetLeft + window.screen.available.width;
  }
  
  var prop = {
    "left" : newLeft
  };
  animate(body, properties: prop, duration: 1000);
}

void initBoards(){
  DivElement boards = new DivElement();
  boards.id = "boards";
  querySelector("body").children.add(boards);
  Board.readyTheBoards()
    .then((value) {
      //on success
      createBoard(value);
      setBodyWidth();
      onWindowResize();
    })
    .catchError((error){
      print('Error initializing boards: $error');
    });
}

