(import :gerbil/gambit/ports)
(import :std/pregexp)
(import :std/srfi/1)

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

(def (main . args)
  (def lst (map string->number (pregexp-split " " (call-with-input-file "input.txt" read-line))))
  (define-values (tree rest) (parse-node lst))
  (displayln (dfs tree (lambda (m) (apply + m)) (lambda (m) (apply + m)))))
