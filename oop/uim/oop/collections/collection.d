/***********************************************************************************
*	Copyright: © 2015-2024 Ozan Nurettin Süel (sicherheitsschmiede)                   *
*	License  : Licensed under Apache 2 [https://apache.org/licenses/LICENSE-2.0.txt] *
*	Author   : Ozan Nurettin Süel (Sicherheitsschmiede)										           * 
***********************************************************************************/
module uim.oop.collections.collection;

import uim.oop;

@safe:

interface ICollection {
	size_t count();
}

class DCollection(T) : ICollection, ICloneable {
	this() {
	}

	size_t count() {
		return 0;
	}

	// Ensures that this collection contains the specified element (optional operation).
	bool add(T newItem) {
		return false;
	}

	// Adds all of the elements in the specified collection to this collection (optional operation).
	bool addAll(DCollection!T someItems) {
		return false;
	}

	// Removes all of the elements from this collection (optional operation).
	void clear() {
	}

	// Returns true if this collection contains the specified element.
	bool contains(T anItem) {
		return false;
	}

	// Returns true if this collection contains all of the elements in the specified collection.
	bool containsAll(T[] someItems) {
		if (someItems.isEmpty) {
			return false;
		}

		foreach (item; someItems) {
			if (!contains(item)) {
				return false;
			}
		}

		return true;
	}

	// equals(T) - Compares the specified object with this collection for equality.
	bool equals(T anItem) {
		return false;
	}

	// Returns the hash code value for this collection.
	int hashCode() {
		return _hashCode;
	}

	// Returns true if this collection contains no elements.
	bool isEmpty() {
		return true;
	}

	// Returns an iterator over the elements in this collection.
	// Iterator<E>	iterator()

	// Returns a possibly parallel Stream with this collection as its source.
	// default Stream<E>	parallelStream()

	// Removes a single instance of the specified element from this collection, if it is present (optional operation).
	bool remove(Object o) {
		return false;
	}

	// Removes all of this collection's elements that are also contained in the specified collection (optional operation).
	bool removeAll(T[] someItems) {
		return false;
	}

	// Removes all of the elements of this collection that satisfy the given predicate.
	// default bool	removeIf(Predicate<? super E> filter)

	// Retains only the elements in this collection that are contained in the specified collection (optional operation).
	// bool	retainAll(Collection<?> c)

	// Returns the number of elements in this collection.
	int size() {
		return 0;
	}

	// Creates a Spliterator over the elements in this collection.
	// default Spliterator<E>	spliterator()

	// Returns a sequential Stream with this collection as its source.
	// default Stream<E>	stream()

	// Returns an array containing all of the elements in this collection.
	T[] toArray() {
		return null;
	}

	// Returns an array containing all of the elements in this collection; the runtime type of the returned array is that of the specified array.
	// <T> T[]	toArray(T[] a)

	mixin TCloneable;
}

auto Collection(T)() {
	return new DCollection!T();
}

unittest {
	assert(Collection!string().className == "DCollection");
	assert(Collection!string().create.className == "DCollection");
	assert(Collection!string().clone.className == "DCollection");
}
