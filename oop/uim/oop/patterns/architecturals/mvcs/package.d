/**
Source: Wikipedia [EN]
Model–view–controller (usually known as MVC) is a software design pattern commonly used for developing user interfaces that divide the related program 
logic into three interconnected elements. This is done to separate internal representations of information from the ways information is presented to 
and accepted from the user.[2][3]

Traditionally used for desktop graphical user interfaces (GUIs), this pattern has become popular for designing web applications.
Popular programming languages have MVC frameworks that facilitate implementation of the pattern.
**/
/***********************************************************************************
*	Copyright: ©2015-2024 Ozan Nurettin Süel (sicherheitsschmiede)                   *
*	License  : Licensed under Apache 2 [https://apache.org/licenses/LICENSE-2.0.txt] *
*	Author   : Ozan Nurettin Süel (Sicherheitsschmiede)										           * 
***********************************************************************************/
module uim.oop.patterns.mvcs;

import uim.oop;
@safe:

class DRobot {
  private string _id;
  private string _name;

  this(string newId, string newName) {
    name = newName; id = newId;
  }
   
  /// Get property id
  @property string id() { return _id; }
  /// Set property id
  @property void id(string newId) { _id = newId; }
  
  /// Get property name
  @property string name() { return _name; }
  /// Set property name
  @property void name(string newName) { _name = newName; }
}

class DRobotView {
  void printRobotDetails(string robotName, string robotId) {
    writeln("Robot: ");
    writeln("Name: ", robotName);
    writeln("Roll Id: ", robotId);
  }
}

class DRobotController {
  private DRobot _model;
  private DRobotView _view;

  this(DRobot newModel, DRobotView newView) {
    _model = newModel;
    _view = newView;
  }

  void robotName(string name) { _model.name(name); }
  string robotName() { return _model.name; }

  void robotId(string id) { _model.id(id); }
  string robotId() { return _model.id; }

  void updateView() {				
    _view.printRobotDetails(_model.name, _model.id);
  }	
}

DRobot retriveRobotFromDatabase() {
  return new DRobot("10", "Robert");
}

version(test_uim_oop) { unittest {
    writeln("MVCPatternDemo");
  //fetch Robot record based on his roll no from the database
  auto model  = retriveRobotFromDatabase();

  //Create a view : to write Robot details on console
  RobotView view = new DRobotView();
  RobotController controller = new DRobotController(model, view);

  controller.updateView();

  //update model data
  controller.robotName("John");
  
  controller.updateView();
}}
