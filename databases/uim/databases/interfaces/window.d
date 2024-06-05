module uim.databases.interfaces.window;

import uim.databases;

@safe:

// This defines the functions used for building window expressions.
interface IWindow {
    const string PRECEDING = "PRECEDING";

    const string FOLLOWING = "FOLLOWING";

    const string RANGE = "RANGE";

    const string ROWS = "ROWS";

    const string GROUPS = "GROUPS";

    /**
     * Adds one or more partition expressions to the window.
     * Params:
     * \UIM\Database\IExpression|\Closure|array<\UIM\Database\/* IExpression| */ string>|string apartitions Partition expressions
     */
    auto partition(/* IExpression|Closure */string[] apartitions);

    /**
     * Adds one or more order by clauses to the window.
     * Params:
     * \UIM\Database\IExpression|\Closure|array<\UIM\Database\/* IExpression| */ string>|string fieldNames DOrder expressions
     */
    auto orderBy(/* IExpression|Closure */string[] fieldNames);

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
     */
    auto range(/* /* IExpression| */ string */ int frameStart = 0, /* /* IExpression| */ string */ int frameEnd = 0);

    // Adds a simple rows frame to the window.
    auto rows(int frameStart, int frameEnd = 0);

    // Adds a simple groups frame to the window.
    auto groups(int frameStart, int frameEnd = 0);

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
     */
    void frame(
        string frameType,
        /* /* IExpression| */ string| */ int frameStartOffset,
        string frameStartDirection,
        /* /* IExpression| */ string| */ int frameEndOffset,
        string frameEndDirection
   );

    // Adds current row frame exclusion.
    auto excludeCurrent();

    // Adds group frame exclusion.
    auto excludeGroup();

    // Adds ties frame exclusion.
    auto excludeTies();
}
