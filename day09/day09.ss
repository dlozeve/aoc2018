(import :std/srfi/1)

(export main)

(def (rotate-right deque k)
  (def left (car deque))
  (def right (cadr deque))
  (if (= k 0)
    deque
    (if (null? right)
      (rotate-right [[] (reverse left)] k)
      (rotate-right [(cons (car right) left) (cdr right)] (1- k)))))

(def (rotate-left deque k)
  (def left (car deque))
  (def right (cadr deque))
  (if (= k 0)
    deque
    (if (null? left)
      (rotate-left [(reverse right) '()] k)
      (rotate-left [(cdr left) (cons (car left) right)] (1- k)))))

(def (deque-car deque)
  (match deque
    ([left right] (car right))))

(def (deque-cdr deque)
  (match deque
    ([left right] [left (cdr right)])))

(def (deque-cons x deque)
  (match deque
    ([left right] [left (cons x right)])))

(def (display-deque deque)
  (displayln (reverse (car deque)) " " (cadr deque)))

(def (play circle marbles scores player)
  ;; (display-deque circle)
  (match marbles
    ([] scores)
    ([marble . rest]
     (def new-player (remainder (1+ player) (vector-length scores)))
     (if (= 0 (remainder marble 23))
       (let ((new-circle (rotate-left circle 7)))
	 (vector-set! scores player (+ marble (deque-car new-circle) (vector-ref scores player)))
	 (play (deque-cdr new-circle) (cdr marbles) scores new-player))
       (let ((new-circle (deque-cons marble (rotate-right circle 2))))
	 (play new-circle (cdr marbles) scores new-player))))))

(def (marbles-game n-players last-marble)
  (apply max (vector->list (play  [[] [0]] (iota last-marble 1) (make-vector n-players 0) 0))))

(def (main (n-players "9") (last-marble "25") . args)
  (displayln (marbles-game 9 25))
  (displayln (marbles-game 10 1618))
  (displayln (marbles-game 13 7999))
  (displayln (marbles-game 17 1104))
  (displayln (marbles-game 21 6111))
  (displayln (marbles-game 30 5807))
  (displayln (marbles-game (string->number n-players) (string->number last-marble))))
