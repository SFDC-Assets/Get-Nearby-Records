//  Generates sample records for the Geolocation Utilities components.
//
//  This code is provided AS IS, with no warranty or guarantee of suitability for use.
//  Contact: john.meyer@salesforce.com

Account sampleAccount = new Account (
    Name = 'Sample Account',
    Get_Nearby_Records_Location__latitude__s = 38.93863,
    Get_Nearby_Records_Location__longitude__s = -77.33010
);
insert sampleAccount;

Contact center = new Contact (
    FirstName = 'John',
    LastName = 'Meyer',
    AccountId = sampleAccount.Id,
    Get_Nearby_Records_Location__latitude__s = 38.92765,
    Get_Nearby_Records_Location__longitude__s = -77.32587
);
insert center;

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