import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  setValue (event) {
    this.element.value = event.params.id

    console.log(this.element)
  }
}
