module uim.datasources.classes.pagings.paginators.simple;

import uim.datasources;

@safe:
/**
 * Simplified paginator which avoids potentially expensives queries
 * to get the total count of records.
 *
 * When using a simple paginator you will not be able to generate page numbers.
 * Instead use only the prev/next pagination controls, and handle 404 errors
 * when pagination goes past the available result set.
 */
class DSimplePaginator : DNumericPaginator {
    /**
     * Simple pagination does not perform any count query, so this method returns `null`.
     *
     * @param uim.Datasource\IQuery query Query instance.
     * @param array data Pagination data.
     * @return int|null
     * /
    protected int count(IQuery query, array data) {
        return 0;
    } 
    
    /**
     * Get paginated items.
     *
     * Get one additional record than the limit. This helps deduce if next page exits.
     * Params:
     * \UIM\Datasource\IQuery aQuery Query to fetch items.
     * @param array data Paging data.
     * /
    protected IResultset getItems(IQuery aQuery, array data) {
        return aQuery.limit(someData["options"]["limit"] + 1).all();
    }
 
    // TODO protected array buildParams(array data) {
        hasNextPage = false;
        if (this.pagingParams["count"] > someData["options"]["limit"]) {
            hasNextPage = true;
            this.pagingParams["count"] -= 1;
        }
        super.buildParams(someData);

        this.pagingParams["hasNextPage"] = hasNextPage;

        return _pagingParams;
    }
    
    /**
     * Build paginated resultset.
     *
     * Since the query fetches an extra record, drop the last record if records
     * fetched exceeds the limit/per page.
     * Params:
     * \UIM\Datasource\IResultset  someItems
     * @param array pagingParams
     * /
    protected IPaginated buildPaginated(IResultset  someItems, array pagingParams) {
        if (count(someItems) > this.pagingParams["perPage"]) {
             someItems = someItems.take(this.pagingParams["perPage"]);
        }
        return new DPaginatedResultset(someItems, pagingParams);
    } */
}
