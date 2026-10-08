const defaultTheme = require('tailwindcss/defaultTheme')

module.exports = {
  content: [
    './_drafts/**/*.html',
    './_includes/**/*.html',
    './_layouts/**/*.html',
    './_pages/**/*.html',
    './_posts/*.md',
    './*.html'
  ],
  theme: {
    fontFamily: {
      'sans': ['Inter var', ...defaultTheme.fontFamily.sans],
      'mono': ['JetBrains Mono', ...defaultTheme.fontFamily.mono]
    },
  },
  plugins: [
    require('@tailwindcss/typography')
  ],
}
