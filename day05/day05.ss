(import :gerbil/gambit/ports)
(import :std/iter)
(import :std/srfi/13)

(export main)

(def (opposite? x y)
     (= (abs (- (char->integer x) (char->integer y))) 32))

(def (react-polymer polymer)
     (foldl (lambda (x acc) (match acc
			      ((cons y rest) (if (opposite? x y) rest (cons x acc)))
			      (else (cons x acc))))
	    '()
	    polymer))

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
