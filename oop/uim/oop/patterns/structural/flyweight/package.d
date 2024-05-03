/*********************************************************************************************************
*  Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                       *
*  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. *
*  Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                     *
*********************************************************************************************************/
module uim.oop.patterns.structural.flyweight;

import uim.oop;
@safe:

/// Create an interface.
interface IShape {
  void draw();
}

/// Create concrete class implementing the same interface.
class DCircle : IShape {
  private string _color;
  private int _x;
  private int _y;
  private int _radius;

  this(string color) {
    _color = color;		
  }

  void x(int x) {
    _x = x;
  }

  void y(int y) {
    _y = y;
  }

  void radius(int radius) {
    _radius = radius;
  }

  override void draw() {
    writeln("Circle: Draw() [Color : "~_color~", x : "~to!string(_x)~", y :"~to!string(_y)~", radius :"~to!string(_radius));
  }
}

/// Create a factory to generate object of concrete class based on given information.
class DShapeFactory {
  private static IShape[string] circleMap;

  static IShape getCircle(string color) {
    DCircle circle = cast(DCircle)circleMap.get(color, null);

    if (circle.isNull) {
        circle = new DCircle(color);
        circleMap[color] = circle;
        writeln("Creating circle of color : "~color);
    }
    return circle;
  }
}

bool isNull(DCircle aShape) {
  return aShape is null;
}
/// Use the factory to get object of concrete class by passing an information such as color.
private static string[] colors = ["Red", "Green", "Blue", "White", "Black"];
private static string getRandomColor() {
  return colors[to!int(uniform(0, colors.length))];
}
private static int getRandomX() {
  return to!int(uniform(0, 100));
}
private static int getRandomY() {
  return to!int(uniform(0, 100));
}
version(test_uim_oop) { unittest {
    writeln("FlyweightPatternDemo");

    for(auto i=0; i < 20; i++) {
        DCircle circle = cast(DCircle)DShapeFactory.getCircle(getRandomColor());
        circle.x(getRandomX());
        circle.y(getRandomY());
        circle.radius(100);
        circle.draw();
    }
  }
}