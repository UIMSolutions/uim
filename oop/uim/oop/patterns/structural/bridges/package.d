module uim.oop.patterns.bridges;

import uim.oop;
@safe:

interface IDrawAPI {
  void drawCircle(int radius, int x, int y);
}

class RedCircle : IDrawAPI {
  override void drawCircle(int radius, int x, int y) {
      writeln("Drawing Circle[ color: red, radius: ", radius, ", x: ", x, ", ", y, "]");
  }
}

class GreenCircle : IDrawAPI {
   override void drawCircle(int radius, int x, int y) {
      writeln("Drawing Circle[ color: green, radius: ", radius, ", x: ", x, ", ", y, "]");
   }
}

abstract class DShape {
  protected IDrawAPI _drawAPI;
   
  protected this(IDrawAPI drawAPI) {
    _drawAPI = drawAPI;
  }
   
  abstract void draw();	
}

class DCircle : Shape {
   private int _x, _y, _radius;

   this(int x, int y, int radius, IDrawAPI drawAPI) {
      super(drawAPI);
      _x = x;  
      _y = y;  
      _radius = radius;
   }

  override void draw() {
    _drawAPI.drawCircle(_radius, _x, _y);
  }
}

version(test_uim_oop) { unittest {
    Shape redCircle = new Circle(100,100, 10, new RedCircle());
  Shape greenCircle = new Circle(100,100, 10, new GreenCircle());

  redCircle.draw();
  greenCircle.draw();
}
}

