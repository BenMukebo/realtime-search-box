import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "spinner"]

  connect() {
    this.timeout = null
    this.lastRecordedQuery = ""
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
      this.recordFinalSearch()
    }, 400)
  }

  recordFinalSearch() {
    const query = this.inputTarget.value.trim()
    if (!query || query === this.lastRecordedQuery) return
    this.lastRecordedQuery = query

    fetch("/search_articles/record", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content
      },
      body: JSON.stringify({ query: query })
    })
  }
}
