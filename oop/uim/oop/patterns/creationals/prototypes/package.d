/***********************************************************************************
*	Copyright: ©2015-2024 Ozan Nurettin Süel (sicherheitsschmiede)                   *
*	License  : Licensed under Apache 2 [https://apache.org/licenses/LICENSE-2.0.txt] *
*	Author   : Ozan Nurettin Süel (Sicherheitsschmiede)										           * 
***********************************************************************************/
module uim.oop.patterns.creational.prototypes;

import uim.oop;
@safe:

interface ICloneable {}

/// Create an abstract class implementing Clonable interface.  
 abstract class DShape : ICloneable {
   
  private string id;
  protected string type;
  
  abstract void draw();
  
  string getType() {
    return type;
  }
  
  string getId() {
    return id;
  }
  
  void setId(string id) {
    this.id = id;
  }
  
  Object clone() {
    Object clone = null;
    
    try {
        clone = this;         
    } catch (Exception e) {
        debug writeln(e); }
    
    return clone;
  }
}

/// Create concrete classes extending the above class.
class DRectangle : Shape {

  this() {
    type = "Rectangle";
  }

  override  void draw() {
    writeln("Inside Rectangle::draw() method.");
  }
}

class DSquare : Shape {
  this() {
    type = "Square";
  }

  override  void draw() {
    writeln("Inside Square::draw() method.");
  }
}

class DCircle : Shape {

  this() {
    type = "Circle";
  }

  override  void draw() {
    writeln("Inside Circle::draw() method.");
  }
}

///Create a class to get concrete classes from database and store them in a Hashtable.
class DShapeCache {
  private static Shape[string] shapeMap;

  static Shape getShape(string shapeId) {
    Shape cachedShape = shapeMap.get(shapeId, null);
    return cast(Shape)cachedShape.clone();
  }

  // for each shape run database query and create shape
  // shapeMap.put(shapeKey, shape);
  // for example, we are adding three shapes
  
  static void loadCache() {
    Circle circle = new DCircle();
    circle.setId("1");
    shapeMap[circle.getId()] = circle;

    Square square = new Square();
    square.setId("2");
    shapeMap[square.getId()] = square;

    Rectangle rectangle = new Rectangle();
    rectangle.setId("3");
    shapeMap[rectangle.getId()] = rectangle;
  }
}

/// PrototypePatternDemo uses ShapeCache class to get clones of shapes stored in a Hashtable.
version(test_uim_oop) { unittest {
  debug writeln("PrototypePatternDemo");
  ShapeCache.loadCache();

  Shape clonedShape = cast(Shape) ShapeCache.getShape("1");
  writeln("Shape : ", clonedShape.getType());		

  Shape clonedShape2 = cast(Shape) ShapeCache.getShape("2");
  writeln("Shape : ", clonedShape2.getType());		

  Shape clonedShape3 = cast(Shape) ShapeCache.getShape("3");
  writeln("Shape : ", clonedShape3.getType());		
}}