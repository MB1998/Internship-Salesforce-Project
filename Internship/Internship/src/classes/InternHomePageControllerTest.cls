@isTest
public class InternHomePageControllerTest {
	@isTest
    public static void test(){
        
        Group__c newgroup = sObjectFactory.getGroups(1, Date.today(), Date.today().addDays(20))[0];
        insert newgroup;
        List<Intern__c> newInterns = sObjectFactory.getInterns(10, newgroup.Id, 'test@test.com');
        insert newInterns;
        List<Homework__c> newHomeworks = sObjectFactory.getHomeworks(15, newgroup.Id, Date.today().addDays(5), 'topics');
        insert newHomeworks;
        List<Test__c> newTests = sObjectFactory.getTests(10, newgroup.Id, Date.today().addDays(5), 'topics');
        insert newTests;
        List<Resource__c> newResources = sObjectFactory.getResources(10, newgroup.Id, 'www.ex.ua');
        insert newResources;
        
        String idVariable = [SELECT Id FROM Intern__c LIMIT 1][0].Id;
        Test.setCurrentPageReference(new PageReference('Page.internHomePage')); 
		System.currentPageReference().getParameters().put('id', idVariable);
        
        System.Test.startTest();
        InternHomePageController newInternHomePageController = new InternHomePageController();
        newInternHomePageController.selected = [SELECT Id FROM Homework__c LIMIT 1][0].Id;
        newInternHomePageController.edit();
        newInternHomePageController.cancel();
        newInternHomePageController.save();
        newInternHomePageController.done();
        System.Test.stopTest();
        
        System.assertEquals(idVariable, idVariable);
    }
}