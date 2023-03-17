<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>SiteUserEmailAlert</fullName>
        <description>SiteUserEmailAlert</description>
        <protected>false</protected>
        <recipients>
            <field>Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Match_Maker_Email_Templates/SiteUserTemplate</template>
    </alerts>
</Workflow>
