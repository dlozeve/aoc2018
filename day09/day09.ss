(import :std/srfi/1)

(export main)

(def (rotate lst n)
  (let*-values (((len) (length lst))
		((k) (remainder n len))
		((k) (+ k (if (< k 0) len 0)))
		((x y) (split-at lst k)))
    (append y x)))

(def (play circle marbles scores player)
  ;(displayln "[" player "] " circle)
  (match marbles
    ([] scores)
    ([marble . rest]
     (def new-player (remainder (1+ player) (vector-length scores)))
     (if (= 0 (remainder marble 23))
       (let* ((new-circle (rotate circle -7)))
	 (vector-set! scores player (+ marble (car new-circle) (vector-ref scores player)))
	 (play (cdr new-circle) (cdr marbles) scores new-player))
       (let ((new-circle (cons marble (rotate circle 2))))
	 (play new-circle (cdr marbles) scores new-player))))))

(def (marbles-game n-players last-marble)
  (apply max (vector->list (play '(0) (iota last-marble 1) (make-vector n-players 0) 0))))

(def (main (n-players "9") (last-marble "25") . args)
  (displayln (marbles-game 9 25))
  (displayln (marbles-game 10 1618))
  (displayln (marbles-game 13 7999))
  (displayln (marbles-game 17 1104))
  (displayln (marbles-game 21 6111))
  (displayln (marbles-game 30 5807))
  (displayln (marbles-game (string->number n-players) (string->number last-marble))))