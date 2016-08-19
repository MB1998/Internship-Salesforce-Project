@isTest
public class TestPageControllerTest {
	@isTest
    public static void test(){
        Group__c newGroup = sObjectFactory.getGroups(1, Date.today(), Date.today().addMonths(1))[0];
        insert newGroup;
        List<Intern__c> newInterns = sObjectFactory.getInterns(10, newGroup.Id, 'test@test.com');
        insert newInterns;
        List<Test__c> newTests = sObjectFactory.getTests(10, newGroup.Id, Date.today().addMonths(1), 'topics');
        insert newTests;
        
        System.test.startTest();
        TestPageController testTestPageController = new TestPageController();
        System.Test.stopTest();
        
        System.assertEquals(newTests.size(), TestPageController.countTest);
    }
}