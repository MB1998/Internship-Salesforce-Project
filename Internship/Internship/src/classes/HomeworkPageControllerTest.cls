@isTest
public class HomeworkPageControllerTest {
	@isTest
    public static void test(){
        Group__c newGroup = sObjectFactory.getGroups(1, Date.today(), Date.today().addMonths(1))[0];
        insert newGroup;
        List<Intern__c> newInterns = sObjectFactory.getInterns(10, newGroup.Id, 'test@test.com');
        insert newInterns;
        List<Homework__c> newHomeworks = sObjectFactory.getHomeworks(10, newGroup.Id, Date.today().addMonths(1), 'topics');
        insert newHomeworks;
        
        System.test.startTest();
        HomeworkPageController testHomeworkPageController = new HomeworkPageController();
        System.Test.stopTest();
        
        System.assertEquals(newHomeworks.size(), HomeworkPageController.countHomework);
    }
}