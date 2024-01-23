/*********************************************************************************************************
*  Copyright: © 2015 - 2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                       *
*  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. *
*  Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                     *
*********************************************************************************************************/
module uim.oop.patterns.structural.decoraters;

import uim.oop;
@safe:

/// Create an interface.
 interface Shape {
   void draw();
}

/// Create concrete classes implementing the same interface.
 class Rectangle : Shape {
   override  void draw() {
      writeln("Shape: Rectangle");
   }
}

 class Circle : Shape {

   override  void draw() {
      writeln("Shape: Circle");
   }
}

/// Create abstract decorator class implementing the Shape interface.
 abstract class ShapeDecorator : Shape {
   protected Shape decoratedShape;

    this(Shape decoratedShape) {
      this.decoratedShape = decoratedShape;
   }

    void draw() {
      decoratedShape.draw();
   }	
}

/// Create concrete decorator class extending the ShapeDecorator class.
 class RedShapeDecorator : ShapeDecorator {

    this(Shape decoratedShape) {
      super(decoratedShape);		
   }

   override void draw() {
      decoratedShape.draw();	       
      setRedBorder(decoratedShape);
   }

   private void setRedBorder(Shape decoratedShape) {
      writeln("Border Color: Red");
   }
}

/// Use the RedShapeDecorator to decorate Shape objects.
version(test_uim_oop) { unittest {
    writeln("DecoratorPatternDemo");
      Shape circle = new Circle();

      Shape redCircle = new RedShapeDecorator(new Circle());

      Shape redRectangle = new RedShapeDecorator(new Rectangle());
      writeln("Circle with normal border");
      circle.draw();

      writeln("\nCircle of red border");
      redCircle.draw();

      writeln("\nRectangle of red border");
      redRectangle.draw();
   }
}