(import :gerbil/gambit/ports)
(import :std/pregexp)
(import :std/iter)

(export main)

(def (claim-area! fabric claim)
  (match claim
    ([id x y w h] (for* ((i (in-range x w))
			 (j (in-range y h)))
		    (hash-update! fabric [i j] (lambda (l) (cons id l)) [])))))

(def (non-overlapping-claim fabric)
  (def overlapping (make-hash-table))
  (hash-for-each (lambda (k v) (for ((id v)) (hash-put! overlapping id #t))) fabric)
  (hash-for-each (lambda (k v) (when (< 1 (length v))
				 (for ((id v)) (hash-put! overlapping id #f))))
		 fabric)
  (hash->list overlapping)
  (hash-find (lambda (k v) (if v k #f)) overlapping))

(def (main . args)
  (def claims-str (call-with-input-file "input.txt" (lambda (p) (read-all p read-line))))
  (def claims (map (lambda (x) (filter-map string->number (pregexp-split "[ #@,:x]" x))) claims-str))
  (def fabric (make-hash-table))
  (for ((claim claims))
    (claim-area! fabric claim))
  (displayln (hash-fold (lambda (k v acc) (if (> (length v) 1) (1+ acc) acc)) 0 fabric))

  (displayln (non-overlapping-claim fabric)))
