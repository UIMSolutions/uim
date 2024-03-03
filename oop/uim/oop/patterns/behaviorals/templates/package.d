/***********************************************************************************
*	Copyright: ©2015-2024 Ozan Nurettin Süel (sicherheitsschmiede)                   *
*	License  : Licensed under Apache 2 [https://apache.org/licenses/LICENSE-2.0.txt] *
*	Author   : Ozan Nurettin Süel (Sicherheitsschmiede)										           * 
***********************************************************************************/
module uim.oop.patterns.behaviorals.templates;

import uim.oop;
@safe:

 abstract class Game {
   abstract bool initialize(/* IData[string] configSettings = null */);
   abstract void startPlay();
   abstract void endPlay();

   //template method
   final void play() {

      //initialize the game
      initialize();

      //start game
      startPlay();

      //end game
      endPlay();
   }
}

 class Cricket : Game {
   override void endPlay() {
      writeln("Cricket Game Finished!");
   }

   // Initialization hook method.
  override bool initialize(/* IData[string] configSettings = null */) {
      writeln("Cricket Game Initialized! Start playing.");
   }

   override void startPlay() {
      writeln("Cricket Game Started. Enjoy the game!");
   }
}

 class Football : Game {

   override void endPlay() {
      writeln("Football Game Finished!");
   }

   // Initialization hook method.
  override bool initialize(/* IData[string] configSettings = null */) {
      writeln("Football Game Initialized! Start playing.");
   }

   override void startPlay() {
      writeln("Football Game Started. Enjoy the game!");
   }
}

version(test_uim_models) { unittest {
      writeln("TemplatePatternDemo");

      Game game = new Cricket();
      game.play();
      writeln();
      game = new Football();
      game.play();		
   }
}