/**
* @author Kevin Winn
* @date May 17, 2022
* @group Test Classes
* @description after delete trigger handler test for object 
*/
@isTest
private class ErrorLogAfterDeleteTriggerHandlerTest {
	@testSetup
	static void setupTestData()	{
		TestDataFactory.generateErrorLogs(StaticResources.TEST_LIST_SIZE);
	}

	@isTest
	static void deleteTestSuccess() {
		Map<Id,ErrorLog__c> logs = new Map<Id,ErrorLog__c>(ErrorLogHelper.getErrorLogs());
		List<ErrorLog__c> dupes = new LIst<ErrorLog__c>();
		for(ErrorLog__c l : logs.values()){
			if(l.Duplicate__c == true){
				dupes.add(l);
			}
		}
		Test.startTest();
		GlobalDMLHandler.deleteObjectList(dupes);
		Test.stopTest();

		List<ErrorLog__c> noDupes = [Select Id From ErrorLog__c Where Duplicate__c = false];
		System.assertNotEquals(true, noDupes.isEmpty(),'dupes are empty');
	}

	@isTest
	static void deleteAgedLogsSuccess(){
		Integer target = 1;
		Test.startTest();
		ErrorLogHelper.deleteAgedErrorLogs(target);
		Test.stopTest();
		List<ErrorLog__c> logs = [Select Id From ErrorLog__c Where IsDeleted = false];
		System.assertEquals(false,logs.isEmpty(),'logs are empty');
	}
}