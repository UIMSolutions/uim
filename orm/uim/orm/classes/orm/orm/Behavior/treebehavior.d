module uim.orm.behaviors;

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
class TreeBehavior : Behavior {
    // Cached copy of the first column in a table"s primary key.
    protected string my_primaryKey = "";

    /**
     * Default config
     *
     * These are merged with user-provided configuration when the behavior is used.
     *
     */
    protected IData[string] Configuration.updateDefaults([
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
        "cascadeCallbacks": false,
    ];

    bool initialize(IData[string] initData = null) {
       configuration.data("leftField"] = new IdentifierExpression(configuration.data("left"]);
       configuration.data("rightField"] = new IdentifierExpression(configuration.data("right"]);
    }
    
    /**
     * Before save listener.
     * Transparently manages setting the lft and rght fields if the parent field is
     * included in the parameters to be saved.
     * Params:
     * \UIM\Event\IEvent<\UIM\ORM\Table> myevent The beforeSave event that was fired
     * @param \UIM\Datasource\IEntity myentity the entity that is going to be saved
     */
    auto beforeSave(IEvent myevent, IEntity myentity) {
        myisNew = myentity.isNew();
        configData = this.getConfig();
        myparent = myentity.get(configData("parent"]);
        myprimaryKey = _getPrimaryKey();
        mydirty = myentity.isDirty(configData("parent"]);
        mylevel = configData("level"];

        if (myparent && myentity.get(myprimaryKey) == myparent) {
            throw new DatabaseException("Cannot set a node\"s parent as itself.");
        }
        if (myisNew) {
            if (myparent) {
                myparentNode = _getNode(myparent);
                myedge = myparentNode.get(configData("right"]);
                myentity.set(configData("left"], myedge);
                myentity.set(configData("right"], myedge + 1);
               _sync(2, "+", ">= {myedge}");

                if (mylevel) {
                    myentity.set(mylevel, myparentNode[mylevel] + 1);
                }
                return;
            }
            myedge = _getMax();
            myentity.set(configData("left"], myedge + 1);
            myentity.set(configData("right"], myedge + 2);

            if (mylevel) {
                myentity.set(mylevel, 0);
            }
            return;
        }
        if (mydirty) {
            if (myparent) {
               _setParent(myentity, myparent);

                if (mylevel) {
                    myparentNode = _getNode(myparent);
                    myentity.set(mylevel, myparentNode[mylevel] + 1);
                }
                return;
            }
           _setAsRoot(myentity);

            if (mylevel) {
                myentity.set(mylevel, 0);
            }
        }
    }
    
    /**
     * After save listener.
     *
     * Manages updating level of descendants of currently saved entity.
     * Params:
     * \UIM\Event\IEvent<\UIM\ORM\Table> myevent The afterSave event that was fired
     * @param \UIM\Datasource\IEntity myentity the entity that is going to be saved
     */
    void afterSave(IEvent myevent, IEntity myentity) {
        if (!configuration.data("level"] || myentity.isNew()) {
            return;
        }
       _setChildrenLevel(myentity);
    }
    
    /**
     * Set level for descendants.
     * Params:
     * \UIM\Datasource\IEntity myentity The entity whose descendants need to be updated.
     */
    protected void _setChildrenLevel(IEntity myentity) {
        configData = this.getConfig();

        if (myentity.get(configData("left"]) + 1 == myentity.get(configData("right"])) {
            return;
        }
        myprimaryKey = _getPrimaryKey();
        myprimaryKeyValue = myentity.get(myprimaryKey);
        mydepths = [myprimaryKeyValue: myentity.get(configData("level"])];

        /** @var \Traversable<\UIM\Datasource\IEntity> mychildren */
        mychildren = _table.find(
            "children",
            for: myprimaryKeyValue,
            fields: [_getPrimaryKey(), configData("parent"], configData("level"]],
            order: configData("left"],
        )
        .all();

        mychildren.each!((node) {
            myparentIdValue = node.get(configData("parent"]);
            mydepth = mydepths[myparentIdValue] + 1;
            mydepths[node.get(myprimaryKey)] = mydepth;

           _table.updateAll(
                [configData("level"]: mydepth],
                [myprimaryKey: node.get(myprimaryKey)]
            ););
        }
    }
    
    /**
     * Also deletes the nodes in the subtree of the entity to be delete
     * Params:
     * \UIM\Event\IEvent<\UIM\ORM\Table> myevent The beforeDelete event that was fired
     * @param \UIM\Datasource\IEntity myentity The entity that is going to be saved
     */
    void beforeDelete(IEvent myevent, IEntity myentity) {
        configData = this.getConfig();
       _ensureFields(myentity);
        myleft = myentity.get(configData("left"]);
        myright = myentity.get(configData("right"]);
        mydiff = to!int((myright - myleft + 1));

        if (mydiff > 2) {
            if (configurationData.isSet("cascadeCallbacks")) {
                myquery = _scope(_table.query())
                    .where(
                        fn (QueryExpression myexp): myexp
                            .gte(configData("leftField"], myleft + 1)
                            .lte(configData("leftField"], myright - 1)
                    );

                myentities = myquery.toArray();
                foreach (myentities as myentityToDelete) {
                   _table.delete(myentityToDelete, ["atomic": false]);
                }
            } else {
               _scope(_table.deleteQuery())
                    .where(
                        fn (QueryExpression myexp): myexp
                            .gte(configData("leftField"], myleft + 1)
                            .lte(configData("leftField"], myright - 1)
                    )
                    .execute();
            }
        }
       _sync(mydiff, "-", "> {myright}");
    }
    
    /**
     * Sets the correct left and right values for the passed entity so it can be
     * updated to a new parent. It also makes the hole in the tree so the node
     * move can be done without corrupting the structure.
     * Params:
     * \UIM\Datasource\IEntity myentity The entity to re-parent
     * @param Json myparent the id of the parent to set
     */
    protected void _setParent(IEntity myentity, Json myparent) {
        configData = this.getConfig();
        myparentNode = _getNode(myparent);
       _ensureFields(myentity);
        myparentLeft = myparentNode.get(configData("left"]);
        myparentRight = myparentNode.get(configData("right"]);
        myright = myentity.get(configData("right"]);
        myleft = myentity.get(configData("left"]);

        if (myparentLeft > myleft && myparentLeft < myright) {
            throw new DatabaseException(
                "Cannot use node `%s` as parent for entity `%s`."
                .format(myparent,myentity.get(_getPrimaryKey()))
            );
        }
        // Values for moving to the left
        mydiff = myright - myleft + 1;
        mytargetLeft = myparentRight;
        mytargetRight = mydiff + myparentRight - 1;
        mymin = myparentRight;
        mymax = myleft - 1;

        if (myleft < mytargetLeft) {
            // Moving to the right
            mytargetLeft = myparentRight - mydiff;
            mytargetRight = myparentRight - 1;
            mymin = myright + 1;
            mymax = myparentRight - 1;
            mydiff *= -1;
        }
        if (myright - myleft > 1) {
            // Correcting internal subtree
            myinternalLeft = myleft + 1;
            myinternalRight = myright - 1;
           _sync(mytargetLeft - myleft, "+", "BETWEEN {myinternalLeft} AND {myinternalRight}", true);
        }
       _sync(mydiff, "+", "BETWEEN {mymin} AND {mymax}");

        if (myright - myleft > 1) {
           _unmarkInternalTree();
        }
        // Allocating new position
        myentity.set(configData("left"], mytargetLeft);
        myentity.set(configData("right"], mytargetRight);
    }
    
    /**
     * Updates the left and right column for the passed entity so it can be set as
     * a new root in the tree. It also modifies the ordering in the rest of the tree
     * so the structure remains valid
     * Params:
     * \UIM\Datasource\IEntity myentity The entity to set as a new root
     */
    protected void _setAsRoot(IEntity myentity) {
        configData = this.getConfig();
        myedge = _getMax();
       _ensureFields(myentity);
        myright = myentity.get(configData("right"]);
        myleft = myentity.get(configData("left"]);
        mydiff = myright - myleft;

        if (myright - myleft > 1) {
            //Correcting internal subtree
            myinternalLeft = myleft + 1;
            myinternalRight = myright - 1;
           _sync(myedge - mydiff - myleft, "+", "BETWEEN {myinternalLeft} AND {myinternalRight}", true);
        }
       _sync(mydiff + 1, "-", "BETWEEN {myright} AND {myedge}");

        if (myright - myleft > 1) {
           _unmarkInternalTree();
        }
        myentity.set(configData("left"], myedge - mydiff);
        myentity.set(configData("right"], myedge);
    }
    
    /**
     * Helper method used to invert the sign of the left and right columns that are
     * less than 0. They were set to negative values before so their absolute value
     * wouldn"t change while performing other tree transformations.
     */
    protected void _unmarkInternalTree() {
        configData = this.getConfig();
       _table.updateAll(
            auto (QueryExpression myexp) use (configData) {
                myleftInverse = clone myexp;
                myleftInverse.setConjunction("*").add("-1");
                myrightInverse = clone myleftInverse;

                return myexp
                    .eq(configData("leftField"], myleftInverse.add(configData("leftField"]))
                    .eq(configData("rightField"], myrightInverse.add(configData("rightField"]));
            },
            fn (QueryExpression myexp): myexp.lt(configData("leftField"], 0)
        );
    }
    
    /**
     * Custom finder method which can be used to return the list of nodes from the root
     * to a specific node in the tree. This custom finder requires that the key "for"
     * is passed in the options containing the id of the node to get its path for.
     * Params:
     * \UIM\ORM\Query\SelectQuery myquery The constructed query to modify
     * @param string|int myfor The path to find or an array of options with `for`.
     */
    SelectQuery findPath(SelectQuery myquery, string|int myfor) {
        configData = this.getConfig();
        [myleft, myright] = array_map(
            auto (myfield) {
                return _table.aliasField(myfield);
            },
            [configData("left"], configData("right"]]
        );


        auto node = _table.get(myfor, select: [myleft, myright]);
        return _scope(myquery)
            .where([
                "myleft <=": node.get(configData("left"]),
                "myright >=": node.get(configData("right"]),
            ])
            .orderBy([myleft: "ASC"]);
    }
    
    /**
     * Get the number of children nodes.
     * Params:
     * \UIM\Datasource\IEntity node The entity to count children for
     * @param bool mydirect whether to count all nodes in the subtree or just
     * direct children
     */
    int childCount(IEntity node, bool mydirect = false) {
        configData = this.getConfig();
        myparent = _table.aliasField(configData("parent"]);

        if (mydirect) {
            return _scope(_table.find())
                .where([myparent: node.get(_getPrimaryKey())])
                .count();
        }
       _ensureFields(node);

        return (node.get(configData("right"]) - node.get(configData("left"]) - 1) / 2;
    }
    
    /**
     * Get the children nodes of the current model.
     *
     * If the direct option is set to true, only the direct children are returned
     * (based upon the parent_id field).
     * Params:
     * \UIM\ORM\Query\SelectQuery myquery Query.
     * @param string|int myfor The id of the record to read. Can also be an array of options.
     * @param bool mydirect Whether to return only the direct (true) or all children (false).
     */
    SelectQuery findChildren(SelectQuery myquery, int|string myfor, bool mydirect = false) {
        configData = this.getConfig();
        [myparent, myleft, myright] = array_map(
            auto (myfield) {
                return _table.aliasField(myfield);
            },
            [configData("parent"], configData("left"], configData("right"]]
        );

        if (myquery.clause("order").isNull) {
            myquery.orderBy([myleft: "ASC"]);
        }
        if (mydirect) {
            return _scope(myquery).where([myparent: myfor]);
        }

        auto node = _getNode(myfor);
        return _scope(myquery)
            .where([
                "{myright} <": node.get(configData("right"]),
                "{myleft} >": node.get(configData("left"]),
            ]);
    }
    
    /**
     * Gets a representation of the elements in the tree as a flat list where the keys are
     * the primary key for the table and the values are the display field for the table.
     * Values are prefixed to visually indicate relative depth in the tree.
     * Params:
     * \UIM\ORM\Query\SelectQuery myquery Query.
     * @param \Closure|string mykeyPath A dot separated path to fetch the field to use for the array key, or a closure to
     *  return the key out of the provided row.
     * @param \Closure|string myvaluePath A dot separated path to fetch the field to use for the array value, or a closure to
     *  return the value out of the provided row.
     * @param string myspacer A string to be used as prefix for denoting the depth in the tree for each item.
     */
    SelectQuery findTreeList(
        SelectQuery myquery,
        Closure|string mykeyPath = null,
        Closure|string myvaluePath = null,
        string myspacer = null
    ) {
        myleft = _table.aliasField(configurationData.isSet("left"));

        results = _scope(myquery)
            .find("threaded", parentField: configurationData.isSet("parent"), order: [myleft: "ASC"]);

        return this.formatTreeList(results, mykeyPath, myvaluePath, myspacer);
    }
    
    /**
     * Formats query as a flat list where the keys are the primary key for the table
     * and the values are the display field for the table. Values are prefixed to visually
     * indicate relative depth in the tree.
     * Params:
     * \UIM\ORM\Query\SelectQuery myquery The query object to format.
     * @param \Closure|string mykeyPath A dot separated path to the field that will be the result array key, or a closure to
     *  return the key from the provided row.
     * @param \Closure|string myvaluePath A dot separated path to the field that is the array"s value, or a closure to
     *  return the value from the provided row.
     * @param string myspacer A string to be used as prefix for denoting the depth in the tree for each item.
     */
    SelectQuery formatTreeList(
        SelectQuery myquery,
        Closure|string mykeyPath = null,
        Closure|string myvaluePath = null,
        string myspacer = null
    ) {
        return myquery.formatResults(
            auto (ICollection results) use (mykeyPath, myvaluePath, myspacer) {
                mykeyPath ??= _getPrimaryKey();
                myvaluePath ??= _table.getDisplayField();
                myspacer ??= "_";

                mynested = results.listNested();
                assert(cast(TreeIterator)mynested);
                assert(isCallable(myvaluePath) || isString(myvaluePath));

                return mynested.printer(myvaluePath, mykeyPath, myspacer);
            }
        );
    }
    
    /**
     * Removes the current node from the tree, by positioning it as a new root
     * and re-parents all children up one level.
     *
     * Note that the node will not be deleted just moved away from its current position
     * without moving its children with it.
     * Params:
     * \UIM\Datasource\IEntity node The node to remove from the tree
     */
    IEntity removeFromTree(IEntity node) {
        return _table.getConnection().transactional(function () use (node) {
           _ensureFields(node);

            return _removeFromTree(node);
        });
    }
    
    /**
     * Helper auto containing the actual code for removeFromTree
     * Params:
     * \UIM\Datasource\IEntity node The node to remove from the tree
     */
    protected IEntity|false _removeFromTree(IEntity node) {
        auto configData = this.getConfig();
        auto myleft = node.get(configData("left"]);
        auto myright = node.get(configData("right"]);
        auto myparent = node.get(configData("parent"]);

        node.set(configData("parent"], null);

        if (myright - myleft == 1) {
            return _table.save(node);
        }
        myprimary = _getPrimaryKey();
       _table.updateAll(
            [configData("parent"]: myparent],
            [configData("parent"]: node.get(myprimary)]
        );
       _sync(1, "-", "BETWEEN " ~ (myleft + 1) ~ " AND " ~ (myright - 1));
       _sync(2, "-", "> {myright}");
        myedge = _getMax();
        node.set(configData("left"], myedge + 1);
        node.set(configData("right"], myedge + 2);
        myfields = [configData("parent"], configData("left"], configData("right"]];

       _table.updateAll(node.extract(myfields), [myprimary: node.get(myprimary)]);

        foreach (myfields as myfield) {
            node.setDirty(myfield, false);
        }
        return node;
    }
    
    /**
     * Reorders the node without changing its parent.
     *
     * If the node is the first child, or is a top level node with no previous node
     * this method will return the same node without any changes
     * Params:
     * \UIM\Datasource\IEntity node The node to move
     * @param int|true mynumber How many places to move the node, or true to move to first position
     * @throws \UIM\Datasource\Exception\RecordNotFoundException When node was not found
     */
    IEntity moveUp(IEntity node, int|bool mynumber = 1) {
        if (mynumber < 1) {
            return false;
        }
        return _table.getConnection().transactional(function () use (node, mynumber) {
           _ensureFields(node);

            return _moveUp(node, mynumber);
        });
    }
    
    /**
     * Helper auto used with the actual code for moveUp
     * Params:
     * \UIM\Datasource\IEntity node The node to move
     * @param int|true mynumber How many places to move the node, or true to move to first position
     */
    protected IEntity _moveUp(IEntity node, int|bool mynumber) {
        configData = this.getConfig();
        [myparent, myleft, myright] = [configData("parent"], configData("left"], configData("right"]];
        [mynodeParent, mynodeLeft, mynodeRight] = array_values(node.extract([myparent, myleft, myright]));

        mytargetNode = null;
        if (mynumber != true) {
            /** @var \UIM\Datasource\IEntity|null mytargetNode */
            mytargetNode = _scope(_table.find())
                .select([myleft, myright])
                .where(["myparent IS": mynodeParent])
                .where(fn (QueryExpression myexp): myexp.lt(configData("rightField"], mynodeLeft))
                .orderByDesc(configData("leftField"])
                .offset(mynumber - 1)
                .limit(1)
                .first();
        }
        if (!mytargetNode) {
            IEntity mytargetNode = _scope(_table.find())
                .select([myleft, myright])
                .where(["myparent IS": mynodeParent])
                .where(fn (QueryExpression myexp): myexp.lt(configData("rightField"], mynodeLeft))
                .orderByAsc(configData("leftField"])
                .limit(1)
                .first();

            if (!mytargetNode) {
                return node;
            }
        }
        [mytargetLeft] = array_values(mytargetNode.extract([myleft, myright]));
        auto myedge = _getMax();
        auto myleftBoundary = mytargetLeft;
        auto myrightBoundary = mynodeLeft - 1;

        auto mynodeToEdge = myedge - mynodeLeft + 1;
        auto myshift = mynodeRight - mynodeLeft + 1;
        auto mynodeToHole = myedge - myleftBoundary + 1;
       _sync(mynodeToEdge, "+", "BETWEEN {mynodeLeft} AND {mynodeRight}");
       _sync(myshift, "+", "BETWEEN {myleftBoundary} AND {myrightBoundary}");
       _sync(mynodeToHole, "-", "> {myedge}");

        /** @var string myleft */
        node.set(myleft, mytargetLeft);
        /** @var string myright */
        node.set(myright, mytargetLeft + mynodeRight - mynodeLeft);

        node.setDirty(myleft, false);
        node.setDirty(myright, false);

        return node;
    }
    
    /**
     * Reorders the node without changing the parent.
     *
     * If the node is the last child, or is a top level node with no subsequent node
     * this method will return the same node without any changes
     * Params:
     * \UIM\Datasource\IEntity node The node to move
     * @param int|true mynumber How many places to move the node or true to move to last position
     * @throws \UIM\Datasource\Exception\RecordNotFoundException When node was not found
     */
    IEntity moveDown(IEntity node, int|bool mynumber = 1) {
        if (mynumber < 1) {
            return null;
        }
        return _table.getConnection().transactional(function () use (node, mynumber) {
           _ensureFields(node);

            return _moveDown(node, mynumber);
        });
    }
    
    /**
     * Helper auto used with the actual code for moveDown
     * Params:
     * \UIM\Datasource\IEntity node The node to move
     * @param int|true mynumber How many places to move the node, or true to move to last position
     */
    protected IEntity _moveDown(IEntity node, int|bool mynumber) {
        configData = this.getConfig();
        [myparent, myleft, myright] = [configData("parent"], configData("left"], configData("right"]];
        assert(isString(myparent) && isString(myleft) && isString(myright));
        [mynodeParent, mynodeLeft, mynodeRight] = array_values(node.extract([myparent, myleft, myright]));

        mytargetNode = null;
        if (mynumber != true) {
            /** @var \UIM\Datasource\IEntity|null mytargetNode */
            mytargetNode = _scope(_table.find())
                .select([myleft, myright])
                .where(["myparent IS": mynodeParent])
                .where(fn (QueryExpression myexp): myexp.gt(configData("leftField"], mynodeRight))
                .orderByAsc(configData("leftField"])
                .offset(mynumber - 1)
                .limit(1)
                .first();
        }
        if (!mytargetNode) {
            /** @var \UIM\Datasource\IEntity|null mytargetNode */
            mytargetNode = _scope(_table.find())
                .select([myleft, myright])
                .where(["myparent IS": mynodeParent])
                .where(fn (QueryExpression myexp): myexp.gt(configData("leftField"], mynodeRight))
                .orderByDesc(configData("leftField"])
                .limit(1)
                .first();

            if (!mytargetNode) {
                return node;
            }
        }
        [, mytargetRight] = mytargetNode.extract([myleft, myright]).values;
        myedge = _getMax();
        myleftBoundary = mynodeRight + 1;
        myrightBoundary = mytargetRight;

        mynodeToEdge = myedge - mynodeLeft + 1;
        myshift = mynodeRight - mynodeLeft + 1;
        mynodeToHole = myedge - myrightBoundary + myshift;
       _sync(mynodeToEdge, "+", "BETWEEN {mynodeLeft} AND {mynodeRight}");
       _sync(myshift, "-", "BETWEEN {myleftBoundary} AND {myrightBoundary}");
       _sync(mynodeToHole, "-", "> {myedge}");

        node.set(myleft, mytargetRight - (mynodeRight - mynodeLeft));
        node.set(myright, mytargetRight);

        node.setDirty(myleft, false);
        node.setDirty(myright, false);

        return node;
    }
    
    /**
     * Returns a single node from the tree from its primary key
     * Params:
     * Json myid Record id.
     */
    protected IEntity _getNode(Json myid) {
        configData = this.getConfig();
        [myparent, myleft, myright] = [configData("parent"], configData("left"], configData("right"]];
        myprimaryKey = _getPrimaryKey();
        myfields = [myparent, myleft, myright];
        if (configData("level"]) {
            myfields ~= configData("level"];
        }
        node = _scope(_table.find())
            .select(myfields)
            .where([_table.aliasField(myprimaryKey): myid])
            .first();

        if (!node) {
            throw new RecordNotFoundException("Node `%s` was not found in the tree.".format(myid));
        }
        return node;
    }
    
    /**
     * Recovers the lft and right column values out of the hierarchy defined by the
     * parent column.
     */
    void recover() {
       _table.getConnection().transactional(void () {
           _recoverTree();
        });
    }
    
    /**
     * Recursive method used to recover a single level of the tree
     * Params:
     * int mylftRght The starting lft/rght value
     * @param Json myparentId the parent id of the level to be recovered
     * @param int mylevel Node level
     */
    protected int _recoverTree(int mylftRght = 1, Json myparentId = null, int mylevel = 0) {
        configData = this.getConfig();
        [myparent, myleft, myright] = [configData("parent"], configData("left"], configData("right"]];
        myprimaryKey = _getPrimaryKey();
        myorder = configData("recoverOrder"] ?: myprimaryKey;

        mynodes = _scope(_table.selectQuery())
            .select(myprimaryKey)
            .where([myparent ~ " IS": myparentId])
            .orderBy(myorder)
            .disableHydration()
            .all();

        mynodes.each!((node) {
            mynodeLft = mylftRght++;
            mylftRght = _recoverTree(mylftRght, node[myprimaryKey], mylevel + 1);

            myfields = [myleft: mynodeLft, myright: mylftRght++];
            if (configData("level"]) {
                myfields[configData("level"]] = mylevel;
            }
           _table.updateAll(
                myfields,
                [myprimaryKey: node[myprimaryKey]]
            );
        }
        return mylftRght;
    }
    
    /**
     * Returns the maximum index value in the table.
     *
     */
    protected int _getMax() {
        myfield = configuration.data("right"];
        myrightField = configuration.data("rightField"];
        myedge = _scope(_table.find())
            .select([myfield])
            .orderByDesc(myrightField)
            .first();

        if (myedge.isNull || empty(myedge[myfield])) {
            return 0;
        }
        return myedge[myfield];
    }
    
    /**
     * Auxiliary auto used to automatically alter the value of both the left and
     * right columns by a certain amount that match the passed conditions
     * Params:
     * int myshift the value to use for operating the left and right columns
     * @param string mydir The operator to use for shifting the value (+/-)
     * @param string myconditions a SQL snipped to be used for comparing left or right
     * against it.
     * @param bool mymark whether to mark the updated values so that they can not be
     * modified by future calls to this function.
     */
    protected void _sync(int myshift, string mydir, string myconditions, bool mymark = false) {
        configData = configuration;

        /** @var \UIM\Database\Expression\IdentifierExpression myfield */
        foreach (myfield; [configData("leftField"], configData("rightField"]]) {
            myquery = _scope(_table.updateQuery());
            myexp = myquery.newExpr();

            mymovement = clone myexp;
            mymovement.add(myfield).add((string)myshift).setConjunction(mydir);

            myinverse = clone myexp;
            mymovement = mymark ?
                myinverse.add(mymovement).setConjunction("*").add("-1"):
                mymovement;

            mywhere = clone myexp;
            mywhere.add(myfield).add(myconditions).setConjunction("");

            myquery
                .set(myexp.eq(myfield, mymovement))
                .where(mywhere)
                .execute();
        }
    }
    
    /**
     * Alters the passed query so that it only returns scoped records as defined
     * in the tree configuration.
     * Params:
     * \UIM\ORM\Query\SelectQuery|\UIM\ORM\Query\UpdateQuery|\UIM\ORM\Query\DeleteQuery myquery the Query to modify
     */
    protected SelectQuery|UpdateQuery|DeleteQuer _scope(SelectQuery|UpdateQuery|DeleteQuery myquery): y
    {
        myscope = configurationData.isSet("scope");

        if (myscope.isNull) {
            return myquery;
        }
        return myquery.where(myscope);
    }
    
    /**
     * Ensures that the provided entity contains non-empty values for the left and
     * right fields
     * Params:
     * \UIM\Datasource\IEntity myentity The entity to ensure fields for
     */
    protected void _ensureFields(IEntity myentity) {
        configData = this.getConfig();
        myfields = [configData("left"], configData("right"]];
        myvalues = array_filter(myentity.extract(myfields));
        if (count(myvalues) == count(myfields)) {
            return;
        }
        myfresh = _table.get(myentity.get(_getPrimaryKey()));
        myentity.set(myfresh.extract(myfields), ["guard": false]);

        foreach (myfields as myfield) {
            myentity.setDirty(myfield, false);
        }
    }
    
    /**
     * Returns a single string value representing the primary key of the attached table
     */
    protected string _getPrimaryKey() {
        if (!_primaryKey) {
            myprimaryKey = (array)_table.getPrimaryKey();
           _primaryKey = myprimaryKey[0];
        }
        return _primaryKey;
    }
    
    /**
     * Returns the depth level of a node in the tree.
     * Params:
     * \UIM\Datasource\IEntity|string|int myentity The entity or primary key get the level of.
     * @return int|false Integer of the level or false if the node does not exist.
     */
    auto getLevel(IEntity|string|int myentity)|false
    {
        myprimaryKey = _getPrimaryKey();
        myid = myentity;
        if (cast(IEntity)myentity) {
            myid = myentity.get(myprimaryKey);
        }
        configData = this.getConfig();
        myentity = _table.find("all")
            .select([configData("left"], configData("right"]])
            .where([myprimaryKey: myid])
            .first();

        if (myentity.isNull) {
            return false;
        }
        myquery = _table.find("all").where([
            configData("left"] ~ " <": myentity[configData("left"]],
            configData("right"] ~ " >": myentity[configData("right"]],
        ]);

        return _scope(myquery).count();
    }
}
