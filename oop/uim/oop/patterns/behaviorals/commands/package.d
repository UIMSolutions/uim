/***********************************************************************************
*	Copyright: © 2015-2024 Ozan Nurettin Süel (sicherheitsschmiede)                   *
*	License  : Licensed under Apache 2 [https://apache.org/licenses/LICENSE-2.0.txt] *
*	Author   : Ozan Nurettin Süel (Sicherheitsschmiede)										           * 
***********************************************************************************/
module uim.oop.patterns.behavioral.commands;

import uim.oop;
@safe:

/// Create a command interface.
interface IOrder {
   void execute();
}

/// Create a request class.
class DStock {
  private string name = "ABC";
  private int quantity = 10;

  void buy() {
    writeln("Stock [ Name: %s, Quantity: %s ] bought".format(name, quantity));
  }
  void sell() {
    writeln("Stock [ Name: %s, Quantity: %s ] sold".format(name, quantity));
  }
}

/// Create concrete classes implementing the IOrder interface.
class DBuyStock : IOrder {
  protected DStock _abcStock;

  this(DStock abcStock) {
    _abcStock = abcStock;
  }

  void execute() {
    _abcStock.buy();
  }
}

class DSellStock : IOrder {
  protected DStock _abcStock;

  this(DStock abcStock) {
    _abcStock = abcStock;
  }

  void execute() {
    _abcStock.sell();
  }
}

/// Create command invoker class.
class DBroker {
  private IOrder[] _orderList; 

  void takeOrder(IOrder order) {
    _orderList ~= order;		
  }

  void placeOrders() {
    _orderList.each!(order => order.execute());
    _orderList = null;
  }
}

/// Use the Broker class to take and execute commands.
version(test_uim_oop) { unittest {
    writeln("CommandPatternDemo");
    
    DStock abcStock = new DStock();

    DBuyStock buyStockOrder = new DBuyStock(abcStock);
    DSellStock sellStockOrder = new DSellStock(abcStock);

    DBroker broker = new DBroker();
    broker.takeOrder(buyStockOrder);
    broker.takeOrder(sellStockOrder);

    broker.placeOrders();
  }
}
