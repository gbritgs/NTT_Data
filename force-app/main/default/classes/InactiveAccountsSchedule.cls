global class InactiveAccountsSchedule implements Database.Batchable<sObject>, Schedulable {
    global void execute(SchedulableContext sc) {
        Database.executeBatch(this);
    }

    global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator([SELECT Id, Name, Inativa__c 
                                         FROM Account WHERE Inativa__c = false]);
    }

    global void execute(Database.BatchableContext BC, List<Account> scope) {
        Date ninetyDaysAgo = Date.today().addDays(-90);
        Date hundredTwentyDaysAgo = Date.today().addDays(-120);

        List<Account> accountsToUpdate = new List<Account>();

        for (Account acc : scope) {
            Boolean hasRecentTask = [SELECT COUNT() FROM Task WHERE WhatId = :acc.Id AND ActivityDate >= :ninetyDaysAgo] > 0;
            Boolean hasWonOpportunity = [SELECT COUNT() FROM Opportunity WHERE AccountId = :acc.Id AND IsWon = true AND CloseDate >= :hundredTwentyDaysAgo] > 0;
            Boolean hasOpportunityInNegotiation = [SELECT COUNT() FROM Opportunity WHERE AccountId = :acc.Id AND StageName = 'Negotiation/Review'] > 0;

            if (!hasRecentTask && !hasWonOpportunity && !hasOpportunityInNegotiation) {
                acc.Inativa__c = true;
                accountsToUpdate.add(acc);
            }
        }

        update accountsToUpdate;
    }

    global void finish(Database.BatchableContext BC) {
        System.Debug('Job: ' + BC);
    }
}