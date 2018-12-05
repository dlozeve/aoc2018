(import :gerbil/gambit/ports)
(import :std/pregexp)
(import :std/iter)
(import :std/sort)
(import :std/srfi/1)
(import :std/srfi/43)

(export main)

(def (react-single polymer)
  (match polymer
    ([x y . z] (if (= (abs (- (char->integer x) (char->integer y))) 32)
		 (react-polymer z)
		 (cons x (react-single (cons y z)))))
    (else polymer)))

(def (react-polymer polymer)
  (def length-before (length polymer))
  (def polymer-new (react-single polymer))
  (if (= (length polymer-new) length-before)
    polymer-new
    (react-polymer polymer-new)))

(def (main . args)
  (def polymer (call-with-input-file "input.txt" read-line))
  (displayln (length (react-polymer (string->list polymer)))))