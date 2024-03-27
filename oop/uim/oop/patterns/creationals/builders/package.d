/*********************************************************************************************************
*  Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                       *
*  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. *
*  Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                     *
*********************************************************************************************************/
module uim.oop.patterns.creational.builders;

import uim.oop;
@safe:

interface Item {
  string name();
  Packing packing();
  float price();	
}

interface Packing {
  string pack();
}

class DWrapper : Packing {
  override string pack() {
    return "Wrapper";
  }
}

class DBottle : Packing {
  override string pack() {
    return "Bottle";
  }
}

abstract class DBurger : Item {
   override Packing packing() {
      return new Wrapper();
   }

   override abstract float price();
}

 abstract class DColdDrink : Item {
	override Packing packing() {
    return new Bottle();
	}

	override abstract float price();
}

 class DVegBurger : Burger {
  override float price() {
    return 25.0f;
  }

  override string name() {
    return "Veg Burger";
  }
}

class DChickenBurger : Burger {
  override float price() {
    return 50.5f;
  }

  override string name() {
    return "Chicken Burger";
  }
}

class DCoke : ColdDrink {
  override float price() {
    return 30.0f;
  }

  override string name() {
    return "Coke";
  }
}

 class Pepsi : ColdDrink {

   override  float price() {
      return 35.0f;
   }

   override  string name() {
      return "Pepsi";
   }
}

 class Meal {
  private Item[] items;	

  void addItem(Item item) {
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

class MealBuilder {
  Meal prepareVegMeal () {
    Meal meal = new Meal();
    meal.addItem(new VegBurger());
    meal.addItem(new Coke());
    return meal;
  }   

  Meal prepareNonVegMeal () {
    Meal meal = new Meal();
    meal.addItem(new ChickenBurger());
    meal.addItem(new Pepsi());
    return meal;
  }
}

version(test_uim_oop) { unittest {
    MealBuilder mealBuilder = new MealBuilder();

  Meal vegMeal = mealBuilder.prepareVegMeal();
  writeln("Veg Meal");
  vegMeal.showItems();
  writeln("Total Cost: ", vegMeal.getCost());

  Meal nonVegMeal = mealBuilder.prepareNonVegMeal();
  writeln("\n\nNon-Veg Meal");
  nonVegMeal.showItems();
  writeln("Total Cost: ",  nonVegMeal.getCost());
}}