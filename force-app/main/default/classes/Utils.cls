public with sharing class Utils {
    public static void handleBeforeInsert(List<Account> accs) {
        for(Account acc :accs) {
            if(acc.Type == 'CPF') {
                validaCPF(acc);
            } else if(acc.Type == 'CNPJ') {
                validaCNPJ(acc);
            }
        }
    }

    public static void validaCPF(Account acc) {
        String value = acc.AccountNumber.replaceAll('[^a-zA-Z0-9\\s+]', '');
        if(value.length() != 11) {
            acc.AccountNumber.addError('Número do cliente é inválido. CPFs devem possuir 11 dígitos');
        } else {
            createOppt(acc);
        }
    }

    public static void validaCNPJ(Account acc) {
        String value = acc.AccountNumber.replaceAll('[^a-zA-Z0-9\\s+]', '');
        if(value.length() != 14) {
            acc.AccountNumber.addError('Número do cliente é inválido. CNPJs devem possuir 14 dígitos');
        } else {
            createOppt(acc);
        }
    }

    private static void createOppt(Account acc) {
        List<Opportunity> oppsInsert = new List<Opportunity>();
        List<Task> tasksInsert = new List<Task>();

        Map<Id, Schema.RecordTypeInfo> recordTypeMap = Account.SObjectType.getDescribe().getRecordTypeInfosById();
        Schema.RecordTypeInfo accountRecordTypeInfo = recordTypeMap.get(acc.RecordTypeId);
        
        if(accountRecordTypeInfo != null) {
            if(accountRecordTypeInfo.getName().equals('Parceiro')) {
                Opportunity opp = new Opportunity(
                    Name = acc.Name + ' - opp Parceiro',
                    CloseDate = Date.today().addDays(30),
                    StageName = 'Qualification',
                    AccountId = acc.Id
                );
                oppsInsert.add(opp);
            } else if(accountRecordTypeInfo.getName().equals('Consumidor final')) {
                Task newTask = new Task(
                    Subject = 'Consumidor Final',
                    WhatId = acc.Id,
                    Status = 'Not Started',
                    Priority = 'Normal'
                );
                tasksInsert.add(newTask);
            }
        }
        
        if(!oppsInsert.isEmpty()) {
            insert oppsInsert;
        }

        if(!tasksInsert.isEmpty()) {
            insert tasksInsert;
        }
    }

    public class UtilsException extends Exception {}
}