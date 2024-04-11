module uim.consoles.tests.stubconsoleinput;

import uim.consoles;

@safe:

/**
 * Stub class used by the console integration harness.
 *
 * This class enables input to be stubbed and have exceptions
 * raised when no answer is available.
 */
class DStubConsoleInput : DConsoleInput {
    // Reply values for ask() and askChoice()
    protected string[] _replies;

    // Current message index
    protected size_t _currentIndex = -1;

    /* 
    this(string[] repliesForRead) {
        super();

        _replies = repliesForRead;
    }
    
    // Read a reply
    string read() {
        _currentIndex += 1;

        if (!this.replies.isSet(_currentIndex)) {
            total = count(this.replies);
            formatter = new DNumberFormatter("en", NumberFormatter.ORDINAL);
            nth = formatter.format(_currentIndex + 1);

            replies = join(", ", this.replies);
            
            string message = "There are no more input replies available. This is the {nth} read operation, " .
                "only {total} replies were set.\nThe provided replies are: {replies}";
            throw new MissingConsoleInputException(message);
        }
        return this.replies[_currentIndex];
    }
    
    //  Check if data is available on stdin
    bool dataAvailable(int timeToWait = 0) {
        return true;
    } */
}

