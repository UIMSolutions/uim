/***********************************************************************************
*	Copyright: ©2015-2024 Ozan Nurettin Süel (sicherheitsschmiede)                   *
*	License  : Licensed under Apache 2 [https://apache.org/licenses/LICENSE-2.0.txt] *
*	Author   : Ozan Nurettin Süel (Sicherheitsschmiede)										           * 
***********************************************************************************/
module uim.oop.patterns.behavioral.commands;

import uim.oop;
@safe:

/// Create a command interface.
interface Order {
   void execute();
}

/// Create a request class.
class Stock {
  private string name = "ABC";
  private int quantity = 10;

  void buy() {
    writeln("Stock [ Name: %s, Quantity: %s ] bought".format(name, quantity));
  }
  void sell() {
    writeln("Stock [ Name: %s, Quantity: %s ] sold".format(name, quantity));
  }
}

/// Create concrete classes implementing the Order interface.
class BuyStock : Order {
  private Stock _abcStock;

  this(Stock abcStock) {
    _abcStock = abcStock;
  }

  void execute() {
    _abcStock.buy();
  }
}

class SellStock : Order {
  private Stock _abcStock;

  this(Stock abcStock) {
    _abcStock = abcStock;
  }

  void execute() {
    _abcStock.sell();
  }
}

/// Create command invoker class.
class Broker {
  private Order[] _orderList; 

  void takeOrder(Order order) {
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
    
    Stock abcStock = new Stock();

    BuyStock buyStockOrder = new BuyStock(abcStock);
    SellStock sellStockOrder = new SellStock(abcStock);

    Broker broker = new Broker();
    broker.takeOrder(buyStockOrder);
    broker.takeOrder(sellStockOrder);

    broker.placeOrders();
  }
}
