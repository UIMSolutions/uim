/*********************************************************************************************************
*  Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                       *
*  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. *
*  Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                     *
*********************************************************************************************************/
module uim.oop.patterns.creational.builders;

import uim.oop;
@safe:

interface IItem {
  string name();
  IPacking packing();
  float price();	
}

interface IPacking {
  string pack();
}

class DWrapper : IPacking {
  override string pack() {
    return "Wrapper";
  }
}

class DBottle : IPacking {
  override string pack() {
    return "Bottle";
  }
}

abstract class DBurger : IItem {
   override IPacking packing() {
      return new Wrapper();
   }

   override abstract float price();
}

 abstract class DColdDrink : IItem {
	override IPacking packing() {
    return new DBottle();
	}

	override abstract float price();
}

 class DVegBurger : DBurger {
  override float price() {
    return 25.0f;
  }

  override string name() {
    return "Veg Burger";
  }
}

class DChickenBurger : DBurger {
  override float price() {
    return 50.5f;
  }

  override string name() {
    return "Chicken Burger";
  }
}

class DCoke : DColdDrink {
  override float price() {
    return 30.0f;
  }

  override string name() {
    return "Coke";
  }
}

 class DPepsi : DColdDrink {

   override  float price() {
      return 35.0f;
   }

   override  string name() {
      return "Pepsi";
   }
}

 class DMeal {
  private IItem[] items;	

  void addItem(IItem item) {
    items ~= item;
  }

  float getCost() {
    return items
      .map!(i=> i.price())
      .sum;
  }

  void showItems() {
    items.each!((item) { 
        std.stdio.write("Item : ", item.name());
        std.stdio.write(", Packing : ", item.packing().pack());
        writeln(", Price : ", item.price());
    });		
  }	
}

class DMealBuilder {
  DMeal prepareVegMeal () {
    DMeal meal = new DMeal();
    meal.addItem(new VegBurger());
    meal.addItem(new DCoke());
    return meal;
  }   

  DMeal prepareNonVegMeal () {
    DMeal meal = new DMeal();
    meal.addItem(new DChickenBurger());
    meal.addItem(new DPepsi());
    return meal;
  }
}

version(test_uim_oop) { unittest {
    DMealBuilder mealBuilder = new DMealBuilder();

  DMeal vegMeal = mealBuilder.prepareVegMeal();
  writeln("Veg Meal");
  vegMeal.showItems();
  writeln("Total Cost: ", vegMeal.getCost());

  DMeal nonVegMeal = mealBuilder.prepareNonVegMeal();
  writeln("\n\nNon-Veg Meal");
  nonVegMeal.showItems();
  writeln("Total Cost: ",  nonVegMeal.getCost());
}}