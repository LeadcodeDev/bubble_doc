import 'https://cdnjs.cloudflare.com/ajax/libs/iconify/2.0.0/iconify.min.js'
import 'https://cdn.jsdelivr.net/npm/mermaid@10/dist/mermaid.esm.min.mjs'
import { codeToHtml } from 'https://esm.sh/shiki@1.0.0'

const codes = document.querySelectorAll('pre.language');

codes.forEach(async (code) => {
  const metaAttributes = code.attributes['data-meta'].value;
  const meta = JSON.parse(metaAttributes);

  code.innerHTML = await codeToHtml(code.innerText, {
    lang: code.attributes['data-lang'].value,
    theme: 'catppuccin-frappe',
    transformers: [
      {
        line(node, line) {
          node.properties['data-line'] = line
          if (meta.highlight.includes(line)) this.addClassToHast(node, 'highlight')
          if (meta.insertLines.includes(line)) this.addClassToHast(node, 'insert')
          if (meta.removeLines.includes(line)) this.addClassToHast(node, 'remove')
        },
      },
    ]
  });
});
