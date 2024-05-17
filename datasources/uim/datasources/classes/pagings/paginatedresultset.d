module uim.datasources.classes.pagings.paginatedresultset;

import uim.datasources;

@safe:

/**
 * Paginated resultset.
 *
 * @template-extends \IteratorIterator<mixed, mixed, \Traversable<mixed>>
 * @template T
 */
class DPaginatedResultset { /* }: IteratorIterator : JsonSerializable, IPaginated {
    // Paging params.
    protected Json[string] params = null;

    /**
     * Constructor
     * Params:
     * \Traversable<T> results Resultset instance.
     * @param Json[string] params Paging params.
     */
    this(DTraversable results, Json[string] params) {
        super(results);

        this.params = params;
    }
 
    size_t count() {
        return _params["count"];
    }
    
    /**
     * Get paginated items.
     */
    Traversable items() {
        return _getInnerIterator();
    }
    
    /**
     * Provide data which should be serialized to Json.
     */
    Json[string] JsonSerialize() {
        return iterator_to_array(items());
    }
 
    int totalCount() {
        return _params["totalCount"];
    }
 
    int perPage() {
        return _params["perPage"];
    }
 
    int pageCount() {
        return _params["pageCount"];
    }
 
    int currentPage() {
        return _params["currentPage"];
    }
 
    bool hasPrevPage() {
        return _params["hasPrevPage"];
    }
 
    bool hasNextPage() {
        return _params["hasNextPage"];
    }
 
    Json pagingParam(string aName) {
        return _params[name] ?? null;
    }
 
    Json[string] pagingParams() {
        return _params;
    } */
}
