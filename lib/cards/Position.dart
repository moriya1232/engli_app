
class Position {
  double left;
  double top;
  double right;
  double bottom;

  Position(double left, double top, double right, double bottom) {
    this.left = left;
    this.right = right;
    this.top = top;
    this.bottom = bottom;
  }

  double getLeft(){
    return this.left;
  }

  double getTop(){
    return this.top;
  }

  double getBottom(){
    return this.bottom;
  }

  double getRight(){
    return this.right;
  }

  void setPositionTopLeft(double left, double top) {
    this.left = left;
    this.top = top;
    this.right = null;
    this.bottom = null;
  }


  void setPositionTopRight(double right, double top) {
    this.left = null;
    this.top = top;
    this.right = right;
    this.bottom = null;
  }


  void setPositionBottomLeft(double left, double bottom) {
    this.left = left;
    this.top = null;
    this.right = null;
    this.bottom = bottom;
  }

  Position setPosition(Position p) {
    this.right = p.getRight();
    this.top = p.getTop();
    this.left = p.getLeft();
    this.bottom = p.getBottom();
    return this;
  }

}