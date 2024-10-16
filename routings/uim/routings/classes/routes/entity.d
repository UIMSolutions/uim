/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.routings.classes.routes.entity;

import uim.routings;

@safe:

/**
 * Matches entities to routes
 *
 * This route will match by entity and map its fields to the URL pattern by
 * comparing the field names with the template vars. This makes it easy and
 * convenient to change routes globally.
 */

class DEntityRoute : DRoute {
    mixin(RouteThis!("Entity"));

    /**
     * Match by entity and map its fields to the URL pattern by comparing the
     * field names with the template vars.
     *
     * If a routing key is defined in both `url` and the entity, the value defined
     * in `url` will be preferred.
     */
    override string match(Json[string] url, Json[string] context= null) {
        /* if (_compiledRoute.isEmpty) {
            this.compile();
        } */
        /* if (url.hasKey("_entity")) {
            myentity = url["_entity"];
           _checkEntity(myentity);

            _keys
                .filter!(field => !url.hasKey(field) && myentity.isSetfield)
                .each!(field => url[field] = myentity[field]);

            }
        } */
        // return super.match(url, context);
        return null; 
    }
    
    // Checks that we really deal with an entity object
    protected void _checkEntity(Json entity) {
        if (!cast(DArrayAccess)entity && !isArray(entity)) {
            throw new UIMException(
                "Route `%s` expects the URL option `_entity` to be an array or object implementing ArrayAccess, but `%s` passed."
                .format(_template, get_debug_type(entity)));
        }
    }
}
mixin(RouteCalls!("Entity"));

unittest {

}