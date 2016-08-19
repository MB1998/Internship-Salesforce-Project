global class RecountRatingScheduleJob implements Schedulable{

	global void execute(SchedulableContext SC) {
    	List<Intern__c> interns = [SELECT id, Trailhead_Progress__c, Rating__c FROM Intern__c];
        Decimal maxTrailHead = interns.get(0).Trailhead_Progress__c;
        for(Intern__c intern : interns){
            if(intern.Trailhead_Progress__c > maxTrailHead){
                maxTrailHead = intern.Trailhead_Progress__c;
            }
        }
        
        List<Junction_Intern_Homework__c> Junction_Intern_Homeworks = [SELECT Id, Intern__c, Mark__c FROM Junction_Intern_Homework__c];
        Map<Id, List<Junction_Intern_Homework__c>> homeworksByInterns = new Map<Id, List<Junction_Intern_Homework__c>>();
        for(Junction_Intern_Homework__c Junction_Intern_Homework : Junction_Intern_Homeworks){
            if(homeworksByInterns.containsKey(Junction_Intern_Homework.Intern__c)){
                homeworksByInterns.get(Junction_Intern_Homework.Intern__c).add(Junction_Intern_Homework);
            } else {
                homeworksByInterns.put(Junction_Intern_Homework.Intern__c, new List<Junction_Intern_Homework__c>{Junction_Intern_Homework});
            }
        }
        
        List<Junction_Intern_Test__c> Junction_Intern_Tests = [SELECT Id, Intern__c, Mark__c FROM Junction_Intern_Test__c];
        Map<Id, List<Junction_Intern_Test__c>> testsByInterns = new Map<Id, List<Junction_Intern_Test__c>>();
        for(Junction_Intern_Test__c Junction_Intern_Test : Junction_Intern_Tests){
            if(testsByInterns.containsKey(Junction_Intern_Test.Intern__c)){
                testsByInterns.get(Junction_Intern_Test.Intern__c).add(Junction_Intern_Test);
            } else {
                testsByInterns.put(Junction_Intern_Test.Intern__c, new List<Junction_Intern_Test__c>{Junction_Intern_Test});
            }
        }
        
        for(Intern__c intern : interns){
        	Decimal rating = 0, averageMarkHomework = 0, averageMarkTest = 0;
            rating += intern.Trailhead_Progress__c / maxTrailHead * Coefficients__c.getInstance('Trailhead').Coefficient_for_rating__c;
            
            for(Junction_Intern_Homework__c Junction_Intern_Homework : homeworksByInterns.get(intern.Id)){
                averageMarkHomework += Junction_Intern_Homework.Mark__c;
            }
            averageMarkHomework /= homeworksByInterns.get(intern.Id).size();
            rating += averageMarkHomework / 100 * Coefficients__c.getInstance('Homework marks').Coefficient_for_rating__c;
            
            for(Junction_Intern_Test__c Junction_Intern_Test : testsByInterns.get(intern.Id)){
                averageMarkTest += Junction_Intern_Test.Mark__c;
            }
            averageMarkTest /= testsByInterns.get(intern.Id).size();
            rating += averageMarkTest / 100 * Coefficients__c.getInstance('Tests results').Coefficient_for_rating__c;
            rating = rating * 100;
            rating = Math.round(rating);
            rating /= 100;
            
            intern.Rating__c = rating;
        }
        update interns;
    }
}