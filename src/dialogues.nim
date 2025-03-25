import framecounter
import os
import macros

type
  Npc = ref object
    name: string

  DialogueLine[T] = ref object
    character: T
    text: string
    frameDelay: int

var clock = FrameCounter(fps: 1)

proc play[T](lines: seq[DialogueLine[T]], cb: proc(d: DialogueLine[T]) {.closure.}, index: int = 0) =
  if index >= lines.len: return  # End of dialogue
  
  let line = lines[index]
  clock.run after(line.frameDelay) do():
    line.cb()
    lines.play(cb, index + 1)  # Schedule next line recursively

macro dialogueBlock(T: typedesc, body: untyped): untyped =
  result = quote do:
    var lines: seq[DialogueLine[`T`]]
    
    template line(c: `T`, t: string, f: int) =
      lines.add(DialogueLine[`T`](
        character: c,
        text: t,
        frameDelay: f
      ))
    
    `body`
    lines

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

var d = dialogueBlock(Npc):
  alice.line("Bob, have you seen my sword?", 0)
  bob.line("Not since yesterday.", 2)
  alice.line("Ugh... I need it!", 2)
  bob.line("Check the tavern?", 2)

var dialogue = @[
  DialogueLine[Npc](character: alice, text: "Bob, have you seen my sword?", frameDelay: 0),
  DialogueLine[Npc](character: bob,   text: "Not since yesterday.",        frameDelay: 2),
  DialogueLine[Npc](character: alice, text: "Ugh... I need it!",           frameDelay: 2),
  DialogueLine[Npc](character: bob,   text: "Check the tavern?",           frameDelay: 2)
]


dialogue.play(say)
d.play(typewriterEffect)

while true:
  clock.tick()
