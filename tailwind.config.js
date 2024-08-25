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
      'sans': [...defaultTheme.fontFamily.sans],
      'serif': [...defaultTheme.fontFamily.serif]
    },
  },
  plugins: [
    require('@tailwindcss/typography')
  ],
}

