public class sObjectFactory {
    public static List<Homework__c> getHomeworks(Integer countOfRequiredRecords, Id GroupId, DateTime DeadLine, String topics){
        List<Homework__c> newHomeworks = new List<Homework__c>();
        for(Integer i = 0; i < countOfRequiredRecords; i++){
            Homework__c newHomework = new Homework__c(Group__c = GroupId, DeadLine__c = DeadLine, Topics__c = topics);
            newHomeworks.add(newHomework);
        }
        return newHomeworks;
    }
    
    public static List<Test__c> getTests(Integer countOfRequiredRecords, Id GroupId, DateTime MyDate, String topics){
        List<Test__c> newTests = new List<Test__c>();
        for(Integer i = 0; i < countOfRequiredRecords; i++){
            Test__c newTest = new Test__c(Group__c = GroupId, Date__c = MyDate, Topics__c = topics, Complexity__c = 0, Lecturer_Name__c = 'test Lecturer`s Name');
            newTests.add(newTest);
        }
        return newTests;
    }
    
    public static List<Group__c> getGroups(Integer countOfRequiredRecords, Date StartDate, Date FinalDate){
        List<Group__c> newGroups = new List<Group__c>();
        for(Integer i = 0; i < countOfRequiredRecords; i++){
            Group__c newGroup = new Group__c(Start_Date__c = StartDate, Final_Date__c = FinalDate);
            newGroups.add(newGroup);
        }
        return newGroups;
    }
    public static List<Intern__c> getInterns(Integer countOfRequiredRecords, Id GroupId, String email){
        List<Intern__c> newInterns = new List<Intern__c>();
        for(Integer i = 0; i < countOfRequiredRecords; i++){
            Intern__c newIntern = new Intern__c(Group__c = GroupId, Email__c = i + email, Skype_id__c = 'test.skype.id' + i, Login_for_org__c = i + email, Password_for_org__c = 'Password', 
                                                Trailhead_Progress__c = 100 * Math.round(Math.random()*1000));
            newInterns.add(newIntern);
        }
        return newInterns;
    }
    
    public static List<Resource__c> getResources(Integer countOfRequiredRecords, Id GroupId, String Link){
        List<Resource__c> newResources = new List<Resource__c>();
        for(Integer i = 0; i < countOfRequiredRecords; i++){
            Resource__c newResource = new Resource__c(Name = 'Test '+i, Group__c = GroupId, Link__c = Link);
            newResources.add(newResource);
        }
        return newResources;
    }
}