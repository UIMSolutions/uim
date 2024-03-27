/***********************************************************************************
*	Copyright: ©2015-2024 Ozan Nurettin Süel (sicherheitsschmiede)                   *
*	License  : Licensed under Apache 2 [https://apache.org/licenses/LICENSE-2.0.txt] *
*	Author   : Ozan Nurettin Süel (Sicherheitsschmiede)										           * 
***********************************************************************************/
module uim.oop.patterns.creational.abstractfactory;

import uim.oop;
@safe:

/// Shape interface.
interface IShape {
   void draw();
}

/// Class for Rectangle Shape
class Rectangle : IShape {
   override void draw() {
      writeln("Inside Rectangle::draw() method.");
   }
}

/// Class for Square Shape
class Square : IShape {
  override void draw() {
    writeln("Inside Square::draw() method.");
  }
}

/// Class for Circle Shape
class DCircle : IShape {
  override void draw() {
    writeln("Inside Circle::draw() method.");
  }
}


/// Create a Factory to generate object of concrete class based on given information.
class ShapeFactory {	
   //use createShape method to get object of type shape 
   IShape createShape(string shapeType) {
      if(shapeType == null) {
         return null;
      }		
      if(shapeType.toLower == "CIRCLE".toLower) {
         return new Circle();
         
      } else if(shapeType.toLower == "RECTANGLE".toLower) {
         return new Rectangle();
         
      } else if(shapeType.toLower == "SQUARE".toLower) {
         return new Square();
      }
      
      return null;
   }
}

/// Use the Factory to get object of concrete class by passing an information such as type.
version(test_uim_oop) { unittest {
     writeln("\nFactoryPatternDemo");

  ShapeFactory shapeFactory = new ShapeFactory();

  //get an object of Circle and call its draw method.
  IShape shape = shapeFactory.createShape("CIRCLE");

  //call draw method of Circle
  if (shape) shape.draw();

  //get an object of Rectangle and call its draw method.
  shape = shapeFactory.createShape("RECTANGLE");

  // call draw method of Rectangle
  if (shape) shape.draw();

  // get an object of Square and call its draw method.
  shape = shapeFactory.createShape("SQUARE");

  // call draw method of square if exists
  if (shape) shape.draw();
}}
