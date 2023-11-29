@isTest
public with sharing class UtilsTest {
    @testSetup static void setup() {
       Id parceiroRecordTypeId = [SELECT Id FROM RecordType WHERE SObjectType = 'Account' AND Name = 'Parceiro' LIMIT 1].Id;
       Id consumidorFinalRecordTypeId = [SELECT Id FROM RecordType WHERE SObjectType = 'Account' AND Name = 'Consumidor final' LIMIT 1].Id;

       Account accountParceiro = new Account(
           Name = 'Account Parceiro',
           Type = 'CPF',
           AccountNumber = '00000000000',
           RecordTypeId = parceiroRecordTypeId
       );
       insert accountParceiro;

       Account accountConsumidorFinal = new Account(
           Name = 'Account Consumidor Final',
           Type = 'CNPJ',
           AccountNumber = '00000000000000',
           RecordTypeId = consumidorFinalRecordTypeId
       );
       insert accountConsumidorFinal;
    }

    @isTest static void positiveScenarioParceiro() {
        Account testAccount = [SELECT Id, Name FROM Account WHERE Name = 'Account Parceiro'];
        
        Test.startTest();
        testAccount.Name = 'Updated';
        update testAccount;
        Test.stopTest();
        
        Account updatedAccount = [SELECT Id, Name FROM Account WHERE Id = :testAccount.Id];
        System.assertEquals('Updated', updatedAccount.Name, 'Account name should be updated');
    }
    
    @isTest static void testScenarioParceiro() {
        Account testAccount = [SELECT Id, Name FROM Account WHERE Name = 'Account Parceiro'];
        
        Test.startTest();
        testAccount.AccountNumber = '1';

        try {
            update testAccount;
        } catch(Exception e) {
            System.assertEquals('System.DmlException', e.getTypeName(), 'Should throw DML exception');
        }
        Test.stopTest();
    }
    
    @isTest static void positiveScenarioConsumidorFinal() {
        Account testAccount = [SELECT Id, Name FROM Account WHERE Name = 'Account Consumidor Final'];
        
        Test.startTest();
        testAccount.Name = 'Updated';
        update testAccount;
        Test.stopTest();
        
        Account updatedAccount = [SELECT Id, Name FROM Account WHERE Id = :testAccount.Id];
        System.assertEquals('Updated', updatedAccount.Name, 'Account name should be updated');
    }
    
    @isTest static void testScenarioConsumidorFinal() {
        Account testAccount = [SELECT Id, Name FROM Account WHERE Name = 'Account Consumidor Final'];
        
        Test.startTest();
        testAccount.AccountNumber = '1';

        try {
            update testAccount;
        } catch(Exception e) {
            System.assertEquals('System.DmlException', e.getTypeName(), 'Should throw DML exception');
        }
        Test.stopTest();
    }
    
    @isTest static void testBatchInsert() {        
        List<Account> testAccounts = new List<Account>();
        for(Integer i = 0; i < 200; i++) {
            testAccounts.add(new Account(Name = 'Test Account ' + i));
        }
        
        Test.startTest();
        insert testAccounts;
        Test.stopTest();
        
        List<Account> insertedAccounts = [SELECT Id, Name FROM Account WHERE Name LIKE 'Test Account%'];
        System.assertEquals(200, insertedAccounts.size(), '200 accounts should be inserted');
    }
}