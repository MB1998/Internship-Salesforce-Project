public class InternHomePageController{
    public InternWrapper intern {get;set;}
    public Boolean Editable {get;set;}
    public List<HomeworkWrapper> homeworks {get;set;}
    public List<TestWrapper> tests {get;set;}
    public List<ResourceWrapper> resources {get;set;}
    public Integer countHomework {get;set;}
    public Integer countTest {get;set;}
    public Integer countResource {get;set;}
    public String selected {get;set;}
    
    private String questId;
    private List<Homework__c> HomeworksPrivate;
    private List<Junction_Intern_Homework__c> JunctionHomeworks;
    private List<Test__c> TestsPrivate;
    private List<Junction_Intern_Test__c> JunctionTests;
    private List<Resource__c> PrivateResources;
    
    public InternHomePageController(){
        questId = ApexPages.currentPage().getParameters().get('id');
        intern = new InternWrapper([SELECT Name, Email__c, Phone__c, Skype_id__c, Group__c, Rating__c, Trailhead_Progress__c, Progress__c, Login_for_org__c, Password_for_org__c FROM Intern__c WHERE Id = :questId][0]);
        Editable = false;
        
        homeworks = new List<HomeworkWrapper>();
        tests = new List<TestWrapper>();
        
        resources = new List<ResourceWrapper>();
        PrivateResources = [SELECT id, Name, Link__c, Description__c FROM Resource__c WHERE Group__c = :intern.GroupId];
        for(Resource__c resource : PrivateResources){
            ResourceWrapper newResourceWrapper = new ResourceWrapper(resource);
            resources.add(newResourceWrapper);
        }
        
        countResource = resources.size();
        
        HomeworksPrivate = [SELECT Id, Name, DeadLine__c, Task__c, Topics__c, Lecturer_name__c, Lecturer_email__c, Lecturer_skype_id__c, Lecturer_other_contacts__c FROM HomeWork__c WHERE Group__c = :intern.GroupId];
        JunctionHomeworks = [SELECT Id, Homework__c, Mark__c, Comment__c, Sended__c FROM Junction_Intern_Homework__c WHERE Intern__c = :questId];
        countHomework = homeworksPrivate.size();
        
        TestsPrivate = [SELECT Id, Name, Date__c, Complexity__c, Topics__c, Lecturer_name__c FROM Test__c WHERE Group__c = :intern.GroupId];
        JunctionTests = [SELECT Id, Test__c, Mark__c FROM Junction_Intern_Test__c WHERE Intern__c = :questId];
        countTest = TestsPrivate.size();
        
        for(Homework__c homework : HomeworksPrivate){
            for(Junction_Intern_Homework__c JunctionHomework : JunctionHomeworks){
                if(JunctionHomework.Homework__c == homework.Id){
                    homeworks.add(new HomeworkWrapper(homework, JunctionHomework)); 
                    break;
                }
            }
        }
        
        for(Test__c test : TestsPrivate){
            for(Junction_Intern_Test__c JunctionTest : JunctionTests){
                if(JunctionTest.Test__c  == test.Id){
                    tests.add(new TestWrapper(test, JunctionTest)); 
                    break;
                }
            }
        }
        
    }
    
    public void edit(){
        Editable = true;
    }
    
    public void cancel(){
        Editable = false;
    }
    
    public void save(){
        try{
            Intern__c intern = new Intern__c(Id = questId, Name = intern.Name, Email__c = intern.email, Phone__c = intern.phone, Group__c = intern.GroupId, 
                Rating__c = intern.Rating, Trailhead_Progress__c = intern.TrailheadProgress, Progress__c = intern.Progress, 
                Login_for_org__c = intern.Login_for_org, Password_for_org__c = intern.Password_for_org);
            update intern;
            Editable = false; } catch (Exception e){ApexPages.Message errorMessage = new ApexPages.Message(ApexPages.Severity.FATAL, 'Check information that you have change! There is a mistake!'); System.debug(e); }
    }
    
    public void done(){
        try{
            Homework__c selectedHomework = [SELECT Name, Task__c, Deadline__c, Lecturer_Email__c FROM Homework__c WHERE Id = :selected][0];        
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage(); 
            mail.setToAddresses(new String[]{selectedHomework.Lecturer_Email__c});
            mail.setReplyTo(intern.Email); 
            mail.setSenderDisplayName('Done homework'); 
            mail.setSubject('Homework is done'); 
            mail.setPlainTextBody('Homework "' + selectedHomework.Name + '" was done by intern '+ intern.Name + '. Homework has task: "' + selectedHomework.Task__c + '", and deadline is ' + selectedHomework.Deadline__c + '. Intern email: ' + intern.email + '. Please, check this homework!'); 
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        } catch (Exception e) {
            ApexPages.Message errorMessage = new ApexPages.Message(ApexPages.Severity.FATAL, 'Sorry! There is some problems with sending email to your lecturer. Please, write him/hew email yourself and informate him/her about your done homework.');
            System.debug(e);
            ApexPages.addMessage(errorMessage);
        }

    }
    
    public class InternWrapper{
        public String Name {get;set;}
        public String Email {get;set;}
        public String Phone {get;set;}
        public String Skype_id {get;set;}
        public Id GroupId;
        public String InternshipGroup {get;set;}
        public Decimal Rating {get;set;}
        public Decimal TrailheadProgress {get;set;}
        public String Progress {get;set;}
        public String Login_for_org {get;set;}
        public String Password_for_org {get;set;}
        
        public InternWrapper (Intern__c questIntern){
            Name = questIntern.Name;
            Email = questIntern.Email__c;
            Phone = questIntern.Phone__c; 
            Skype_id = questIntern.Skype_id__c;
            GroupId = questIntern.Group__c;
            Group__c groupOfIntern = [SELECT Name FROM Group__c WHERE id=:questIntern.Group__c];
            InternshipGroup = groupOfIntern.Name; 
            Rating = questIntern.Rating__c; 
            TrailheadProgress = questIntern.Trailhead_Progress__c; 
            Progress = questIntern.Progress__c; 
            Login_for_org = questIntern.Login_for_org__c; 
            Password_for_org = questIntern.Password_for_org__c; 
        }
    }
    
    public class HomeworkWrapper{
        public String Id {get;set;}
        public String Name {get;set;}
        public String Task {get;set;}
        public DateTime Deadline {get;set;}
        public String LecturerName {get;set;}
        public String LecturerEmail {get;set;}
        public String LecturerSkype {get;set;}
        public String LecturerOtherContacts {get;set;}
        public String Topics {get;set;}
        public Boolean isDone {get;set;}
        public Decimal Mark {get;set;}
        public String Comment {get;set;}
        public Boolean Sended {get;set;}
        
        public HomeworkWrapper(Homework__c homework, Junction_Intern_Homework__c junction){
            System.debug(homework.id);
            id = homework.Id;
            Name = homework.Name;
            Task = homework.Task__c;
            Deadline = homework.Deadline__c;
            LecturerName = homework.Lecturer_Name__c;
            LecturerEmail = homework.Lecturer_Email__c;
            LecturerSkype = homework.Lecturer_skype_id__c;
            LecturerOtherContacts = homework.Lecturer_other_contacts__c;
            Topics = homework.Topics__c;
            isDone = (junction.Mark__c != 0);
            Sended = false;
            Mark = junction.Mark__c;
            Comment = junction.Comment__c;
            Sended = junction.Sended__c;
        }
    }
    
    public class TestWrapper{
        public String Name {get;set;}
        public DateTime TestDate {get;set;}
        public Decimal Complexity {get;set;}
        public String LecturerName {get;set;}
        public String Topics {get;set;}
        public Decimal Mark {get;set;}
        
        public TestWrapper(Test__c test, Junction_Intern_Test__c junction){
            Name = test.Name;
            TestDate = test.Date__c;
            Complexity = test.Complexity__c;
            LecturerName = test.Lecturer_Name__c;
            Topics = test.Topics__c;
            Mark = junction.Mark__c;
        }
    }
    
    public class ResourceWrapper{
        public string Name {get;set;}
        public String Link {get;set;}
        public String Description {get; set;}
        
        public ResourceWrapper(Resource__c resource){
            Name = resource.Name;
            Link = resource.Link__c;
            Description  = resource.Description__c;
        }
    }
}