import { Controller } from '@hotwired/stimulus'
import { useHover } from 'stimulus-use'

export default class extends Controller {
  static values = {
    iframeId: String,
    identifier: Number
  }

  connect () {
    useHover(this, { element: this.element })
  }

  mouseEnter () {
    if (this.section == null) return

    if (this.section.hasAttribute('data-controller')) {
      this.section.dataset.controller = `scroll ${this.origionalControllerAttributes}`
    } else {
      this.section.setAttribute('data-controller', 'scroll')
    }
  }

  mouseLeave () {
    if (this.section == null) return

    if (this.section.hasAttribute('data-controller')) {
      this.section.dataset.controller = `${this.origionalControllerAttributes}`
    } else {
      this.section.removeAttribute('data-controller')
    }
  }

  get origionalControllerAttributes () {
    const existingControllerAttributes = this.section.dataset.controller.replace('scroll', '')
    const unique = [...new Set(existingControllerAttributes.split(' '))]
    const result = unique.filter(e => e !== '')

    return result
  }

  get section () {
    const iframe = document.getElementById('page-live-preview')
    const sectioId = `#aypex_section_id_${this.identifierValue}`
    const x = iframe.contentWindow
    const section = x.document.querySelector(sectioId)

    return section
  }
}
