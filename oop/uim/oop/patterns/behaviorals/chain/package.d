/***********************************************************************************
*	Copyright: ©2015 -2024 Ozan Nurettin Süel (sicherheitsschmiede)                   *
*	License  : Licensed under Apache 2 [https://apache.org/licenses/LICENSE-2.0.txt] *
*	Author   : Ozan Nurettin Süel (Sicherheitsschmiede)										           * 
***********************************************************************************/
module uim.oop.patterns.behavioral.chain;

import uim.oop;
@safe:

/// Create an abstract logger class.
abstract class AbstractLogger {
  static int INFO = 1;
  static int DEBUG = 2;
  static int ERROR = 3;

  protected int _level;

  //next element in chain or responsibility
  protected AbstractLogger _nextLogger;

  @property void nextLogger(AbstractLogger nextLogger) {
    _nextLogger = nextLogger;
  }

  void logMessage(int level, string message) {
    if(_level <= level) {
        write(message); }
    if(_nextLogger) _nextLogger.logMessage(level, message);
  }

  abstract protected void write(string message);
}

/// Create concrete classes extending the logger.
class ConsoleLogger : AbstractLogger {

  this(int level) {
    _level = level;
  }

  override protected void write(string message) {		
    writeln("Standard Console::Logger: ", message);
  }
}

class ErrorLogger : AbstractLogger {
  this(int level) {
    _level = level;
  }

  override protected void write(string message) {		
    writeln("Error Console::Logger: "~message);
  }
}

class FileLogger : AbstractLogger {

  this(int level) {
    _level = level;
  }

  override protected void write(string message) {		
    writeln("File::Logger: ", message);
  }
}

private static AbstractLogger getChainOfLoggers() {
  AbstractLogger errorLogger = new ErrorLogger(AbstractLogger.ERROR);
  AbstractLogger fileLogger = new FileLogger(AbstractLogger.DEBUG);
  AbstractLogger consoleLogger = new ConsoleLogger(AbstractLogger.INFO);

  errorLogger.nextLogger = fileLogger;
  fileLogger.nextLogger = consoleLogger;

  return errorLogger;	
}

/// Create different types of loggers. Assign them error levels and set next logger in each logger. Next logger in each logger represents the part of the chain.
version(test_uim_oop) { unittest {
   writeln("ChainPatternDemo"); 
   
   AbstractLogger loggerChain = getChainOfLoggers();

   loggerChain.logMessage(AbstractLogger.INFO, 
      "This is an information.");

   loggerChain.logMessage(AbstractLogger.DEBUG, 
      "This is an debug level information.");

   loggerChain.logMessage(AbstractLogger.ERROR, 
        "This is an error information.");
   }
}