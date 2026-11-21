# Qwen Chat for Anvil (on device)

An [Anvil](https://github.com/deeeeone/Anvil) provider plugin that gives you **Qwen models from chat.qwen.ai, for free**, by running [smanx/qwen2api](https://github.com/smanx/qwen2api) on your Mac. There's no server to deploy and no API key: Anvil sets it up the first time you use it, starts it when you pick a `qwen/…` model, and stops it when Anvil quits.

## Install

In Anvil: **Settings → Provider → Add provider → From GitHub**, paste

```
https://github.com/deeeeone/anvil-provider-qwen2api
```

and confirm. Then pick a `qwen/…` model from the model menu.

**Needs:** Node.js 18+ (`brew install node`) and git. Google Chrome (or Chromium, Brave, Edge) makes it much more reliable; without one it falls back to a weaker mode.

## What it does

| Step | Where |
|---|---|
| First use: download qwen2api at a pinned commit into `upstream/` and `npm install` it | [`setup.sh`](setup.sh) |
| Start the proxy on `127.0.0.1:38765`, only reachable from this Mac | [`start.sh`](start.sh), [`localhost-only.cjs`](localhost-only.cjs) |
| Tell Anvil where it is and which models it has | [`anvil-provider.json`](anvil-provider.json) |

Your prompts go from Anvil to the proxy on your Mac, and from there to chat.qwen.ai. Nothing else is involved. The setup log is in the plugin folder (`.anvil-server.log`); Settings links to it.

Models are listed live from the proxy once it runs. `qwen3-max` and `qwen3-coder-plus` are shown before that.

## Good to know

- This uses Qwen Chat's website through an unofficial proxy, not Alibaba's paid API. It can break when the site changes, and it may go against Qwen Chat's terms. Use it on an account you're prepared to risk.
- qwen2api is third-party code with no license file, so this plugin doesn't copy it: `setup.sh` downloads it from GitHub on your Mac. To update, bump `COMMIT` in `setup.sh`; Anvil reruns setup automatically when that file changes.
- To use a copy you host yourself (Docker, Hugging Face…), see qwen2api's README and add an [`openai` plugin](https://github.com/deeeeone/Anvil/blob/main/docs/PROVIDERS.md) pointing at it.

## License

The plugin's own files are MIT. qwen2api is by [smanx](https://github.com/smanx), under its own terms.
