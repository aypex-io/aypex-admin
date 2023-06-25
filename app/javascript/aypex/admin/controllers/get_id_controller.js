import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static outlets = ['input-value']

  markAsSelected (event) {
    this.inputValueOutlets.forEach(result => result.markAsSelected(event))
  }
}
