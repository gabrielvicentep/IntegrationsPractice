import { LightningElement, track, api, wire } from "lwc";
import getWheather from "@salesforce/apex/WheatherCallouts.getWheather";

const columns = [
  { label: "Day", fieldName: "day" },
  { label: "Temperature", fieldName: "temperature" },
  { label: "Description", fieldName: "description" }
];
export default class WheatherForecast extends LightningElement {
  @api destination;
  @track wForecast = [];
  type = "forecast";
  loaded = false;
  columns = columns;
  errorMessage = "";

  @wire(getWheather, { type: "$type", destination: "$destination" })
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
