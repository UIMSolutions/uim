/***********************************************************************************
*	Copyright: © 2015-2024 Ozan Nurettin Süel (sicherheitsschmiede)                   *
*	License  : Licensed under Apache 2 [https://apache.org/licenses/LICENSE-2.0.txt] *
*	Author   : Ozan Nurettin Süel (UIManufaktur)										           * 
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
class DRectangle : DShape {

  this() {
    type = "Rectangle";
  }

  override  void draw() {
    writeln("Inside Rectangle::draw() method.");
  }
}

class DSquare : DShape {
  this() {
    type = "Square";
  }

  override  void draw() {
    writeln("Inside Square::draw() method.");
  }
}

class DCircle : DShape {

  this() {
    type = "Circle";
  }

  override  void draw() {
    writeln("Inside Circle::draw() method.");
  }
}

///Create a class to get concrete classes from database and store them in a Hashtable.
class DShapeCache {
  private static DShape[string] _shapeMap;

  static DShape getShape(string shapeId) {
    DShape cachedShape = shapeId in _shapeMap ? _shapeMap[shapeId] : null;
    return cast(DShape)cachedShape.clone();
  }

  // for each shape run database query and create shape
  // _shapeMap.put(shapeKey, shape);
  // for example, we are adding three shapes
  
  static void loadCache() {
    DCircle circle = new DCircle();
    circle.setId("1");
    _shapeMap[circle.getId()] = circle;

    DSquare square = new DSquare();
    square.setId("2");
    _shapeMap[square.getId()] = square;

    DRectangle rectangle = new DRectangle();
    rectangle.setId("3");
    _shapeMap[rectangle.getId()] = rectangle;
  }
}

/// PrototypePatternDemo uses ShapeCache class to get clones of shapes stored in a Hashtable.
version(test_uim_oop) { unittest {
  debug writeln("PrototypePatternDemo");
  DShapeCache.loadCache();

  DShape clonedShape = cast(DShape) DShapeCache.getShape("1");
  writeln("Shape : ", clonedShape.getType());		

  DShape clonedShape2 = cast(DShape) DShapeCache.getShape("2");
  writeln("Shape : ", clonedShape2.getType());		

  DShape clonedShape3 = cast(DShape) DShapeCache.getShape("3");
  writeln("Shape : ", clonedShape3.getType());		
}}