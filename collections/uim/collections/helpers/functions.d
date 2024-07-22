module uim.collections.helpers.functions;

import uim.collections;

@safe:

ICollection collection(Json[] someItems) {
    return new D_Collection(someItems);
}
