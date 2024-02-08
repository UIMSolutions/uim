/***********************************************************************************
*	Copyright: ©2015-2024 Ozan Nurettin Süel (sicherheitsschmiede)                   *
*	License  : Licensed under Apache 2 [https://apache.org/licenses/LICENSE-2.0.txt] *
*	Author   : Ozan Nurettin Süel (Sicherheitsschmiede)										           * 
***********************************************************************************/
/**
SOurce Wikipedia [EN]:
In software engineering, double-checked locking (also known as "double-checked locking optimization"[) is a software design pattern used 
to reduce the overhead of acquiring a lock by testing the locking criterion (the "lock hint") before acquiring the lock. Locking occurs only if the locking criterion check indicates that locking is required.

The pattern, when implemented in some language/hardware combinations, can be unsafe. At times, it can be considered an anti-pattern.

It is typically used to reduce locking overhead when implementing "lazy initialization" in a multi-threaded environment, especially 
as part of the Singleton pattern. Lazy initialization avoids initializing a value until the first time it is accessed.
**/
module uim.oop.patterns.architecturals.double_checked_lockings;

import uim.oop;
@safe: