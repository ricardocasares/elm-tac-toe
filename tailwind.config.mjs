import daisyui from "daisyui";

export default {
  content: ["index.html", "src/**/*.{html,elm}"],
  plugins: [daisyui],
  theme: {
    extend: {
      fontFamily: {
        display: ['"Futura"', '"Jost"', '"Century Gothic"', "sans-serif"],
      },
    },
  },
  daisyui: {
    themes: [
      {
        mondrian: {
          primary: "#1d3fa8",
          secondary: "#d40920",
          accent: "#fac901",
          neutral: "#111111",
          "base-100": "#f4f1e8",
          "base-200": "#e9e5d6",
          "base-300": "#111111",
          "base-content": "#111111",
          "--rounded-box": "0",
          "--rounded-btn": "0",
          "--rounded-badge": "0",
          "--btn-focus-scale": "1",
          "--border-btn": "4px",
        },
      },
      "light",
      "cyberpunk",
      "wireframe",
      "black",
      "dracula",
    ],
  },
};
