import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "spinner"]

  connect() {
    this.timeout = null
    if (this.hasSpinnerTarget) {
      this.spinnerTarget.classList.add("hidden")
    }
  }
  
  search() {
    this.spinnerTarget.classList.remove("hidden")
    clearTimeout(this.timeout)
    this.timeout = setTimeout(() => {
      this.element.requestSubmit()
      this.spinnerTarget.classList.add("hidden")
    }, 400)
  }
}
