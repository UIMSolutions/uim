module uim.oop.patterns.bridges;

import uim.oop;
@safe:

interface IDrawAPI {
  void drawCircle(int radius, int x, int y);
}

class DRedCircle : IDrawAPI {
  override void drawCircle(int radius, int x, int y) {
      writeln("Drawing Circle[color: red, radius: ", radius, ", x: ", x, ", ", y, "]");
  }
}

class DGreenCircle : IDrawAPI {
   override void drawCircle(int radius, int x, int y) {
      writeln("Drawing Circle[color: green, radius: ", radius, ", x: ", x, ", ", y, "]");
   }
}

abstract class DShape {
  protected IDrawAPI _drawAPI;
   
  protected this(IDrawAPI drawAPI) {
    _drawAPI = drawAPI;
  }
   
  abstract void draw();	
}

class DCircle : DShape {
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
    DShape redCircle = new DCircle(100,100, 10, new DRedCircle());
  DShape greenCircle = new DCircle(100,100, 10, new DGreenCircle());

  redCircle.draw();
  greenCircle.draw();
}
}

