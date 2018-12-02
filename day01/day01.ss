(import :gerbil/gambit/ports)

(export main)

(def freqs (with-input-from-file "input.txt" read-all))

(def (repeat n l)
  (match n
    (0 [])
    (else (append l (repeat (1- n) l)))))

(def (main . args)
  (displayln (apply + freqs))

  (let/cc exit
    (foldl
      (lambda (x acc)
	(let ((new-x (+ x (car acc))))
	  (if (memq new-x acc)
	    (begin (displayln new-x) (exit))
	    (cons new-x acc))))
      [0]
      (repeat 200 freqs))))
