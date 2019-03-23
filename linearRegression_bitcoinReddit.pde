/*----------------------------------------
|    Bitcoin Price vs. Reddit Mentions    |
|      Coded by: Erik Dillaman            |
 ----------------------------------------*/

String TABLE_ONE = "bitcoinPrice.csv";
String TABLE_TWO = "parsedTable.csv";
Table price, posts;
ArrayList<Node> nodes;
float maxPrice, maxPosts = 0;
boolean leftButton, rightButton;
float xOFFSET = 30;
float xSIDE = 30;
float yOFFSET = 50;
float yTOP = 50;
int NODE_SIZE = 6;
float yInt, slope, rSquared;

void setup()
{  
  pixelDensity(2);
  surface.setSize(1000, 700);
  price = loadTable(TABLE_ONE);
  posts = loadTable(TABLE_TWO);
  nodes = new ArrayList<Node>();
  TableRow headOneRow = price.getRow(0);
  TableRow headTwoRow = posts.getRow(0);
  String headOne = headOneRow.getString(1);
  String headTwo = headTwoRow.getString(1);

  for (int i = 1; i < price.getRowCount(); i++) {
    TableRow priceRow = price.getRow(i);
    TableRow postRow = posts.getRow(i);
    int largestTable = price.getRowCount();
    if (posts.getRowCount() > largestTable) largestTable = posts.getRowCount();
    if (priceRow.getFloat(1) > maxPrice) maxPrice = priceRow.getFloat(1);
    if (postRow.getFloat(1) > maxPosts) maxPosts = postRow.getFloat(1);
    Node node = new Node(priceRow.getString(0), headOne, headTwo, priceRow.getFloat(1), postRow.getFloat(1), xOFFSET, xSIDE, yOFFSET, yTOP, NODE_SIZE, largestTable);
    nodes.add(node);
  }

  int i = 0;
  for (Node node : nodes) {
    node.setPostY(maxPosts);
    node.setPriceY(maxPrice);
    node.setX(i, nodes.size());
    i++;
  }
}


void draw()
{
  background(255);
  int prevX = 0;
  int prevYPrice = 0;
  int prevYPosts = 0;
  for (Node node : nodes) {
    node.drawLine(prevX, prevYPrice, prevYPosts);
    prevYPrice = (int)node.yPrice;
    prevYPosts = (int)node.yPost;
    prevX = (int)node.x;
  }  
  for (Node node : nodes) {
    node.display();
    node.checkHover();
    node.hover();
  }
    
  if (leftButton || rightButton) {
    noStroke();
    fill(255, 255, 255, 175);
    rect(0, 0, width, height-101);
    rect(161, height-100, width-131, height-101);
    rect(30, height-95, 100, 30);
    if (leftButton){
      rect(30, height-50, 120, 30);
      stroke(#1D7918); 
    } else{ 
      rect(30, height-70, 120, 20);
      stroke(#F77A25);
    }
      
    line(xOFFSET, (slope*xOFFSET)+yInt, width-xSIDE, (slope*(width-xSIDE))+yInt);
    stroke(0);
    fill(255);
    rect(mouseX-20, mouseY-36, 220, 40);
    fill(0);
    text("R-Squared Value: "+rSquared, mouseX-10, mouseY-10);
  }
}

void mousePressed()
{
  if (mouseButton == LEFT) {
    mapRegression(1);
    leftButton = true;
  }
  if (mouseButton == RIGHT) {
    mapRegression(2);  
    rightButton = true;
  }
}

void mouseReleased()
{
  leftButton = false;
  rightButton = false;
}

void mapRegression(int graph)
{

  float sumY = 0;
  float sumXY = 0;
  float sumX2 = 0; 
  float sumX = 0;
  float sumY2 = 0;

  for (Node node : nodes) {
    if (graph == 1) sumY += node.yPost; 
    else sumY += node.yPrice;
    if (graph == 1) sumXY += node.yPost*node.x; 
    else sumXY += node.yPrice*node.x;
    if (graph == 1) sumY2+= node.yPost*node.yPost; 
    else sumY2 += node.yPrice*node.yPrice;
    sumX2 += node.x*node.x;
    sumX += node.x;
  }

  slope = ((nodes.size()*sumXY) - (sumY*sumX)) / ((nodes.size()*sumX2) - (sumX*sumX));
  yInt =  (sumY - (slope * sumX)) / nodes.size();
  float r2 = ((nodes.size()*sumXY) - (sumX*sumY)) / sqrt(((nodes.size()*sumX2)-(sumX*sumX))*((nodes.size()*sumY2)-(sumY*sumY))); 
  rSquared = r2*r2;
  
  println(slope + "      " + yInt);
  println(xOFFSET+", "+(slope*xOFFSET)+yInt+"    "+ (width-xSIDE) +", "+(slope*(width-xSIDE))+yInt);
  println("R^2 Value: "+rSquared);
}
