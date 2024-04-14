module uim.databases.interfaces.window;

import uim.databases;

@safe:

// This defines the functions used for building window expressions.
interface IWindow {
    /*
    const string PRECEDING = "PRECEDING";

    const string FOLLOWING = "FOLLOWING";

    const string RANGE = "RANGE";

    const string ROWS = "ROWS";

    const string GROUPS = "GROUPS";

    /**
     * Adds one or more partition expressions to the window.
     * Params:
     * \UIM\Database\IExpression|\Closure|array<\UIM\Database\IExpression|string>|string apartitions Partition expressions
     * /
    auto partition(IExpression|Closure|string[] apartitions);

    /**
     * Adds one or more order by clauses to the window.
     * Params:
     * \UIM\Database\IExpression|\Closure|array<\UIM\Database\IExpression|string>|string afields DOrder expressions
     * /
    auto orderBy(IExpression|Closure|string[] afields);

    /**
     * Adds a simple range frame to the window.
     *
     * `start`:
     * - `0` - 'CURRENT ROW'
     * - `null` - 'UNBOUNDED PRECEDING'
     * - offset - 'offset PRECEDING'
     *
     * `end`:
     * - `0` - 'CURRENT ROW'
     * - `null` - 'UNBOUNDED FOLLOWING'
     * - offset - 'offset FOLLOWING'
     *
     * If you need to use 'FOLLOWING' with frame start or
     * 'PRECEDING' with frame end, use `frame()` instead.
     * Params:
     * \UIM\Database\IExpression|string|int start Frame start
     * @param \UIM\Database\IExpression|string|int end Frame end
     * If not passed in, only frame start SQL will be generated.
     * /
    auto range(IExpression|string|int start, IExpression|string|int end = 0);

    /**
     * Adds a simple rows frame to the window.
     *
     * See `range()` for details.
     * Params:
     * int start Frame start
     * @param int end Frame end
     * If not passed in, only frame start SQL will be generated.
     * /
    auto rows(int start, int end = 0);

    /**
     * Adds a simple groups frame to the window.
     *
     * See `range()` for details.
     * Params:
     * int start Frame start
     * @param int end Frame end
     * If not passed in, only frame start SQL will be generated.
     * /
    auto groups(int start, int end = 0);

    /**
     * Adds a frame to the window.
     *
     * Use the `range()`, `rows()` or `groups()` helpers if you need simple
     * 'BETWEEN offset PRECEDING and offset FOLLOWING' frames.
     *
     * You can specify any direction for both frame start and frame end.
     *
     * With both `startOffset` and `endOffset`:
     * - `0` - 'CURRENT ROW'
     * - `null` - 'UNBOUNDED'
     * Params:
     * string atype Frame type
     * @param \UIM\Database\IExpression|string|int startOffset Frame start offset
     * @param string astartDirection Frame start direction
     * @param \UIM\Database\IExpression|string|int endOffset Frame end offset
     * @param string aendDirection Frame end direction
     * /
    void frame(
        string atype,
        IExpression|string|int startOffset,
        string astartDirection,
        IExpression|string|int endOffset,
        string aendDirection
    );

    // Adds current row frame exclusion.
    auto excludeCurrent();

    /**
     * Adds group frame exclusion.
     * /
    auto excludeGroup();

    // Adds ties frame exclusion.
    auto excludeTies();

    */
}
