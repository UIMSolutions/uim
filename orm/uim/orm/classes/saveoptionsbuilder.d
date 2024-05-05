/*********************************************************************************************************
	Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.orm.saveoptionsbuilder;

import uim.orm;

@safe:

/* use ArrayObject;
 */
/**
 * OOP style Save Option Builder.
 *
 * This allows you to build options to save entities in a OOP style and helps
 * you to avoid mistakes by validating the options as you build them.
 *
 * @see DORMdatasources.RulesChecker
 * @deprecated 4.4.0 Use a normal array for options instead.
 */
class DSaveOptionsBuilder { /*}: ArrayObject {
    mixin TAssociationsNormalizer;

    /**
     * Options
     *
     * @var array<string, mixed>
     * /
    protected _options = null;

    /**
     * Table object.
     *
     * @var DORMTable
     * /
    protected _table;

    /**
     * Constructor.
     *
     * @param DORMDORMTable aTable A table instance.
     * @param array<string, mixed> options Options to parse when instantiating.
     * /
    this(DORMTable aTable, Json[string] optionData = null) {
        _table = table;
        this.parseArrayOptions(options);

        super(();
    }

    /**
     * Takes an options array and populates the option object with the data.
     *
     * This can be used to turn an options array into the object.
     *
     * @throws \InvalidArgumentException If a given option key does not exist.
     * @param array<string, mixed> array Options array.
     * @return this
     * /
    function parseArrayOptions(Json[string] array) {
        foreach (Json[string] as key: value) {
            this.{key}(value);
        }

        return this;
    }

    /**
     * Set associated options.
     *
     * @param array|string associated String or array of associations.
     * @return this
     * /
    function associated(associated) {
        associated = _normalizeAssociations(associated);
        _associated(_table, associated);
        _options["associated"] = associated;

        return this;
    }

    /**
     * Checks that the associations exists recursively.
     *
     * @param DORMDORMTable aTable Table object.
     * @param Json[string] associations An associations array.
     * /
    protected void _associated(DORMTable aTable, Json[string] associations) {
        foreach (associations as key: associated) {
            if (is_int(key)) {
                _checkAssociation(table, associated);
                continue;
            }
            _checkAssociation(table, key);
            if (isset(associated["associated"])) {
                _associated(table.getAssociation(key).getTarget(), associated["associated"]);
                continue;
            }
        }
    }

    /**
     * Checks if an association exists.
     *
     * @throws \RuntimeException If no such association exists for the given table.
     * @param DORMDORMTable aTable Table object.
     * @param string association Association name.
     * /
    protected void _checkAssociation(DORMTable aTable, string association) {
        if (!table.associations().has(association)) {
            throw new DRuntimeException(sprintf(
                "Table `%s` is not associated with `%s`",
                get_class(table),
                association
            ));
        }
    }

    /**
     * Set the guard option.
     *
     * @param bool guard Guard the properties or not.
     * @return this
     * /
    function guard(bool guard) {
        _options["guard"] = guard;

        return this;
    }

    /**
     * Set the validation rule set to use.
     *
     * @param string validate Name of the validation rule set to use.
     * @return this
     * /
    function validate(string validate) {
        _table.getValidator(validate);
        _options["validate"] = validate;

        return this;
    }

    /**
     * Set check existing option.
     *
     * @param bool checkExisting Guard the properties or not.
     * @return this
     * /
    function checkExisting(bool checkExisting) {
        _options["checkExisting"] = checkExisting;

        return this;
    }

    /**
     * Option to check the rules.
     *
     * @param bool checkRules Check the rules or not.
     * @return this
     * /
    function checkRules(bool checkRules) {
        _options["checkRules"] = checkRules;

        return this;
    }

    /**
     * Sets the atomic option.
     *
     * @param bool atomic Atomic or not.
     * @return this
     * /
    function atomic(bool atomic) {
        _options["atomic"] = atomic;

        return this;
    }

    /**
     * @return array<string, mixed>
     * /
    Json[string] toDataArray() {
        return _options;
    }

    /**
     * Setting custom options.
     *
     * @param string option Option key.
     * @param mixed value Option value.
     * @return this
     * /
    function set(string option, value) {
        if (method_exists(this, option)) {
            return _{option}(value);
        }
        _options[option] = value;

        return this;
    } */
}
