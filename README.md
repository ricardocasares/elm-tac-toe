# ElmTacToe

Playing TicTacToe with Elm. Two players share one screen, X goes first.

## Run it

Requires [Bun](https://bun.sh). Installing also fetches the pinned Elm tools listed in `elm-tooling.json`.

```sh
bun install
bun run dev     # play at the URL Vite prints
bun run test    # game rules and UI tests
bun run lint    # elm-review
bun run build   # production build in dist/
```

## Layout

- `src/Game.elm` holds the rules: moves, turns, wins and draws. It knows nothing about the UI.
- `src/Main.elm` is the Elm app that renders a `Game` and turns clicks into moves.
- `tests/GameSpec.elm` tests the rules, including playing out all 255,168 possible games.
- `tests/MainSpec.elm` plays through the rendered page by simulating clicks.
