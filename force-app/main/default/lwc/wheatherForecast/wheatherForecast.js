import { LightningElement, track, api, wire } from "lwc";
import getWheather from "@salesforce/apex/WheatherCallouts.getWheather";

const columns = [
  { label: "Day", fieldName: "day", initialWidth: 180 },
  { label: "Temperature °C", fieldName: "temperature", initialWidth: 180 },
  { label: "Description", fieldName: "description" }
];
export default class WheatherForecast extends LightningElement {
  newDestination;

  @api get destination() {
    return this._destination;
  }
  set destination(value) {
    this._destination = value;
    if (this._destination) {
      if (this._destination.includes(" ")) {
        this.newDestination = this._destination.replaceAll(" ", "-");
      } else {
        this.newDestination = this._destination;
      }
    }
  }
  @track wForecast = [];
  type = "forecast";
  loaded = false;
  columns = columns;
  errorMessage = "";

  @wire(getWheather, { type: "$type", destination: "$newDestination" })
  wiredData({ error, data }) {
    if (data) {
      console.log("Forecast", data);
      this.wForecast = data;
      this.loaded = true;
    } else if (error) {
      this.wForecast = null;
      this.loaded = true;
      this.errorMessage = error.body.message;
      throw new Error(this.errorMessage);
    }
  }
}
