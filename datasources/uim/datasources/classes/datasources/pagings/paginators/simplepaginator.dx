


 *


 * @since         3.9.0

 */module uim.datasources.Paging;

import uim.datasources.IQuery;

/**
 * Simplified paginator which avoids potentially expensives queries
 * to get the total count of records.
 *
 * When using a simple paginator you will not be able to generate page numbers.
 * Instead use only the prev/next pagination controls, and handle 404 errors
 * when pagination goes past the available result set.
 */
class SimplePaginator : NumericPaginator
{
    /**
     * Simple pagination does not perform any count query, so this method returns `null`.
     *
     * @param uim.Datasource\IQuery query Query instance.
     * @param array data Pagination data.
     * @return int|null
     */
    protected Nullable!int getCount(IQuery query, array data) {
        return null;
    }
}

// phpcs:disable
class_alias(
    "Cake\Datasource\Paging\SimplePaginator",
    "Cake\Datasource\SimplePaginator"
);
// phpcs:enable
