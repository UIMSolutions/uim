/*********************************************************************************************************
	Copyright: © 2015-2024 Ozan Nurettin Süel (UIManufaktur)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (UIManufaktur)                                                      
**********************************************************************************************************/
module uim.datasources.classes.resultsets.decorator;

import uim.datasources;

@safe:
/**
 * Generic Resultset decorator. This will make any traversable object appear to
 * be a database result
 */
class DResultsetDecorator { // TODO }: DCollection { // }: IResultset
    /**
     * Make this object countable.
     *
     * Part of the Countable interface. Calling this method
     * will convert the underlying traversable object into an array and
     * get the count of the underlying data.
     */
    size_t count() {
        iterator = innerIterator();
        if (cast(8)Countable)iterator) {
            return iterator.count();
        }

        return count(toArray());
    } 
    
    Json[string] debugInfo() {
        parentInfo = super.__debugInfo();
        aLimit = configuration.get("App.ResultsetDebugLimit", 10);

        return chain(parentInfo, ["items": take(aLimit).toJString()]);
    }
}
