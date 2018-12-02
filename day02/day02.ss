(import :gerbil/gambit/ports)

(export main)

(def (unique-counts l)
  (def hash (make-hash-table))
  (for-each (lambda (x) (hash-update! hash x 1+ 0)) l)
  (hash-values hash))

(def (checksum l)
  (let ((twice (length (filter (lambda (x) (memq 2 (unique-counts x))) l)))
	(thrice (length (filter (lambda (x) (memq 3 (unique-counts x))) l))))
    (* twice thrice)))

(def (similarity id1 id2)
  (apply +
    (map (lambda (x y) (if (eq? x y) 0 1)) id1 id2)))

(def (find-similar id id-list)
  (filter (lambda (x) (eq? 1 (similarity id x))) id-list))

(def (intersection id1 id2)
  (reverse (foldl (lambda (x y acc) (if (eq? x y) (cons x acc) acc)) [] id1 id2)))

(def (main . args)
  (def ids (call-with-input-file "input.txt" (lambda (p) (read-all p read-line))))
  (displayln (checksum (map string->list ids)))

  (def common
    (let/cc exit
      (foldl
	(lambda (id acc)
	  (let ((similar (find-similar id acc)))
	    (if (< 0 (length similar))
	      (exit (intersection id (car similar)))
	      (cons id acc))))
	[]
	(map string->list ids))))
  (displayln (list->string common)))