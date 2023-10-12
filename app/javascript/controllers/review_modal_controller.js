import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="review-modal"
export default class extends Controller {
  static targets = ["reviewModal"]
  connect() {
  }

  close(event) {
    if (event.detail.success) {
      this.reviewModalTarget.classList.add("hidden");
    }
  }
}
