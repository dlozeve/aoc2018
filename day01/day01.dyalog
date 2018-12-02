⎕IO←0
x←,⍎¨⎕csv'input.txt'
+/x

y←+\(200×⍴x)⍴x
pos←{⍸⍵=y}¨y
y[1⌷{⍵[⍋⍵]}{1⌷⍵}¨(⊃¨1<⍴¨pos)/pos]
