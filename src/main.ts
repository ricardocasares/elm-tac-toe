import "./main.css";
// @ts-expect-error
import Elm from "./Main.elm";

if (process.env.NODE_ENV === "development") {
  const ElmDebugTransform = await import("elm-debug-transformer");

  ElmDebugTransform.register({
    simple_mode: true,
  });
}

export const node = document.querySelector("#app");
export const app = Elm.init({ node });
