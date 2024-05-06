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

    /**
     * Constructor
     * Params:
     * Json[string] middleware The list of middleware to append.
     * @param \UIM\Core\IContainer container Container instance.
     * /
    this(Json[string] middleware = [], ?IContainer container = null) {
        this.container = container;
        this.queue = middleware;
    }
    
    /**
     * Resolve middleware name to a PSR 15 compliant middleware instance.
     * Params:
     * \Psr\Http\Server\IHttpMiddleware|\Closure|string amiddleware The middleware to resolve.
     * @throws \InvalidArgumentException If Middleware not found.
     * /
    protected IHttpMiddleware resolve(IHttpMiddleware|Closure|string amiddleware) {
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
                IHttpMiddleware middleware = new className();
            }
        }
        if (cast(IHttpMiddleware)middleware) {
            return middleware;
        }
        return new DClosureDecoratorMiddleware(middleware);
    }
    
    /**
     * Append a middleware to the end of the queue.
     * Params:
     * \Psr\Http\Server\IHttpMiddleware|\Closure|string[] amiddleware The middleware(s) to append.
     * /
    void add(IHttpMiddleware|Closure|string[] amiddleware) {
        if (middleware.isArray) {
            this.queue = chain(this.queue, middleware);

            return;
        }
        this.queue ~= middleware;
    }
    
    /**
     * Alias for MiddlewareQueue.add().
     * Params:
     * \Psr\Http\Server\IHttpMiddleware|\Closure|string[] amiddleware The middleware(s) to append.
     * /
    MiddlewareQueue push(IHttpMiddleware|Closure|string[] amiddleware) {
        return _add(middleware);
    }
    
    /**
     * Prepend a middleware to the start of the queue.
     * Params:
     * \Psr\Http\Server\IHttpMiddleware|\Closure|string[] amiddleware The middleware(s) to prepend.
     * /
    auto prepend(IHttpMiddleware|Closure|string[] amiddleware) {
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
     * @param \Psr\Http\Server\IHttpMiddleware|\Closure|string amiddleware The middleware to insert.
     * /
    auto insertAt(int  anIndex, IHttpMiddleware|Closure|string amiddleware) {
        array_splice(this.queue,  anIndex, 0, [middleware]);

        return this;
    }
    
    /**
     * Insert a middleware before the first matching class.
     *
     * Finds the index of the first middleware that matches the provided class,
     * and inserts the supplied middleware before it.
     * Params:
     * @param \Psr\Http\Server\IHttpMiddleware|\Closure|string amiddleware The middleware to insert.
     * @return this
     * @throws \LogicException If middleware to insert before is not found.
     * /
    auto insertBefore(string className, IHttpMiddleware|Closure|string amiddleware) {
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
            return _insertAt(anI, middleware);
        }
        throw new DLogicException("No middleware matching `%s` could be found.".format(className));
    }
    
    /**
     * Insert a middleware object after the first matching class.
     *
     * Finds the index of the first middleware that matches the provided class,
     * and inserts the supplied middleware after it. If the class is not found,
     * this method will behave like add().
     * Params:
     * string className The classname to insert the middleware before.
     * @param \Psr\Http\Server\IHttpMiddleware|\Closure|string amiddleware The middleware to insert.
     * /
    auto insertAfter(string className, IHttpMiddleware|Closure|string amiddleware) {
        found = false;
         anI = 0;
        foreach (anI: object; this.queue) {
            /** @psalm-suppress ArgumentTypeCoercion * /
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
            return _insertAt(anI + 1, middleware);
        }
        return _add(middleware);
    }
    
    /**
     * Get the number of connected middleware layers.
     *
     * Implement the Countable interface.
     * /
    size_t count() {
        return count(this.queue);
    }
    
    /**
     * Seeks to a given position in the queue.
     * Params:
     * int position The position to seek to.
     * /
    void seek(int position) {
        if (!isSet(this.queue[position])) {
            throw new DOutOfBoundsException("Invalid seek position (%s)."
                .format(position));
        }
        this.position = position;
    }
    
    /**
     * Rewinds back to the first element of the queue.
     * /
    void rewind() {
        this.position = 0;
    }
    
    /**
     * Returns the current middleware.
     * @see \Iterator.current()
     * /
    IHttpMiddleware current() {
        if (!isSet(this.queue[this.position])) {
            throw new DOutOfBoundsException("Invalid current position (%s).".format(this.position));
        }
        if (cast(IHttpMiddleware)this.queue[this.position]) {
            return _queue[this.position];
        }
        return _queue[this.position] = this.resolve(this.queue[this.position]);
    }
    
    // Return the key of the middleware.
    int key() {
        return _position;
    }
    
    // Moves the current position to the next middleware.
    void next() {
        ++this.position;
    }
    
    // Checks if current position is valid.
    bool valid() {
        return isSet(this.queue[this.position]);
    } */ 
}
