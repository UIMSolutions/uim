module uim.orm.classes.behaviors.tree;

import uim.orm;

@safe:


/**
 * Makes the table to which this is attached to behave like a nested set and
 * provides methods for managing and retrieving information out of the derived
 * hierarchical structure.
 *
 * Tables attaching this behavior are required to have a column referencing the
 * parent row, and two other numeric columns (lft and rght) where the implicit
 * order will be cached.
 *
 * For more information on what is a nested set and a how it works refer to
 * https://www.sitepoint.com/hierarchical-data-database-2/
 */
class DTreeBehavior : DBehavior {
    // Cached copy of the first column in a table"s primary key.
    protected string _primaryKeys;

    /* 
    override bool initialize(Json[string] myConfiguration) {
        configuration.updateDefaults([
        "implementedFinders": [
            "path": "findPath",
            "children": "findChildren",
            "treeList": "findTreeList",
        ],
        "implementedMethods": [
            "childCount": "childCount",
            "moveUp": "moveUp",
            "moveDown": "moveDown",
            "recover": "recover",
            "removeFromTree": "removeFromTree",
            "getLevel": "getLevel",
            "formatTreeList": "formatTreeList",
        ],
        "parent": "parent_id",
        "left": "lft",
        "right": "rght",
        "scope": null,
        "level": null,
        "recoverOrder": null,
        "cascadeCallbacks": false.toJson,
    ];

        configuration.get("leftField"] = new DIdentifierExpression(configuration.get("left"]);
        configuration.get("rightField"] = new DIdentifierExpression(configuration.get("right"]);

        return true;
    }

    /**
     * Before save listener.
     * Transparently manages setting the lft and rght fields if the parent field is
     * included in the parameters to be saved.
     *
     * @param DORMevents.IEvent event The beforeSave event that was fired
     * @param DORMDatasource\IEntity anEntity the entity that is going to be saved
     * @return void
     * @throws \RuntimeException if the parent to set for the node is invalid
     * /
    function beforeSave(IEvent event, IEntity anEntity) {
        isNew = entity.isNew();
        myConfiguration = configuration;
        parent = entity.get(configuration.get("parent"]);
        primaryKeys = _primaryKeys();
        dirty = entity.isDirty(configuration.get("parent"]);
        level = configuration.get("level"];

        if (parent && entity.get(primaryKeys) == parent) {
            throw new DRuntimeException("Cannot set a node"s parent as itself");
        }

        if (isNew && parent) {
            parentNode = _getNode(parent);
            edge = parentNode.get(configuration.get("right"]);
            entity.set(configuration.get("left"], edge);
            entity.set(configuration.get("right"], edge + 1);
            _sync(2, "+", ">= {edge}");

            if (level) {
                entity.set(level, parentNode[level] + 1);
            }

            return;
        }

        if (isNew && !parent) {
            edge = _getMax();
            entity.set(configuration.get("left"], edge + 1);
            entity.set(configuration.get("right"], edge + 2);

            if (level) {
                entity.set(level, 0);
            }

            return;
        }

        if (dirty && parent) {
            _setParent(entity, parent);

            if (level) {
                parentNode = _getNode(parent);
                entity.set(level, parentNode[level] + 1);
            }

            return;
        }

        if (dirty && !parent) {
            _setAsRoot(entity);

            if (level) {
                entity.set(level, 0);
            }
        }
    }

    /**
     * After save listener.
     *
     * Manages updating level of descendants of currently saved entity.
     *
     * @param DORMevents.IEvent event The afterSave event that was fired
     * @param DORMDatasource\IEntity anEntity the entity that is going to be saved
     * /
    void afterSave(IEvent event, IEntity anEntity) {
        if (!configuration.get("level"] || entity.isNew()) {
            return;
        }

        _setChildrenLevel(entity);
    }

    /**
     * Set level for descendants.
     *
     * @param DORMDatasource\IEntity anEntity The entity whose descendants need to be updated.
     * /
    protected void _setChildrenLevel(IEntity anEntity) {
        myConfiguration = configuration;

        if (entity.get(configuration.get("left"]) + 1 == entity.get(configuration.get("right"])) {
            return;
        }

        primaryKeys = _primaryKeys();
        primaryKeysValue = entity.get(primaryKeys);
        depths = [primaryKeysValue: entity.get(configuration.get("level"])];

        children = _table.find("children", [
            "for": primaryKeysValue,
            "fields": [_primaryKeys(), configuration.get("parent"], configuration.get("level"]],
            "order": configuration.get("left"],
        ]);

        /** @var DORMdatasources.IEntity node * /
        foreach (children as node) {
            parentIdValue = node.get(configuration.get("parent"]);
            depth = depths[parentIdValue] + 1;
            depths[node.get(primaryKeys)] = depth;

            _table.updateAll(
                [configuration.get("level"]: depth],
                [primaryKeys: node.get(primaryKeys)]
            );
        }
    }

    /**
     * Also deletes the nodes in the subtree of the entity to be delete
     *
     * @param DORMevents.IEvent event The beforeDelete event that was fired
     * @param DORMDatasource\IEntity anEntity The entity that is going to be saved
     * /
    void beforeremove(IEvent event, IEntity anEntity) {
        myConfiguration = configuration;
        _ensureFields(entity);
        left = entity.get(configuration.get("left"]);
        right = entity.get(configuration.get("right"]);
        diff = right - left + 1;

        if (diff > 2) {
            query = _scope(_table.query())
                .where(function (exp) use (myConfiguration, left, right) {
                    /** @var DDBExpression\QueryExpression exp * /
                    return exp
                        .gte(configuration.get("leftField"], left + 1)
                        .lte(configuration.get("leftField"], right - 1);
                });
            if (this.configuration.get("cascadeCallbacks")) {
                entities = query.toArray();
                foreach (entities as entityToDelete) {
                    _table.remove(entityToDelete, ["atomic": false.toJson]);
                }
            } else {
                query.remove();
                statement = query.execute();
                statement.closeCursor();
            }
        }

        _sync(diff, "-", "> {right}");
    }

    /**
     * Sets the correct left and right values for the passed entity so it can be
     * updated to a new parent. It also makes the hole in the tree so the node
     * move can be done without corrupting the structure.
     *
     * @param DORMDatasource\IEntity anEntity The entity to re-parent
     * @param mixed parent the id of the parent to set
     * @return void
     * @throws \RuntimeException if the parent to set to the entity is not valid
     * /
    protected void _setParent(IEntity anEntity, parent) {
        myConfiguration = configuration;
        parentNode = _getNode(parent);
        _ensureFields(entity);
        parentLeft = parentNode.get(configuration.get("left"]);
        parentRight = parentNode.get(configuration.get("right"]);
        right = entity.get(configuration.get("right"]);
        left = entity.get(configuration.get("left"]);

        if (parentLeft > left && parentLeft < right) {
            throw new DRuntimeException(sprintf(
                "Cannot use node '%s' as parent for entity '%s'",
                parent,
                entity.get(_primaryKeys())
            ));
        }

        // Values for moving to the left
        diff = right - left + 1;
        targetLeft = parentRight;
        targetRight = diff + parentRight - 1;
        min = parentRight;
        max = left - 1;

        if (left < targetLeft) {
            // Moving to the right
            targetLeft = parentRight - diff;
            targetRight = parentRight - 1;
            min = right + 1;
            max = parentRight - 1;
            diff *= -1;
        }

        if (right - left > 1) {
            // Correcting internal subtree
            internalLeft = left + 1;
            internalRight = right - 1;
            _sync(targetLeft - left, "+", "BETWEEN {internalLeft} AND {internalRight}", true);
        }

        _sync(diff, "+", "BETWEEN {min} AND {max}");

        if (right - left > 1) {
            _unmarkInternalTree();
        }

        // Allocating new position
        entity.set(configuration.get("left"], targetLeft);
        entity.set(configuration.get("right"], targetRight);
    }

    /**
     * Updates the left and right column for the passed entity so it can be set as
     * a new root in the tree. It also modifies the ordering in the rest of the tree
     * so the structure remains valid
     *
     * @param DORMDatasource\IEntity anEntity The entity to set as a new root
     * /
    protected void _setAsRoot(IEntity anEntity) {
        myConfiguration = configuration;
        edge = _getMax();
        _ensureFields(entity);
        right = entity.get(configuration.get("right"]);
        left = entity.get(configuration.get("left"]);
        diff = right - left;

        if (right - left > 1) {
            //Correcting internal subtree
            internalLeft = left + 1;
            internalRight = right - 1;
            _sync(edge - diff - left, "+", "BETWEEN {internalLeft} AND {internalRight}", true);
        }

        _sync(diff + 1, "-", "BETWEEN {right} AND {edge}");

        if (right - left > 1) {
            _unmarkInternalTree();
        }

        entity.set(configuration.get("left"], edge - diff);
        entity.set(configuration.get("right"], edge);
    }

    /**
     * Helper method used to invert the sign of the left and right columns that are
     * less than 0. They were set to negative values before so their absolute value
     * wouldn't change while performing other tree transformations.
     * /
    protected void _unmarkInternalTree() {
        myConfiguration = configuration;
        _table.updateAll(
            function (exp) use (myConfiguration) {
                /** @var DDBExpression\QueryExpression exp * /
                leftInverse = clone exp;
                leftInverse.setConjunction("*").add("-1");
                rightInverse = clone leftInverse;

                return exp
                    .eq(configuration.get("leftField"], leftInverse.add(configuration.get("leftField"]))
                    .eq(configuration.get("rightField"], rightInverse.add(configuration.get("rightField"]));
            },
            function (exp) use (myConfiguration) {
                /** @var DDBExpression\QueryExpression exp * /
                return exp.lt(configuration.get("leftField"], 0);
            }
        );
    }

    /**
     * Custom finder method which can be used to return the list of nodes from the root
     * to a specific node in the tree. This custom finder requires that the key "for"
     * is passed in the options containing the id of the node to get its path for.
     *
     * @param DORMQuery query The constructed query to modify
     * @param Json[string] options the list of options for the query
     * @return 
     * @throws \InvalidArgumentException If the "for" key is missing in options
     * /
    DORMQuery findPath(Query query, Json[string] optionData) {
        if (options.isEmpty("for"])) {
            throw new DInvalidArgumentException("The "for" key is required for find("path")");
        }

        myConfiguration = configuration;
        [left, right] = array_map(
            function (field) {
                return _table.aliasField(field);
            },
            [configuration.get("left"], configuration.get("right"]]
        );

        node = _table.get(options["for"], ["fields": [left, right]]);

        return _scope(query)
            .where([
                "left <=": node.get(configuration.get("left"]),
                "right >=": node.get(configuration.get("right"]),
            ])
            .order([left: "ASC"]);
    }

    /**
     * Get the number of children nodes.
     *
     * @param DORMDatasource\IEntity node The entity to count children for
     * @param bool direct whether to count all nodes in the subtree or just
     * direct children
     * @return int Number of children nodes.
     * /
    int childCount(IEntity node, bool direct = false) {
        myConfiguration = configuration;
        parent = _table.aliasField(configuration.get("parent"]);

        if (direct) {
            return _scope(_table.find())
                .where([parent: node.get(_primaryKeys())])
                .count();
        }

        _ensureFields(node);

        return (node.get(configuration.get("right"]) - node.get(configuration.get("left"]) - 1) / 2;
    }

    /**
     * Get the children nodes of the current model
     *
     * Available options are:
     *
     * - for: The id of the record to read.
     * - direct: Boolean, whether to return only the direct (true), or all (false) children,
     *   defaults to false (all children).
     *
     * If the direct option is set to true, only the direct children are returned (based upon the parent_id field)
     *
     * @param DORMQuery query Query.
     * @param Json[string] options Array of options as described above
     * @return DORMQuery
     * @throws \InvalidArgumentException When the "for" key is not passed in options
     * /
    function findChildren(Query query, Json[string] optionData): Query
    {
        myConfiguration = configuration;
        options = options.update["for": null, "direct": false.toJson];
        [parent, left, right] = array_map(
            function (field) {
                return _table.aliasField(field);
            },
            [configuration.get("parent"], configuration.get("left"], configuration.get("right"]]
        );

        [for, direct] = [options["for"], options["direct"]];

        if (for.isEmpty) {
            throw new DInvalidArgumentException("The "for" key is required for find("children")");
        }

        if (query.clause("order") == null) {
            query.order([left: "ASC"]);
        }

        if (direct) {
            return _scope(query).where([parent: for]);
        }

        node = _getNode(for);

        return _scope(query)
            .where([
                "{right} <": node.get(configuration.get("right"]),
                "{left} >": node.get(configuration.get("left"]),
            ]);
    }

    /**
     * Gets a representation of the elements in the tree as a flat list where the keys are
     * the primary key for the table and the values are the display field for the table.
     * Values are prefixed to visually indicate relative depth in the tree.
     *
     * ### Options
     *
     * - keyPath: A dot separated path to fetch the field to use for the array key, or a closure to
     *   return the key out of the provided row.
     * - valuePath: A dot separated path to fetch the field to use for the array value, or a closure to
     *   return the value out of the provided row.
     * - spacer: A string to be used as prefix for denoting the depth in the tree for each item
     *
     * @param DORMQuery query Query.
     * @param Json[string] options Array of options as described above.
     * @return DORMQuery
     * /
    function findTreeList(Query query, Json[string] optionData): Query
    {
        left = _table.aliasField(this.configuration.get("left"));

        results = _scope(query)
            .find("threaded", [
                "parentField": this.configuration.get("parent"),
                "order": [left: "ASC"],
            ]);

        return _formatTreeList(results, options);
    }

    /**
     * Formats query as a flat list where the keys are the primary key for the table
     * and the values are the display field for the table. Values are prefixed to visually
     * indicate relative depth in the tree.
     *
     * ### Options
     *
     * - keyPath: A dot separated path to the field that will be the result array key, or a closure to
     *   return the key from the provided row.
     * - valuePath: A dot separated path to the field that is the array"s value, or a closure to
     *   return the value from the provided row.
     * - spacer: A string to be used as prefix for denoting the depth in the tree for each item.
     *
     * @param DORMQuery query The query object to format.
     * @param Json[string] options Array of options as described above.
     * @return DORMQuery Augmented query.
     * /
    function formatTreeList(Query query, Json[string] optionData = null): Query
    {
        return query.formatResults(function (ICollection results) use (options) {
            options = options.update[
                "keyPath": _primaryKeys(),
                "valuePath": _table.getDisplayField(),
                "spacer": "_",
            ];

            /** @var DORMcollections.Iterator\TreeIterator nested * /
            nested = results.listNested();

            return nested.printer(options["valuePath"], options["keyPath"], options["spacer"]);
        });
    }

    /**
     * Removes the current node from the tree, by positioning it as a new root
     * and re-parents all children up one level.
     *
     * Note that the node will not be deleted just moved away from its current position
     * without moving its children with it.
     *
     * @param DORMDatasource\IEntity node The node to remove from the tree
     * @return DORMDatasource\IEntity|false the node after being removed from the tree or
     * false on error
     * /
    function removeFromTree(IEntity node) {
        return _table.getConnection().transactional(function () use (node) {
            _ensureFields(node);

            return _removeFromTree(node);
        });
    }

    /**
     * Helper function containing the actual code for removeFromTree
     *
     * @param DORMDatasource\IEntity node The node to remove from the tree
     * @return DORMDatasource\IEntity|false the node after being removed from the tree or
     * false on error
     * /
    protected function _removeFromTree(IEntity node) {
        myConfiguration = configuration;
        left = node.get(configuration.get("left"]);
        right = node.get(configuration.get("right"]);
        parent = node.get(configuration.get("parent"]);

        node.set(configuration.get("parent"], null);

        if (right - left == 1) {
            return _table.save(node);
        }

        primary = _primaryKeys();
        _table.updateAll(
            [configuration.get("parent"]: parent],
            [configuration.get("parent"]: node.get(primary)]
        );
        _sync(1, "-", "BETWEEN " ~ (left + 1) ~ " AND " ~ (right - 1));
        _sync(2, "-", "> {right}");
        edge = _getMax();
        node.set(configuration.get("left"], edge + 1);
        node.set(configuration.get("right"], edge + 2);
        fields = [configuration.get("parent"], configuration.get("left"], configuration.get("right"]];

        _table.updateAll(node.extract(fields), [primary: node.get(primary)]);

        foreach (fields as field) {
            node.setDirty(field, false);
        }

        return node;
    }

    /**
     * Reorders the node without changing its parent.
     *
     * If the node is the first child, or is a top level node with no previous node
     * this method will return the same node without any changes
     *
     * @param DORMDatasource\IEntity node The node to move
     * @param int|true number How many places to move the node, or true to move to first position
     * @throws DORMDatasource\exceptions.RecordNotFoundException When node was not found
     * @return DORMDatasource\IEntity|false node The node after being moved or false if `number` is < 1
     * /
    function moveUp(IEntity node, number = 1) {
        if (number < 1) {
            return false;
        }

        return _table.getConnection().transactional(function () use (node, number) {
            _ensureFields(node);

            return _moveUp(node, number);
        });
    }

    /**
     * Helper function used with the actual code for moveUp
     *
     * @param DORMDatasource\IEntity node The node to move
     * @param int|true number How many places to move the node, or true to move to first position
     * @return DORMDatasource\IEntity node The node after being moved
     * @throws DORMDatasource\exceptions.RecordNotFoundException When node was not found
     * /
    protected function _moveUp(IEntity node, number): IEntity
    {
        myConfiguration = configuration;
        [parent, left, right] = [configuration.get("parent"], configuration.get("left"], configuration.get("right"]];
        [nodeParent, nodeLeft, nodeRight] = array_values(node.extract([parent, left, right]));

        targetNode = null;
        if (number != true) {
            /** @var DORMdatasources.IEntity|null targetNode * /
            targetNode = _scope(_table.find())
                .select([left, right])
                .where(["parent IS": nodeParent])
                .where(function (exp) use (myConfiguration, nodeLeft) {
                    /** @var DDBExpression\QueryExpression exp * /
                    return exp.lt(configuration.get("rightField"], nodeLeft);
                })
                .orderDesc(configuration.get("leftField"])
                .offset(number - 1)
                .limit(1)
                .first();
        }
        if (!targetNode) {
            /** @var DORMdatasources.IEntity|null targetNode * /
            targetNode = _scope(_table.find())
                .select([left, right])
                .where(["parent IS": nodeParent])
                .where(function (exp) use (myConfiguration, nodeLeft) {
                    /** @var DDBExpression\QueryExpression exp * /
                    return exp.lt(configuration.get("rightField"], nodeLeft);
                })
                .orderAsc(configuration.get("leftField"])
                .limit(1)
                .first();

            if (!targetNode) {
                return node;
            }
        }

        [targetLeft] = array_values(targetNode.extract([left, right]));
        edge = _getMax();
        leftBoundary = targetLeft;
        rightBoundary = nodeLeft - 1;

        nodeToEdge = edge - nodeLeft + 1;
        shift = nodeRight - nodeLeft + 1;
        nodeToHole = edge - leftBoundary + 1;
        _sync(nodeToEdge, "+", "BETWEEN {nodeLeft} AND {nodeRight}");
        _sync(shift, "+", "BETWEEN {leftBoundary} AND {rightBoundary}");
        _sync(nodeToHole, "-", "> {edge}");

        node.set(left, targetLeft);
        node.set(right, targetLeft + nodeRight - nodeLeft);

        node.setDirty(left, false);
        node.setDirty(right, false);

        return node;
    }

    /**
     * Reorders the node without changing the parent.
     *
     * If the node is the last child, or is a top level node with no subsequent node
     * this method will return the same node without any changes
     *
     * @param DORMDatasource\IEntity node The node to move
     * @param int|true number How many places to move the node or true to move to last position
     * @throws DORMDatasource\exceptions.RecordNotFoundException When node was not found
     * @return DORMDatasource\IEntity|false the entity after being moved or false if `number` is < 1
     * /
    function moveDown(IEntity node, number = 1) {
        if (number < 1) {
            return false;
        }

        return _table.getConnection().transactional(function () use (node, number) {
            _ensureFields(node);

            return _moveDown(node, number);
        });
    }

    /**
     * Helper function used with the actual code for moveDown
     *
     * @param DORMDatasource\IEntity node The node to move
     * @param int|true number How many places to move the node, or true to move to last position
     * @return DORMDatasource\IEntity node The node after being moved
     * @throws DORMDatasource\exceptions.RecordNotFoundException When node was not found
     * /
    protected function _moveDown(IEntity node, number): IEntity
    {
        myConfiguration = configuration;
        [parent, left, right] = [configuration.get("parent"], configuration.get("left"], configuration.get("right"]];
        [nodeParent, nodeLeft, nodeRight] = array_values(node.extract([parent, left, right]));

        targetNode = null;
        if (number != true) {
            /** @var DORMdatasources.IEntity|null targetNode * /
            targetNode = _scope(_table.find())
                .select([left, right])
                .where(["parent IS": nodeParent])
                .where(function (exp) use (myConfiguration, nodeRight) {
                    /** @var DDBExpression\QueryExpression exp * /
                    return exp.gt(configuration.get("leftField"], nodeRight);
                })
                .orderAsc(configuration.get("leftField"])
                .offset(number - 1)
                .limit(1)
                .first();
        }
        if (!targetNode) {
            /** @var DORMdatasources.IEntity|null targetNode * /
            targetNode = _scope(_table.find())
                .select([left, right])
                .where(["parent IS": nodeParent])
                .where(function (exp) use (myConfiguration, nodeRight) {
                    /** @var DDBExpression\QueryExpression exp * /
                    return exp.gt(configuration.get("leftField"], nodeRight);
                })
                .orderDesc(configuration.get("leftField"])
                .limit(1)
                .first();

            if (!targetNode) {
                return node;
            }
        }

        [, targetRight] = array_values(targetNode.extract([left, right]));
        edge = _getMax();
        leftBoundary = nodeRight + 1;
        rightBoundary = targetRight;

        nodeToEdge = edge - nodeLeft + 1;
        shift = nodeRight - nodeLeft + 1;
        nodeToHole = edge - rightBoundary + shift;
        _sync(nodeToEdge, "+", "BETWEEN {nodeLeft} AND {nodeRight}");
        _sync(shift, "-", "BETWEEN {leftBoundary} AND {rightBoundary}");
        _sync(nodeToHole, "-", "> {edge}");

        node.set(left, targetRight - (nodeRight - nodeLeft));
        node.set(right, targetRight);

        node.setDirty(left, false);
        node.setDirty(right, false);

        return node;
    }

    /**
     * Returns a single node from the tree from its primary key
     *
     * @param mixed id Record id.
     * @return DORMDatasource\IEntity
     * @throws DORMDatasource\exceptions.RecordNotFoundException When node was not found
     * @psalm-suppress InvalidReturnType
     * /
    protected function _getNode(id): IEntity
    {
        myConfiguration = configuration;
        [parent, left, right] = [configuration.get("parent"], configuration.get("left"], configuration.get("right"]];
        primaryKeys = _primaryKeys();
        fields = [parent, left, right];
        if (configuration.get("level"]) {
            fields[] = configuration.get("level"];
        }

        node = _scope(_table.find())
            .select(fields)
            .where([_table.aliasField(primaryKeys): id])
            .first();

        if (!node) {
            throw new DRecordNotFoundException("Node \"{id}\" was not found in the tree.");
        }

        /** @psalm-suppress InvalidReturnStatement * /
        return node;
    }

    /**
     * Recovers the lft and right column values out of the hierarchy defined by the
     * parent column.
     * /
    void recover() {
        _table.getConnection().transactional(void () {
            _recoverTree();
        });
    }

    /**
     * Recursive method used to recover a single level of the tree
     *
     * @param int lftRght The starting lft/rght value
     * @param mixed parentId the parent id of the level to be recovered
     * @param int level Node level
     * @return int The next lftRght value
     * /
    protected int _recoverTree(int lftRght = 1, parentId = null, level = 0) {
        myConfiguration = configuration;
        [parent, left, right] = [configuration.get("parent"], configuration.get("left"], configuration.get("right"]];
        primaryKeys = _primaryKeys();
        order = configuration.get("recoverOrder"] ?: primaryKeys;

        nodes = _scope(_table.query())
            .select(primaryKeys)
            .where([parent ~ " IS": parentId])
            .order(order)
            .disableHydration()
            .all();

        foreach (nodes as node) {
            nodeLft = lftRght++;
            lftRght = _recoverTree(lftRght, node[primaryKeys], level + 1);

            fields = [left: nodeLft, right: lftRght++];
            if (configuration.get("level"]) {
                fields[configuration.get("level"]] = level;
            }

            _table.updateAll(
                fields,
                [primaryKeys: node[primaryKeys]]
            );
        }

        return lftRght;
    }

    /**
     * Returns the maximum index value in the table.
     * /
    protected int _getMax() {
        field = configuration.get("right"];
        rightField = configuration.get("rightField"];
        edge = _scope(_table.find())
            .select([field])
            .orderDesc(rightField)
            .first();

        if (edge == null || edge.isEmpty(field))) {
            return 0;
        }

        return edge[field];
    }

    /**
     * Auxiliary function used to automatically alter the value of both the left and
     * right columns by a certain amount that match the passed conditions
     *
     * @param int shift the value to use for operating the left and right columns
     * @param string dir The operator to use for shifting the value (+/-)
     * @param string conditions a SQL snipped to be used for comparing left or right
     * against it.
     * @param bool mark whether to mark the updated values so that they can not be
     * modified by future calls to this function.
     * /
    protected void _sync(int shift, string dir, string conditions, bool mark = false) {
        myConfiguration = configuration;

        foreach ([configuration.get("leftField"], configuration.get("rightField"]] as field) {
            query = _scope(_table.query());
            exp = query.newExpr();

            movement = clone exp;
            movement.add(field).add((string)shift).setConjunction(dir);

            inverse = clone exp;
            movement = mark ?
                inverse.add(movement).setConjunction("*").add("-1") :
                movement;

            where = clone exp;
            where.add(field).add(conditions).setConjunction("");

            query.update()
                .set(exp.eq(field, movement))
                .where(where);

            query.execute().closeCursor();
        }
    }

    /**
     * Alters the passed query so that it only returns scoped records as defined
     * in the tree configuration.
     *
     * @param DORMQuery query the Query to modify
     * @return DORMQuery
     * /
    protected function _scope(Query query): Query
    {
        scope = this.configuration.get("scope");

        if ((scope.isArray) {
            return query.where(scope);
        }
        if (is_callable(scope)) {
            return scope(query);
        }

        return query;
    }

    /**
     * Ensures that the provided entity contains non-empty values for the left and
     * right fields
     *
     * @param DORMDatasource\IEntity anEntity The entity to ensure fields for
     * /
    protected void _ensureFields(IEntity anEntity) {
        myConfiguration = configuration;
        fields = [configuration.get("left"], configuration.get("right"]];
        values = array_filter(entity.extract(fields));
        if (count(values) == count(fields)) {
            return;
        }

        fresh = _table.get(entity.get(_primaryKeys()));
        entity.set(fresh.extract(fields), ["guard": false.toJson]);

        foreach (fields as field) {
            entity.setDirty(field, false);
        }
    }

    /**
     * Returns a single string value representing the primary key of the attached table
     * /
    protected string _primaryKeys() {
        if (!_primaryKeys) {
            primaryKeys = (array)_table.primaryKeys();
            _primaryKeys = primaryKeys[0];
        }

        return _primaryKeys;
    }

    /**
     * Returns the depth level of a node in the tree.
     *
     * @param DORMDatasource\IEntity|string|int entity The entity or primary key get the level of.
     * @return int|false Integer of the level or false if the node does not exist.
     * /
    function getLevel(entity) {
        primaryKeys = _primaryKeys();
        id = entity;
        if (entity instanceof IEntity) {
            id = entity.get(primaryKeys);
        }
        myConfiguration = configuration;
        entity = _table.find("all")
            .select([configuration.get("left"], configuration.get("right"]])
            .where([primaryKeys: id])
            .first();

        if (entity == null) {
            return false;
        }

        query = _table.find("all").where([
            configuration.get("left"] ~ " <": entity[configuration.get("left"]],
            configuration.get("right"] ~ " >": entity[configuration.get("right"]],
        ]);

        return _scope(query).count();
    } */
}
