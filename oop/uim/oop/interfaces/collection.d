/*********************************************************************************************************
	Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.oop.interfaces.collection;

import uim.oop;

@safe:
interface ICollection2(T) { // : IIterable!T {
  // Ensures that this collection contains the specified element (optional operation).
  bool add(T newItem);

  // Adds all of the elements in the specified collection to this collection (optional operation).
  bool addAll(ICollection2!T aCollection);

  // Removes all of the elements from this collection (optional operation).
  void	clear();

  // Returns true if this collection contains the specified element.
  bool contains(T anItem);

  // Returns true if this collection contains all of the elements in the specified collection.
  bool containsAll(ICollection2!T aCollection);

  // Returns the hash code value for this collection.
  int	hashCode();

  // Returns true if this collection contains no elements.
  bool isEmpty();

  // Returns an iterator over the elements in this collection.
  // Iterator<E>	iterator();

  // Removes a single instance of the specified element from this collection, if it is present (optional operation).
  bool remove(T anItem);

  // Removes all of this collection's elements that are also contained in the specified collection (optional operation).
  bool removeAll(ICollection2!T aCollection);

  // Returns the number of elements in this collection.
  size_t	size();

  // Returns an array containing all of the elements in this collection.
  T[] toArray();
} 