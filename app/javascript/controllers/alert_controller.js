import { Controller } from "@hotwired/stimulus";
import Swal from "sweetalert2";

export default class extends Controller {
  static values = {
    message: String,
    type: String
  }

  connect() {
    console.log(this.messageValue);
    console.log(this.typeValue);

    if (this.hasMessageValue && this.messageValue) {
      this.showAlert();
    }
  }

  showAlert() {
    Swal.fire({
      position: "top-end",
      icon: this.typeValue,
      title: this.messageValue,
      showConfirmButton: true,
      timer: 2500
    });
  }
}
