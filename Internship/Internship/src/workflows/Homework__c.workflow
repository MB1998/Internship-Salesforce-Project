<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Sending_email_to_lecturer_with_recalling_to_check_homework_s_deadline_is_now</fullName>
        <description>Sending email to lecturer with recalling to check homework`s deadline is now</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Check_homework</template>
    </alerts>
    <rules>
        <fullName>Recalling to check homework</fullName>
        <actions>
            <name>Sending_email_to_lecturer_with_recalling_to_check_homework_s_deadline_is_now</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <description>This workflow rule recall lecturer to check homework when dedline past.</description>
        <formula>DeadLine__c = NOW()</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
