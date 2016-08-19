trigger HomeworkTrigger on Homework__c (before insert, after insert, before update, after update, before delete, after delete, after undelete) {
    if(Trigger.isAfter){
        if(Trigger.isInsert){
            HomeworkHandler.afterInsert(Trigger.NEW);
        }
    }
}