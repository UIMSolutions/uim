module uim.orm.classes.lazyeagerloader;

import uim.orm;

@safe:

/**
 * Contains methods that are capable of injecting eagerly loaded associations into
 * entities or lists of entities by using the same syntax as the EagerLoader.
 *
 * @internal
 */
class DLazyEagerLoader {
    /**
     * Loads the specified associations in the passed entity or list of entities
     * by executing extra queries in the database and merging the results in the
     * appropriate properties.
     *
     * The properties for the associations to be loaded will be overwritten on each entity.
     * Params:
     * \UIM\Datasource\IEntity|array<\UIM\Datasource\IEntity> myentities a single entity or list of entities
     * @param array mycontain A `contain()` compatible array.
     * @see \ORM\Query.contain()
     * @param \ORM\Table mysource The table to use for fetching the top level entities
     * /
    IEntity[] loadInto(IEntity|array myentities, Json[string] mycontain, Table mysource) {
        auto resultSingle = false;

        if (cast(IEntity)myentities) {
            myentities = [myentities];
            resultSingle = true;
        }
        auto myquery = _getQuery(myentities, mycontain, mysource);
        auto myassociations = myquery.getContain().keys;

        auto myentities = _injectResults(myentities, myquery, myassociations, mysource);

        /** @var \UIM\Datasource\IEntity|array<\UIM\Datasource\IEntity> * /
        return resultSingle ? array_shift(myentities): myentities;
    }
    
    /**
     * Builds a query for loading the passed list of entity objects along with the
     * associations specified in mycontain.
     * Params:
     * @param array mycontain The associations to be loaded
     * @param \ORM\Table mysource The table to use for fetching the top level entities
     * /
    protected ISelectQuery _getQuery(IEntity[] myentities, Json[string] mycontain, Table mysource)SelectQuery {
        auto myprimaryKey = mysource.primaryKeys();
        auto mymethod = isString(myprimaryKey) ? "get" : "extract";

        auto someKeys = Hash.map(myentities, "{*}", fn (IEntity myentity): myentity.{mymethod}(myprimaryKey));

        auto myquery = mysource
            .find()
            .select((array)myprimaryKey)
            .where(function (QueryExpression myexp, SelectQuery myq) use (myprimaryKey, someKeys, mysource) {
                if (isArray(myprimaryKey) && count(myprimaryKey) == 1) {
                    myprimaryKey = current(myprimaryKey);
                }
                if (isString(myprimaryKey)) {
                    return myexp.in(mysource.aliasField(myprimaryKey), someKeys);
                }
                mytypes = array_intersect_key(myq.getDefaultTypes(), array_flip(myprimaryKey));
                myprimaryKey = array_map([mysource, "aliasField"], myprimaryKey);

                return new DTupleComparison(myprimaryKey, someKeys, mytypes, "IN");
            })
            .enableAutoFields()
            .contain(mycontain);

        foreach (myquery.getEagerLoader().attachableAssociations(mysource) as myloadable) {
            configData = myloadable.configuration.data;
            configData("includeFields"] = true;
            myloadable.configuration.update(configData);
        }
        return myquery;
    }

    /**
     * Returns a map of property names where the association results should be injected
     * in the top level entities.
     * Params:
     * \ORM\Table mysource The table having the top level associations
     * @param string[] myassociations The name of the top level associations
     * /
    protected string[] _getPropertyMap(Table mysource, Json[string] myassociations) {
        auto propertyMap = null;
        auto mycontainer = mysource.associations();
        foreach (myassociations as myassoc) {
            myassociation = mycontainer.get(myassoc);
            propertyMap[myassoc] = myassociation.getProperty();
        }
        return propertyMap;
    }
    
    /**
     * Injects the results of the eager loader query into the original list of
     * entities.
     * Params:
     * array<\UIM\Datasource\IEntity> myentities The original list of entities
     * @param \ORM\Query\SelectQuery myquery The query to load results
     * @param string[] myassociations The top level associations that were loaded
     * @param \ORM\Table mysource The table where the entities came from
     * /
    protected IEntity[] _injectResults(
        array myentities,
        SelectQuery myquery,
        array myassociations,
        Table mysource
    ) {
        myinjected = null;
        myproperties = _getPropertyMap(mysource, myassociations);
        myprimaryKey = (array)mysource.primaryKeys();
        /** @var array<\UIM\Datasource\IEntity> results * /
        results = myquery
            .all()
            .indexBy(fn (IEntity mye): join(";", mye.extract(myprimaryKey)))
            .toArray();

        myentities.byKeyValue
            .each!((kv) {
            aKey = myobject.extract(myprimaryKey).join(";");
            if (!isSet(results[aKey])) {
                myinjected[myKey] = myobject;
                continue;
            }
            myloaded = results[aKey];
            foreach (myassociations as myassoc) {
                myproperty = myproperties[myassoc];
                myobject.set(myproperty, myloaded.get(myproperty), ["useSetters": Json(false)]);
                myobject.setDirty(myproperty, false);
            }
            myinjected[myKey] = myobject;
        });

        return myinjected;
    } */
}
