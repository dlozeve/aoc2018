⎕IO←0
x←⊃⎕nget'input.txt'1
x←⍎¨¨'\d+'⎕S'&'¨x

⍝ Part 1
claims←{id x y w h←⍵ ⋄ (x+⍳w)∘.,y+⍳h}¨x
fabric←1000 1000⍴0
{fabric[⍵]+←1}¨claims
+/,1<fabric

⍝ Part 2
⊃⊃x/⍨{∧/,1=fabric[⍵]}¨claims
