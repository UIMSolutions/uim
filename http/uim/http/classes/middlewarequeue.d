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
    
    /**
     * Resolve middleware name to a PSR 15 compliant middleware instance.
     * Params:
     * \Psr\Http\Server\IHttpMiddleware|\/*Closure|*/ string amiddleware The middleware to resolve.
     */
    protected IHttpMiddleware resolve(/* IHttpMiddleware|Closure|*/ string middlewareName) {
        if (isString(middlewareName)) {
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
        }
        if (cast(IHttpMiddleware)middlewareName) {
            return middlewareName;
        }
        return new DClosureDecoratorMiddleware(middlewareName);
    }
    
    /**
     * Append a middleware to the end of the queue.
     * Params:
     * \Psr\Http\Server\IHttpMiddleware|\/*Closure|* / string[] amiddleware The middleware(s) to append.
     */
    void add(/* IHttpMiddleware| Closure|*/ string[] middlewares) {
            _queue = chain(_queue, middlewares);
    }
    void add(IHttpMiddleware|/*Closure|*/ string[] amiddleware) {
        _queue ~= middleware;
    }
    
    /**
     * Alias for MiddlewareQueue.add().
     * Params:
     * \Psr\Http\Server\IHttpMiddleware|\/*Closure|*/ string[] amiddleware The middleware(s) to append.
     */
    MiddlewareQueue push(IHttpMiddleware|/*Closure|*/ string[] amiddleware) {
        return _add(middleware);
    }
    
    /**
     * Prepend a middleware to the start of the queue.
     * Params:
     * \Psr\Http\Server\IHttpMiddleware|\/*Closure|*/ string[] amiddleware The middleware(s) to prepend.
     */
    auto prepend(IHttpMiddleware|/*Closure|*/ string[] amiddleware) {
        if (middleware.isArray) {
            _queue = chain(middleware, _queue);

            return this;
        }
        array_unshift(_queue, middleware);

        return this;
    }
    
    /**
     * Insert a middleware at a specific index.
     *
     * If the index already exists, the new middleware will be inserted,
     * and the existing element will be shifted one index greater.
     */
    auto insertAt(int insertTndex, /* IHttpMiddleware| *//*Closure|*/ string amiddleware) {
        array_splice(_queue,  insertTndex, 0, [middleware]);

        return this;
    }
    
    /**
     * Insert a middleware before the first matching class.
     *
     * Finds the index of the first middleware that matches the provided class,
     * and inserts the supplied middleware before it.
     */
    auto insertBefore(string classname, IHttpMiddleware|/*Closure|*/ string middlewareToInsert) {
        bool isFound = false;
        auto index = 0;
        foreach (index, object; _queue) {
            if (
                (
                    isString(object)
                    && object == classname
               )
                || isA(object,  classname)
           ) {
                isFound = true;
                break;
            }
        }
        if (isFound) {
            return _insertAt(anI, middlewareToInsert);
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
    // auto insertAfter(string classname, DClosure middlewareToInsert) {
    auto insertAfter(string classname, string middlewareToInsert) {
        auto found = false;
        auto anI = 0;
        foreach (anI, object; _queue) {
            /** @psalm-suppress ArgumentTypeCoercion */
            if (
                (
                    isString(object)
                    && object == classname
               )
                || isA(object,  classname)
           ) {
                found = true;
                break;
            }
        }
        
        return found
            ? _insertAt(anI + 1, middlewareToInsert)
            : _add(middlewareToInsert);
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
            throw new DOutOfBoundsException("Invalid seek position (%s)."
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
            throw new DOutOfBoundsException("Invalid current position (%s).".format(_position));
        }
        if (cast(IHttpMiddleware)_queue[_position]) {
            return _queue[_position];
        }
        return _queue[_position] = this.resolve(_queue[_position]);
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
