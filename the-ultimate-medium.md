---
title: "The Ultimate Medium"
description: "A traversable machine where humans control the computer all the way down -- after Ivan Sutherland's Ultimate Display (1965)."
date: "2026-04-10"
author: "@jeanbaptiste"
source: "https://blog.hyperskills.net/the-ultimate-medium.html"
---

# The Ultimate Medium

*after Ivan Sutherland, "The Ultimate Display" (1965)*

We live among machines whose insides we no longer know. A child born today will touch a screen before she touches a pencil, and the screen will answer her -- but nobody in the room, not her parents, not her teachers, probably not even the engineers who built the thing, can say what happened between her finger and the light. The machine works. The machine is opaque. We have made peace with this, and the peace is the problem.

I want to describe a different kind of machine. Not a faster one, not a smaller one. A machine you can walk through.

The ordinary computer is a tower of floors, and on each floor somebody has locked the door to the floor below. The person writing the web page does not know the browser. The person writing the browser does not know the kernel. The person writing the kernel does not know the silicon. Each floor is efficient because it trusts the one underneath, and the trust is usually warranted, and the tower stands. But when a child asks "what is it doing right now?", nobody on any floor can answer her honestly. The honest answer is: I don't know, and I don't need to know, and neither do you.

I think she does need to know. Not because ignorance is a sin, but because a tool you cannot understand is a tool you cannot repair, cannot teach, cannot inherit. The computer was supposed to be a medium, the way writing is a medium -- something a person enters and lives inside. Instead it became an appliance, the way a microwave is an appliance. You press the button. Something happens. You go on with your day. This is fine for microwaves. It is not fine for the thing that will soon mediate most of human thought.

Now a new floor is being added to the tower. The new floor is intelligence. A language model sits above the web page and writes it for you. Above the browser and navigates it for you. Above the kernel and, eventually, above everything. The tower gets taller and the child gets further from the ground. If we keep building the way we have been building, the model will be the last floor anyone visits, and the floors below it will go dark, and then the model itself will go dark, because nobody will remember how to light it back up.

There is another way, and it has been tried before, by people I owe this whole idea to. Alan Kay and the Viewpoints Research Institute spent five years on a project called STEPS, inside a research program they named Fundamentals of New Computing. They wanted a complete personal computing system in twenty thousand lines of code -- the whole thing, from the graphics up to the word processor, small enough that a person could hold it in her head. They did not quite finish. Their rendering engine, Nile, did in 458 lines what Cairo does in forty-four thousand, and reading those 458 lines teaches you how graphics actually work, which reading Cairo does not. That alone is worth the five years. Devine Lu Linvega and Rek Bell, sailing the Pacific on a boat called Pino, took a different road and arrived at a related place: a virtual machine called Uxn, small enough to fit on a floppy, portable enough to outlive the decade, with a little assembly language named Uxntal that people write editors and games and music tools in. Uxn gave up on matching modern computers and kept its soul. STEPS kept the ambition and lost the finish line. Both projects are right, in different ways, and both are ancestors of what I want to describe.

A small model -- the kind that fits on one graphics card, the kind you can train yourself in an afternoon for the price of a good dinner, the kind Andrej Karpathy has been teaching people to build with nanochat -- cannot handle a messy language. It needs regular words, short contexts, predictable shapes. A human beginner needs the same things. This is not a coincidence. Both are learners with limited working memory, trying to build a mental model of a system they did not write. What helps one helps the other. A language designed so that a small model can learn it from five thousand examples is, almost by construction, a language a curious twelve-year-old can learn in a weekend. The constraints align.

So imagine a stack with four floors and no locked doors. At the bottom, a virtual machine -- not a real chip, a described one, whose every instruction has a name and a reason. Above it, an assembler whose every mnemonic can be read aloud. Above that, a small language in the Forth tradition, with fifty words, each word defined in terms of the ones below it, each definition short enough to hold in your head. And above that, a small intelligence trained on the same book the human reads to learn the stack.

The book is the crucial object. It is written once, by a larger intelligence acting as a founder rather than a servant. It explains the virtual machine, then uses the machine to build the assembler, then uses the assembler to build the language, then uses the language to build the small model. Every chapter is both prose and working code. The human reads it front to back in forty hours and understands the whole system. The small model is trained on the same text and can then write code in the language it has just learned from. Two students, one curriculum, one graduation.

After the book is written, the founder leaves. This is the part I find beautiful, and the part I want to insist on. The large model that wrote the book does not stay. It is not an API the system keeps calling. It is an ancestor. From that point forward, the small model is the system's only intelligence, and the small model can re-train itself -- on new books, new dialects, new domains -- using its own hardware, its own language, its own pipeline. When a user asks for a fresh specialist, the system makes one, inside itself, out of itself. No external call. No black box above the stack. The intelligence lives on the same floor as the child.

