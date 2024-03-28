/***********************************************************************************
*	Copyright: ©2015-2024 Ozan Nurettin Süel (sicherheitsschmiede)                   *
*	License  : Licensed under Apache 2 [https://apache.org/licenses/LICENSE-2.0.txt] *
*	Author   : Ozan Nurettin Süel (Sicherheitsschmiede)										           * 
***********************************************************************************/
module uim.oop.patterns.creationals.abstractfactories.version2;

public interface PizzaIngredientFactory {
	public Dough createDough();
	public Sauce createSauce();
	public Cheese createCheese();
	public Clam createClam();
}

public class NYPizzaIngredientFactory : PizzaIngredientFactory {
	public Dough createDough() {
		return new DThinDough();
	}

	public Sauce createSauce() {
		return new MarinaraSauce();
	}

	public Cheese createCheese() {
		return new DReggianoCheese(); }

	public Clam createClam() {
		return new DFreshClam(); }
}

public class DChicagoPizzaIngredientFactory : PizzaIngredientFactory {
	public Dough createDough() {
		return new DThickDough(); }
	
	public Sauce createSauce() {
		return new DTomateSauce(); }
	
	public Cheese createCheese() {
		return new MozzarellaCheese(); }
	
	public Clam createClam() {
		return new DFreezeClam(); }
}

import std.stdio;

// прародитель всех пицц
public abstract class Pizza
{
protected:
	string name;
	Dough dough;
	Sauce sauce;
	Cheese cheese;
	Clam clam;

public:
	abstract void prepare();

	// выпекание пиццы
	void bake()
	{
		writeln("Bake for 25 minutes at 350 degrees");
	}
	
	
	// нарезание пиццы
	void cut()
	{
		writeln("Cutting the pizza into diagonal slices");
	}
	
	
	// упаковка пиццы
	void box()
	{
		writeln("Place pizza in official PizzaStore Box");
	}
	
	
	// получить название пиццы
	string getName()
	{
		return name;
	}

	void setName(string name)
	{
		this.name = name;
	}
}

// пицца с сыром
public class DCheesePizza : Pizza
{
protected:
	PizzaIngredientFactory ingredientFactory;

public:
	this(PizzaIngredientFactory ingredientFactory)
	{
		this.ingredientFactory = ingredientFactory;
	}

	override void prepare()
	{
		writeln("Preparing " ~ name);
		dough = ingredientFactory.createDough();
		sauce = ingredientFactory.createSauce();
		cheese = ingredientFactory.createCheese();
		clam = ingredientFactory.createClam();
	}
}

// пицца с мидиями
public class DClamPizza : Pizza
{
protected:
	PizzaIngredientFactory ingredientFactory;
	
public:
	this(PizzaIngredientFactory ingredientFactory)
	{
		this.ingredientFactory = ingredientFactory;
	}
	
	override void prepare()
	{
		writeln("Preparing " ~ name);
		dough = ingredientFactory.createDough();
		sauce = ingredientFactory.createSauce();
		cheese = ingredientFactory.createCheese();
		clam = ingredientFactory.createClam();
	}
}


// общий класс для различных видов пиццерий
public abstract class PizzaStore
{
	// рецепт приготовления пиццы прописан тут
	public Pizza orderPizza(string type)
	{
		Pizza pizza;
		
		pizza = createPizza(type);
		
		pizza.prepare();
		pizza.bake();
		pizza.cut();
		pizza.box();
		
		return pizza;
	}

	protected abstract Pizza createPizza(string type);
}

// нью-йоркская пиццерия
public class NYPizzaStore : PizzaStore
{
	override protected Pizza createPizza(string item)
	{
		Pizza pizza = null;
		PizzaIngredientFactory ingredientFactory = new NYPizzaIngredientFactory(); 

		switch(item)
		{
			case "cheese":
				pizza = new DCheesePizza(ingredientFactory);
				pizza.setName("NY Style Cheese Pizza");
				break;
			case "clam":
				pizza = new DClamPizza(ingredientFactory);
				pizza.setName("NY Style Clam Pizza");
				break;
			default:
				pizza = null;
				break;
		}
		return pizza;
	}
}


// чикагская пиццерия
public class DChicagoPizzaStore : PizzaStore
{
	override protected Pizza createPizza(string item)
	{
		Pizza pizza = null;
		PizzaIngredientFactory ingredientFactory = new DChicagoPizzaIngredientFactory(); 

		switch(item)
		{
			case "cheese":
				pizza = new DCheesePizza(ingredientFactory);
				pizza.setName("Chicago Style Cheese Pizza");
				break;
			case "clam":
				pizza = new DClamPizza(ingredientFactory);
				pizza.setName("Chicago Style Clam Pizza");
				break;
			default:
				pizza = null;
				break;
		}
		return pizza;
	}
}

// тип основы
interface Dough
{

}

// тонкая основа
class DThinDough : Dough
{

	this()
	{
		writeln("  ---> Thin Dough");
	}
}

// толстая основа
class DThickDough : Dough
{
	
	this()
	{
		writeln("  ---> Thick Dough");
	}
}


// тип соуса
interface Sauce
{

}

// соус маринара
class MarinaraSauce : Sauce
{
	
	this()
	{
		writeln("  ---> Marinara Sauce");
	}
}

// томатный соус
class DTomateSauce : Sauce
{
	
	this()
	{
		writeln("  ---> Tomate Sauce");
	}
}

// тип сыра
interface Cheese
{

}

// сыр реджано
class DReggianoCheese : Cheese
{
	
	this()
	{
		writeln("  ---> Reggiano Cheese");
	}
}

// сыр моццарелла
class MozzarellaCheese : Cheese
{
	
	this()
	{
		writeln("  ---> Mozzarella Cheese");
	}
}

// тип мидий (!)
interface Clam
{

}

// мидии - свежие
class FreshClam : Clam
{
	
	this()
	{
		writeln("  ---> Fresh Clam");
	}
}


// мидии в консервах
class FreezeClam : Clam
{
	
	this()
	{
		writeln("  ---> Freeze Clam");
	}
}

version(test_uim_oop) { unittest {	
    writeln("--- DAbstract Factory test ---");
    PizzaStore nyStore = new NYPizzaStore();
    PizzaStore chicagoStore = new DChicagoPizzaStore();

    Pizza pizza = nyStore.orderPizza("cheese");
    writeln();
    pizza = chicagoStore.orderPizza("cheese");
    writeln();
    pizza = nyStore.orderPizza("clam");
    }}