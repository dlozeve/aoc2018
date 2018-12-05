(import :gerbil/gambit/ports)
(import :std/iter)
(import :std/srfi/13)

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

(def (remove-unit unit polymer)
     (string-delete (lambda (x) (char=? (char-downcase x) (char-downcase unit))) polymer))

(def (find-minimal polymer)
     (apply min
	    (for/collect ((c (in-range (char->integer #\a) 26)))
			 (length (react-polymer (string->list (remove-unit (integer->char c) polymer)))))))

(def (main . args)
  (def polymer (call-with-input-file "input.txt" read-line))
  (displayln (length (react-polymer (string->list polymer))))
  (displayln (find-minimal polymer)))
