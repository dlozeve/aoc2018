(import :gerbil/gambit/ports)
(import :std/pregexp)
(import :std/srfi/1)
(import :std/srfi/13)
(import :std/iter)

(export main)

(defstruct point (x y vx vy))

(def (step-point p n)
  (make-point (+ (* n (point-vx p)) (point-x p))
	      (+ (* n (point-vy p)) (point-y p))
	      (point-vx p)
	      (point-vy p)))

(def (step-points points n)
  (map (lambda (p) (step-point p n)) points))

(def (bounding-box points)
  (let ((xs (map point-x points))
	(ys (map point-y points)))
    [(- (apply max xs) (apply min xs) -1)
     (- (apply max ys) (apply min ys) -1)]))

(def (plot-points points)
  (def box (bounding-box points))
  (def min-x (apply min (map point-x points)))
  (def min-y (apply min (map point-y points)))
  (def new-points
    (delete-duplicates
     (map (lambda (p) [(- (point-x p) min-x) (- (point-y p) min-y)]) points)))
  (def plot (make-vector (cadr box) #f))
  (for ((i (in-range (cadr box)))) (vector-set! plot i (make-string (car box) #\.)))
  (for ((p new-points))
    (string-set! (vector-ref plot (cadr p)) (car p) #\#))
  (for ((i (in-range (cadr box))))
    (displayln (vector-ref plot i))))

(def (main (n "10240") . args)
  (def params
    (map (lambda (s) (filter-map string->number (pregexp-split "[<>, ]" s)))
	 (call-with-input-file "input.txt" (lambda (p) (read-all p read-line)))))
  (def points (map (lambda (p) (apply make-point p)) params))
  ;; (def sizes (for/collect ((i (in-range 20000)))
  ;; 	       [i (apply * (bounding-box (step-points points i)))]))
  ;; (displayln
  ;;  (foldl (lambda (s acc) (if (< (cadr s) (cadr acc)) s acc))
  ;; 	  (car sizes)
  ;; 	  (cdr sizes)))
  (plot-points (step-points points (string->number n))))
