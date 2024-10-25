module uim.http.classes.middlewares.queue;

import uim.http;

@safe:

class DMiddlewareQueue {
    // }: Countable, SeekableIterator {
    // Internal position for iterator.
    protected int position = 0;

    // The queue of middlewares.
    protected Json[int] _queue = null;

    protected IContainer _container;

    /*   this(Json[string] middleware = null, IContainer container = null) {
    _container = container;
    _queue = middleware;
  } */

    // Resolve middleware name to a PSR 15 compliant middleware instance.
    protected IMiddleware resolve(IMiddleware middleware) {
        return middleware;
    }

    protected IMiddleware resolve( /* IMiddleware|*/ string middlewareName) {
        if (_container && _container.has(middlewareName)) {
            middlewareName = _container.get(middlewareName);
        } else {
            string classname = App.classname(middlewareName, "Middleware", "Middleware");
            if (classname.isNull) {
                throw new DInvalidArgumentException(
                    "Middleware `%s` was not found."
                        .format(middlewareName
                        ));
            }
            IMiddleware middlewareName = new classname();
        }
        return new DClosureDecoratorMiddleware(middlewareName);
    }

    // Append a middleware to the end of the queue.
    void add(string[] middlewareNames) {
        _queue = chain(_queue, middlewareNames);
    }

    void add(IMiddleware middleware) {
        _queue ~= middleware;
    }

    // Alias for DMiddlewareQueue.add().
    DMiddlewareQueue push(IMiddleware middleware) {
        return _add(middleware);
    }

    DMiddlewareQueue push(string[] middlewareNames...) {
        return _add(middlewareNames.dup);
    }

    DMiddlewareQueue push(string[] middlewareNames) {
        return _add(middlewareNames);
    }

    // Prepend a middleware to the start of the queue.
    auto prepend(IMiddleware middleware) {
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
    auto insertAt(int insertTndex, /* IMiddleware| */ string amiddleware) {
        array_splice(_queue, insertTndex, 0, [middleware]);
        return this;
    }

    /**
     * Insert a middleware before the first matching class.
     *
     * Finds the index of the first middleware that matches the provided class,
     * and inserts the supplied middleware before it.
     */
    auto insertBefore(string classname, IMiddleware middleware) {
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
    // auto insertAfter(string classname, IMiddleware middlewareToInsert) {
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
    IMiddleware currentValue() {
        if (_queue.isNull(_position)) {
            throw new DOutOfBoundsException(
                "Invalid current position (%s).".format(_position));
        }

        if (cast(IMiddleware) _queue[_position]) {
            _queue[_position];
        }
        _queue[_position] = this.resolve(_queue[_position]);
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
