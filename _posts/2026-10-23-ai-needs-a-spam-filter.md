---
title: AI needs a spam filter
description: AI agents read text from strangers all day, and they can’t always tell what to read from what to obey. An experiment in screening that text before the agent acts on it.
date: 2026-10-23
unlisted: true
sitemap: false
---

Yesterday, [Steven Liss](https://x.com/This_Liss) noticed that his Claude Code was putting personal data into HTTP headers. The sites it fetched had politely asked agents to identify their users, so it did. Chris Lakin then asked his own Claude about it:

<figure class="tweet">
  <blockquote>
    <p class="tweet-author">Chris Lakin <span>@chrislakin</span></p>
    <p>I asked my claude about this and it said it had shared my email 10+ times this month… including to the SEC</p>
    <div class="tweet-quoted">
      <p class="tweet-author">Steven Liss <span>@This_Liss</span></p>
      <p>Another vulnerability few are talking about: I found my Claude Code exposing personal data in http headers because the sites it curled politely asked agents to identify their users 😊<br>Epistemic cybersecurity is the hot new category for 2027.</p>
    </div>
  </blockquote>
  <figcaption><a href="https://x.com/chrislakin/status/2113358733548081528">View on X</a> · Oct 22, 2026</figcaption>
</figure>

A model’s account of what it did last month isn’t proof of anything. But the trick itself is simple. Nobody hacked anything. The page asked, and the agent did what it was told.

My agents read web pages, search results, GitHub issues and command-line output all day. Most of that text is written by people I don’t know. And a language model can’t reliably tell the difference between text it should read and text it should obey. An instruction hidden in a web page looks a lot like one from me.

It reminds me of email spam. Once sending an email cost almost nothing, inboxes filled up. Nobody solved that by reading their mail more carefully. We solved it with filters that look at every message before we do.

I think agents need the same thing, so I’ve been running a small experiment to see what it could look like.

## Where the filter sits

The filter can’t live inside the agent. If a web page has talked the model into something, asking the same model to check itself doesn’t help much. It has to be a separate thing.

Claude Code makes this easy. The `ANTHROPIC_BASE_URL` setting decides where it sends its requests. Point it at a proxy on your own machine, and every request goes through the proxy before it reaches Anthropic.

When the agent uses a tool, like fetching a page or calling an MCP server, the result goes to the model in the next request. So the proxy sees everything the agent reads, and the agent itself doesn’t have to change.

## Who decides

You could ask a frontier model to judge every tool result. It would be slow and expensive, and you’d pay for it on every read. A spam filter that slows you down or costs more than the mail gets turned off.

A small model trained for one narrow job fits better. Superagent’s [Security-One](https://www.superagent.sh/docs/models/security-one) is one of those. It’s an open-weights model with 27 billion parameters, fine-tuned for security triage. You give it a piece of text, and it returns the probability that the text is unsafe.

It doesn’t catch everything. In Superagent’s own tests, it caught 99.8% of the attacks in one benchmark and 78% in another. It’s fast, though. When I measured it, a normal page took about half a second to check, and a very long one a little over a second. The check runs alongside the request, so the agent doesn’t wait for it.

## Agent Screen

I combined the two in a small Mac menu bar app called [Agent Screen](https://github.com/nowadays-tech/agent-screen). It runs the proxy, sends the outside text the agent reads to Security-One, and turns the shield in the menu bar red when something scores high. It also logs what it flagged and where the text came from.

![Packages from web pages, search results, MCP tools and CLI output travel towards a round screen. Most pass through to the agent. Two red ones stop at the screen.](/assets/images/ai-spam-filter/screen.png)

The drawing shows where I want to take it. Right now it only watches. Every request goes through unchanged, and it flags what looks suspicious. It doesn’t block anything yet, because I want to see what it would have blocked before I let it.

This is an experiment, not a security product. It hasn’t been tested against real attacks, and I wouldn’t rely on it. What I want to find out is how many of the flags turn out to be real.

## Try it

You need a Mac with macOS 15 or later, Swift 6 (Xcode 16 or its command line tools), and an API key from [Superagent](https://www.superagent.sh).

Build the app and open it:

```sh
git clone https://github.com/nowadays-tech/agent-screen.git
cd agent-screen
bin/build
cp -R "build/Agent Screen.app" ~/Applications/
open ~/Applications/"Agent Screen.app"
```

A shield shows up in the menu bar. Choose **Superagent API Key…** and paste your key. Without a key, traffic passes through unchecked.

Then start Claude Code through the proxy:

```sh
ANTHROPIC_BASE_URL=http://127.0.0.1:8977 claude
```

Your normal Claude login works through it. To use the proxy every time, add the setting to `~/.claude/settings.json`:

```json
{
  "env": {
    "ANTHROPIC_BASE_URL": "http://127.0.0.1:8977"
  }
}
```

Keep the app running. When it’s closed, Claude Code can’t reach the API. Choose **Open at Login** in the menu so it starts with your Mac.

Flags show up in the menu. Each one is also saved as a line in this file:

```sh
~/Library/Application\ Support/Agent\ Screen/flags.jsonl
```

To stop, remove the setting and quit the app.
