import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  connect () {
    const iFrame = this.element
    const iFrameContent = iFrame.contentWindow

    iFrameContent.addEventListener('load', function () {
      const innerHtmlHeight = iFrameContent.document.querySelector('body').clientHeight

      console.log(innerHtmlHeight)
      console.log(iFrame)
      // iFrame.style.height = `${innerHtmlHeight}px`
    })
  }
}
