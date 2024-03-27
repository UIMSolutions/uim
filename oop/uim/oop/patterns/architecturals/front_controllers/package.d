/***********************************************************************************
*	Copyright: ©2015-2024 Ozan Nurettin Süel (sicherheitsschmiede)                   *
*	License  : Licensed under Apache 2 [https://apache.org/licenses/LICENSE-2.0.txt] *
*	Author   : Ozan Nurettin Süel (Sicherheitsschmiede)										           * 
***********************************************************************************/
module uim.oop.patterns.front_controllers;

/**
Source: Wikipedia [EN]
The front controller software design pattern is listed in several pattern catalogs and related to the design of web applications. 
It is "a controller that handles all requests for a website", which is a useful structure for web application developers to achieve 
flexibility and reuse without code redundancy.

Source: Wikipedia [DE]
Der Begriff Front-Controller bezeichnet ein Entwurfsmuster in der Softwaretechnik. Ein Front-Controller dient als Einstiegspunkt in eine Webanwendung.

Der Front-Controller erweitert üblicherweise das Model-View-Controller-Architekturmuster. Alle Anfragen an die Webanwendung werden vom Front-Controller 
empfangen und an einen bestimmten Controller delegiert. Dafür initialisiert er den Router (meist in eine externe Komponente ausgelagert) und führt vor 
der Delegierung allgemeine Aufgaben wie die Lokalisierung durch.
**/

import uim.oop;
@safe:

/// Create Views.
class HomeView {
   void show() {
      writeln("Displaying Home Page");
   }
}

class DStudentView {
   void show() {
      writeln("Displaying DStudent Page");
   }
}

/// Create Dispatcher.
class Dispatcher {
   private DStudentView _studentView;
   private HomeView _homeView;
   
   this() {
      _studentView = new DStudentView();
      _homeView = new HomeView();
   }

   void dispatch(string request) {
      if(request.toLower == "student") {
         _studentView.show();
      }
      else{
         _homeView.show();
      }	
   }
}

/// Create FrontController
class FrontController {
   private Dispatcher _dispatcher;

   this() {
      _dispatcher = new Dispatcher();
   }

   private bool isAuthenticUser() {
      writeln("User is authenticated successfully.");
      return true; }

   private void trackRequest(string request) {
      writeln("Page requested: ", request); }

   void dispatchRequest(string request) {
      //log each request
      trackRequest(request);
      
      //authenticate the user
      if(isAuthenticUser()) _dispatcher.dispatch(request);
   }
}

/// Use the FrontController to demonstrate Front Controller Design Pattern.
version(test_uim_oop) { unittest {
   writeln("FrontControllerPatternDemo");
   
   FrontController frontController = new FrontController();
   frontController.dispatchRequest("HOME");
   frontController.dispatchRequest("STUDENT");
}}