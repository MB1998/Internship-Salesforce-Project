@isTest
public class RecountRatingScheduleJobTest {
	@isTest
    public static void test(){
        RecountRatingScheduleJobTest.setupData();
        
        List<Coefficients__c> coefficients = new List<Coefficients__c>();
        Coefficients__c Trailhead = new Coefficients__c(Name = 'Trailhead', Coefficient_for_rating__c = 30.0);
        Coefficients__c HomeworkMarks = new Coefficients__c(Name = 'Homework marks', Coefficient_for_rating__c = 30.0);
        Coefficients__c Testsresults = new Coefficients__c(Name = 'Tests results', Coefficient_for_rating__c = 40.0);
        coefficients.add(Trailhead);
        coefficients.add(HomeworkMarks);
        coefficients.add(Testsresults);
        insert coefficients;
        
        System.Test.startTest();
        String jobId = System.schedule('RecountRatingScheduleJobTest','0 0 0 15 3 ? 2022', new RecountRatingScheduleJob());
        System.Test.stopTest();
        
        List<Intern__c> internsToCheck = [SELECT Id, Rating__c FROM Intern__c];
        for(Intern__c intern : internsToCheck){
            System.debug(intern.Rating__c);
        	System.assert(intern.Rating__c != 0 && intern.Rating__c != null);
        }
    }
    
    @isTest
    private static void setupData(){
        Group__c testGroup = sObjectFactory.getGroups(1, Date.today(), Date.today().addMonths(2))[0];
        insert testGroup;
        
        List<Intern__c> testInterns = sObjectFactory.getInterns(10, testGroup.Id, 'test@test.com');
        insert testInterns;
        
        List<Homework__c> testHomeworks = sObjectFactory.getHomeworks(10, testGroup.Id, DateTime.now(), 'topics');
        insert testHomeworks;
        
        List<Test__c> testTests = sObjectFactory.getTests(10, testGroup.Id, DateTime.now(), 'topics');
        insert testTests;
        
        List<Junction_Intern_Homework__c> Junction_Intern_Homeworks = 
            [SELECT Id, Mark__c FROM Junction_Intern_Homework__c WHERE Intern__c IN :testInterns AND Homework__c IN :testHomeworks];
        List<Junction_Intern_Test__c> Junction_Intern_Tests = 
            [SELECT Id, Mark__c FROM Junction_Intern_Test__c WHERE Intern__c IN :testInterns AND Test__c IN :testTests];
        
        for(Junction_Intern_Homework__c Junction_Intern_Homework : Junction_Intern_Homeworks){
            Junction_Intern_Homework.Mark__c = Math.round(Math.random()*100);
        }
        update Junction_Intern_Homeworks;
        
        for(Junction_Intern_Test__c Junction_Intern_Test : Junction_Intern_Tests){
            Junction_Intern_Test.Mark__c = Math.round(Math.random()*100);
        }
        update Junction_Intern_Tests;
    }
}