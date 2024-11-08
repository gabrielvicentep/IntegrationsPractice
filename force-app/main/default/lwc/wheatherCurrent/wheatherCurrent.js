import { LightningElement, api, wire, track } from "lwc";
import getWheather from "@salesforce/apex/WheatherCallouts.getWheather";
import { ShowToastEvent } from "lightning/platformShowToastEvent";

export default class WheatherCurrent extends LightningElement {
  @track wCurrent = [];
  loaded = false;
  destination = null;
  type = "current";
  errorMessage = "";

  @api get destination() {
    return this._destination;
  }
  set destination(value) {
    this._destination = value;

    if (this._destination) {
      this.getCurrentWheather(this._destination);
    }
  }
  async getCurrentWheather(destination) {
    if (destination.includes(" ")) {
      destination = destination.replaceAll(" ", "-");
    }
    if (destination) {
      try {
        const wList = await getWheather({
          type: this.type,
          destination: destination
        });
        this.wCurrent = wList[0];
        this.loaded = true;
        this.error = undefined;
      } catch (error) {
        this.loaded = true;
        this.wCurrent = undefined;
        this.errorMessage = error.body.message;
        this.showToast();
      }
    }
  }
  showToast() {
    const event = new ShowToastEvent({
      title: "Error",
      message: this.errorMessage + " Please try again later.",
      variant: "error",
      mode: "sticky"
    });
    this.dispatchEvent(event);
  }
}
