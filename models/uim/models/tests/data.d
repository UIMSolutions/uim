module uim.models.tests.data;

import uim.models;
@safe:

bool testDataSetGet(IData testData) {
    assert(testData !is null, "testDataSetGet: testdata is null");
    
    testData.set("0");
    assert(testData.toString == "1", "testDataSetGet: testdata string set get not work");

    return true;
}