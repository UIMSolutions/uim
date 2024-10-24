/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.collections.classes.iterators.buffered;

import uim.collections;

@safe:

/**
 * Creates an iterator from another iterator that will keep the results of the inner
 * iterator in memory, so that results don`t have to be re-calculated.
 */
class DBufferedIterator : D_Collection { // }, Countable {
  this() {
    super();
  }

  // Points to the next record number that should be fetched
  protected int _index = 0;

  // Last record fetched from the inner iterator
  protected Json _current;
  // Returns the current record in the iterator
  Json currentValue() {
    return _current;
  }

  // Last key obtained from the inner iterator
  protected string _key;
  // Returns the current key in the iterator
  string key() {
    return _key;
  }
  // Whether the internal iterator`s rewind method was already called
  protected bool _started = false;

  // Whether the internal iterator has reached its end.
  protected bool _isFinished = false;

  /*
  // The in-memory cache containing results from previous iterators
  protected ISplDoublyLinkedList _buffer;

  /**
     * Maintains an in-memory cache of the results yielded by the internal
     * iterator.
     * Params:
     * range itemsToBeFiltered The items to be filtered.
     */
  this(Json[string] itemsToBeFiltered) {
    /* _buffer = new DSplDoublyLinkedList(); */
    super(itemsToBeFiltered);
  }

  // Rewinds the collection
  void rewind() {
    if (_index == 0 && !_started) {
      _started = true;
      /* super.rewind(); */

      return;
    }
    _index = 0;
  }

  // Returns whether the iterator has more elements
  bool valid() {
    /* if (_buffer.offsethasKey(_index)) {
      /* auto current = _buffer.offsetGet(_index);
      _current = current["value"];
      _key = current["key"];

      return true; * /
    } */
    // valid = super.valid();

    if (valid) {
      // _current = super.currentValue();
      // _key = super.key();
      /* _buffer.push([
          "key": _key,
          "value": _current,
        ]); */
    }
    // TODO _finished = ! valid;

    // return valid;
    return false;
  }

  // Advances the iterator pointer to the next element
  void next() {
    _index++;

    // Don`t move inner iterator if we have more buffer
    /* if (_buffer.offsethasKey(_index)) {
      return;
    }
    if (!_finished) {
      super.next();
    } */
  }

  // Returns the number or items in this collection
  size_t count() {
    /* if (!_started) {
      _rewind();
    } */
    while (this.valid()) {
      this.next();
    }
    // TODO return _buffer.count();
    return 0;
  }

  // Magic method used for serializing the iterator instance.
  /* Json[string] __serialize() {
    if (!_finished) {
      count();
    }
    return iterator_to_array(_buffer);
  } */

  // Magic method used to rebuild the iterator instance.
  /* void __unserialize(Json[string] data) {
    __construct([]);

    data.each!(value => _buffer.push(value));
    _started = true;
    _finished = true;
  } */
}
