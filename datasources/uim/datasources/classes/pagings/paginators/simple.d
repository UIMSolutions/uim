module uim.datasources.classes.pagings.paginators.simple;

import uim.datasources;

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
    } */
}
