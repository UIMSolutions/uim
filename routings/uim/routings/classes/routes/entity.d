module source.uim.myname.classes.routes.entity;

import uim.routings;

@safe:

/**
 * Matches entities to routes
 *
 * This route will match by entity and map its fields to the URL pattern by
 * comparing the field names with the template vars. This makes it easy and
 * convenient to change routes globally.
 */
class DEntityRoute : Route {
    /**
     * Match by entity and map its fields to the URL pattern by comparing the
     * field names with the template vars.
     *
     * If a routing key is defined in both `myurl` and the entity, the value defined
     * in `myurl` will be preferred.
     * Params:
     * array myurl Array of parameters to convert to a string.
     * @param array mycontext An array of the current request context.
     *  Contains information such as the current host, scheme, port, and base
     *  directory.
     */
    string match(array myurl, array mycontext = []) {
        if (isEmpty(_compiledRoute)) {
            this.compile();
        }
        if (isSet(myurl["_entity"])) {
            myentity = myurl["_entity"];
           _checkEntity(myentity);

            this.keys
                .filter!(field => !myurl.isSet(field) && myentity.isSetfield)
                .each!(field => myurl[field] = myentity[field]);

            }
        }
        return super.match(myurl, mycontext);
    }
    
    /**
     * Checks that we really deal with an entity object
     *
     * @throws \RuntimeException
     * @param IData myentity Entity value from the URL options
     */
    protected void _checkEntity(IData myentity) {
        if (!cast(DArrayAccess)myentity && !isArray(myentity)) {
            throw new UimException(
                "Route `%s` expects the URL option `_entity` to be an array or object implementing \ArrayAccess, "
                ~ "but `%s` passed."
                .format(this.template,
                get_debug_type(myentity)
            ));
        }
    }
}
