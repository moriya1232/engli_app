

import 'cards/Position.dart';

String mail = "engli@gmail.com";
String name = "אברהם";


const r1 = "Pets";
const r2 = "Furnitures";
const r3 = "Animals";
const r4 = "Days";
const r5 = "Places";
const r6 = "Monthes";
const r7 = "Family";
const r8 = "Colors";
const r9 = "Food";
const r10 = "Body";

const howMuchScoreForSuccess = 10;


double rowHeight;
double otherPlayersHeight;
double fontSizeNames;
double widthScreen;
double heightScreen;
Position firstPlayerPos;
Position secondPlayerPos;
Position thirdPlayerPos;
Position mePos;
Position deckPos;
double heightCloseCard;
double widthCloseCard;

double getFirstPlayerLeft() {
  return widthScreen / 2 - widthCloseCard / 2;
}

double getFirstPlayerTop() {
  return heightCloseCard / 2;
}

double getSecondPlayerLeft() {
  return heightCloseCard / 2;
}

double getSecondPlayerTop() {
  return heightCloseCard + fontSizeNames + rowHeight / 2;
}

double getThirdPlayerRight() {
  return heightCloseCard / 2;
}

double getThirdPlayerTop() {
  return heightCloseCard + fontSizeNames + rowHeight / 2;
}

double getMeLeft() {
  return widthScreen / 2 - widthCloseCard / 2;
}

double getMeTop() {
  return heightScreen*(3/4);
}

double getDeckLeft() {
  return widthScreen / 2 - widthCloseCard / 2;
}

double getDeckTop() {
  return otherPlayersHeight - rowHeight / 2;
}

