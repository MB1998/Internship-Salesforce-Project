public class HomeworkHandler {
    public static void afterInsert(List<Homework__c> homeworks){
        
        Set<Id> groupIds = new Set<Id>();
        for(Homework__c homework : homeworks){
            groupIds.add(homework.Group__c);
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
        
        List<Junction_Intern_Homework__c> newJunction_Intern_Homeworks = new List<Junction_Intern_Homework__c>();
        for(Homework__c homework : homeworks){
            for(Intern__c intern : internsByGroup.get(homework.Group__c)){
                Junction_Intern_Homework__c newJunction_Intern_Homework = new Junction_Intern_Homework__c(Intern__c = intern.Id, Homework__c = homework.Id, Mark__c = 0, Comment__c = '');
                newJunction_Intern_Homeworks.add(newJunction_Intern_Homework);
            }
        }
        insert newJunction_Intern_Homeworks;
    }
}