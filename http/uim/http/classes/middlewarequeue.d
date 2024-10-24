/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.http.classes.middlewarequeue;

/**
 * Provides methods for creating and manipulating a "queue" of middlewares.
 * This queue is used to process a request and generate response via \UIM\Http\Runner.
 *
 * @template-implements \SeekableIterator<int, \Psr\Http\Server\IHttpMiddleware>
 */
class MiddlewareQueue { // }: Countable, SeekableIterator {
  // Internal position for iterator.
  protected int position = 0;

  // The queue of middlewares.
  protected Json[int] queue = null;

  protected IContainer container;

  this(Json[string] middleware = null, IContainer container = null) {
    _container = container;
    _queue = middleware;
  }

  // Resolve middleware name to a PSR 15 compliant middleware instance.
  protected IHttpMiddleware resolve(IHttpMiddleware middleware) {
    return middleware;
  }

  protected IHttpMiddleware resolve( /* IHttpMiddleware|*/ string middlewareName) {
    if (this.container && this.container.has(middlewareName)) {
      middlewareName = this.container.get(middlewareName);
    } else {
      string classname = App.classname(middlewareName, "Middleware", "Middleware");
      if (classname.isNull) {
        throw new DInvalidArgumentException(
          "Middleware `%s` was not found."
            .format(middlewareName
            ));
      }
      IHttpMiddleware middlewareName = new classname();
    }
    return new DClosureDecoratorMiddleware(middlewareName);
  }

  /**
     * Append a middleware to the end of the queue.
     * Params:
     * \Psr\Http\Server\IHttpMiddleware|\/** / string[] amiddleware The middleware(s) to append.
     */
  void add(string[] middlewareNames) {
    _queue = chain(_queue, middlewareNames);
  }

  void add(IHttpMiddleware middleware) {
    _queue ~= middleware;
  }

  // Alias for MiddlewareQueue.add().
  MiddlewareQueue push(IHttpMiddleware middleware) {
    return _add(middleware);
  }

  MiddlewareQueue push(string[] middlewareNames...) {
    return _add(middlewareNames.dup);
  }

  MiddlewareQueue push(string[] middlewareNames) {
    return _add(middlewareNames);
  }

  // Prepend a middleware to the start of the queue.
  auto prepend(IHttpMiddleware middleware) {
    _queue.unshift(middleware);
    return this;
  }

  auto prepend(string[] middlewareNames...) {
    return prepend(middlewareNames.dup);
  }

  auto prepend(string[] middlewareNames) {
    _queue = chain(middlewareNames, _queue);
    return this;
  }

  /**
     * Insert a middleware at a specific index.
     *
     * If the index already exists, the new middleware will be inserted,
     * and the existing element will be shifted one index greater.
     */
  auto insertAt(int insertTndex, /* IHttpMiddleware| */ string amiddleware) {
    array_splice(_queue, insertTndex, 0, [middleware]);
    return this;
  }

  /**
     * Insert a middleware before the first matching class.
     *
     * Finds the index of the first middleware that matches the provided class,
     * and inserts the supplied middleware before it.
     */
  auto insertBefore(string classname, IHttpMiddleware middleware) {
  }

  auto insertBefore(string classname, string middlewareToInsert) {
    bool isFound = false;
    auto index = 0;
    foreach (index, object; _queue) {
      if (
        (
          object.isString
          && object == classname
        )
        || isA(object, classname)
        ) {
        isFound = true;
        break;
      }
    }
    if (isFound) {
      return _insertAt(index, middlewareToInsert);
    }
    throw new DLogicException("No middleware matching `%s` could be found.".format(classname));
  }

  /**
     * Insert a middleware object after the first matching class.
     *
     * Finds the index of the first middleware that matches the provided class,
     * and inserts the supplied middleware after it. If the class is not found,
     * this method will behave like add().
     */
  // auto insertAfter(string classname, IHttpMiddleware middlewareToInsert) {
  auto insertAfter(string classname, string middlewareToInsert) {
    auto found = false;
    auto index = 0;
    foreach (index, object; _queue) {
      /** @psalm-suppress ArgumentTypeCoercion */
      if (
        (
          object.isString
          && object == classname
        )
        || isA(object, classname)
        ) {
        found = true;
        break;
      }
    }

    return found
      ? _insertAt(index + 1, middlewareToInsert) : _add(middlewareToInsert);
  }

  /**
     * Get the number of connected middleware layers.
     *
     * Implement the Countable interface.
     */
  size_t count() {
    return count(_queue);
  }

  // Seeks to a given position in the queue.
  void seek(int positionToSeek) {
    if (_queue.isNull(positionToSeek)) {
      throw new DOutOfBoundsException(
        "Invalid seek position (%s)."
          .format(positionToSeek));
    }
    _position = positionToSeek;
  }

  // Rewinds back to the first element of the queue.
  void rewind() {
    _position = 0;
  }

  // Returns the current middleware.
  IHttpMiddleware currentValue() {
    if (_queue.isNull(_position)) {
      throw new DOutOfBoundsException(
        "Invalid current position (%s).".format(_position));
    }

    if (cast(IHttpMiddleware) _queue[_position])
      _queue[_position];
    _queue[_position] = this.resolve(
      _queue[_position]);
    return _queue[_position];
  }

  // Return the key of the middleware.
  int key() {
    return _position;
  }

  // Moves the current position to the next middleware.
  void next() {
    ++_position;
  }

  // Checks if current position is valid.
  bool valid() {
    return isSet(_queue[_position]);
  }
}
