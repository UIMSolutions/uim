/*********************************************************************************************************
  Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.oop.containers.container;

import uim.oop;
@safe:

abstract class DContainer(T) {
  this() {
    initialize;
  }

  bool initialize(Json initData = null) {
    return true;
  }

  // Ensures that this container contains the specified element.
  abstract bool add(T addItem); 
  
  // Adds all of the elements in the specified container to this container.
  abstract bool addAll(DContainer!T addItems);
  
  // Adds all of array addItems to this container.
  abstract bool addAll(T[] addItems);

  // Adds all of the elements in the specified container to this container.
  abstract bool addAll(T[] addItems...);

  // Removes all of the elements from this container */
  abstract bool clear(); 
  
  // Returns true if this container contains the specified element.
  abstract bool contains(T checkItem);
  
  // Returns true if this container contains all of the elements in the specified container.
  abstract bool containsAll(DContainer!T checkItems);
  abstract bool containsAll(T[] checkItems...);
  abstract bool containsAll(T[] checkItems);

  // Compares the specified object with this container for equality.
  // abstract bool equals(T checkItem);
  
  // Returns the hash code value for this container.
  // int	hashCode();
  
  // Returns true if this container contains no elements.*/
  abstract bool isEmpty();
  
  /* // Returns an iterator over the elements in this container.
  Iterator<E>	iterator();
  
  // Returns a possibly parallel Stream with this container as its source.
  Stream<E>	parallelStream(); */
  
  // Removes a single instance of the specified element from this container, if it is present.
  abstract bool remove(T removeItem);
  
  // Removes all of this container's elements that are also contained in the specified container.
  abstract bool removeAll(DContainer!T removeItems);
  abstract bool removeAll(T[] removeItems...);
  abstract bool removeAll(T[] removeItems);

  /*  // Removes all of the elements of this container that satisfy the given predicate.
  bool removeIf(Predicate<? super E> filter); * /
  
  // Retains only the elements in this container that are contained in the specified container.
  bool retainAll(Container!T retainItems);
  
  // Returns the number of elements in this container.*/
  abstract size_t size(); 
  
  /* // Creates a Spliterator over the elements in this container.
  Spliterator<E>	spliterator();
  
  // Returns a sequential Stream with this container as its source.
  default Stream<E>	stream(); */
  
  // Returns an array containing all of the elements in this container.
  abstract T[]	toArray(); 
}