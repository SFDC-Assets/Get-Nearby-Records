//  Controller for the Get Nearby Records Lightning component.
//  
//  This code is provided AS IS, with no warranty or guarantee of suitability for use.
//  Contact: john.meyer@salesforce.com

public without sharing class GetNearbyRecords {

    public class Info {
        @AuraEnabled public Id recordId;
        @AuraEnabled public String recordName;
        @AuraEnabled public Double latitude;
        @AuraEnabled public Double longitude;
        @AuraEnabled public Double distance;
    }

    public class Result {
        @AuraEnabled public Boolean error;
        @AuraEnabled public String errorMessage;
        @AuraEnabled public List<Info> records;
    }

    public class Geolocation {
        @AuraEnabled public Boolean error;
        @AuraEnabled public String errorMessage;
        @AuraEnabled public Double latitude;
        @AuraEnabled public Double longitude;
    }


    //  Get the location coordinates of the given record.
    //
    //  The parameters represent:
    //      objectApiName: the API name of the object
    //      fieldApiName: the API name of the geolocation field containing the location whose nearby neighbors are desired
    //      recordId: the Id of the record containing the location

    @AuraEnabled(cacheable=true)
    public static Geolocation getRecordLocation (String objectApiName, String fieldApiName, Id recordId) {

        Geolocation location = new Geolocation();

        try {
            SObject record = Database.query('SELECT ' + fieldApiName + ' FROM ' + objectApiName + ' WHERE Id = \'' + recordId + '\'');
            if (record.get(fieldApiName) != null) {
                location.error = false;
                location.errorMessage = null;
                location.latitude = ((Location) record.get(fieldApiName)).getLatitude();
                location.longitude = ((Location) record.get(fieldApiName)).getLongitude();
            } else {
                location.error = true;
                location.errorMessage = 'No location in this record.';
                location.latitude = null;
                location.longitude = null;                   
            }
        } catch (Exception e) {
            location.error = true;
            location.errorMessage = e.getMessage();
            location.latitude = null;
            location.longitude = null;
        }

        return location;
    }


    //  Gets the records whose geolocation field is nearby the given latitude and longitude.
    //
    //  The parameters represent:
    //      recordId: the Id of the record containing the location
    //      objectApiName: the API name of the object
    //      fieldApiName: the API name of the geolocation field
    //      additionalWhereClause: an optional SOQL WHERE clause expression that will be added to the query
    //      distance: The radius of the geofence
    //      units: either 'mi' or 'km'
    //      latitude and longitude: the geolocation of the record

    @AuraEnabled(cacheable=true)
    public static Result getNearbyRecordsByLocation (Id recordId, String objectApiName, String fieldApiName,
            String additionalWhereClause, Double distance, String units, Double latitude, Double longitude) {

        Result result = new Result();
        String nameField = getNameField(objectApiName);
        Location fromLocation = Location.newInstance(latitude, longitude);

        result.error = false;
        result.errorMessage = null;

        try {
            List<SObject> records = Database.query(
                'SELECT ' + nameField + ', ' + fieldApiName +
                ' FROM ' + objectApiName +
                ' WHERE (DISTANCE(' + fieldApiName + ', GEOLOCATION(' + latitude + ',' + longitude + '), \'' + units + '\') < ' + distance +
                    ' AND Id != \'' + recordId + '\')' +
                    (additionalWhereClause != null ? ' AND (' + additionalWhereClause + ')' : '') +
                ' ORDER BY DISTANCE(' + fieldApiName + ', GEOLOCATION(' + latitude + ',' + longitude + '), \'' + units + '\') ASC' +
                ' LIMIT 99');
            List<Info> infoRecords = new List<Info>();
            for (SObject record : records) {
                Info infoRecord = new Info();
                infoRecord.recordId = (Id) record.get('Id');
                infoRecord.recordName = String.valueOf(record.get(nameField));
                infoRecord.latitude = ((Location) record.get(fieldApiName)).getLatitude();
                infoRecord.longitude = ((Location) record.get(fieldApiName)).getLongitude();
                infoRecord.distance = fromLocation.getDistance((Location) record.get(fieldApiName), units);
                infoRecords.add(infoRecord);
            }
            result.records = infoRecords;
        } catch (Exception e) {
            result.error = true;
            result.errorMessage = e.getMessage();
            result.records = null;
        }

        return result;
    }


    //  Find the name field for an object.
    //
    //  The parameter represents:
    //      objectApiName:  the API name of the object whose name field is wanted.

    private static String getNameField (String objectApiName) {
		String name;
        for (Schema.SObjectField field : Schema.getGlobalDescribe().get(objectApiName).getDescribe().fields.getMap().values())
            if (field.getDescribe().isNameField()) {
                name = field.getDescribe().getName();
                break;
            }
        return name;
    }

}