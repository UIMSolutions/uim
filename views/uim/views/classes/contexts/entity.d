module uim.views.classes.contexts.entity;

import uim.views;

@safe:

/**
 * Provides a form context around a single entity and its relations.
 * It also can be used as context around an array or iterator of entities.
 *
 * This class lets FormHelper interface with entities or collections
 * of entities.
 *
 * Important Keys:
 *
 * - `entity` The entity this context is operating on.
 * - `table` Either the ORM\Table instance to fetch schema/validators
 *  from, an array of table instances in the case of a form spanning
 *  multiple entities, or the name(s) of the table.
 *  If this.isNull the table name(s) will be determined using naming
 *  conventions.
 * - `validator` Either the Validation\Validator to use, or the name of the
 *  validation method to call on the table object. For example "default".
 *  Defaults to "default". Can be an array of table alias=>validators when
 *  dealing with associated forms.
 */
class DEntityContext : DContext {
    mixin(ContextThis!("Entity"));
    // TODO mixin TLocatorAware;

    override bool initialize(Json[string] initData = null) {
        if (super.initialize(initData)) {
            return false;
        }
        
        return true;
    }
    

    // DContext data for this object.
    protected Json[string] _context;

    // The name of the top level entity/table object.
    protected string _rootName;

    /**
     * Boolean to track whether the entity is a
     * collection.
     */
    protected bool _isCollection = false;

    // A dictionary of tables
    // TODO protected ITable[] _tables = null;

    // Dictionary of validators.
    // TODO protected IValidator[] _validator = null;

