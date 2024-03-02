
if (!function_exists("collection")) {
    /**
     * Returns a new {@link \UIM\Collection\Collection} object wrapping the passed argument.
     * Params:
     * iterable someItems The items from which the collection will be built.
     */
    ICollection collection(iterable someItems) {
        return cakeCollection(someItems);
    }
}
