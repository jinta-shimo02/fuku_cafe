import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="modal"
export default class extends Controller {
  static targets = ["modal"];
  static values = { shopId: Number };

  open() {
    this.modalTarget.classList.add("open");
  }

  close() {
    this.modalTarget.classList.remove("open");
  }
}
