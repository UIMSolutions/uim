/*********************************************************************************************************
* Copyright: © 2015-2024 Ozan Nurettin Süel (UIManufaktur)                                       *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. *
* Authors: Ozan Nurettin Süel (UIManufaktur)                                                     *
*********************************************************************************************************/
module uim.oop.patterns.creationals.object_pools;

import uim.oop;

// TODO
@safe:

/* 
class DConnection {
  void close() {}
  bool isClosed() { 
      return false; 
    }
}

abstract class ObjectPool(T) {
  private long expirationTime;

  private long[T] locked;
  private long[T] unlocked;

  this() {
    expirationTime = 30000; // 30 seconds
  }

  protected abstract T create();

  abstract bool validate(T o);

  abstract void expire(T o);

  /* synchronized * /
T checkOut() {
  long now = toTimestamp(now());
  T t;
  if (!unlocked.empty) {
    foreach (e; unlocked.byKey.array) {
      t = e;
      if ((now - unlocked[t]) > expirationTime) {
        // object has expired
        unlocked.removeKey(t);
        expire(t);
        t = null;
      } else {
        if (validate(t)) {
          unlocked.removeKey(t);
          locked[t] = now;
          return (t);
        } else {
          // object failed validation
          unlocked.removeKey(t);
          expire(t);
          t = null;
        }
      }
    }
  }
  // no objects available, create a new one
  t = create();
  locked[t] = now;
  return (t);
}

/* synchronized * /
void checkIn(T t) {
  locked.removeKey(t);
  unlocked[t] = toTimestamp(now());
}
}

//The three remaining methods are abstract 
//and therefore must be implemented by the subclass

class DConnectionPool : ObjectPool!Connection {

  private string dsn, usr, pwd;

  this(string driver, string dsn, string usr, string pwd) {
    super();
    this.dsn = dsn;
    this.usr = usr;
    this.pwd = pwd;
  }

  override protected IConnection create() {
    return new DConnection;
  }

  override void expire(Connection connection) {
    try {
      connection.close();
    } catch (Exception e) {
      debug writeln(e);
    }
  }

  override
  bool validate(Connection connection) {
    try {
      return (!connection.isClosed);
    } catch (Exception e) {
      debug writeln(e);
      return (false);
    }
  }
}

version (test_uim_oop) {
  unittest {
    // Create the ConnectionPool:
    ConnectionPool pool = new DConnectionPool(
      "org.hsqldb.jdbcDriver", "jdbc:hsqldb://localhost/mydb",
      "sa", "secret");

    // Get a connection:
    Connection con = pool.checkOut();

    // Return the connection:
    pool.checkIn(con);
  }
}
 */ 