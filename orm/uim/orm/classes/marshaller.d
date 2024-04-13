module uim.orm.classes.marshaller;

import uim.orm;

@safe:

/**
 * Contains logic to convert array data into entities.
 *
 * Useful when converting request data into entities.
 *
 * @see \ORM\Table.newEntity()
 * @see \ORM\Table.newEntities()
 * @see \ORM\Table.patchEntity()
 * @see \ORM\Table.patchEntities()
 */
class DMarshaller {
    /*
    mixin TAssociationsNormalizer();

    // The table instance this marshaller is for.
    protected ITable my_table;

    /**
     * Constructor.
     * Params:
     * \ORM\Table mytable The table this marshaller is for.
     * /
    this(Table mytable) {
       _table = mytable;
    }
    
    /**
     * Build the map of property: marshalling callable.
     * Params:
     * array data The data being marshalled.
     * @param IData[string] options List of options containing the "associated" key.
     * @throws \InvalidArgumentException When associations do not exist.
     * /
    protected array _buildPropertyMap(array data, IData[string] options) {
        auto mymap = null;
        auto tableSchema = _table.getSchema();

        // Is a concrete column?
        foreach (mydata.keys as myprop) {
            myprop = to!string(myprop);
            mycolumnType = tableSchema.getColumnType(myprop);
            if (mycolumnType) {
                mymap[myprop] = fn (myvalue): TypeFactory.build(mycolumnType).marshal(myvalue);
            }
        }
        // Map associations
        options["associated"] = options["associated"] ?? [];
        myinclude = _normalizeAssociations(options["associated"]);
        foreach (myinclude as aKey: mynested) {
            if (isInt(aKey) && isScalar(mynested)) {
                aKey = mynested;
                mynested = null;
            }
            // If the key is not a special field like _ids or _joinData
            // it is a missing association that we should error on.
            if (!_table.hasAssociation((string)aKey)) {
                if (!to!string(aKey).startWith("_")) {
                    throw new DInvalidArgumentException(
                        "Cannot marshal data for `%s` association. It is not associated with `%s`."
                        .format(to!string(aKey, _table.aliasName()))
                    );
                }
                continue;
            }
            myassoc = _table.getAssociation(to!string(aKey));

            if (isSet(options["forceNew"])) {
                mynested["forceNew"] = options["forceNew"];
            }
            if (isSet(options["isMerge"])) {
                mycallback = auto (myvalue, IEntity myentity) use (myassoc, mynested) {
                    options = mynested ~ ["associated": ArrayData, "association": myassoc];

                    return _mergeAssociation(myentity.get(myassoc.getProperty()), myassoc, myvalue, options);
                };
            } else {
                mycallback = auto (myvalue, myentity) use (myassoc, mynested) {
                    options = mynested ~ ["associated": ArrayData];

                    return _marshalAssociation(myassoc, myvalue, options);
                };
            }
            mymap[myassoc.getProperty()] = mycallback;
        }
        mybehaviors = _table.behaviors();
        foreach (mybehaviors.loaded() as myname) {
            mybehavior = mybehaviors.get(myname);
            if (cast(IPropertyMarshal)mybehavior) {
                mymap += mybehavior.buildMarshalMap(this, mymap, options);
            }
        }
        return mymap;
    }
    
    /**
     * Hydrate one entity and its associated data.
     *
     * ### Options:
     *
     * - validate: Set to false to disable validation. Can also be a string of the validator ruleset to be applied.
     *  Defaults to true/default.
     * - associated: DAssociations listed here will be marshalled as well. Defaults to null.
     * - fields: An allowed list of fields to be assigned to the entity. If not present,
     *  the accessible fields list in the entity will be used. Defaults to null.
     * - accessibleFields: A list of fields to allow or deny in entity accessible fields. Defaults to null
     * - forceNew: When enabled, belongsToMany associations will have "new" entities created
     *  when primary key values are set, and a record does not already exist. Normally primary key
     *  on missing entities would be ignored. Defaults to false.
     *
     * The above options can be used in each nested `associated` array. In addition to the above
     * options you can also use the `onlyIds` option for HasMany and BelongsToMany associations.
     * When true this option restricts the request data to only be read from `_ids`.
     *
     * ```
     * result = mymarshaller.one(mydata, [
     *  "associated": ["Tags": ["onlyIds": BooleanData(true)]]
     * ]);
     * ```
     *
     * ```
     * result = mymarshaller.one(mydata, [
     *  "associated": [
     *    "Tags": ["accessibleFields": ["*": BooleanData(true)]]
     *  ]
     * ]);
     * ```
     * Params:
     * IData[string] mydata The data to hydrate.
     * @param IData[string] options List of options
     * /
    IEntity one(array data, IData[string] optionData = null) {
        [mydata, options] = _prepareDataAndOptions(mydata, options);

        myprimaryKey = (array)_table.getPrimaryKeys();
        myentity = _table.newEmptyEntity();

        if (isSet(options["accessibleFields"])) {
            foreach ((array)options["accessibleFields"] as aKey: myvalue) {
                myentity.setAccess(aKey, myvalue);
            }
        }
        myerrors = _validate(mydata, options["validate"], true);

        options["isMerge"] = false;
        mypropertyMap = _buildPropertyMap(mydata, options);
        myproperties = null;
        /**
         * @var string aKey
         * /
        foreach (mydata as aKey: myvalue) {
            if (!empty(myerrors[aKey])) {
                if (cast(IInvalidProperty)myentity) {
                    myentity.setInvalidField(aKey, myvalue);
                }
                continue;
            }
            if (myvalue == "" && in_array(aKey, myprimaryKey, true)) {
                // Skip marshalling "" for pk fields.
                continue;
            }
            if (isSet(mypropertyMap[aKey])) {
                myproperties[aKey] = mypropertyMap[aKey](myvalue, myentity);
            } else {
                myproperties[aKey] = myvalue;
            }
        }
        if (isSet(options["fields"])) {
            foreach ((array)options["fields"] as myfield) {
                if (array_key_exists(myfield, myproperties)) {
                    myentity.set(myfield, myproperties[myfield], ["asOriginal": BooleanData(true)]);
                }
            }
        } else {
            myentity.set(myproperties, ["asOriginal": BooleanData(true)]);
        }
        // Don"t flag clean association entities as
        // dirty so we don"t persist empty records.
        myproperties.byKeyValue
            .filter!(fieldValue => cast(IEntity)fieldValue.value)
            .each!(fieldValue => myentity.setDirty(fieldValue.key, fieldValue.value.isDirty()));
        myentity.setErrors(myerrors);
        this.dispatchAfterMarshal(myentity, mydata, options);

        return myentity;
    }
    
    /**
     * Returns the validation errors for a data set based on the passed options
     * Params:
     * array data The data to validate.
     * @param string|bool myvalidator Validator name or `true` for default validator.
     * @param bool myisNew Whether it is a new DORMEntity or one to be updated.
     * /
    protected array _validate(array data, string|bool myvalidator, bool myisNew) {
        if (!myvalidator) {
            return null;
        }
        if (myvalidator == true) {
            myvalidator = null;
        }
        return _table.getValidator(myvalidator).validate(mydata, myisNew);
    }
    
    /**
     * Returns data and options prepared to validate and marshall.
     * Params:
     * IData[string] mydata The data to prepare.
     * @param IData[string] options The options passed to this marshaller.
     * /
    protected array _prepareDataAndOptions(array data, IData[string] options) {
        options = options.update["validate": BooleanData(true)];

        mytableName = _table.aliasName();
        if (isSet(mydata[mytableName]) && isArray(mydata[mytableName])) {
            mydata += mydata[mytableName];
            unset(mydata[mytableName]);
        }
        mydata = new ArrayObject(mydata);
        options = new ArrayObject(options);
       _table.dispatchEvent("Model.beforeMarshal", compact("data", "options"));

        return [(array)mydata, (array)options];
    }
    
    /**
     * Create a new sub-marshaller and marshal the associated data.
     * Params:
     * \ORM\Association myassoc The association to marshall
     * @param IData aValue The data to hydrate. If not an array, this method will return null.
     * @param IData[string] options List of options.
     * /
    protected IEntity[] _marshalAssociation(Association myassoc, IData aValue, IData[string] options) {
        if (!isArray(myvalue)) {
            return null;
        }
        mytargetTable = myassoc.getTarget();
        mymarshaller = mytargetTable.marshaller();
        mytypes = [Association.ONE_TO_ONE, Association.MANY_TO_ONE];
        mytype = myassoc.type();
        if (in_array(mytype, mytypes, true)) {
            return mymarshaller.one(myvalue, options);
        }
        if (mytype == Association.ONE_TO_MANY || mytype == Association.MANY_TO_MANY) {
            myhasIds = array_key_exists("_ids", myvalue);
            myonlyIds = array_key_exists("onlyIds", options) && options["onlyIds"];

            if (myhasIds && isArray(myvalue["_ids"])) {
                return _loadAssociatedByIds(myassoc, myvalue["_ids"]);
            }
            if (myhasIds || myonlyIds) {
                return null;
            }
        }
        if (mytype == Association.MANY_TO_MANY) {
            assert(cast(BelongsToMany)myassoc);

            return mymarshaller._belongsToMany(myassoc, myvalue, options);
        }
        return mymarshaller.many(myvalue, options);
    }
    
    /**
     * Hydrate many entities and their associated data.
     *
     * ### Options:
     *
     * - validate: Set to false to disable validation. Can also be a string of the validator ruleset to be applied.
     *  Defaults to true/default.
     * - associated: DAssociations listed here will be marshalled as well. Defaults to null.
     * - fields: An allowed list of fields to be assigned to the entity. If not present,
     *  the accessible fields list in the entity will be used. Defaults to null.
     * - accessibleFields: A list of fields to allow or deny in entity accessible fields. Defaults to null
     * - forceNew: When enabled, belongsToMany associations will have "new" entities created
     *  when primary key values are set, and a record does not already exist. Normally primary key
     *  on missing entities would be ignored. Defaults to false.
     * Params:
     * array data The data to hydrate.
     * @param IData[string] options List of options
     * /
    IEntity[] many(array data, IData[string] optionData = null) {
        myoutput = null;
        foreach (mydata as myrecord) {
            if (!isArray(myrecord)) {
                continue;
            }
            myoutput ~= this.one(myrecord, options);
        }
        return myoutput;
    }
    
    /**
     * Marshals data for belongsToMany associations.
     *
     * Builds the related entities and handles the special casing
     * for junction table entities.
     * Params:
     * \ORM\Association\BelongsToMany myassoc The association to marshal.
     * @param array data The data to convert into entities.
     * @param IData[string] options List of options.
     * /
    protected IEntity[] _belongsToMany(BelongsToMany myassoc, array data, IData[string] optionData = null) {
        auto myassociated = options["associated"] ?? [];
        auto myforceNew = options.get("forceNew", false);
        auto mydata = mydata.values;
        auto mytarget = myassoc.getTarget();
        auto myprimaryKey = array_flip((array)mytarget.getPrimaryKeys());
        auto myrecords = myconditions = null;
        auto myprimaryCount = count(myprimaryKey);

        foreach (index: myrow; mydata) {
            if (!isArray(myrow)) {
                continue;
            }
            if (array_intersect_key(myprimaryKey, myrow) == myprimaryKey) {
                someKeys = array_intersect_key(myrow, myprimaryKey);
                if (count(someKeys) == myprimaryCount) {
                    myrowConditions = null;
                    foreach (someKeys as aKey: myvalue) {
                        myrowConditions[][mytarget.aliasField(aKey)] = myvalue;
                    }
                    if (myforceNew && !mytarget.exists(myrowConditions)) {
                        myrecords[index] = this.one(myrow, options);
                    }
                    myconditions = chain(myconditions, myrowConditions);
                }
            } else {
                myrecords[index] = this.one(myrow, options);
            }
        }
        if (!empty(myconditions)) {
            /** @var \Traversable<\UIM\Datasource\IEntity> results * /
            results = mytarget.find()
                .andWhere(fn (QueryExpression myexp): myexp.or(myconditions))
                .all();

            mykeyFields = myprimaryKey.keys;

            myexisting = null;
            results.each!((row) {
                auto myKey = join(";", row.extract(mykeyFields));
                myexisting[myKey] = row;
            });
            foreach (index: myrow; mydata) {
                string[] keys = mykeyFields
                    .filter!(key => myrow.isSet(myKey))
                    .map!(key => myrow[key])
                    .array;

                aKey = keys.join(";");

                // Update existing record and child associations
                if (isSet(myexisting[aKey])) {
                    myrecords[index] = this.merge(myexisting[aKey], myrow, options);
                }
            }
        }
        myjointMarshaller = myassoc.junction().marshaller();

        mynested = null;
        if (isSet(myassociated["_joinData"])) {
            mynested = (array)myassociated["_joinData"];
        }
        foreach (myrecords as myi: myrecord) {
            // Update junction table data in _joinData.
            if (isSet(mydata[myi]["_joinData"])) {
                myjoinData = myjointMarshaller.one(mydata[myi]["_joinData"], mynested);
                myrecord.set("_joinData", myjoinData);
            }
        }
        return myrecords;
    }
    
    /**
     * Loads a list of belongs to many from ids.
     * Params:
     * \ORM\Association myassoc The association class for the belongsToMany association.
     * @param array myids The list of ids to load.
     * /
    protected IEntity[] _loadAssociatedByIds(Association myassoc, array myids) {
        if (isEmpty(myids)) {
            return null;
        }
        mytarget = myassoc.getTarget();
        myprimaryKey = (array)mytarget.getPrimaryKeys();
        mymulti = count(myprimaryKey) > 1;
        myprimaryKey = array_map([mytarget, "aliasField"], myprimaryKey);

        if (mymulti) {
            myfirst = current(myids);
            if (!isArray(myfirst) || count(myfirst) != count(myprimaryKey)) {
                return null;
            }
            mytype = null;
            myschema = mytarget.getSchema();
            foreach ((array)mytarget.getPrimaryKeys() as mycolumn) {
                mytype ~= myschema.getColumnType(mycolumn);
            }
            myfilter = new DTupleComparison(myprimaryKey, myids, mytype, "IN");
        } else {
            myfilter = [myprimaryKey[0] ~ " IN": myids];
        }
        return mytarget.find().where(myfilter).toArray();
    }
    
    /**
     * Merges `mydata` into `myentity` and recursively does the same for each one of
     * the association names passed in `options`. When merging associations, if an
     * entity is not present in the parent entity for a given association, a new one
     * will be created.
     *
     * When merging HasMany or BelongsToMany associations, all the entities in the
     * `mydata` array will appear, those that can be matched by primary key will get
     * the data merged, but those that cannot, will be discarded. `ids` option can be used
     * to determine whether the association must use the `_ids` format.
     *
     * ### Options:
     *
     * - associated: DAssociations listed here will be marshalled as well.
     * - validate: Whether to validate data before hydrating the entities. Can
     *  also be set to a string to use a specific validator. Defaults to true/default.
     * - fields: An allowed list of fields to be assigned to the entity. If not present
     *  the accessible fields list in the entity will be used.
     * - accessibleFields: A list of fields to allow or deny in entity accessible fields.
     *
     * The above options can be used in each nested `associated` array. In addition to the above
     * options you can also use the `onlyIds` option for HasMany and BelongsToMany associations.
     * When true this option restricts the request data to only be read from `_ids`.
     *
     * ```
     * result = mymarshaller.merge(myentity, mydata, [
     *  "associated": ["Tags": ["onlyIds": BooleanData(true)]]
     * ]);
     * ```
     * Params:
     * \UIM\Datasource\IEntity myentity the entity that will get the data merged in
     * @param array data key value list of fields to be merged into the entity
     * @param IData[string] options List of options.
     * /
    IEntity merge(IEntity myentity, array data, IData[string] optionData = null) {
        [mydata, options] = _prepareDataAndOptions(mydata, options);

        myisNew = myentity.isNew();
        someKeys = null;

        if (!myisNew) {
            someKeys = myentity.extract((array)_table.getPrimaryKeys());
        }
        if (isSet(options["accessibleFields"])) {
            foreach ((array)options["accessibleFields"] as aKey: myvalue) {
                myentity.setAccess(aKey, myvalue);
            }
        }
        myerrors = _validate(mydata + someKeys, options["validate"], myisNew);
        options["isMerge"] = true;
        mypropertyMap = _buildPropertyMap(mydata, options);
        myproperties = null;

        // @var string aKey
        foreach (aKey, myvalue; mydata) {
            if (!empty(myerrors[aKey])) {
                if (cast(IInvalidProperty)myentity) {
                    myentity.setInvalidField(aKey, myvalue);
                }
                continue;
            }
            myoriginal = myentity.get(aKey);

            if (isSet(mypropertyMap[aKey])) {
                myvalue = mypropertyMap[aKey](myvalue, myentity);

                // Don"t dirty scalar values and objects that didn"t
                // change. Arrays will always be marked as dirty because
                // the original/updated list could contain references to the
                // same objects, even though those objects may have changed internally.
                if (
                    (
                        isScalar(myvalue)
                        && myoriginal == myvalue
                    )
                    || (
                        myvalue.isNull
                        && myoriginal == myvalue
                    )
                    || (
                        isObject(myvalue)
                        && !(cast(IEntity)myvalue)
                        && myoriginal == myvalue
                    )
                ) {
                    continue;
                }
            }
            myproperties[aKey] = myvalue;
        }
        myentity.setErrors(myerrors);
        if (!options.isSet("fields")) {
            myentity.set(myproperties);

            myproperties.byKeyValue
                .filter!(fieldValue => cast(IEntity)fieldValue.value)
                .each!(fieldValue => myentity.setDirty(fieldValue.key, fieldValue.value.isDirty()));

            this.dispatchAfterMarshal(myentity, mydata, options);

            return myentity;
        }
        foreach ((array)options["fields"] as myfield) {
            assert(isString(myfield));
            if (!array_key_exists(myfield, myproperties)) {
                continue;
            }
            myentity.set(myfield, myproperties[myfield]);
            if (cast(IEntity)myproperties[myfield]) {
                myentity.setDirty(myfield, myproperties[myfield].isDirty());
            }
        }
        this.dispatchAfterMarshal(myentity, mydata, options);

        return myentity;
    }
    
    /**
     * Merges each of the elements from `mydata` into each of the entities in `myentities`
     * and recursively does the same for each of the association names passed in
     * `options`. When merging associations, if an entity is not present in the parent
     * entity for a given association, a new one will be created.
     *
     * Records in `mydata` are matched against the entities using the primary key
     * column. Entries in `myentities` that cannot be matched to any record in
     * `mydata` will be discarded. Records in `mydata` that could not be matched will
     * be marshalled as a new DORMEntity.
     *
     * When merging HasMany or BelongsToMany associations, all the entities in the
     * `mydata` array will appear, those that can be matched by primary key will get
     * the data merged, but those that cannot, will be discarded.
     *
     * ### Options:
     *
     * - validate: Whether to validate data before hydrating the entities. Can
     *  also be set to a string to use a specific validator. Defaults to true/default.
     * - associated: DAssociations listed here will be marshalled as well.
     * - fields: An allowed list of fields to be assigned to the entity. If not present,
     *  the accessible fields list in the entity will be used.
     * - accessibleFields: A list of fields to allow or deny in entity accessible fields.
     * Params:
     * iterable<\UIM\Datasource\IEntity> myentities the entities that will get the
     *  data merged in
     * @param array data list of arrays to be merged into the entities
     * @param IData[string] options List of options.
     * /
    IEntity[] mergeMany(Range myentities, array data, IData[string] optionData = null) {
        myprimary = (array)_table.getPrimaryKeys();

        myindexed = (new DCollection(mydata))
            .groupBy(function (myel) use (myprimary) {
                auto someKeys = myprimary
                    .map!(key => myel.get(key, "")).array;
                return join(";", someKeys);
            })
            .map(function (myelement, aKey) {
                return aKey == "" ? myelement : myelement[0];
            })
            .toArray();

        mynew = myindexed[""] ?? [];
        unset(myindexed[""]);
        myoutput = null;

        foreach (myentity; myentities) {
            if (!(cast(IEntity)myentity)) {
                continue;
            }
            aKey = join(";", myentity.extract(myprimary));
            if (!isSet(myindexed[aKey])) {
                continue;
            }
            myoutput ~= this.merge(myentity, myindexed[aKey], options);
            unset(myindexed[aKey]);
        }
        myconditions = (new DCollection(myindexed))
            .map(function (mydata, aKey) {
                return split(";", to!string(aKey));
            })
            .filter(fn (someKeys): count(Hash.filter(someKeys)) == count(myprimary))
            .reduce(function (myconditions, someKeys) use (myprimary) {
                myfields = array_map([_table, "aliasField"], myprimary);
                myconditions["OR"] ~= array_combine(myfields, someKeys);

                return myconditions;
            }, ["OR": ArrayData]);
        mymaybeExistentQuery = _table.find().where(myconditions);

        if (!empty(myindexed) && count(mymaybeExistentQuery.clause("where"))) {
            /** @var \Traversable<\UIM\Datasource\IEntity> myexistent * /
            myexistent = mymaybeExistentQuery.all();
            myexistent.each!((entity) {
                string key = entity.extract(myprimary).join(";");
                if (isSet(myindexed[key])) {
                    myoutput ~= this.merge(myentity, myindexed[key], options);
                    unset(myindexed[key]);
                }
            }
        }
        foreach ((new DCollection(myindexed)).append(mynew) as myvalue) {
            if (!isArray(myvalue)) {
                continue;
            }
            myoutput ~= this.one(myvalue, options);
        }
        return myoutput;
    }
    
    /**
     * Creates a new sub-marshaller and merges the associated data.
     * Params:
     * \UIM\Datasource\IEntity|array<\UIM\Datasource\IEntity>|null myoriginal The original entity
     * @param \ORM\Association myassoc The association to merge
     * @param IData aValue The array of data to hydrate. If not an array, this method will return null.
     * @param IData[string] options List of options.
     * /
    protected IEntity[] _mergeAssociation(
        IEntity|array|null myoriginal,
        Association myassoc,
        IData aValue,
        IData[string] options
    ) {
        if (!myoriginal) {
            return _marshalAssociation(myassoc, myvalue, options);
        }
        if (!isArray(myvalue)) {
            return null;
        }
        auto mytargetTable = myassoc.getTarget();
        auto mymarshaller = mytargetTable.marshaller();
        auto mytypes = [Association.ONE_TO_ONE, Association.MANY_TO_ONE];
        auto mytype = myassoc.type();
        if (in_array(mytype, mytypes, true)) {
            /** @var \UIM\Datasource\IEntity myoriginal * /
            return mymarshaller.merge(myoriginal, myvalue, options);
        }
        if (mytype == Association.MANY_TO_MANY) {
            /**
             * @var array<\UIM\Datasource\IEntity> myoriginal
             * @var \ORM\Association\BelongsToMany myassoc
             * /
            return mymarshaller._mergeBelongsToMany(myoriginal, myassoc, myvalue, options);
        }
        if (mytype == Association.ONE_TO_MANY) {
            myhasIds = array_key_exists("_ids", myvalue);
            myonlyIds = array_key_exists("onlyIds", options) && options["onlyIds"];
            if (myhasIds && isArray(myvalue["_ids"])) {
                return _loadAssociatedByIds(myassoc, myvalue["_ids"]);
            }
            if (myhasIds || myonlyIds) {
                return null;
            }
        }
        /**
         * @var array<\UIM\Datasource\IEntity> myoriginal
         * /
        return mymarshaller.mergeMany(myoriginal, myvalue, options);
    }
    
    /**
     * Creates a new sub-marshaller and merges the associated data for a BelongstoMany
     * association.
     * Params:
     * myoriginal = The original entities list.
     * @param \ORM\Association\BelongsToMany myassoc The association to marshall
     * @param array myvalue The data to hydrate
     * @param IData[string] options List of options.
     * /
    protected IEntity[] _mergeBelongsToMany(IEntity[] myoriginal, BelongsToMany associationToMarshall, array myvalue, IData[string] options) {
        myassociated = options["associated"] ?? [];

        myhasIds = array_key_exists("_ids", myvalue);
        myonlyIds = array_key_exists("onlyIds", options) && options["onlyIds"];

        if (myhasIds && isArray(myvalue["_ids"])) {
            return _loadAssociatedByIds(associationToMarshall, myvalue["_ids"]);
        }
        if (myhasIds || myonlyIds) {
            return null;
        }
        if (!empty(myassociated) && !in_array("_joinData", myassociated, true) && !isSet(myassociated["_joinData"])) {
            return this.mergeMany(myoriginal, myvalue, options);
        }
        return _mergeJoinData(myoriginal, associationToMarshall, myvalue, options);
    }
    
    /**
     * Merge the special _joinData property into the entity set.
     * Params:
     * array<\UIM\Datasource\IEntity> myoriginal The original entities list.
     * @param \ORM\Association\BelongsToMany myassoc The association to marshall
     * @param array myvalue The data to hydrate
     * @param IData[string] options List of options.
     * /
    protected IEntity[] _mergeJoinData(array myoriginal, BelongsToMany myassoc, array myvalue, IData[string] options) {
        myassociated = options["associated"] ?? [];
        myextra = null;
        foreach (myoriginal as myentity) {
            // Mark joinData as accessible so we can marshal it properly.
            myentity.setAccess("_joinData", true);

            myjoinData = myentity.get("_joinData");
            if (myjoinData && cast(IEntity)myjoinData) {
                myextra[spl_object_hash(myentity)] = myjoinData;
            }
        }
        myjoint = myassoc.junction();
        mymarshaller = myjoint.marshaller();

        mynested = null;
        if (isSet(myassociated["_joinData"])) {
            mynested = (array)myassociated["_joinData"];
        }
        options["accessibleFields"] = ["_joinData": BooleanData(true)];

        myrecords = this.mergeMany(myoriginal, myvalue, options);
        foreach (myrecords as myrecord) {
            myhash = spl_object_hash(myrecord);
            myvalue = myrecord.get("_joinData");

            // Already an entity, no further marshalling required.
            if (cast(IEntity)myvalue) {
                continue;
            }
            // Scalar data can"t be handled
            if (!isArray(myvalue)) {
                myrecord.unset("_joinData");
                continue;
            }
            // Marshal data into the old object, or make a new joinData object.
            if (isSet(myextra[myhash])) {
                myrecord.set("_joinData", mymarshaller.merge(myextra[myhash], myvalue, mynested));
            } else {
                myjoinData = mymarshaller.one(myvalue, mynested);
                myrecord.set("_joinData", myjoinData);
            }
        }
        return myrecords;
    }
    
    /**
     * dispatch Model.afterMarshal event.
     * Params:
     * \UIM\Datasource\IEntity myentity The entity that was marshaled.
     * @param array data readOnly mydata to use.
     * @param IData[string] options List of options that are readOnly.
     * /
    protected void dispatchAfterMarshal(IEntity myentity, array data, IData[string] optionData = null) {
        mydata = new ArrayObject(mydata);
        options = new ArrayObject(options);
       _table.dispatchEvent("Model.afterMarshal", compact("entity", "data", "options"));
    } */
}
