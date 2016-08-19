public class HomeworkPageController{
    public static List<ObjectWrapper> internsPerformance{get;set;}
    public static List<Homework__c> homeworks{get;set;}
    public static Integer countHomework {get;set;}
    
    public HomeworkPageController(){
        homeworks = [SELECT Id, Name, Task__c, Deadline__c, Topics__c FROM Homework__c WHERE OwnerId = :UserInfo.getUserId() ORDER BY CreatedDate DESC];
        countHomework = homeworks.size();
        Map<Id, Homework__c> homeworksById = new Map<Id, Homework__c>(homeworks);

        Set<Id> homeworkIds = new Set<Id>();
        List<String> homeworksNames = new List<String>();
        for(Homework__c homework: homeworks){
            homeworkIds.add(homework.Id);
            homeworksNames.add(homework.name);
        }
        
        List<Intern__c> interns = [SELECT ID, Name FROM Intern__c ORDER BY CreatedDate DESC];
        Map<Id, Intern__c> InternsById = new Map<Id, Intern__c>(interns);
        
        List<Junction_Intern_Homework__c> junctions = [SELECT ID, Homework__c, Intern__c, Mark__c, Comment__c FROM Junction_Intern_Homework__c WHERE Homework__c IN :homeworkIds ORDER BY Homework__r.CreatedDate DESC];
        
        Map<Intern__c, List<Junction_Intern_Homework__c>> junctionsByInterns = new Map<Intern__c, List<Junction_Intern_Homework__c>>();
        for(Junction_Intern_Homework__c junction : junctions){
            if(junctionsByInterns.containsKey(InternsById.get(junction.Intern__c))){
                junctionsByInterns.get(InternsById.get(junction.Intern__c)).add(junction);
            } else {
                junctionsByInterns.put(InternsById.get(junction.Intern__c), new List<Junction_Intern_Homework__c> {junction});
            }
        }
        
        internsPerformance = new List<ObjectWrapper>();
        ObjectWrapper newHeaderObjectWrapper = new ObjectWrapper('Intern name', homeworksNames);
        internsPerformance.add(newHeaderObjectWrapper);
        
        for(Intern__c intern : junctionsByInterns.keySet()){
            ObjectWrapper newObjectWrapper = new ObjectWrapper(intern, junctionsByInterns.get(intern), homeworksById);
            internsPerformance.add(newObjectWrapper);
        }
    }
    
    public class ObjectWrapper{
        public Intern__c intern {get;set;}
        public List<FieldWrapper> homeworksResults {get;set;}
        
        public ObjectWrapper(Intern__c newintern, List<Junction_Intern_Homework__c> junctions, Map<Id, Homework__c> homeworksById){
            intern = newintern;
            homeworksResults = new List<FieldWrapper>();
            
            for(Junction_Intern_Homework__c junction : junctions){
                FieldWrapper newFieldWrapper = new FieldWrapper(junction, homeworksById);
                homeworksResults.add(newFieldWrapper);
            }
        }
        
        public ObjectWrapper(String internName, List<String> homeworksNames){
            intern = new Intern__c(Name = internName);
            homeworksResults = new List<FieldWrapper>();
            
            for(String homeworkName : homeworksNames){
                FieldWrapper newFieldWrapper = new FieldWrapper(homeworkName , homeworkName );
                homeworksResults.add(newFieldWrapper);
            }
        }
    }
    
    public class FieldWrapper{
        public HomeWork__c Homework {get;set;}
        public Decimal HomeworkMark {get;set;}
        public String HomeworkResult {get;set;}
        public String HomeworkComment {get;set;}
        
        public FieldWrapper(Junction_Intern_Homework__c junction, Map<Id, Homework__c> homeworksById){
            Homework = homeworksById.get(junction.Homework__c);
            HomeworkMark = junction.Mark__c;
            HomeworkResult = String.valueOf(HomeworkMark);
            HomeworkComment = junction.Comment__c;
        }
        
        public FieldWrapper( String Mark, String Comment){
            HomeworkResult = Mark + '. Mark';
            HomeworkComment = Comment + '. Comment';
            Homework = new Homework__c(name = '');
        }
    }
}