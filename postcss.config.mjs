import tailwindcss from "tailwindcss";
import autoprefixer from "autoprefixer";
import tailwindConfig from "./tailwind.config.mjs";

export default {
  plugins: [autoprefixer(), tailwindcss(tailwindConfig)],
};
