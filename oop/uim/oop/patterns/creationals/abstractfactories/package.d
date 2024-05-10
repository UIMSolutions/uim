/***********************************************************************************
*	Copyright: © 2015-2024 Ozan Nurettin Süel (sicherheitsschmiede)                   *
*	License  : Licensed under Apache 2 [https://apache.org/licenses/LICENSE-2.0.txt] *
*	Author   : Ozan Nurettin Süel (Sicherheitsschmiede)										           * 
***********************************************************************************/
module uim.oop.patterns.creational.factory;

import uim.oop;
@safe:

/// Shape interface.
interface IShape {
   void draw();
}

/// Class for Rectangle Shape
class DRectangle : IShape {
   override void draw() {
      writeln("Inside Rectangle::draw() method.");
   }
}

/// Class for Square Shape
class DSquare : IShape {
  override void draw() {
    writeln("Inside Square::draw() method.");
  }
}

/// Class for RoundedRectangle Shape
class DRoundedRectangle : IShape {
   override void draw() {
      writeln("Inside RoundedRectangle::draw() method.");
   }
}

/// Class for RoundedSquare Shape
class DRoundedSquare : IShape {
  override void draw() {
    writeln("Inside RoundedSquare::draw() method.");
  }
}

/// Create an DAbstract class to get factories for Normal and Rounded Shape Objects.
abstract class DAbstractFactory {
   abstract IShape createShape(string shapeType) ;
}

/// Create a Factory to generate object of concrete class based on given information.
class DShapeFactory : DAbstractFactory {	
   //use createShape method to get object of type shape 
   override IShape createShape(string shapeType) {
      switch(shapeType.lower) {
         case "rectangle": return new DRectangle();
         case "square": return new DSquare();
         default: return null;
      }
   }
}

class DRoundedShapeFactory : DAbstractFactory {	
   //use createShape method to get object of type shape 
   override IShape createShape(string shapeType) {
      switch(shapeType.lower) {
         case "rectangle": return new DRoundedRectangle();
         case "square": return new DRoundedSquare();
         default: return null;
      }
   }
}

/// Create a Factory generator/producer class to get factories by passing an information such as Shape
 class FactoryProducer {
    static DAbstractFactory factory(bool rounded) {   
      if(rounded) {
         return new DRoundedShapeFactory();         
      }else{
         return new DShapeFactory();
      }
   }
}

/// Use the Factory to get object of concrete class by passing an information such as type.
version(test_uim_oop) { unittest {
  writeln("\nAbstractFactory Pattern Demo");

  //get shape factory
  DAbstractFactory shapeFactory = FactoryProducer.factory(false);

  //get an object of Circle and call its draw method.
  IShape shape = shapeFactory.createShape("RECTANGLE");

  // call draw method of Rectangle
  if (shape) shape.draw();

  // get an object of Square and call its draw method.
  shape = shapeFactory.createShape("SQUARE");

  // call draw method of square if exists
  if (shape) shape.draw();

  shapeFactory = FactoryProducer.factory(true);

  //get an object of Circle and call its draw method.
  shape = shapeFactory.createShape("RECTANGLE");

  // call draw method of Rectangle
  if (shape) shape.draw();

  // get an object of Square and call its draw method.
  shape = shapeFactory.createShape("SQUARE");

  // call draw method of square if exists
  if (shape) shape.draw();
}
}