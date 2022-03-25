//  Test class and metbods for the Get Nearby Records Lightning component.
//
//  Copyright (c) 2022, salesforce.com, inc.
//  All rights reserved.
//  SPDX-License-Identifier: BSD-3-Clause
//  For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
//
//  Contact: john.meyer@salesforce.com

@isTest(isParallel=true)
private without sharing class GetNearbyRecordsTest {

    static final String ACCOUNT_NAME = 'Sample Account';

    @isTest
    private static void testProperFunction () {

        System.Test.startTest();

        Account sampleAccount = new Account(Name = ACCOUNT_NAME);
        insert sampleAccount;

        insert new List<Contact> {
            new Contact (
                FirstName = 'David',
                LastName = 'Larrimore',
                AccountId = sampleAccount.Id,
                Get_Nearby_Records_Location__latitude__s = 38.92366,
                Get_Nearby_Records_Location__longitude__s = -77.32929
            ),
            new Contact (
                FirstName = 'Roksolana',
                LastName = 'Corrasco',
                AccountId = sampleAccount.Id,
                Get_Nearby_Records_Location__latitude__s = 38.92426,
                Get_Nearby_Records_Location__longitude__s = -77.34019
            ),
            new Contact (
                FirstName = 'Geoff',
                LastName = 'Roser',
                AccountId = sampleAccount.Id,
                Get_Nearby_Records_Location__latitude__s = 38.93056,
                Get_Nearby_Records_Location__longitude__s = -77.33316
            ),
            new Contact (
                FirstName = 'Jennifer',
                LastName = 'Ward',
                AccountId = sampleAccount.Id,
                Get_Nearby_Records_Location__latitude__s = 38.94236,
                Get_Nearby_Records_Location__longitude__s = -77.34685
            ),
            new Contact (
                FirstName = 'Andy',
                LastName = 'Cather',
                AccountId = sampleAccount.Id,
                Get_Nearby_Records_Location__latitude__s = 38.95980,
                Get_Nearby_Records_Location__longitude__s = -77.38527
            ),
            new Contact (
                FirstName = 'Diana',
                LastName = 'Keohane',
                AccountId = sampleAccount.Id,
                Get_Nearby_Records_Location__latitude__s = 39.060993,
                Get_Nearby_Records_Location__longitude__s = -77.480182
            )
        };  
        Contact center = new Contact (
            FirstName = 'John',
            LastName = 'Meyer',
            AccountId = sampleAccount.Id,
            Get_Nearby_Records_Location__latitude__s = 38.92765,
            Get_Nearby_Records_Location__longitude__s = -77.32587
        );
        insert center;

        GetNearbyRecords.Geolocation location = GetNearbyRecords.getRecordLocation('Contact', 'Get_Nearby_Records_Location__c', center.Id);
        System.assertNotEquals(null, location);
        GetNearbyRecords.Result result = GetNearbyRecords.getNearbyRecordsByLocation(center.Id, 'Contact', 'Get_Nearby_Records_Location__c', null, (Double) 1.0, 'mi', location.latitude, location.longitude);
        System.assertEquals(3, result.records.size());

        System.Test.stopTest();
    }

    @isTest
    private static void testNoLocationInCenter () {
 
        System.Test.startTest();

        Account sampleAccount = new Account(Name = ACCOUNT_NAME);
        insert sampleAccount;

        Contact center = new Contact (
            FirstName = 'John',
            LastName = 'Meyer',
            AccountId = sampleAccount.Id
        );
        insert center;

        GetNearbyRecords.Geolocation location = GetNearbyRecords.getRecordLocation('Contact', 'Get_Nearby_Records_Location__c', center.Id);
        System.assert(location.error);

        System.Test.stopTest();
    }
 
    @isTest
    private static void testBadQueryInCenter () {
 
        System.Test.startTest();

        Account sampleAccount = new Account(Name = ACCOUNT_NAME);
        insert sampleAccount;

        Contact center = new Contact (
            FirstName = 'John',
            LastName = 'Meyer',
            AccountId = sampleAccount.Id,
            Get_Nearby_Records_Location__latitude__s = 38.92765,
            Get_Nearby_Records_Location__longitude__s = -77.32587
        );
        insert center;

        GetNearbyRecords.Geolocation location = GetNearbyRecords.getRecordLocation('Contact', 'Bad_Get_Nearby_Records_Location__c', center.Id);
        System.assert(location.error);

        System.Test.stopTest();
    }

    @isTest
    private static void testBadQueryInNearby () {

        System.Test.startTest();

        Account sampleAccount = new Account(Name = ACCOUNT_NAME);
        insert sampleAccount;

        insert new List<Contact> {
            new Contact (
                FirstName = 'David',
                LastName = 'Larrimore',
                AccountId = sampleAccount.Id,
                Get_Nearby_Records_Location__latitude__s = 38.92366,
                Get_Nearby_Records_Location__longitude__s = -77.32929
            )
        };  
        Contact center = new Contact (
            FirstName = 'John',
            LastName = 'Meyer',
            AccountId = sampleAccount.Id,
            Get_Nearby_Records_Location__latitude__s = 38.92765,
            Get_Nearby_Records_Location__longitude__s = -77.32587
        );
        insert center;

        GetNearbyRecords.Geolocation location = GetNearbyRecords.getRecordLocation('Contact', 'Get_Nearby_Records_Location__c', center.Id);
        System.assertNotEquals(null, location);
        GetNearbyRecords.Result result = GetNearbyRecords.getNearbyRecordsByLocation(center.Id, 'Contact', 'Bad_Get_Nearby_Records_Location__c', null, (Double) 1.0, 'mi', location.latitude, location.longitude);
        System.assert(result.error);

        System.Test.stopTest();
    }

}