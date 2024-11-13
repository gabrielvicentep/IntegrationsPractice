import { LightningElement, track } from "lwc";
import { ShowToastEvent } from "lightning/platformShowToastEvent";

export default class WrapperLwc extends LightningElement {
  @track inputError = "";
  destination;
  newDestination = "";
  showForecast = false;
  showCurrent = false;
  errorMessage = "test";

  errorCallback(error, stack) {
    this.errorMessage = error.message;
    this.showToast();
  }

  handleOnChangeDestination(event) {
    this.newDestination = event.target.value;
  }
  handleForecast() {
    if (this.validateDestination()) {
      this.destination = this.newDestination;
      this.showCurrent = false;
      this.showForecast = true;
    }
  }

  handleCurrent() {
    if (this.validateDestination()) {
      this.destination = this.newDestination;
      this.showForecast = false;
      this.showCurrent = true;
    }
  }
  validateDestination() {
    if (
      this.newDestination === null ||
      this.newDestination.match(/^ *$/) !== null //checks if input is empty or whitespaces
    ) {
      this.inputError = "Please enter a destination";
      return false;
    }
    this.inputError = "";
    return true;
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
