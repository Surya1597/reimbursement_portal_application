import { Controller } from "@hotwired/stimulus"

// Handles toggling of the "other" reason field on the bill form.
export default class extends Controller {
  static targets = ["select", "reasonField", "reasonInput"]

  connect() {
    this.toggleReason()
  }

  toggleReason() {
    const showReason = this.selectTarget.value === "other"
    this.reasonFieldTarget.classList.toggle("d-none", !showReason)
    this.reasonInputTarget.required = showReason
  }
}
