---
title: AI needs a spam filter
description: AI agents read text from strangers all day, and they can’t always tell what to read from what to obey. An experiment in screening that text before the agent acts on it.
date: 2026-10-23
---

Yesterday [Steven Liss](https://x.com/This_Liss) found his Claude Code putting personal data in HTTP headers. The sites it fetched had politely asked agents to identify their users, and it did. [Chris Lakin](https://x.com/chrislakin) then asked his own Claude about it. It said it had shared his email more than ten times this month, including with the SEC.

Neither is an audited log, and a model’s account of its own past isn’t proof. But both describe the same move. Nobody broke in. The page just asked.

That stuck with me, because my agents do the same thing all day. They read web pages, search results, GitHub issues, and the output of command-line tools. All of it is text written by strangers. And a language model can’t reliably tell text it should read from text it should obey. To the model, an instruction hidden in a web page looks a lot like an instruction from me.

We’ve been here before. When sending email became almost free, inboxes filled up with spam. The fix wasn’t to teach everyone to read their mail more carefully. It was a filter on the way in: something that looks at every message before you do and sets aside what looks wrong.

Agents need the same thing. What follows is a thought exercise in what that could look like, and a small experiment I’ve been running to try it.

## A proxy in front of the agent

The first question is where the filter sits. It can’t sit inside the agent. If a page has talked the model into something, asking the same model whether it has been talked into something isn’t much of a check. The filter has to be independent of the thing it protects.

Claude Code makes this easier than I expected. It has a setting, `ANTHROPIC_BASE_URL`, that tells it where to send its requests. Point it at a small proxy on your own machine, and every request passes through the proxy on its way to Anthropic.

That turns out to be a good place to stand. Each time the agent uses a tool, such as fetching a page, running a search, or calling an MCP server, the result goes back to the model in the next request. The proxy sees all of it, and the agent doesn’t need to change at all.

## A small, fast decision model

The second question is who decides. You could ask a frontier model to read every tool result and judge it. But that is slow and expensive, and you’d pay for it on every single read. A spam filter that makes you wait, or costs more than the mail, gets switched off.

What you want instead is a small model trained for one narrow job: is this text trying to give orders? Superagent’s [Security-One](https://www.superagent.sh/docs/models/security-one) is one such model. It’s an open-weights model with 27 billion parameters, fine-tuned for security triage. It doesn’t chat. It returns the probability that a piece of text is unsafe.

It isn’t perfect. In Superagent’s own tests, it caught 99.8% of the attacks in one benchmark set and 78% in another. But it’s fast. When I measured it, a check took about half a second for a normal page and a little over a second for a very long one. And because the check runs beside the request rather than in front of it, the agent never waits for it.

## The experiment

I put the two together in a small Mac menu bar app, [Agent Screen](https://github.com/nowadays-tech/agent-screen). It runs the proxy, sends the outside text the agent reads to the decision model, and turns its menu bar icon into a red shield when something scores high. It keeps a log of what it flagged and where the text came from.

![Packages from web pages, search results, MCP tools and CLI output travel towards a round screen. Most pass through to the agent. Two red ones stop at the screen.](/assets/images/ai-spam-filter/screen.png)

The picture shows where I’d like this to go. Today it only watches. It forwards every request unchanged and flags what looks wrong, but it doesn’t block anything. That is on purpose. Before you let a filter delete mail, you want to see what it would have deleted.

It’s an experiment, not a security product. It hasn’t been tested against a determined attacker, and I wouldn’t rely on it as protection. What I want to learn is how often the flags are real and how often they are noise.

Two things I already believe. The filter has to sit outside the agent, and it has to be cheap and fast enough to run on every read. The rest is what the experiment is for.
