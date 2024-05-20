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
    // Simple pagination does not perform any count query, so this method returns `null`.
    protected size_t count(IQuery query, Json[string] paginationData) {
        return 0;
    } 
    
    /**
     * Get paginated items.
     *
     * Get one additional record than the limit. This helps deduce if next page exits.
     * Params:
     * \UIM\Datasource\IQuery aQuery Query to fetch items.
     * @param Json[string] pagingData Paging pagingData.
     */
    protected IResultset getItems(IQuery aQuery, Json[string] pagingData) {
        return aQuery.limit(pagingData["options"]["limit"] + 1).all();
    }
 
    protected Json[string] buildParams(Json[string] pagingData) {
        hasNextPage = false;
        if (this.pagingParams["count"] > pagingData["options"]["limit"]) {
            hasNextPage = true;
            this.pagingParams["count"] -= 1;
        }
        super.buildParams(pagingData);

        this.pagingParams["hasNextPage"] = hasNextPage;

        return _pagingParams;
    }
    
    /**
     * Build paginated resultset.
     *
     * Since the query fetches an extra record, drop the last record if records
     * fetched exceeds the limit/per page.
     */
    protected IPaginated buildPaginated(IResultset resultItems, Json[string] pagingParams) {
        if (count(resultItems) > this.pagingParams["perPage"]) {
             resultItems = someItems.take(this.pagingParams["perPage"]);
        }
        return new DPaginatedResultset(resultItems, pagingParams);
    } 
}
