//  Test class and metbods for the Get Nearby Records Lightning component.
//
//  This code is provided AS IS, with no warranty or guarantee of suitability for use.
//  Contact: john.meyer@salesforce.com

@isTest(isParallel=true)
private without sharing class GetNearbyRecordsFindGeolocFieldsTest {

    @isTest
    private static void testProperFunction () {

        System.Test.startTest();

        VisualEditor.DesignTimePageContext context = new VisualEditor.DesignTimePageContext();
        context.pageType = 'RecordPage';
        context.entityName = 'Contact';

        GetNearbyRecordsFindGeolocationFields picklist = new GetNearbyRecordsFindGeolocationFields(context);
        System.assertNotEquals(0, picklist.getValues().size());
        System.assertNotEquals(GetNearbyRecordsFindGeolocationFields.NO_GEOLOCATION_FIELD, picklist.getDefaultValue().getValue());

        System.Test.stopTest();
    }

    @isTest
    private static void testNoGeolocationField () {

        System.Test.startTest();

        VisualEditor.DesignTimePageContext context = new VisualEditor.DesignTimePageContext();
        context.pageType = 'RecordPage';
        context.entityName = 'Product2';

        GetNearbyRecordsFindGeolocationFields picklist = new GetNearbyRecordsFindGeolocationFields(context);
        System.assertNotEquals(0, picklist.getValues().size());
        System.assertEquals(GetNearbyRecordsFindGeolocationFields.NO_GEOLOCATION_FIELD, picklist.getDefaultValue().getValue());

        System.Test.stopTest();
    }
}
