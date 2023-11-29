@isTest
public with sharing class InactiveAccountsScheduleTest {
    @isTest
    static void testInactiveAccountsSchedule() {
        Account testAccount = new Account(Name = 'Test Account', Inativa__c = false);
        insert testAccount;
        
        Test.startTest();
        InactiveAccountsSchedule job = new InactiveAccountsSchedule();
        job.execute(null);
        Test.stopTest();
        
        Account updatedAccount = [SELECT Id, Inativa__c FROM Account WHERE Id = :testAccount.Id];
        System.assertEquals(true, updatedAccount.Inativa__c, 'Account should be marked as inactive');
    }
}