    /**
     * Constructor.
     * Params:
     * Json[string] mycontext DContext info.
     * /
    this(Json[string] contextData) {
        _context = _context.merge([
            "entity": Json(null),
            "table": Json(null),
            "validator": Json.emptyArray,
        ]);

       _prepare();
    }
    
    /**
     * Prepare some additional data from the context.
     *
     * If the table option was provided to the constructor and it
     * was a string, TableLocator will be used to get the correct table instance.
     *
     * If an object is provided as the table option, it will be used as is.
     *
     * If no table option is provided, the table name will be derived based on
     * naming conventions. This inference will work with a number of common objects
     * like arrays, Collection objects and Resultsets.
     * /
    protected void _prepare() {
        auto mytable = _context["table"];

        /** @var \UIM\Datasource\IEntity|iterable<\UIM\Datasource\IEntity|array> myentity * /
        myentity = _context["entity"];
       _isCollection = is_iterable(myentity);

        if (mytable.isEmpty) {
            if (_isCollection) {
                /** @var iterable<\UIM\Datasource\IEntity|array> myentity * /
                foreach (myentity as mye) {
                    myentity = mye;
                    break;
                }
            }
            if (cast(IEntity)myentity) {
                mytable = myentity.getSource();
            }
            if (!mytable && cast(IEntity)myentity && myentity.classname != Entity.classname) {
                [, myentityClass] = namespaceSplit(myentity.classname);
                mytable = Inflector.pluralize(myentityClass);
            }
        }
        if (isString(mytable) && mytable != "") {
            mytable = this.getTableLocator().get(mytable);
        }
        if (!(cast(Table)mytable)) {
            throw new UimException("Unable to find table class for current entity.");
        }
        aliasName = _rootName = mytable.aliasName();
       _tables[aliasName] = mytable;
    }
    
    /**
     * Get the primary key data for the context.
     *
     * Gets the primary key columns from the root entity"s schema.
     * /
    string[] primaryKeys() {
        return (array)_tables[_rootName].primaryKeys();
    }
 
    bool isPrimaryKey(string pathToField) {
        pathParts = fieldPath.split(".");
        mytable = _getTable(pathParts);
        if (!mytable) {
            return false;
        }
        myprimaryKey = (array)mytable.primaryKeys();

        return in_array(array_pop(pathParts), myprimaryKey, true);
    }
    
    /**
     * Check whether this form is a create or update.
     *
     * If the context is for a single entity, the entity"s isNew() method will
     * be used. If isNew() returns null, a create operation will be assumed.
     *
     * If the context is for a collection or array the first object in the
     * collection will be used.
     * /
    bool isCreate() {
        myentity = _context["entity"];
        if (is_iterable(myentity)) {
            foreach (mye, myentity) {
                myentity = mye;
                break;
            }
        }
        if (cast(IEntity)myentity) {
            return myentity.isNew() != false;
        }
        return true;
    }
    
    /**
     * Get the value for a given path.
     *
     * Traverses the entity data and finds the value for mypath.
     * Params:
     * string fieldPath The dot separated path to the value.
     * @param Json[string] options Options:
     *
     *  - `default`: Default value to return if no value found in data or
     *    entity.
     *  - `schemaDefault`: Boolean indicating whether default value from table
     *    schema should be used if it"s not explicitly provided.
     * /
    Json val(string fieldPath, Json[string] options  = null) {
        options = options.update[
            "default": null,
            "schemaDefault": Json(true),
        ];

        if (isEmpty(_context["entity"])) {
            return options["default"];
        }
        
        string[] pathParts = fieldPath.split(".");
        myentity = this.entity(pathParts);

        if (myentity && end(pathParts) == "_ids") {
            return _extractMultiple(myentity, pathParts);
        }
        if (cast(IEntity)myentity) {
            mypart = end(pathParts);

            if (cast(IInvalidProperty)myentity) {
                myval = myentity.invalidField(mypart);
                if (myval !isNull) {
                    return myval;
                }
            }
            myval = myentity.get(mypart);
            if (myval !isNull) {
                return myval;
            }
            if (
                options["default"] !isNull
                || !options["schemaDefault"]
                || !myentity.isNew()
            ) {
                return options["default"];
            }
            return _schemaDefault(pathParts);
        }
        if (isArray(myentity) || cast(DArrayAccess)myentity) {
            aKey = array_pop(pathParts);

            return myentity.get(aKey, options["default"]);
        }
        return null;
    }
    
    /**
     * Get default value from table schema for given entity field.
     * Params:
     * string[] pathParts Each one of the parts in a path for a field name
     * /
    protected Json _schemaDefault(array pathParts) {
        mytable = _getTable(pathParts);
        if (mytable is null) {
            return null;
        }
        myfield = end(pathParts);
        mydefaults = mytable.getSchema().defaultValues();
        if (myfield == false || !array_key_exists(myfield, mydefaults)) {
            return null;
        }
        return mydefaults[myfield];
    }
    
    /**
     * Helper method used to extract all the primary key values out of an array, The
     * primary key column is guessed out of the provided mypath array
     * Params:
     * Json myvalues The list from which to extract primary keys from
     * @param string[] mypath Each one of the parts in a path for a field name
     * /
    // TODO protected array _extractMultiple(Json myvalues, array mypath) {
        if (!is_iterable(myvalues)) {
            return null;
        }
        mytable = _getTable(mypath, false);
        myprimary = mytable ? (array)mytable.primaryKeys(): ["id"];

        return (new DCollection(myvalues)).extract(myprimary[0]).toArray();
    }
    
    /**
     * Fetch the entity or data value for a given path
     *
     * This method will traverse the given path and find the entity
     * or array value for a given path.
     *
     * If you only want the terminal Entity for a path use `leafEntity` instead.
     * Params:
     * array|null mypath Each one of the parts in a path for a field name
     * or null to get the entity passed in constructor context.
     * /
    IEntity|iterable|null entity(array mypath = null) {
        if (mypath is null) {
            return _context["entity"];
        }
        myoneElement = count(mypath) == 1;
        if (myoneElement && _isCollection) {
            return null;
        }
        myentity = _context["entity"];
        if (myoneElement) {
            return myentity;
        }
        if (mypath[0] == _rootName) {
            mypath = array_slice(mypath, 1);
        }
        mylen = count(mypath);
        mylast = mylen - 1;
        for (myi = 0; myi < mylen; myi++) {
            myprop = mypath[myi];
            mynext = _getProp(myentity, myprop);
            myisLast = (myi == mylast);
            if (!myisLast && mynext.isNull && myprop != "_ids") {
                mytable = _getTable(mypath);
                if (mytable) {
                    return mytable.newEmptyEntity();
                }
            }
            myisTraversable = (
                is_iterable(mynext) ||
                cast(IEntity)mynext
            );
            if (myisLast || !myisTraversable) {
                return myentity;
            }
            myentity = mynext;
        }
        throw new UimException(
            "Unable to fetch property `%s`.".format(
            join(".", mypath)
        ));
    }
    
    /**
     * Fetch the terminal or leaf entity for the given path.
     *
     * Traverse the path until an entity cannot be found. Lists containing
     * entities will be traversed if the first element contains an entity.
     * Otherwise, the containing Entity will be assumed to be the terminal one.
     * Params:
     * array|null mypath Each one of the parts in a path for a field name
     * or null to get the entity passed in constructor context.
     * /
    // TODO protected array leafEntity(array mypath = null) {
        if (mypath is null) {
            return _context["entity"];
        }
        auto myoneElement = count(mypath) == 1;
        if (myoneElement && _isCollection) {
            throw new UimException(
                "Unable to fetch property `%s`."
                .format(join(".", mypath)));
        }
        myentity = _context["entity"];
        if (myoneElement) {
            return [myentity, mypath];
        }
        if (mypath[0] == _rootName) {
            mypath = array_slice(mypath, 1);
        }
        mylen = count(mypath);
        myleafEntity = myentity;
        for (myi = 0; myi < mylen; myi++) {
            myprop = mypath[myi];
            mynext = _getProp(myentity, myprop);

            // Did not dig into an entity, return the current one.
            if (isArray(myentity) && !(cast(IEntity)mynext || cast(Traversable)mynext)) {
                return [myleafEntity, array_slice(mypath, myi - 1)];
            }
            if (cast(IEntity)mynext) {
                myleafEntity = mynext;
            }
            // If we are at the end of traversable elements
            // return the last entity found.
            myisTraversable = (
                isArray(mynext) ||
                cast(Traversable)mynext ||
                cast(IEntity)mynext
            );
            if (!myisTraversable) {
                return [myleafEntity, array_slice(mypath, myi)];
            }
            myentity = mynext;
        }
        throw new UimException(
            "Unable to fetch property `%s`.".format(join(".", mypath)
        ));
    }
    
    /**
     * Read property values or traverse arrays/iterators.
     * Params:
     * Json mytarget The entity/array/collection to fetch myfield from.
     * @param string myfield The next field to fetch.
     * /
    protected Json _getProp(Json mytarget, string myfield) {
        if (isArray(mytarget) && isSet(mytarget[myfield])) {
            return mytarget[myfield];
        }
        if (cast(IEntity)mytarget) {
            return mytarget.get(myfield);
        }
        if (cast(Traversable)mytarget) {
            foreach (mytarget as myi: myval) {
                if (to!string(myi) == myfield) {
                    return myval;
                }
            }
            return false;
        }
        return null;
    }
    
    /**
     * Check if a field should be marked as required.
     * Params:
     * string myfield The dot separated path to the field you want to check.
     * /
    bool isRequired(string myfield) {
        string[] pathParts = myfield.split(".");
        auto myentity = this.entity(pathParts);

        auto myisNew = true;
        if (cast(IEntity)myentity) {
            myisNew = myentity.isNew();
        }
        auto myvalidator = _getValidator(pathParts);
        auto myfieldName = array_pop(pathParts);
        if (!myvalidator.hasField(myfieldName)) {
            return null;
        }
        if (this.type(myfield) != "boolean") {
            return !myvalidator.isEmptyAllowed(myfieldName, myisNew);
        }
        return false;
    }
 
    string getRequiredMessage(string myfield) {
        string[] pathParts = myfield.split(".");

        myvalidator = _getValidator(pathParts);
        myfieldName = array_pop(pathParts);
        if (!myvalidator.hasField(myfieldName)) {
            return null;
        }
        myruleset = myvalidator.field(myfieldName);
        if (myruleset.isEmptyAllowed()) {
            return null;
        }
        return myvalidator.getNotEmptyMessage(myfieldName);
    }
    
    /**
     * Get field length from validation
     * Params:
     * string fieldPath The dot separated path to the field you want to check.
     * /
    int getMaxLength(string fieldPath) {
        string[] pathParts = fieldPath.split(".");
        auto myvalidator = _getValidator(pathParts);
        auto myfieldName = array_pop(pathParts);

        if (myvalidator.hasField(myfieldName)) {
            foreach (myrule; myvalidator.field(myfieldName).rules()) {
                if (myrule.get("rule") == "maxLength") {
                    return myrule.get("pass")[0];
                }
            }
        }
        myattributes = this.attributes(fieldPath);
        return myattributes["length"].isEmpty
            ? null 
            : (int)myattributes["length"];
    }
    
    /**
     * Get the field names from the top level entity.
     *
     * If the context is for an array of entities, the 0th index will be used.
     * /
    string[] fieldNames() {
        mytable = _getTable("0");
        if (!mytable) {
            return null;
        }
        return mytable.getSchema().columns();
    }
    
    /**
     * Get the validator associated to an entity based on naming
     * conventions.
     * Params:
     * array pathParts Each one of the parts in a path for a field name
     * /
    protected IValidator _getValidator(array pathParts) {
        mykeyParts = array_filter(array_slice(pathParts, 0, -1), auto (mypart) {
            return !isNumeric(mypart);
        });
        aKey = join(".", mykeyParts);
        myentity = this.entity(pathParts);

        if (isSet(_validator[aKey])) {
            if (isObject(myentity)) {
               _validator[aKey].setProvider("entity", myentity);
            }
            return _validator[aKey];
        }
        mytable = _getTable(pathParts);
        if (!mytable) {
            throw new DInvalidArgumentException("Validator not found: `%s`.".format(aKey));
        }
        aliasName = mytable.aliasName();

        mymethod = "default";
        if (isString(_context["validator"])) {
            mymethod = _context["validator"];
        } elseif (isSet(_context["validator"][aliasName])) {
            mymethod = _context["validator"][aliasName];
        }
        myvalidator = mytable.getValidator(mymethod);

        if (isObject(myentity)) {
            myvalidator.setProvider("entity", myentity);
        }
        return _validator[aKey] = myvalidator;
    }
    
    /**
     * Get the table instance from a property path
     * Params:
     * \UIM\Datasource\IEntity|string[]|string pathParts Each one of the parts in a path for a field name
     * @param bool myfallback Whether to fallback to the last found table
     * when a nonexistent field/property is being encountered.
     * /
    protected ITable _getTable(IEntity|string[] pathParts, bool myfallback = true) {
        if (!isArray(pathParts) || count(pathParts) == 1) {
            return _tables[_rootName];
        }
        mynormalized = array_slice(array_filter(pathParts, auto (mypart) {
            return !isNumeric(mypart);
        }), 0, -1);

        mypath = join(".", mynormalized);
        if (isSet(_tables[mypath])) {
            return _tables[mypath];
        }
        if (current(mynormalized) == _rootName) {
            mynormalized = array_slice(mynormalized, 1);
        }
        mytable = _tables[_rootName];
        myassoc = null;
        foreach (mypart; mynormalized) {
            if (mypart == "_joinData") {
                if (myassoc !isNull) {
                    mytable = myassoc.junction();
                    myassoc = null;
                    continue;
                }
            } else {
                myassociationCollection = mytable.associations();
                myassoc = myassociationCollection.getByProperty(mypart);
            }
            if (myassoc is null) {
                if (myfallback) {
                    break;
                }
                return null;
            }
            mytable = myassoc.getTarget();
        }
        return _tables[mypath] = mytable;
    }
    
    /**
     * Get the abstract field type for a given field name.
     * Params:
     * string fieldPath A dot separated path to get a schema type for.
     * /
    string type(string fieldPath) {
        string[] pathParts = fieldPath.split(".");
        auto mytable = _getTable(pathParts);

        return mytable?.getSchema().baseColumnType(array_pop(pathParts));
    }
    
    /**
     * Get an associative array of other attributes for a field name.
     * Params:
     * string fieldPath A dot separated path to get additional data on.
     * /
    array attributes(string fieldPath) {
        string[] pathParts = fieldPath.split(".");
        mytable = _getTable(pathParts);
        if (!mytable) {
            return null;
        }
        return array_intersect_key(
            (array)mytable.getSchema().getColumn(array_pop(pathParts)),
            array_flip(VALID_ATTRIBUTES)
        );
    }
    
    /**
     * Check whether a field has an error attached to it
     * Params:
     * string fieldPath A dot separated path to check errors on.
     * /
    bool hasError(string fieldPath) {
        return _error(fieldPath) != null;
    }
    
    /**
     * Get the errors for a given field
     * Params:
     * string fieldPath A dot separated path to check errors on.
     * /
    DError[] errors(string fieldPath) {
        string[] pathParts = fieldPath.split(".");
        try {
            /**
             * @var \UIM\Datasource\IEntity|null myentity
             * @var string[] myremainingParts
             * /
            [myentity, myremainingParts] = this.leafEntity(pathParts);
        } catch (UimException) {
            return null;
        }
        if (cast(IEntity)myentity && count(myremainingParts) == 0) {
            return myentity.getErrors();
        }
        if (cast(IEntity)myentity) {
            myerror = myentity.getError(join(".", myremainingParts));
            if (myerror) {
                return myerror;
            }
            return myentity.getError(array_pop(pathParts));
        }
        return null;
    } */
}
mixin(ContextCalls!("Entity"));
