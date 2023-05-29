import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  connect () {
    const color = this.element.style['background-color']
    const iframe = this.element.contentWindow

    console.log(this.element.style.backgroundColor)

    iframe.addEventListener('load', function () {
      const innerHtml = iframe.document.querySelector('html')
      innerHtml.style.backgroundColor = 'transparent'
    })
  }
}
