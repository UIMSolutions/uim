module uim.datasources.classes.pagings.paginatedresultset;

import uim.datasources;

@safe:

/**
 * Paginated resultset.
 *
 * @template-extends \IteratorIterator<mixed, mixed, \Traversable<mixed>>
 * @template T
 */
class DPaginatedResultset { /* }: IteratorIterator : IDataSerializable, IPaginated {
    // Paging params.
    // TODO protected array params = null;

    /**
     * Constructor
     * Params:
     * \Traversable<T> results Resultset instance.
     * @param array params Paging params.
     * /
    this(Traversable results, array params) {
        super(results);

        this.params = params;
    }
 
    size_t count() {
        return _params["count"];
    }
    
    /**
     * Get paginated items.
     * /
    Traversable items() {
        return _getInnerIterator();
    }
    
    /**
     * Provide data which should be serialized to IData.
     * /
    array IDataSerialize() {
        return iterator_to_array(this.items());
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
 
    IData pagingParam(string aName) {
        return _params[name] ?? null;
    }
 
    array pagingParams() {
        return _params;
    } */
}
