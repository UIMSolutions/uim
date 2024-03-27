/*********************************************************************************************************
  Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.oop.patterns.structural.facade;

import uim.oop;
@safe:

/// Create an interface.
 interface Shape {
   void draw();
}

/// Create concrete classes implementing the same interface.
 class Rectangle : Shape {

   override  void draw() {
      writeln("Rectangle::draw()");
   }
}

 class DSquare : Shape {

   override  void draw() {
      writeln("Square::draw()");
   }
}

 class DCircle : Shape {

   override  void draw() {
      writeln("Circle::draw()");
   }
}

/// Create a facade class.
 class DShapeMaker {
   private Shape circle;
   private Shape rectangle;
   private Shape square;

    this() {
      circle = new Circle();
      rectangle = new Rectangle();
      square = new Square();
   }

    void drawCircle() {
      circle.draw();
   }
    void drawRectangle() {
      rectangle.draw();
   }
    void drawSquare() {
      square.draw();
   }
}
/// Use the facade to draw various types of shapes.
version(test_uim_oop) { unittest {
    writeln("FacadePatternDemo");
    
    ShapeMaker shapeMaker = new ShapeMaker();

      shapeMaker.drawCircle();
      shapeMaker.drawRectangle();
      shapeMaker.drawSquare();		
   }
}