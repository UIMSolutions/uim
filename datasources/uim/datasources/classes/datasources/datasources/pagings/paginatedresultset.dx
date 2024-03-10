module uim.datasources\Paging;

import uim.datasources;

@safe:

/**
 * Paginated resultset.
 *
 * @template-extends \IteratorIterator<mixed, mixed, \Traversable<mixed>>
 * @template T
 */
class PaginatedResultSet : IteratorIterator : JsonSerializable, IPaginated {
    // Paging params.
    protected array params = [];

    /**
     * Constructor
     * Params:
     * \Traversable<T> results Resultset instance.
     * @param array params Paging params.
     */
    this(Traversable results, array params) {
        super(results);

        this.params = params;
    }
 
    size_t count() {
        return this.params["count"];
    }
    
    /**
     * Get paginated items.
     */
    Traversable items() {
        return this.getInnerIterator();
    }
    
    /**
     * Provide data which should be serialized to JSON.
     */
    array jsonSerialize() {
        return iterator_to_array(this.items());
    }
 
    int totalCount() {
        return this.params["totalCount"];
    }
 
    int perPage() {
        return this.params["perPage"];
    }
 
    int pageCount() {
        return this.params["pageCount"];
    }
 
    int currentPage() {
        return this.params["currentPage"];
    }
 
    bool hasPrevPage() {
        return this.params["hasPrevPage"];
    }
 
    bool hasNextPage() {
        return this.params["hasNextPage"];
    }
 
    Json pagingParam(string aName) {
        return this.params[name] ?? null;
    }
 
    array pagingParams() {
        return this.params;
    }
}
