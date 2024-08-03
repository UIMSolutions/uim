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
 * from, an array of table instances in the case of a form spanning
 * multiple entities, or the name(s) of the table.
 * If this.isNull the table name(s) will be determined using naming
 * conventions.
 * - `validator` Either the Validation\Validator to use, or the name of the
 * validation method to call on the table object. For example "default".
 * Defaults to "default". Can be an array of table alias=>validators when
 * dealing with associated forms.
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
     .
     * Params:
     * Json[string] mycontext DContext info.
     */
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
     */
    protected void _prepare() {
        auto mytable = _context["table"];

        /** @var \UIM\Datasource\IEntity|iterable<\UIM\Datasource\IEntity|array> myentity */
        myentity = _context["entity"];
       _isCollection = is_iterable(myentity);

        if (mytable.isEmpty) {
            if (_isCollection) {
                /** @var iterable<\UIM\Datasource\IEntity|array> myentity */
                foreach (exception; myentity) {
                    myentity = exception;
                    break;
                }
            }
            if (cast(IEntity)myentity) {
                mytable = myentity.source();
            }
            if (!mytable && cast(IEntity)myentity && myentity.classname != Entity.classname) {
                [, myentityClass] = namespaceSplit(myentity.classname);
                mytable = Inflector.pluralize(myentityClass);
            }
        }
        if (isString(mytable) && mytable != "") {
            mytable = getTableLocator().get(mytable);
        }
        if (!(cast(Table)mytable)) {
            throw new DException("Unable to find table class for current entity.");
        }
        aliasName = _rootName = mytable.aliasName();
       _tables[aliasName] = mytable;
    }
    
    /**
     * Get the primary key data for the context.
     * Gets the primary key columns from the root entity"s schema.
     */
    string[] primaryKeys() {
        return _tables[_rootName].primaryKeys();
    }
 
    bool isPrimaryKey(string pathToField) {
        auto pathParts = fieldPath.split(".");
        auto mytable = _getTable(pathParts);
        if (!mytable) {
            return false;
        }

        string[] primaryKeys = mytable.primaryKeys();
        return isIn(pathParts.pop(), primaryKeys, true);
    }
    
    /**
     * Check whether this form is a create or update.
     *
     * If the context is for a single entity, the entity"s isNew() method will
     * be used. If isNew() returns null, a create operation will be assumed.
     *
     * If the context is for a collection or array the first object in the
     * collection will be used.
     */
    bool isCreate() {
        myentity = _context["entity"];
        if (is_iterable(myentity)) {
            foreach (exception, myentity) {
                myentity = exception;
                break;
            }
        }

        return cast(IEntity)myentity
            ? myentity.isNew() == true
            : true;
    }
    
    /**
     * Get the value for a given path.
     *
     * Traverses the entity data and finds the value for mypath.
     * Params:
     * string fieldPath The dot separated path to the value.
     */
    Json val(string fieldPath, Json[string] options  = null) {
        auto updatedOptions = options.merge([
            "default": Json(null),
            "schemaDefault": true.toJson,
        ]);

        if (_context.isEmpty("entity")) {
            return updatedoptions.get("default"];
        }
        
        string[] pathParts = fieldPath.split(".");
        
        auto myentity = entity(pathParts);
        if (myentity && end(pathParts) == "_ids") {
            return _extractMultiple(myentity, pathParts);
        }
        if (cast(IEntity)myentity) {
            auto mypart = end(pathParts);
            if (cast(IInvalidProperty)myentity) {
                if (auto value = myentity.invalidField(mypart))
                    return value;
                }
            }
            
            if (auto value = myentity.get(mypart)) {
                return value;
            }
            if (
                updatedoptions.hasKey("default")
                || !updatedoptions.get("schemaDefault")
                || !myentity.isNew()
           ) {
                return updatedoptions.get("default");
            }
            return _schemaDefault(pathParts);
        }
        if (isArray(myentity) || cast(DArrayAccess)myentity) {
            string key = pathParts.pop();
            return myentity.get(key, updatedoptions.get("default"));
        }
        return null;
    }
    
    /**
     * Get default value from table schema for given entity field.
     * Params:
     * string[] pathParts Each one of the parts in a path for a field name
     */
    protected Json _schemaDefault(Json[string] pathParts) {
        auto mytable = _getTable(pathParts);
        if (mytable.isNull) {
            return null;
        }
        
        auto fieldName = end(pathParts);
        auto mydefaults = mytable.getSchema().defaultValues();
        if (fieldName == false || !array_key_hasKey(fieldName, mydefaults)) {
            return null;
        }
        return mydefaults[fieldName];
    }
    
    /**
     * Helper method used to extract all the primary key values out of an array, The
     * primary key column is guessed out of the provided mypath array
     * Params:
     * Json myvalues The list from which to extract primary keys from
     */
    protected Json[string] _extractMultiple(Json myvalues, Json[string] mypaths) {
        if (!is_iterable(myvalues)) {
            return null;
        }

        auto mytable = _getTable(mypath, false);
        auto myprimary = mytable ? mytable.primaryKeys(): ["id"];
        return (new DCollection(myvalues)).extract(myprimary[0]).toJString();
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
     */
    IEntity|iterable|null entity(Json[string] mypath = null) {
        if (mypath.isNull) {
            return _context["entity"];
        }

        auto isOneElement = mypath.length == 1;
        if (isOneElement && _isCollection) {
            return null;
        }
        myentity = _context["entity"];
        if (isOneElement) {
            return myentity;
        }
        if (mypath[0] == _rootName) {
            mypath = mypath.slice(1);
        }
        mylen = count(mypath);
        mylast = mylen - 1;
        for (index = 0; index < mylen; index++) {
            myprop = mypath[index];
            mynext = _getProp(myentity, myprop);
            myisLast = (index == mylast);
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
        throw new DException(
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
     */
    protected Json[string] leafEntity(Json[string] mypath = null) {
        if (mypath.length == 0) {
            return _context["entity"];
        }

        bool isOneElement = mypath.length == 1;
        if (isOneElement && _isCollection) {
            throw new DException(
                "Unable to fetch property `%s`."
                .format(join(".", mypath)));
        }
        
        auto myentity = _context["entity"];
        if (isOneElement) {
            return [myentity, mypath];
        }
        if (mypath[0] == _rootName) {
            mypath = mypath.slice(, 1);
        }
        
        auto pathLength = mypath.length;
        auto myleafEntity = myentity;
        for (index = 0; index < mylen; index++) {
            auto myprop = mypath[index];
            auto mynext = _getProp(myentity, myprop);

            // Did not dig into an entity, return the current one.
            if (myentity.isArray && !(cast(IEntity)mynext || cast(Traversable)mynext)) {
                return [myleafEntity, mypath.slice(index - 1)];
            }
            if (cast(IEntity)mynext) {
                myleafEntity = mynext;
            }
            // If we are at the end of traversable elements
            // return the last entity found.
            auto myisTraversable = (
                mynext.isArray ||
                cast(Traversable)mynext ||
                cast(IEntity)mynext
           );
            if (!myisTraversable) {
                return [myleafEntity, mypath.slice(index)];
            }
            myentity = mynext;
        }
        throw new DException(
            "Unable to fetch property `%s`.".format(join(".", mypath)
       ));
    }
    
    /**
     * Read property values or traverse arrays/iterators.
     * Params:
     * Json mytarget The entity/array/collection to fetch fieldName from.
     */
    protected Json _getProp(IEntity mytarget, string fieldName) {
        return myTarget is null
            ? Json(null)
            : mytarget.get(fieldName);
    }
    
    protected Json _getProp(Json mytarget, string fieldName) {
        if (mytarget.isArray && mytarget.hasKey(fieldName)) {
            return mytarget[fieldName];
        }
        if (cast(Traversable)mytarget) {
            foreach (index, myval; mytarget) {
                if (to!string(index) == fieldName) {
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
     * string fieldName The dot separated path to the field you want to check.
     */
    bool isRequired(string fieldName) {
        string[] pathParts = fieldName.split(".");
        auto myentity = entity(pathParts);

        auto myisNew = true;
        if (cast(IEntity)myentity) {
            myisNew = myentity.isNew();
        }
        auto myvalidator = _getValidator(pathParts);
        auto fieldName = pathParts.pop();
        if (!myvalidator.hasField(fieldName)) {
            return null;
        }

        return this.type(fieldName) != "boolean"
            ? !myvalidator.isEmptyAllowed(fieldName, myisNew)
            : false;
    }
 
    string getRequiredMessage(string fieldName) {
        string[] pathParts = fieldName.split(".");

        myvalidator = _getValidator(pathParts);
        fieldName = pathParts.pop();
        if (!myvalidator.hasField(fieldName)) {
            return null;
        }

        auto myruleset = myvalidator.field(fieldName);
        return myruleset.isEmptyAllowed()
            ? null
            : myvalidator.getNotEmptyMessage(fieldName);
    }
    
    /**
     * Get field length from validation
     * Params:
     * string fieldPath The dot separated path to the field you want to check.
     */
    int getMaxLength(string fieldPath) {
        string[] pathParts = fieldPath.split(".");
        auto myvalidator = _getValidator(pathParts);
        auto fieldName = pathParts.pop();

        if (myvalidator.hasField(fieldName)) {
            foreach (myrule; myvalidator.field(fieldName).rules()) {
                if (myrule.getString("rule") == "maxLength") {
                    return myrule.get("pass")[0];
                }
            }
        }

        auto myattributes = this.attributes(fieldPath);
        return myattributes.isEmpty("length")
            ? null 
            : myattributes.getInteger("length");
    }
    
    /**
     * Get the field names from the top level entity.
     *
     * If the context is for an array of entities, the 0th index will be used.
     */
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
     * Json[string] pathParts Each one of the parts in a path for a field name
     */
    protected IValidator _getValidator(Json[string] pathParts) {
        string[] mykeyParts = filterValues(pathParts.slice(0, -1), auto (mypart) {
            return !isNumeric(mypart);
        });
        string aKey = mykeyParts.join(".");
        auto myentity = entity(pathParts);

        if (_validator.hasKey(aKey)) {
            if (isObject(myentity)) {
               _validator[aKey].setProvider("entity", myentity);
            }
            return _validator[aKey];
        }
        
        auto mytable = _getTable(pathParts);
        if (!mytable) {
            throw new DInvalidArgumentException("Validator not found: `%s`.".format(aKey));
        }
        string aliasName = mytable.aliasName();
        string mymethod = "default";
        if (isString(_context["validator"])) {
            mymethod = _context["validator"];
        } else if (_context.hasKey("validator."~aliasName)) {
            mymethod = _context["validator"][aliasName];
        }
        
        auto myvalidator = mytable.getValidator(mymethod);
        if (isObject(myentity)) {
            myvalidator.setProvider("entity", myentity);
        }
        return _validator[aKey] = myvalidator;
    }
    
    //  Get the table instance from a property path
    protected ITable _getTable(/* IEntity| */string[] pathParts, bool isFallback = true) {
        if (!isArray(pathParts) || count(pathParts) == 1) {
            return _tables[_rootName];
        }

        string[] mynormalized = pathParts.filter!(part => !isNumeric(mypart)).array.slice(0, -1);

        auto mypath = mynormalized.join(".");
        if (_tables.hasKey(mypath)) {
            return _tables[mypath];
        }
        if (currentValue(mynormalized) == _rootName) {
            mynormalized = mynormalized.slice(1);
        }
        auto mytable = _tables[_rootName];
        auto myassoc = null;
        foreach (mypart; mynormalized) {
            if (mypart == "_joinData") {
                if (myassoc !is null) {
                    mytable = myassoc.junction();
                    myassoc = null;
                    continue;
                }
            } else {
                myassociationCollection = mytable.associations();
                myassoc = myassociationCollection.getByProperty(mypart);
            }
            if (myassoc.isNull) {
                if (isFallback) {
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
     */
    string type(string fieldPath) {
        string[] pathParts = fieldPath.split(".");
        auto mytable = _getTable(pathParts);

        return mytable?.getSchema().baseColumnType(pathParts.pop());
    }
    
    /**
     * Get an associative array of other attributes for a field name.
     * Params:
     * string fieldPath A dot separated path to get additional data on.
     */
    Json[string] attributes(string fieldPath) {
        string[] pathParts = fieldPath.split(".");
        mytable = _getTable(pathParts);
        if (!mytable) {
            return null;
        }
        return intersectinternalKey(
            (array)mytable.getSchema().getColumn(pathParts.pop()),
            array_flip(VALID_ATTRIBUTES)
       );
    }
    
    /**
     * Check whether a field has an error attached to it
     * Params:
     * string fieldPath A dot separated path to check errors on.
     */
    bool hasError(string fieldPath) {
        return _error(fieldPath) != null;
    }
    
    /**
     * Get the errors for a given field
     * Params:
     * string fieldPath A dot separated path to check errors on.
     */
    DError[] errors(string fieldPath) {
        string[] pathParts = fieldPath.split(".");
        try {
            /**
             * @var \UIM\Datasource\IEntity|null myentity
             * @var string[] myremainingParts
             */
            [myentity, myremainingParts] = this.leafEntity(pathParts);
        } catch (DException) {
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
            return myentity.getError(pathParts.pop());
        }
        return null;
    }
}
mixin(ContextCalls!("Entity"));
