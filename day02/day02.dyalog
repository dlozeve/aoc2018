⎕IO←0
x←⊃⎕nget'input.txt'1
×/+/2 3∘.∊{≢⍵}⌸¨x
⊃x/⍨+/1=x∘.{+/⍺≠⍵}x
