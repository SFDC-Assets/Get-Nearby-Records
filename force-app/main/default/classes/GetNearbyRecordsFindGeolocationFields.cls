//  Dynamic Picklist class for the Get Nearby Records Lightning component.
//  
//  This code is provided AS IS, with no warranty or guarantee of suitability for use.
//  Contact: john.meyer@salesforce.com

public class GetNearbyRecordsFindGeolocationFields extends VisualEditor.DynamicPickList {

    public static final String NO_GEOLOCATION_FIELD = 'NO_GEOLOCATION_FIELD';
    private VisualEditor.DynamicPickListRows geoLocationFields = new VisualEditor.DynamicPickListRows();

    public GetNearbyRecordsFindGeolocationFields (VisualEditor.DesignTimePageContext context) {
        for (Schema.SObjectField field : Schema.getGlobalDescribe().get(context.entityName).getDescribe().fields.getMap().values())
            if (field.getDescribe().getType().name() == 'LOCATION')
                this.geoLocationFields.addRow(new VisualEditor.DataRow(field.getDescribe().getLabel(), field.getDescribe().getName()));
        if (this.geoLocationFields.size() == 0)
            this.geoLocationFields.addRow(new VisualEditor.DataRow('** No Geolocation fields found **', NO_GEOLOCATION_FIELD));
    }

    public override VisualEditor.DataRow getDefaultValue () {
        return this.geoLocationFields.get(0);
    }

    public override VisualEditor.DynamicPickListRows getValues () {               
        return this.geoLocationFields;
    }
}
