trigger TestTrigger on Test__c (before insert, after insert, before update, after update, before delete, after delete, after undelete) {
    if(Trigger.isAfter){
        if(Trigger.isInsert){
            TestHandler.afterInsert(Trigger.NEW);
        }
    }
}