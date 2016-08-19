@isTest
public class TestTriggerTest {
    @isTest
    public static void afterInsertTest(){
        Group__c testGroup = sObjectFactory.getGroups(1, Date.today(), Date.today().addMonths(1))[0];
        insert testGroup;
        List<Intern__c> testInterns = sObjectFactory.getInterns(10, testGroup.Id, 'test@test.com');
        insert testInterns;
        List<Test__c> testTests = sObjectFactory.getTests(200, testGroup.Id, DateTime.now().addDays(5), 'topics');
        
        System.Test.startTest();
        insert testTests;
        System.Test.stopTest();
        
        List<Test__c> testTestsToCheck = [SELECT Id FROM Test__c WHERE Group__c = :testGroup.Id];
        List<Junction_Intern_Test__c> Junction_Intern_TestToCheck = 
            [SELECT Id FROM Junction_Intern_Test__c WHERE Intern__c IN :testInterns AND Test__c IN :testTestsToCheck];
        System.assertEquals(200, testTestsToCheck.size());
        System.assertEquals(2000, Junction_Intern_TestToCheck.size());
    }
}