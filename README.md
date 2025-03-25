# Dialogues

A small dialogue system for nim, with dialogue builder.

## Requirements

Requires framecounter.

`nimble install https://github.com/RattleyCooper/framecounter`

## Example

```nim
import dialogues
import framecounter
import os

  type
    Npc = ref object
      name: string

  proc say(d: DialogueLine[Npc]) =
    echo d.character.name, ": ", d.text

  proc typewriterEffect(d: DialogueLine[Npc]) =
    stdout.write(d.character.name, ": ")
    for c in d.text:
      stdout.write(c)
      stdout.flushFile()
      sleep(50)
    echo ""

  let alice = Npc(name: "Alice")
  let bob = Npc(name: "Bob")

  # Manually create Dialogue Lines...
  var dialogue = @[
    DialogueLine[Npc](character: alice, text: "Bob, have you seen my sword?", frameDelay: 0),
    DialogueLine[Npc](character: bob,   text: "Not since yesterday.",        frameDelay: 2),
    DialogueLine[Npc](character: alice, text: "Ugh... I need it!",           frameDelay: 2),
    DialogueLine[Npc](character: bob,   text: "Check the tavern?",           frameDelay: 2)
  ]

  # Create dialogue using dialogueBlock.
  var dialogue2 = dialogueBlock(Npc):
    alice.line("Bob, have you seen my sword?", 0)
    bob.line("Not since yesterday.", 2)
    alice.line("Ugh... I need it!", 2)
    bob.line("Check the tavern?", 2)

  dialogue.play(say)
  dialogue2.play(typewriterEffect)

  while true:
    clock.tick()
```
