<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Sending_email_to_lecturer_with_recalling_to_entry_test_s_results_to_system</fullName>
        <description>Sending email to lecturer with recalling to entry test`s results to system.</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Entry_test_results</template>
    </alerts>
    <rules>
        <fullName>Recalling to entry test result</fullName>
        <actions>
            <name>Sending_email_to_lecturer_with_recalling_to_entry_test_s_results_to_system</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <description>This workflow rule sends email to lecturer to entry test`s results to system after test.</description>
        <formula>Date__c = NOW()</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
