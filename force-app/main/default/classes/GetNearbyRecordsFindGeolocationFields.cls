//  Dynamic Picklist class for the Get Nearby Records Lightning component.
//  
//  This code is provided AS IS, with no warranty or guarantee of suitability for use.
//  Contact: john.meyer@salesforce.com

global class GetNearbyRecordsFindGeolocationFields extends VisualEditor.DynamicPickList {

    global static final String NO_GEOLOCATION_FIELD = 'NO_GEOLOCATION_FIELD';
    private VisualEditor.DynamicPickListRows geoLocationFields = new VisualEditor.DynamicPickListRows();

    global GetNearbyRecordsFindGeolocationFields (VisualEditor.DesignTimePageContext context) {
        for (Schema.SObjectField field : Schema.getGlobalDescribe().get(context.entityName).getDescribe().fields.getMap().values())
            if (field.getDescribe().getType().name() == 'LOCATION')
                this.geoLocationFields.addRow(new VisualEditor.DataRow(field.getDescribe().getLabel(), field.getDescribe().getName()));
        if (this.geoLocationFields.size() == 0)
            this.geoLocationFields.addRow(new VisualEditor.DataRow('** No Geolocation fields found **', NO_GEOLOCATION_FIELD));
    }

    global override VisualEditor.DataRow getDefaultValue () {
        return this.geoLocationFields.get(0);
    }

    global override VisualEditor.DynamicPickListRows getValues () {               
        return this.geoLocationFields;
    }
}
