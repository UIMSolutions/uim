/*********************************************************************************************************
	Copyright: © 2015-2023 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module datasources.uim.datasources.interfaces.repositoryInterface;

/**
 * Describes the methods that any class representing a data storage should
 * comply with.
 */
interface IRepository
{
    /**
     * Sets the repository alias.
     *
     * @param string alias Table alias
     * @return this
     */
    function setAlias(string alias);

    // Returns the repository alias.
    string getAlias();

    /**
     * Sets the table registry key used to create this table instance.
     *
     * @param string registryAlias The key used to access this object.
     * @return this
     */
    function setRegistryAlias(string registryAlias);

    // Returns the table registry key used to create this table instance.
    string getRegistryAlias();

    /**
     * Test to see if a Repository has a specific field/column.
     *
     * @param string field The field to check for.
     * @return bool True if the field exists, false if it does not.
     */
    bool hasField(string field);

    /**
     * Creates a new Query for this repository and applies some defaults based on the
     * type of search that was selected.
     *
     * @param string type the type of query to perform
     * @param array<string, mixed> options An array that will be passed to Query::applyOptions()
     * @return uim.Datasource\IQuery
     */
    function find(string type = "all", STRINGAA someOptions = null);

    /**
     * Returns a single record after finding it by its primary key, if no record is
     * found this method throws an exception.
     *
     * ### Example:
     *
     * ```
     * id = 10;
     * article = articles.get(id);
     *
     * article = articles.get(id, ["contain": ["Comments]]);
     * ```
     *
     * @param mixed primaryKey primary key value to find
     * @param array<string, mixed> options options accepted by `Table::find()`
     * @throws uim.Datasource\exceptions.RecordNotFoundException if the record with such id
     * could not be found
     * @return uim.Datasource\IEntity
     * @see uim.datasources.IRepository::find()
     */
    function get(primaryKey, STRINGAA someOptions = null): IEntity;

    /**
     * Creates a new Query instance for this repository
     *
     * @return uim.Datasource\IQuery
     */
    function query();

    /**
     * Update all matching records.
     *
     * Sets the fields to the provided values based on conditions.
     * This method will *not* trigger beforeSave/afterSave events. If you need those
     * first load a collection of records and update them.
     *
     * @param uim.databases.Expression\QueryExpression|\Closure|array|string fields A hash of field: new value.
     * @param mixed conditions Conditions to be used, accepts anything Query::where()
     * can take.
     * @return size_t count Returns the affected rows.
     */
    int updateAll(fields, conditions);

    /**
     * Deletes all records matching the provided conditions.
     *
     * This method will *not* trigger beforeDelete/afterDelete events. If you
     * need those first load a collection of records and delete them.
     *
     * This method will *not* execute on associations" `cascade` attribute. You should
     * use database foreign keys + ON CASCADE rules if you need cascading deletes combined
     * with this method.
     *
     * @param mixed conditions Conditions to be used, accepts anything Query::where()
     * can take.
     * @return int Returns the number of affected rows.
     * @see uim.datasources.IRepository::delete()
     */
    int deleteAll(conditions);

    /**
     * Returns true if there is any record in this repository matching the specified
     * conditions.
     *
     * @param array conditions list of conditions to pass to the query
     */
    bool exists(conditions);

    /**
     * Persists an entity based on the fields that are marked as dirty and
     * returns the same entity after a successful save or false in case
     * of any error.
     *
     * @param uim.Datasource\IEntity entity the entity to be saved
     * @param \ArrayAccess|STRINGAA someOptions The options to use when saving.
     * @return uim.Datasource\IEntity|false
     */
    function save(IEntity entity, options = null);

    /**
     * Delete a single entity.
     *
     * Deletes an entity and possibly related associations from the database
     * based on the "dependent" option used when defining the association.
     *
     * @param uim.Datasource\IEntity entity The entity to remove.
     * @param \ArrayAccess|STRINGAA someOptions The options for the delete.
     * @return bool success
     */
    bool delete(IEntity entity, options = null);

    /**
     * This creates a new entity object.
     *
     * Careful: This does not trigger any field validation.
     * This entity can be persisted without validation error as empty record.
     * Always patch in required fields before saving.
     *
     * @return uim.Datasource\IEntity
     */
    function newEmptyEntity(): IEntity;

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
     *
     * @param array data The data to build an entity with.
     * @param array<string, mixed> options A list of options for the object hydration.
     * @return uim.Datasource\IEntity
     */
    function newEntity(array data, STRINGAA someOptions = null): IEntity;

    /**
     * Create a list of entities + associated entities from an array.
     *
     * This is most useful when hydrating request data back into entities.
     * For example, in your controller code:
     *
     * ```
     * articles = this.Articles.newEntities(this.request[));
     * ```
     *
     * The hydrated entities can then be iterated and saved.
     *
     * @param array data The data to build an entity with.
     * @param array<string, mixed> options A list of options for the objects hydration.
     * @return array<uim.Datasource\IEntity> An array of hydrated records.
     */
    array newEntities(array data, STRINGAA someOptions = null);

    /**
     * Merges the passed `data` into `entity` respecting the accessible
     * fields configured on the entity. Returns the same entity after being
     * altered.
     *
     * This is most useful when editing an existing entity using request data:
     *
     * ```
     * article = this.Articles.patchEntity(article, this.request[));
     * ```
     *
     * @param uim.Datasource\IEntity entity the entity that will get the
     * data merged in
     * @param array data key value list of fields to be merged into the entity
     * @param array<string, mixed> options A list of options for the object hydration.
     * @return uim.Datasource\IEntity
     */
    function patchEntity(IEntity entity, array data, STRINGAA someOptions = null): IEntity;

    /**
     * Merges each of the elements passed in `data` into the entities
     * found in `entities` respecting the accessible fields configured on the entities.
     * Merging is done by matching the primary key in each of the elements in `data`
     * and `entities`.
     *
     * This is most useful when editing a list of existing entities using request data:
     *
     * ```
     * article = this.Articles.patchEntities(articles, this.request[));
     * ```
     *
     * @param iterable<uim.Datasource\IEntity> entities the entities that will get the
     * data merged in
     * @param array data list of arrays to be merged into the entities
     * @param array<string, mixed> options A list of options for the objects hydration.
     * @return array<uim.Datasource\IEntity>
     */
    array patchEntities(iterable entities, array data, STRINGAA someOptions = null);
}
