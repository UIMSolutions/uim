module uim.oop.patterns.structural.decoraters.version2;

import uim.oop;
@safe:

interface ICoffee {
    float cost();
    string ingredients();
}

class DSimpleCoffee : ICoffee {
  float cost() {
    return 1.0; }

  string ingredients() {
    return "Coffee"; }
}

abstract class DCoffeeDecorator : ICoffee {
  private ICoffee decorated_coffee;

  this(ICoffee d) {
    decorated_coffee = d; }

  float cost() {
    return decorated_coffee.cost; }

  string ingredients() {
    return decorated_coffee.ingredients;}
}

class DWithMilk : DCoffeeDecorator {
  this(ICoffee d) {
    super(d); }

  override float cost() {
    return super.cost + 0.5; }

  override string ingredients() {
    return super.ingredients ~ ", Milk"; }
}

class DWithSprinkles : DCoffeeDecorator {
  this(ICoffee d) {
    super(d); }

  override float cost() {
    return super.cost + 0.2; }

  override string ingredients() {
    return super.ingredients ~ ", Sprinkles"; }
}

void print(ICoffee coffee) {
    writefln("Cost: %1.1f; Ingredients: %s", coffee.cost, coffee.ingredients);
}

version(test_uim_oop) { unittest {
    ICoffee coffee = new DSimpleCoffee;
    print(ICoffee);

    coffee = new DWithMilk(coffee);
    print(ICoffee);

    coffee = new DWithSprinkles(coffee);
    print(ICoffee);
  }}
