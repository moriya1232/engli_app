
class Position {
  double _left;
  double _top;
  double _right;
  double _bottom;
  bool _visible;


  set visible(bool value) {
    _visible = value;
  }

  Position(double left, double top, double right, double bottom) {
    this._left = left;
    this._right = right;
    this._top = top;
    this._bottom = bottom;
    this._visible = true;
  }

  double getLeft(){
    return this._left;
  }

  double getTop(){
    return this._top;
  }

  double getBottom(){
    return this._bottom;
  }

  double getRight(){
    return this._right;
  }

  void setPositionTopLeft(double left, double top) {
    this._left = left;
    this._top = top;
    this._right = null;
    this._bottom = null;
  }

  bool getVisible() {
    return this._visible;
  }


  void setPositionTopRight(double right, double top) {
    this._left = null;
    this._top = top;
    this._right = right;
    this._bottom = null;
  }


  void setPositionBottomLeft(double left, double bottom) {
    this._left = left;
    this._top = null;
    this._right = null;
    this._bottom = bottom;
  }

  Position setPosition(Position p) {
    this._right = p.getRight();
    this._top = p.getTop();
    this._left = p.getLeft();
    this._bottom = p.getBottom();
    return this;
  }

}