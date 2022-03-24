//  Javascript controller for the Get Nearby Records Lightning component.
//
//  This code is provided AS IS, with no warranty or guarantee of suitability for use.
//  Contact: john.meyer@salesforce.com

import { LightningElement, api, track, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getRecordLocation from '@salesforce/apex/GetNearbyRecords.getRecordLocation';
import getNearbyRecordsByLocation from '@salesforce/apex/GetNearbyRecords.getNearbyRecordsByLocation';

const METERS_PER_MILE = 1609.34;
const METERS_PER_KILOMETER = 1000.0;

const NO_GEOLOCATION_FIELD = 'NO_GEOLOCATION_FIELD';

export default class GetNearbyRecords extends LightningElement {
	@api recordId;
	@api objectApiName;
	@api fieldApiName;
	@api cardTitle;
	@api showDataTable;
	@api initialDistance = '1.0';
	@api initialUnits = 'mi';
	@api initialZoomLevel;
	@api additionalWhereClause;
	@api drawCircle;
	@api circleColor = '#00FF00';

	unitOptions = [
		{ value: 'mi', label: 'miles' },
		{ value: 'km', label: 'kilometers' }
	];
	mapOptions = {
		scrollwheel: false,
		disableDoubleClickZoom: true
	};

	recordHasLocation = false;
	hasGeolocationField = true;
	latitude;
	longitude;
	distance;
	units;

	center;

	@track markers = [];

	@track tableData = [];
	tableRows = 0;

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

	connectedCallback() {
		this.distance = parseFloat(this.initialDistance);
		this.units = this.initialUnits;
		this.hasGeolocationField = this.fieldApiName !== NO_GEOLOCATION_FIELD;
	}

	@wire(getRecordLocation, { objectApiName: '$objectApiName', fieldApiName: '$fieldApiName', recordId: '$recordId' })
	getRecords({ error, data }) {
		if (data && !data.error) {
			this.recordHasLocation = true;
			this.latitude = data.latitude;
			this.longitude = data.longitude;
			this.drawMap();
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
			if (result.error && this.hasGeolocationField) {
				this.dispatchEvent(
					new ShowToastEvent({
						title: 'Error occurred trying to retrieve nearby records',
						message: JSON.stringify(result.errorMessage),
						variant: 'error',
						mode: 'sticky'
					})
				);
			} else {
				this.center = {
					location: {
						Latitude: this.latitude,
						Longitude: this.longitude
					}
				};
				this.markers = [];
				if (this.drawCircle) {
					this.markers.push({
						location: {
							Latitude: this.latitude - 0.0000001,
							Longitude: this.longitude - 0.0000001
						},
						type: 'Circle',
						radius: this.units === 'mi' ? this.distance * METERS_PER_MILE : this.distance * METERS_PER_KILOMETER,
						strokeColor: this.circleColor,
						strokeOpacity: 0.5,
						strokeWeight: 3,
						fillColor: this.circleColor,
						fillOpacity: 0.1
					});
				}
				this.markers.push({
					location: {
						Latitude: this.latitude,
						Longitude: this.longitude
					},
					value: this.recordId,
					title: 'This record',
					icon: 'standard:home'
				});
				this.tableData = [];
				this.tableRows = 0;
				result.records.forEach((record) => {
					this.tableRows++;
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
