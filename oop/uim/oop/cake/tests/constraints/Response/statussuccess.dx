module uim.cake.TestSuite\Constraint\Response;

import uim.cake;

@safe:

/* * StatusSuccess
 *
 * @internal
 */
class StatusSuccess : StatusCodeBase {
    /**
     * @var array<int, int>|int
     */
    protected array|int code = [200, 308];

    // Assertion message
    override string toString() {
        return "%d is between 200 and 308".format(this.response.statusCode());
    }
}
