@isTest
public class InternPageControllerTest {
	@isTest
    public static void test(){
        Group__c newGroup = sObjectFactory.getGroups(1, Date.today(), Date.today().addMonths(1))[0];
        insert newGroup;
        List<Intern__c> newInterns = sObjectFactory.getInterns(15, newGroup.Id, 'test@test.com');
        insert newInterns;
        
        System.test.startTest();
        internPageController newinternPageController = new internPageController();
        System.test.stopTest();
        
        System.assertEquals(newInterns.size(), newinternPageController.countInterns);
    }
}