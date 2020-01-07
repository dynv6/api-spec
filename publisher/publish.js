
const fs = require("fs")
    , process = require("process")
    , data = fs.readFileSync("/docs/openapi.json", "utf-8")
    , spec = JSON.parse(data)

require("widdershins").convert(spec, {
  language_tabs: [
    { go: "Go" },
    { ruby: "Ruby" },
    { python: "Python" },
    { javascript: "JavaScript" },
  ],
}, (err, md) => {
  if (err) {
    console.error("error converting OpenAPI to Shins:", err)
    process.exit(1)
  }

  require("shins").render(md, {
    minify:     true,
    inline:     true,
    logo:       "./dynv6.svg",
    "logo-url": "https://dynv6.com/",
  }, (err, html) => {
    if (err) {
      console.error("error converting Shins to HTML:", err)
      process.exit(1)
    }

    fs.writeFileSync("/docs/index.html", html, "utf-8")
  })
})
