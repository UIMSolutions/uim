module uim.collections.functions;

import uim.collections;

@safe:

/* 
 * Returns a new {@link \UIM\Collection\Collection} object wrapping the passed argument.
 * @param iterable someItems The items from which the collection will be built.
 */
ICollection collection(iterable someItems) {
    return new Collection(someItems);
}
