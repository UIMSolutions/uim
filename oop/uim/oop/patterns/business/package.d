/***********************************************************************************
*	Copyright: ©2015-2024 Ozan Nurettin Süel (sicherheitsschmiede)                   *
*	License  : Licensed under Apache 2 [https://apache.org/licenses/LICENSE-2.0.txt] *
*	Author   : Ozan Nurettin Süel (Sicherheitsschmiede)										           * 
***********************************************************************************/
module uim.oop.patterns.business;

import uim.oop;

@safe:

interface IBusinessService {
  void doProcessing();
}

/// Create concrete Service classes.
class DEJBService : IBusinessService {
  override void doProcessing() {
    writeln("Processing task by invoking EJB Service");
  }
}

class JMSService : IBusinessService {
  override void doProcessing() {
    writeln("Processing task by invoking JMS Service");
  }
}

/// Create Business Lookup Service.
class DBusinessLookUp {
  IBusinessService getBusinessService(string serviceType) {

    // TODO an error?
/*    return serviceType.toLower == "EJB".toLower
      ? new DEJBService() : new JMSService();
*/
    return null;
  }
}

/// Create Business Delegate.
class DBusinessDelegate {
  private BusinessLookUp lookupService = new BusinessLookUp();
  private IBusinessService businessService;
  private string _serviceType;

  void setServiceType(string serviceType) {
    _serviceType = serviceType;
  }

  void doTask() {
    businessService = lookupService.getBusinessService(_serviceType);
    businessService.doProcessing();
  }
}

/// Create Client.
class DClient {
  BusinessDelegate _businessService;

  this(BusinessDelegate newBusinessService) {
    _businessService = newBusinessService;
  }

  void doTask() {
    _businessService.doTask();
  }
}

/// Use BusinessDelegate and Client classes to demonstrate Business Delegate pattern.
version (test_uim_oop) {
  unittest {
    BusinessDelegate businessDelegate = new BusinessDelegate();
    businessDelegate.setServiceType("EJB");

    Client client = new DClient(businessDelegate);
    client.doTask();

    businessDelegate.setServiceType("JMS");
    client.doTask();
  }
}
