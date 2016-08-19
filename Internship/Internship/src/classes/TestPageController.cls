public class TestPageController{
    public static List<ObjectWrapper> internsPerformance{get;set;}
    public static List<Test__c> tests{get;set;}
    public static Integer countTest {get;set;}
    
    public TestPageController(){
        tests = [SELECT Id, Name, Date__c, Complexity__c, Topics__c FROM Test__c WHERE OwnerId = :UserInfo.getUserId() ORDER BY CreatedDate DESC];
        countTest = tests.size();
        Map<Id, Test__c> testsById = new Map<Id, Test__c>(tests);

        Set<Id> testIds = new Set<Id>();
        List<String> testsNames = new List<String>();
        for(Test__c test: tests){
            testIds.add(test.Id);
            testsNames.add(test.name);
        }
        
        List<Intern__c> interns = [SELECT ID, Name FROM Intern__c ORDER BY CreatedDate DESC];
        Map<Id, Intern__c> InternsById = new Map<Id, Intern__c>(interns);
        
        List<Junction_Intern_Test__c> junctions = [SELECT ID, Test__c, Intern__c, Mark__c FROM Junction_Intern_Test__c WHERE Test__c IN :testIds ORDER BY Test__r.CreatedDate DESC];
        
        Map<Intern__c, List<Junction_Intern_Test__c>> junctionsByInterns = new Map<Intern__c, List<Junction_Intern_Test__c>>();
        for(Junction_Intern_Test__c junction : junctions){
            if(junctionsByInterns.containsKey(InternsById.get(junction.Intern__c))){
                junctionsByInterns.get(InternsById.get(junction.Intern__c)).add(junction);
            } else {
                junctionsByInterns.put(InternsById.get(junction.Intern__c), new List<Junction_Intern_Test__c> {junction});
            }
        }
        
        internsPerformance = new List<ObjectWrapper>();
        ObjectWrapper newHeaderObjectWrapper = new ObjectWrapper('Intern name', testsNames);
        internsPerformance.add(newHeaderObjectWrapper);
        
        for(Intern__c intern : junctionsByInterns.keySet()){
            ObjectWrapper newObjectWrapper = new ObjectWrapper(intern, junctionsByInterns.get(intern), testsById);
            internsPerformance.add(newObjectWrapper);
        }
    }
    
    
    public class ObjectWrapper{
        public Intern__c intern {get;set;}
        public List<FieldWrapper> testsResults {get;set;}
        
        public ObjectWrapper(Intern__c newintern, List<Junction_Intern_Test__c> junctions, Map<Id, Test__c> testsById){
            intern = newintern;
            testsResults = new List<FieldWrapper>();
            
            for(Junction_Intern_Test__c junction : junctions){
                FieldWrapper newFieldWrapper = new FieldWrapper(junction, testsById);
                testsResults.add(newFieldWrapper);
            }
        }
        
        public ObjectWrapper(String internName, List<String> testsNames){
            intern = new Intern__c(Name = internName);
            testsResults = new List<FieldWrapper>();
            
            for(String testName : testsNames){
                FieldWrapper newFieldWrapper = new FieldWrapper(testName);
                testsResults.add(newFieldWrapper);
            }
        }
    }
    
    public class FieldWrapper{
        public Test__c Test {get;set;}
        public Decimal TestMark {get;set;}
        public String TestResult {get;set;}
        
        public FieldWrapper(Junction_Intern_Test__c junction, Map<Id, Test__c> testsById){
            Test = testsById.get(junction.Test__c);
            TestMark = junction.Mark__c;
            TestResult = String.valueOf(TestMark );
        }
        
        public FieldWrapper( String Mark){
            TestResult = Mark + '. Mark';
            Test = new Test__c(name = '');
        }
    }
}