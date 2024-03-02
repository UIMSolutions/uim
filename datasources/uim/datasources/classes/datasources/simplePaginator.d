/*********************************************************************************************************
	Copyright: © 2015-2023 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.datasources;

/**
 * Simplified paginator which avoids potentially expensives queries
 * to get the total count of records.
 *
 * When using a simple paginator you will not be able to generate page numbers.
 * Instead use only the prev/next pagination controls, and handle 404 errors
 * when pagination goes past the available result set.
 */
class SimplePaginator : Paginator
{
  /**
    * Simple pagination does not perform any count query, so this method returns `null`.
    *
    * @param uim.Datasource\IQuery myQuery Query instance.
    * @param array myData Pagination data.
    * @return int|null
    */
  protected Nullable!int getCount(IQuery myQuery, array myData) {
    return null;
  }
}
class_exists("Cake\Datasource\Paging\SimplePaginator");
deprecationWarning(
    "Use Cake\Datasource\Paging\SimplePaginator instead of Cake\Datasource\SimplePaginator."
);