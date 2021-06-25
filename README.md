![Creative Commons License](https://img.shields.io/badge/license-Creative%20Commons-success) ![In Development](https://img.shields.io/badge/status-Released-success) ![Code Coverage](https://img.shields.io/badge/apex%20code%20coverage-100%25-success)

<h1 align="center">GET NEARBY RECORDS</h1>
<p align="center">
This package contains a Lightning component that finds records of a particular Salesforce object that are geographically near a given location.
</p>

## Summary

Suppose you have a Salesforce object that contains a [geolocation field](https://help.salesforce.com/articleView?id=custom_field_geolocate_overview.htm&type=0) and you would like to find records of that object that are geographically near one another. Given a set of latitude and longitude coordinates stored in a particular record, this Lightning Web Component finds and displays records of that object that are geographically near those coordinates.

## Installation and Setup

Read the disclaimer below and click on the **Install the Package** link. This will install the component to your org.

![Installation](/images/Installation.png)

If you are a Salesforce employee installing in an SDO, CDO, or IDO, you probably want to make sure that you select the button under the "Advanced" twisty to compile only the Apex in the package.

![Configuration](/images/Configuration.png)

There are several options available to configure the component to your liking:

- **Card Title**: Enter any title for the card that you wish.
- **API name of the location field of this object**: This must be set to the API name of a geolocation field in the object that holds the coordinates that you wish to display.
- **Additional WHERE clause predicate**: You can optionally set this to a SOQL WHERE clause expression (without the `WHERE`) to further refine the search for nearby records. For example, specifying `CreatedDate = LAST_90_DAYS` in this field will limit the results to records that were created in the last 90 days. The SOQL expression is generated internally by surrounding whatever you put in this field in parentheses and adding it onto the WHERE clause expression in the component.
- **Initial zoom level** The initial zoom level of the map. It must be between 1 and 22, and defaults to 15.
- **Draw a circle around center marker**: Check this box if you want the component to draw a circle on the map around the marker placed at the coordinates of the current record to show the radius of inclusion of the nearby records.
- **Circle color** The color of the circle to be drawn if applicable. Defaults to green, "#00FF00".
- **Show a table of the nearby locations**: If checked, the component will show a table of the nearby records containing links to those records and the distance each one is from the location specified in the current record.

## How to Deploy This Package to Your Org

I am a pre-sales Solutions Engineer for [Salesforce](https://www.salesforce.com) and I develop solutions for my customers to demonstrate the capabilities of the amazing Salesforce platform. _This package represents functionality that I have used for demonstration purposes and the content herein is definitely not ready for actual production use; specifically, it has not been tested extensively nor has it been written with security and access controls in mind. By installing this package, you assume all risk for any consequences and agree not to hold me or my company liable._ If you are OK with that ...

[Install the Package](https://login.salesforce.com/packaging/installPackage.apexp?p0=04t2E000003od8yQAA)

## Maintainer

[John Meyer / johnsfdemo](https://github.com/johnsfdemo)

**Current Version**: 1.0.2
