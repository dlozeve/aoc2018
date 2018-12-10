(import :gerbil/gambit/ports)
(import :std/pregexp)
(import :std/srfi/1)
(import :std/iter)

(export main)

(defstruct node (children metadata))

(def (parse-node lst)
  (match lst
    ([m n . rest]
     (let*-values (((children rest) (parse-children rest m))
		   ((metadata rest) (split-at rest n)))
       (values (make-node children metadata) rest)))))

(def (parse-children lst m)
  (if (= m 0)
    (values [] lst)
    (let*-values (((children rest) (parse-children lst (1- m)))
		  ((child rest) (parse-node rest)))
      (values (cons child children) rest))))

(def (dfs node f g)
  (if (null? (node-children node))
    (f (node-metadata node))
    (g (cons (f (node-metadata node))
	     (map (lambda (n) (dfs n f g)) (node-children node))))))

(def (node-value node)
  (if (null? (node-children node))
    (apply + (node-metadata node))
    (apply + (for/collect ((m (node-metadata node)))
	       (if (and (> m 0) (< (1- m) (length (node-children node))))
		 (node-value (list-ref (reverse (node-children node)) (1- m)))
		 0)))))

(def (main . args)
  (def example-lst [2 3 0 3 10 11 12 1 1 0 1 99 2 1 1 2])
  (define-values (example _) (parse-node example-lst))
  (displayln (dfs example (lambda (m) (apply + m)) (lambda (m) (apply + m))))
  (displayln (node-value example))
  (def lst (map string->number (pregexp-split " " (call-with-input-file "input.txt" read-line))))
  (define-values (tree _) (parse-node lst))
  (displayln (dfs tree (lambda (m) (apply + m)) (lambda (m) (apply + m))))
  (displayln (node-value tree)))
