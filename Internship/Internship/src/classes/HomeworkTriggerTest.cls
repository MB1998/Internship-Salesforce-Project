@isTest
public class HomeworkTriggerTest {
    @isTest
    public static void afterInsertTest(){
        Group__c testGroup = sObjectFactory.getGroups(1, Date.today(), Date.today().addMonths(1))[0];
        insert testGroup;
        List<Intern__c> testInterns = sObjectFactory.getInterns(10, testGroup.Id, 'test@test.com');
        insert testInterns;
        List<Homework__c> testHomeworks = sObjectFactory.getHomeworks(200, testGroup.Id, DateTime.now().addDays(5), 'topics');
        
        System.Test.startTest();
        insert testHomeworks;
        System.Test.stopTest();
        
        List<Homework__c> testHomeworksToCheck = [SELECT Id FROM Homework__c WHERE Group__c = :testGroup.Id];
        List<Junction_Intern_Homework__c> Junction_Intern_HomeworkToCheck = 
            [SELECT Id FROM Junction_Intern_Homework__c WHERE Intern__c IN :testInterns AND Homework__c IN :testHomeworksToCheck];
        System.assertEquals(200, testHomeworksToCheck.size());
        System.assertEquals(2000, Junction_Intern_HomeworkToCheck.size());
    }
}