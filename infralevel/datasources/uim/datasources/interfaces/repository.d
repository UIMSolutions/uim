module uim.datasources.interfaces.repository;

import uim.datasources;

@safe:
    /**
 * Describes the methods that any class representing a data storage should
 * comply with.
 */
interface IDatasourceRepository : IObject {
    /* // Get / Set the repository alias name.
    mixin(IProperty!("string", "aliasName"));

    // Get / Set the table registry key used to create this table instance.
    mixin(IProperty!("string", "registryKey"));
    
    /**
     * Alias a field with the repository`s current alias.
     *
     * If field is already aliased it will result in no-op.
     * /
    string aliasField(string fieldAliasName);

    // Test to see if a Repository has a specific field/column.
    bool hasField(string fieldName);

    /**
     * Creates a new Query for this repository and applies some defaults based on the
     * type of search that was selected.
     * /
    IQuery find(string queryType = "all", Json someArguments);

    /**
     * Returns a single record after finding it by its primary key, if no record is
     * found this method throws an exception.
     *
     * ### Example:
     *
     * ```
     * anId = 10;
     * article = articles.get(anId);
     *
     * article = articles.get(anId, ["contain": ["Comments]]);
     * ```
     * /
    IDatasourceEntity get(
        Json primaryKeys,
        string[] finders = "all",
        /* ICache| * / string cache = null,
        /* Closure * / string cacheKey = null,
        Json[] someArguments
   );

    // Creates a new Query instance for this repository
    IQuery query();

    /**
     * Update all matching records.
     *
     * Sets the fields to the provided values based on conditions.
     * This method will *not* trigger beforeSave/afterSave events. If you need those
     * first load a collection of records and update them.
     * /
    int updateAll(/* Closure * / string[] fieldNames,/* IClosure * / string[] conditions);

    /**
     * Deletes all records matching the provided conditions.
     *
     * This method will *not* trigger beforeDelete/afterDelete events. If you
     * need those first load a collection of records and delete them.
     *
     * This method will *not* execute on associations' `cascade` attribute. You should
     * use database foreign keys + ON CASCADE rules if you need cascading deletes combined
     * with this method.
     * Params:
     * \/*Closure|* / string[] conditions Conditions to be used, accepts anything Query.where()
     * can take.
     * /
    int deleteAll(/* Closure * / string[] conditions);

    /**
     * Returns true if there is any record in this repository matching the specified
     * conditions.
     * Params:
     * \/*Closure|* / string[] conditions list of conditions to pass to the query
     * /
   bool hasKey(/* Closure * / string[] conditions);

    /**
     * Persists an entity based on the fields that are marked as dirty and
     * returns the same entity after a successful save or false in case
     * of any error.
     * /
    IDatasourceEntity|false save(IDatasourceEntity entity, Json[string] options = null);

    /**
     * Delete a single entity.
     *
     * Deletes an entity and possibly related associations from the database
     * based on the 'dependent' option used when defining the association.
     * Params:
     * \UIM\Datasource\IDatasourceEntity entity The entity to remove.
         * /
    bool removeKey(IDatasourceEntity entity, Json[string] options = null);

    /**
     * This creates a new entity object.
     *
     * Careful: This does not trigger any field validation.
     * This entity can be persisted without validation error as empty record.
     * Always patch in required fields before saving.
     * /
    IDatasourceEntity newEmptyEntity();

    /**
     * Create a new entity + associated entities from an array.
     *
     * This is most useful when hydrating request data back into entities.
     * For example, in your controller code:
     *
     * ```
     * article = this.Articles.newEntity(this.request[));
     * ```
     *
     * The hydrated entity will correctly do an insert/update based
     * on the primary key data existing in the database when the entity
     * is saved. Until the entity is saved, it will be a detached record.
     * /
    IDatasourceEntity newEntity(Json[string] dataForEntity, Json[string] options = null);

    /**
     * Create a list of entities + associated entities from an array.
     *
     * This is most useful when hydrating request data back into entities.
     * For example, in your controller code:
     * ```
     * articles = this.Articles.newEntities(this.request[));
     * ```
     * The hydrated entities can then be iterated and saved.
     * /
    IDatasourceEntity[] newEntities(Json[string] buildData, Json[string] optionsForHydration = null);

    /**
     * Merges the passed `someData` into `entity` respecting the accessible
     * fields configured on the entity. Returns the same entity after being
     * altered.
     *
     * This is most useful when editing an existing entity using request data:
     *
     * ```
     * article = this.Articles.patchEntity(article, this.request[));
     * ```
     * /
    IDatasourceEntity patchEntity(IDatasourceEntity entity, Json[string] data, Json[string] options = null);

    /**
     * Merges each of the elements passed in `someData` into the entities
     * found in `entities` respecting the accessible fields configured on the entities.
     * Merging is done by matching the primary key in each of the elements in `someData`
     * and `entities`.
     *
     * This is most useful when editing a list of existing entities using request data:
     *
     * ```
     * article = this.Articles.patchEntities(articles, this.request[));
     * ```
     * /
    IDatasourceEntity[] patchEntities(IDatasourceEntity[] entities, Json[string] dataToMerge, Json[string] optionsForHydration = null);
 */}