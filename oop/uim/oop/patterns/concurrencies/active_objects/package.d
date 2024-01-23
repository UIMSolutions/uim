/*********************************************************************************************************
*  Copyright: © 2015 - 2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                       *
*  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. *
*  Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                     *
*********************************************************************************************************/
/**
Source: Wikipedia [EN] 
The active object design pattern decouples method execution from method invocation for objects that each reside in their own thread of control.[1] The goal is to introduce concurrency, by using asynchronous method invocation and a scheduler for handling requests.[2]

The pattern consists of six elements:[3]

* A proxy, which provides an interface towards clients with publicly accessible methods.
* An interface which defines the method request on an active object.
* A list of pending requests from clients.
* A scheduler, which decides which request to execute next.
* The implementation of the active object method.
* A callback or variable for the client to receive the result.
**/ 
module uim.oop.patterns.concurrencies.active_objects;

import uim.oop;
@safe:

/// Firstly we can see a standard class that provides two methods that set a double to be a certain value. This class does NOT conform to the active object pattern.
class MyClass {
    private double val = 0.0;
    
    void doSomething() {
        val = 1.0;
    }

    void doSomethingElse() {
        val = 2.0;
    }
}

/* The class is dangerous in a multithreading scenario because both methods can be called simultaneously, so the value of val (which is not atomic—it's updated in multiple steps) could be undefined—a classic race condition. You can, of course, use synchronization to solve this problem, which in this trivial case is easy. But once the class becomes realistically complex, synchronization can become very difficult. [5]

To rewrite this class as an active object, you could do the following:

class MyActiveObject {

    private double val = 0.0;
    private BlockingQueue<Runnable> dispatchQueue = new LinkedBlockingQueue<Runnable>();

    public MyActiveObject() {
        new Thread (new Runnable() {
                    
                @Override
                public void run() {
                    try {
                        while (true) {
                            dispatchQueue.take().run();
                        }
                    } catch (InterrupteUimException e) {   
                        // okay, just terminate the dispatcher
                    }
                }
            }
        ).start();
    }

    void doSomething() throws InterrupteUimException {
        dispatchQueue.put(new Runnable() {
                @Override
                public void run() { 
                    val = 1.0; 
                }
            }
        );
    }

    void doSomethingElse() throws InterrupteUimException {
        dispatchQueue.put(new Runnable() {
                @Override
                public void run() { 
                    val = 2.0; 
                }
            }
        );
    }
}
*/ 

/* JAVA 8
public class MyClass {
    private double val; 
    
    // container for tasks
    // decides which request to execute next 
    // asyncMode=true means our worker thread processes its local task queue in the FIFO order 
    // only single thread may modify internal state
    private final ForkJoinPool fj = new ForkJoinPool(1, ForkJoinPool.defaultForkJoinWorkerThreadFactory, null, true);
    
    // implementation of active object method
    public void doSomething() throws InterrupteUimException {
        fj.execute(() -> { val = 1.0; });
    }
 
    // implementation of active object method
    public void doSomethingElse() throws InterrupteUimException {
        fj.execute(() -> { val = 2.0; });
    }
}
*/ 