(import :gerbil/gambit/ports)
(import :std/iter)
(import :std/pregexp)
(import :std/srfi/1)
(import :std/sort)

(export main)

(def (no-incoming? edges m)
  (not (member m (map cadr edges))))

(def (find-no-incoming edges)
  (sort
   (filter (lambda (m) (no-incoming? edges m)) (delete-duplicates (apply append edges)))
   char<?))

(def (topological-sort edges)
  (def (aux edges l s)
    (match s
      ([] l)
      ([n . rest] (let* ((new-edges (filter (lambda (e) (not (eq? n (car e)))) edges))
			 (additional-s (map cadr (filter (lambda (e)
							   (and (eq? n (car e)) (no-incoming? new-edges (cadr e))))
							 edges)))
			 (new-s (sort (delete-duplicates (append rest additional-s)) char<?)))
		    (aux new-edges (cons n l) new-s)))))
  (reverse (aux edges [] (find-no-incoming edges))))

(def (main . args)
  (def edges
    (map (lambda (e)
	   (map (lambda (s) (car (string->list s)))
		(cdr (pregexp-match "Step (.) must be finished before step (.) can begin." e))))
	 (call-with-input-file "input.txt" (lambda (p) (read-all p read-line)))))
  (displayln (list->string (topological-sort edges))))
