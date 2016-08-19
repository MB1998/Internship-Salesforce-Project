public class internPageController{
    public List<Intern__c> interns {get;set;}
    public Integer countInterns {get;set;}
    
    public internPageController(){
        interns = [SELECT Id, Name, Group__r.Name, Email__c, Phone__c, Skype_id__c, Login_for_org__c, Password_for_org__c, Progress__c, Rating__c, Trailhead_Progress__c FROM Intern__c];
        countInterns = interns.size();
    }  
}