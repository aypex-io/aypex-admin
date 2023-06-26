import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  setValue (event) {
    const inputEvent = new Event('input')

    this.element.value = event.params.id
    this.element.dispatchEvent(inputEvent)
  }
}
