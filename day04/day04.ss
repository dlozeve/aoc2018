(import :gerbil/gambit/ports)
(import :std/pregexp)
(import :std/iter)
(import :std/sort)
(import :std/srfi/1)
(import :std/srfi/43)

(export main)

(defstruct date (year month day))

(defstruct shift (date id sleep))

(def (parse-date str)
  (def d (apply make-date (filter-map string->number (pregexp-split "[-\\[ ]" str))))
  (let ((parsed-hour (string->number (cadr (pregexp-match "\\s(\\d\\d):\\d\\d" str)))))
    (if (< 12 parsed-hour) (set! (date-day d) (1+ (date-day d)))))
  d)

(def (parse-minute str)
  (string->number (cadr (pregexp-match "\\s\\d\\d:(\\d\\d)" str))))

(def (parse-id str)
  (let ((parsed-id (pregexp-match "\\s\\#(\\d+)\\s" str)))
    (if parsed-id (string->number (cadr parsed-id)) #f)))

(def (partition-shifts records-str)
  (if (null? records-str)
    '()
    (let-values (((shift rest) (break (lambda (x) (pregexp-match "begins shift" x)) (cdr records-str))))
      (cons (cons (car records-str) shift) (partition-shifts rest)))))

(def (parse-shift records-str)
  (def id (parse-id (car records-str)))
  (def date (parse-date (car records-str)))
  (def sleep (make-vector 60 0))
  (for ((record (cdr records-str)))
    (let ((minute (parse-minute record)))
      (if (pregexp-match "falls asleep" record)
	(for ((i (in-range minute (- 60 minute)))) (vector-set! sleep i 1))
	(for ((i (in-range minute (- 60 minute)))) (vector-set! sleep i 0)))))
  (make-shift date id sleep))

(def (find-sleepiest-guard shifts)
  (def guards (make-hash-table))
  (for ((shift shifts))
    (let ((time-asleep (apply + (vector->list (shift-sleep shift)))))
      (hash-update! guards (shift-id shift) (lambda (x) (+ x time-asleep)) 0)))
  (car (hash-fold (lambda (k v acc) (if (> v (cadr acc)) (list k v) acc)) '(0 0) guards)))

(def (find-sleepiest-minute id shifts)
  (def total (make-list 60 0))
  (for ((shift shifts))
    (when (= id (shift-id shift))
      (set! total (map + total (vector->list (shift-sleep shift))))))
  (list-index (lambda (x) (= x (apply max total))) total))

(def (find-sleepy shifts)
  (def hash (make-hash-table))
  (for* ((shift shifts)
	 (i (in-range 60)))
    (hash-update! hash
		  [(shift-id shift) i]
		  (lambda (x) (+ x (vector-ref (shift-sleep shift) i)))
		  0))
  (car (hash-fold (lambda (k v acc) (if (> v (cadr acc)) (list k v) acc)) '(0 0) hash)))

(def (main . args)
  (def records-str
    (sort
     (call-with-input-file "input.txt" (lambda (p) (read-all p read-line)))
     string<?))
  (def shifts (map parse-shift (partition-shifts records-str)))
  (def sleepy-guard (find-sleepiest-guard shifts))
  (def sleepy-minute (find-sleepiest-minute sleepy-guard shifts))
  (displayln (* sleepy-guard sleepy-minute))
  (displayln (apply * (find-sleepy shifts))))
