public class TestHandler {
    public static void afterInsert(List<Test__c> tests){
        
        Set<Id> groupIds = new Set<Id>();
        for(Test__c test : tests){
            groupIds.add(test.Group__c);
        }
        
        List<Intern__c> interns = [SELECT Id, Group__c FROM Intern__c WHERE Group__c IN :groupIds];
        
        Map<Id, List<Intern__c>> internsByGroup = new Map<Id, List<Intern__c>>();
        for(Intern__c intern : interns){
            if(internsByGroup.containsKey(intern.Group__c)){
                internsByGroup.get(intern.Group__c).add(intern);
            } else {
                internsByGroup.put(intern.Group__c, new List<Intern__c>{intern});
            }
        }
        
        List<Junction_Intern_Test__c> newJunction_Intern_Tests = new List<Junction_Intern_Test__c>();
        for(Test__c test : tests){
            for(Intern__c intern : internsByGroup.get(test.Group__c)){
                Junction_Intern_Test__c Junction_Intern_Test = new Junction_Intern_Test__c(Intern__c = intern.Id, Test__c = test.Id, Mark__c = 0);
                newJunction_Intern_Tests.add(Junction_Intern_Test);
            }
        }
        insert newJunction_Intern_Tests;
    }
}