class Node
{
  boolean priceHover, postHover; 
  float xOFFSET, xSIDE, yOFFSET, yTOP;
  int NODE_SIZE, xSize;
  String date, headingOne, headingTwo;
  float price, post, x, yPrice, yPost;
  PFont font, font2;


  Node(String date, String headingOne, String headingTwo, float price, float post, float xOFFSET, float xSIDE, float yOFFSET, float yTOP, int NODE_SIZE, int xSize) {
    this.date = date;
    this.price = price;
    this.post = post;    
    this.headingOne = headingOne;
    this.headingTwo = headingTwo;
    this.xSize = xSize;
    font = createFont("GillSansMT.TTF", 16);
    font2 = createFont("GillSansMT.TTF", 20);
    this.xOFFSET = xOFFSET;
    this.xSIDE = xSIDE;
    this.yOFFSET = yOFFSET;
    this.yTOP = yTOP;
    this.NODE_SIZE = NODE_SIZE;
  }

  void setX(float xData, int size) {
    x = map(xData, 0, size, xOFFSET, width-xSIDE);
  }

  void setPriceY(float max) {
    yPrice = map(price, max, 140, yTOP, height-yOFFSET);
  }

  void setPostY(float max) {
    yPost = map(post, max, 0, yTOP, height-yOFFSET);
  }

  void checkHover() {
    float period = width-xOFFSET-xSIDE;
    period /= xSize;
    if (mouseX > x-period+1 && mouseX < x+period-1) {
      priceHover = true;
    } else {
      priceHover = false;
    }
  }

  void display() {

    noStroke();
    fill(#F77A25);
    ellipseMode(CENTER);
    ellipse(x, yPrice, NODE_SIZE, NODE_SIZE);
//    fill(#1D7918);
    fill(#46F05B);
    ellipse(x, yPost, NODE_SIZE, NODE_SIZE);
  }

  void drawLine(int prevX, int prevYPrice, int prevYPosts) {
    if (prevX != 0 || prevYPrice != 0 || prevYPosts != 0) {
      stroke(#F0BE9D);
      strokeWeight(1);
      line(prevX, prevYPrice, x, yPrice);  
      stroke(#B9E3A5);
      line(prevX, prevYPosts, x, yPost);
    }
  }

  void hover() {
    if (priceHover) {

      stroke(180);
      line(xOFFSET, yOFFSET, xOFFSET, height-yTOP);
      line(xOFFSET, height-yTOP, width-xSIDE, height-yTOP);      

      stroke(190);
      fill(0);
      line(x, height-yOFFSET, x, yTOP);
      fill(255);
      rect(xOFFSET-10, height-100, 140, 80); 
      fill(0);
      textFont(font2);      
      text(date, xOFFSET+10, height-75);
      textFont(font);      
      fill(#1D7918);
      text(headingTwo+" : "+post, xOFFSET, height-50);
      fill(#F77A25);      
      text(headingOne+" : "+price, xOFFSET, height-30);
    }
  }
}
