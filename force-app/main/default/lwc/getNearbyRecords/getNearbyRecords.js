//  Javascript controller for the Get Nearby Records Lightning component.
//
//  This code is provided AS IS, with no warranty or guarantee of suitability for use.
//  Contact: john.meyer@salesforce.com

import { LightningElement, api, track, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getRecordLocation from '@salesforce/apex/GetNearbyRecords.getRecordLocation';
import getNearbyRecordsByLocation from '@salesforce/apex/GetNearbyRecords.getNearbyRecordsByLocation';

export default class GetNearbyRecords extends LightningElement {
	@api recordId;
	@api objectApiName;
	@api fieldApiName;
	@api cardTitle;
	@api showDataTable;
	@api initialZoomLevel;
	@api additionalWhereClause;

	unitOptions = [
		{ value: 'mi', label: 'miles' },
		{ value: 'km', label: 'kilometers' }
	];
	mapOptions = {
		scrollwheel: false,
		disableDoubleClickZoom: true
	};

	recordHasLocation = false;
	latitude;
	longitude;
	distance = '0.5';
	units = 'mi';

	@track markers = [];

	@track tableData = [];
	columns = [
		{
			label: 'Record',
			fieldName: 'link',
			type: 'url',
			wrapText: false,
			cellAttributes: { alignment: 'left' },
			typeAttributes: {
				label: { fieldName: 'recordName' },
				tooltip: { fieldName: 'recordName' },
				target: '_blank'
			}
		},
		{
			label: 'Distance',
			fieldName: 'distance',
			type: 'text',
			wrapText: false,
			cellAttributes: { alignment: 'right' },
			initialWidth: 150
		}
	];

	@wire(getRecordLocation, { objectApiName: '$objectApiName', fieldApiName: '$fieldApiName', recordId: '$recordId' })
	getRecords({ error, data }) {
		if (data) {
			if (data.error) {
				this.dispatchEvent(
					new ShowToastEvent({
						title: 'Error occurred trying to retrieve coordinates from this record',
						message: JSON.stringify(data.errorMessage),
						variant: 'error',
						mode: 'sticky'
					})
				);
			} else {
				this.recordHasLocation = true;
				this.latitude = data.latitude;
				this.longitude = data.longitude;
				this.drawMap();
			}
		}
	}

	drawMap() {
		getNearbyRecordsByLocation({
			recordId: this.recordId,
			objectApiName: this.objectApiName,
			fieldApiName: this.fieldApiName,
			additionalWhereClause: this.additionalWhereClause,
			distance: this.distance,
			units: this.units,
			latitude: this.latitude,
			longitude: this.longitude
		}).then((result) => {
			if (result.error) {
				this.dispatchEvent(
					new ShowToastEvent({
						title: 'Error occurred trying to retrieve nearby records',
						message: JSON.stringify(result.errorMessage),
						variant: 'error',
						mode: 'sticky'
					})
				);
			} else {
				this.markers = [
					{
						location: {
							Latitude: this.latitude,
							Longitude: this.longitude
						},
						value: this.recordId,
						title: 'This record',
						icon: 'standard:home'
					}
				];
				this.tableData = [];
				result.records.forEach((record) => {
					this.markers.push({
						location: {
							Latitude: record.latitude,
							Longitude: record.longitude
						},
						value: record.recordId,
						title: record.recordName,
						description: `<b>Distance:</b> ${record.distance.toString().match(/^-?\d+(?:\.\d{0,2})?/)[0]} ${
							this.units
						}`,
						icon: 'action:map'
					});
					this.tableData.push({
						recordId: record.recordId,
						recordName: record.recordName,
						distance: `${record.distance.toString().match(/^-?\d+(?:\.\d{0,2})?/)[0]} ${this.units}`,
						link: `/lightning/r/${this.objectApiName}/${record.recordId}/view`
					});
				});
			}
		});
	}

	handleChangeDistance(event) {
		this.distance = event.detail.value;
		this.drawMap();
	}

	handleChangeUnits(event) {
		this.units = event.detail.value;
		this.drawMap();
	}
}
