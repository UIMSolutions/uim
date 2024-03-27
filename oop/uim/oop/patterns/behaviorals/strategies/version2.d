/***********************************************************************************
*	Copyright: ©2015-2024 Ozan Nurettin Süel (sicherheitsschmiede)                   *
*	License  : Licensed under Apache 2 [https://apache.org/licenses/LICENSE-2.0.txt] *
*	Author   : Ozan Nurettin Süel (Sicherheitsschmiede)										           * 
***********************************************************************************/
module uim.oop.patterns.behaviorals.strategies.version2;

import uim.oop;
@safe:

interface Strategy {
public:
    void execute();
}

class FirstStrategy : Strategy {
protected:
    string strategyName = "First strategy";
public:
    void execute() {
        writeln(strategyName, " executes"); }
}

class DSecondStrategy : Strategy {
protected:
    string strategyName = "Second strategy";
public:
    void execute() {
        writeln(strategyName, " executes differently"); }
}

version(test_uim_oop) { unittest {
    FirstStrategy first = new FirstStrategy();
    SecondStrategy second = new DSecondStrategy();

    first.execute();
    second.execute();
  }}