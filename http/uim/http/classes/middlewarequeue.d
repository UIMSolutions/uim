module uim.http.classes.middlewarequeue;

/**
 * Provides methods for creating and manipulating a "queue" of middlewares.
 * This queue is used to process a request and generate response via \UIM\Http\Runner.
 *
 * @template-implements \SeekableIterator<int, \Psr\Http\Server\IMiddleware>
 */
class MiddlewareQueue : Countable, SeekableIterator {
    // Internal position for iterator.
    protected int position = 0;

    /**
     * The queue of middlewares.
     *
     * @var array<int, mixed>
     */
    protected Json[int] queue = [];

    protected IContainer container;

    /**
     * Constructor
     * Params:
     * array middleware The list of middleware to append.
     * @param \UIM\Core\IContainer container Container instance.
     */
    this(array middleware = [], ?IContainer container = null) {
        this.container = container;
        this.queue = middleware;
    }
    
    /**
     * Resolve middleware name to a PSR 15 compliant middleware instance.
     * Params:
     * \Psr\Http\Server\IMiddleware|\Closure|string amiddleware The middleware to resolve.
     * @throws \InvalidArgumentException If Middleware not found.
     */
    protected IMiddleware resolve(IMiddleware|Closure|string amiddleware) {
        if (isString(middleware)) {
            if (this.container && this.container.has(middleware)) {
                middleware = this.container.get(middleware);
            } else {
                string className = App.className(middleware, "Middleware", "Middleware");
                if (className.isNull) {
                    throw new DInvalidArgumentException(
                        "Middleware `%s` was not found."
                        .format(middleware
                    ));
                }
                IMiddleware middleware = new className();
            }
        }
        if (cast(IMiddleware)middleware) {
            return middleware;
        }
        return new ClosureDecoratorMiddleware(middleware);
    }
    
    /**
     * Append a middleware to the end of the queue.
     * Params:
     * \Psr\Http\Server\IMiddleware|\Closure|string[] amiddleware The middleware(s) to append.
     */
    void add(IMiddleware|Closure|string[] amiddleware) {
        if (middleware.isArray) {
            this.queue = chain(this.queue, middleware);

            return;
        }
        this.queue ~= middleware;
    }
    
    /**
     * Alias for MiddlewareQueue.add().
     * Params:
     * \Psr\Http\Server\IMiddleware|\Closure|string[] amiddleware The middleware(s) to append.
     */
    MiddlewareQueue push(IMiddleware|Closure|string[] amiddleware) {
        return this.add(middleware);
    }
    
    /**
     * Prepend a middleware to the start of the queue.
     * Params:
     * \Psr\Http\Server\IMiddleware|\Closure|string[] amiddleware The middleware(s) to prepend.
     */
    auto prepend(IMiddleware|Closure|string[] amiddleware) {
        if (middleware.isArray) {
            this.queue = chain(middleware, this.queue);

            return this;
        }
        array_unshift(this.queue, middleware);

        return this;
    }
    
    /**
     * Insert a middleware at a specific index.
     *
     * If the index already exists, the new middleware will be inserted,
     * and the existing element will be shifted one index greater.
     * Params:
     * int  anIndex The index to insert at.
     * @param \Psr\Http\Server\IMiddleware|\Closure|string amiddleware The middleware to insert.
     */
    auto insertAt(int  anIndex, IMiddleware|Closure|string amiddleware) {
        array_splice(this.queue,  anIndex, 0, [middleware]);

        return this;
    }
    
    /**
     * Insert a middleware before the first matching class.
     *
     * Finds the index of the first middleware that matches the provided class,
     * and inserts the supplied middleware before it.
     * Params:
     * @param \Psr\Http\Server\IMiddleware|\Closure|string amiddleware The middleware to insert.
     * @return this
     * @throws \LogicException If middleware to insert before is not found.
     */
    auto insertBefore(string className, IMiddleware|Closure|string amiddleware) {
        bool isFound = false;
         anI = 0;
        foreach (anI: object; this.queue) {
            if (
                (
                    isString(object)
                    && object == className
                )
                || isA(object,  className)
            ) {
                isFound = true;
                break;
            }
        }
        if (isFound) {
            return this.insertAt(anI, middleware);
        }
        throw new LogicException("No middleware matching `%s` could be found.".format(className));
    }
    
    /**
     * Insert a middleware object after the first matching class.
     *
     * Finds the index of the first middleware that matches the provided class,
     * and inserts the supplied middleware after it. If the class is not found,
     * this method will behave like add().
     * Params:
     * string className The classname to insert the middleware before.
     * @param \Psr\Http\Server\IMiddleware|\Closure|string amiddleware The middleware to insert.
     */
    auto insertAfter(string className, IMiddleware|Closure|string amiddleware) {
        found = false;
         anI = 0;
        foreach (anI: object; this.queue) {
            /** @psalm-suppress ArgumentTypeCoercion */
            if (
                (
                    isString(object)
                    && object == className
                )
                || isA(object,  className)
            ) {
                found = true;
                break;
            }
        }
        if (found) {
            return this.insertAt(anI + 1, middleware);
        }
        return this.add(middleware);
    }
    
    /**
     * Get the number of connected middleware layers.
     *
     * Implement the Countable interface.
     */
    size_t count() {
        return count(this.queue);
    }
    
    /**
     * Seeks to a given position in the queue.
     * Params:
     * int position The position to seek to.
     */
    void seek(int position) {
        if (!isSet(this.queue[position])) {
            throw new OutOfBoundsException("Invalid seek position (%s)."
                .format(position));
        }
        this.position = position;
    }
    
    /**
     * Rewinds back to the first element of the queue.
     */
    void rewind() {
        this.position = 0;
    }
    
    /**
     * Returns the current middleware.
     * @see \Iterator.current()
     */
    IMiddleware current() {
        if (!isSet(this.queue[this.position])) {
            throw new OutOfBoundsException("Invalid current position (%s).".format(this.position));
        }
        if (cast(IMiddleware)this.queue[this.position]) {
            return this.queue[this.position];
        }
        return this.queue[this.position] = this.resolve(this.queue[this.position]);
    }
    
    /**
     * Return the key of the middleware.
     *
     * @see \Iterator.key()
     */
    int key() {
        return this.position;
    }
    
    /**
     * Moves the current position to the next middleware.
     *
     * @see \Iterator.next()
     */
    void next() {
        ++this.position;
    }
    
    /**
     * Checks if current position is valid.
     *
     * @see \Iterator.valid()
     */
    bool valid() {
        return isSet(this.queue[this.position]);
    }
}
