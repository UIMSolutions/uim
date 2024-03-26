module uim.collections.helpers.functions;

import uim.collections;

@safe:

/* 
 * Returns a new {@link \UIM\Collection\Collection} object wrapping the passed argument.
 * @param range someItems The items from which the collection will be built.
 */
ICollection collection(IData[] someItems) {
    return new DCollection(someItems);
}