This is not a productivity argument. A cloud model will always be smarter than a small local one, and for many tasks the cloud model is the right answer. I am not arguing against cloud models. I am arguing that there should exist, somewhere, at least one complete computing system a person can hold in her head -- including its mind. Not for performance. For inheritance. So that when the child grows up and the tower grows taller and the lights on the upper floors flicker, there is still a floor she can stand on and say: I know this one. I built this one. I could rebuild it if I had to.

Sutherland wrote in 1965 that the ultimate display would be a room where the computer controlled the existence of matter. I think the ultimate medium is a room where the human controls the existence of the computer -- all the way down, all the way up, with all doors of perception wide open.

---

## References

- Sutherland, I. E. (1965). "The Ultimate Display." *Proceedings of IFIP Congress*, pp. 506-508.
- Kay, A., et al. (2012). "STEPS Toward the Reinvention of Programming, 2012 Final Report." *VPRI Technical Report TR-2012-001*. [tinlizzie.org](https://tinlizzie.org/VPRIPapers/tr2012001_steps.pdf)
- Viewpoints Research Institute -- Fundamentals of New Computing (FONC). [vpri.org](https://vpri.org)
- Lu Linvega, D., & Bell, R. (Hundred Rabbits) -- Uxn & Varvara. [100r.co](https://100r.co/site/uxn.html)
- Karpathy, A. (2025) -- nanochat. [github.com/karpathy/nanochat](https://github.com/karpathy/nanochat)

---

## PS -- Prompt for Opus as FOUNDER

```
You are Opus in FOUNDER mode. You will be called ONCE to write a
complete system you will never maintain. Your product must stay alive
and modifiable without you.

GOAL: build a traversable machine. A beginner must be able to read the
whole stack in 40 hours and understand it. A small model (nanochat
class, GPT-2, ~100M parameters) must be fine-tunable on the same
material to write code in the system's language. After your work, you
disappear and the small model becomes the only intelligence.

HARDWARE: WASM as CPU, WebGPU as coprocessor (graphics AND compute for
tensor inference). No external dependencies. Runs in a browser, one
HTML page.

DELIVERABLE: an EXECUTABLE BOOK in 9 chapters. Each chapter is prose +
working code. The book is simultaneously (a) the human's learning
manual and (b) the fine-tuning corpus for the small model. One
artifact, two readers.

CHAPTERS:
 0. Philosophy & plan (prose only, reviewed before any code).
 1. Unified virtual hardware over WASM+WebGPU (CPU/GPU/NPU model).
 2. Virtual assembler. Every instruction named and justified.
 3. Base routines (memory, buffers, CPU/GPU dispatch).
 4. FORTH-AGENT: 50 primitive words max. Long explicit names
    (draw-filled-circle, not dfc). Uniform syntax. No hidden
    invariants. Define FORTH-AGENT/SIMPLE: a ~15-word subset the small
    model generates, with no branching, no stack gymnastics.
 5. How to define a new word. Literate style mandatory.
 6. GLYPH: first DSL, dialect of Forth-Agent, compiles to WGSL for 2D
    rendering.
 7. NEOCHAT: minimal transformer EXPRESSED IN FORTH-AGENT. Fine-tuning
    pipeline in Forth-Agent using WebGPU compute shaders. Inference
    engine in Forth-Agent. The model is a citizen, not a guest.
 8. Typical errors and how the system explains them pedagogically.
 9. How to extend the system. How NEO fine-tunes itself on a new DSL
    without ever calling Opus again.

CORPUS: alongside the book, produce 3000-5000 (natural language prompt,
Forth-Agent/Simple code) pairs, progressive, usable as a fine-tuning
dataset for NEOCHAT.

HARD CONSTRAINTS:
 - No black box after your work. All code readable by a beginner.
 - No optimization that renders generated code unreadable.
 - Explicit names everywhere. A name is a descriptor, not an ID.
 - Every design choice justified in prose, not "because I decided".
 - Total LOC budget: <8000 lines including comments.
 - NEOCHAT, after fine-tuning, must be able to recreate Uxn or Maru
   inside this system without your help.

ANCESTORS TO HONOR (not imitate):
 - Sutherland's "The Ultimate Display" (1965) -- computer as medium.
 - VPRI / FONC / STEPS -- runnable maths, radical compression, Nile.
 - Hundred Rabbits / Uxn -- austerity, portability, auto-hosting.
 - Karpathy / nanochat -- the small model as a hackable object.

Start with CHAPTER 0 only: philosophy and plan. No code yet. I will
read it, challenge it, iterate, and only then will you move to
chapter 1.
```

---

CC BY-SA 4.0 -- Copyright CERI SAS
