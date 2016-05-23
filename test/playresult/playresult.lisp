

;;;;
;;;; Tests related to the result of the engine::play() function
;;;;

(in-package :connect4-test)


(define-test play-result-board-full ()
	     (let ((r (run-minmax-test 
	      "play-result-board-full"
	      (create-test-board (list
		      "wbwbw"
		      "bwbwb"
		      "wbwbw"
		      "bwbwb"
		      ))
	      board:WHITE 6)))
	       ;;(format t "Result: ~a" r)
	       (assert-true r (format nil "Result not set"))
	       (assert-true (eql 4 (length r))  (format nil "Result length does not match"))
	       (assert-true (not (first r)) (format nil "First not nil"))
	       (assert-true (not (second r)) (format nil "Second not nil"))
	       (assert-true (not (third r)) (format nil "Third not nil"))
	       (assert-true (not (fourth r)) (format nil "Fourth not nil"))
	       (assert-true (playresult:play-result-no-move-available r) (format nil "play-result-no-move-available has failed"))
	       ))


(define-test play-result-players-color-1 ()
	     (assert-true
	      (eql
	       board:WHITE
	       (playresult::play-result-players-color `(1 1 1 ((2 ,board:WHITE "")))))
	      (format nil "play-result-players-color-1 failed")))

(define-test play-result-filter-move-sequence-by-token-1 ()
	     (let ((r
		    (playresult::play-result-filter-move-sequence-by-token
		     `(1 1 1 ((2 ,board:WHITE "") (3 ,board:BLACK "") (4 ,board:WHITE "")))
		     board:BLACK)))
	       (assert-true
		(eql 1 (length r))
		(format nil "play-result-filter-move-sequence-by-token-1 failed"))
	       (assert-true
		(eql (second (first r)) board:BLACK)
		(format nil "play-result-filter-move-sequence-by-token-1 failed"))
	       (assert-true
		(eql 3 (length (first r)))
		(format nil "play-result-filter-move-sequence-by-token-1 failed"))
	       ))

(define-test play-result-filter-move-sequence-by-token-2 ()
	     (let ((r
		    (playresult::play-result-filter-move-sequence-by-token
		     `(1 1 1 ((2 ,board:WHITE "") (3 ,board:BLACK "") (4 ,board:WHITE "")))
		     board:WHITE)))
	       (assert-true
		(eql 2 (length r))
		(format nil "play-result-filter-move-sequence-by-token-2 failed"))
	       (assert-true
		(eql 3 (length (first r)))
		(format nil "play-result-filter-move-sequence-by-token-2 failed"))
	       (assert-true
		(eql 3 (length (second r)))
		(format nil "play-result-filter-move-sequence-by-token-2 failed"))
	       (assert-true
		(eql (second (first r)) board:WHITE)
		(format nil "play-result-filter-move-sequence-by-token-2 failed"))
	       (assert-true
		(eql (second (second r)) board:WHITE)
		(format nil "play-result-filter-move-sequence-by-token-2 failed"))
	       ))



(define-test play-result-players-move-sequence-1 ()
	     (let ((r
		    (playresult::play-result-players-move-sequence
		     `(1 1 1 ((2 ,board:WHITE "") (3 ,board:BLACK "") (4 ,board:WHITE ""))))))
	       (assert-true
		(eql 2 (length r))
		(format nil "play-result-players-move-sequence-1 failed"))
	       (assert-true
		(eql 2 (first r))
		(format nil "play-result-players-move-sequence-1 failed"))
	       (assert-true
		(eql 4 (second r))
		(format nil "play-result-players-move-sequence-1 failed"))
	       ))

(define-test play-result-is-four-n-1 ()
	     (assert-false
	      (playresult::play-result-is-four-n
	       `(1 1 1 ((2 ,board:WHITE "") (3 ,board:BLACK "") (4 ,board:WHITE ""))))
	      (format nil "play-result-is-four-n-1 failed")))


(define-test play-result-is-four-n-2 ()
	     (assert-false
	      (playresult::play-result-is-four-n
	       `(1 1 1 ((2 ,board:WHITE "") (3 ,board:BLACK "MATE") (4 ,board:WHITE ""))))
	      (format nil "play-result-is-four-n-2 failed")))

(define-test play-result-is-four-n-3 ()
	     (assert-true
	      (playresult::play-result-is-four-n
	       `(1 1 1 ((2 ,board:WHITE "MATE") (3 ,board:BLACK "") (4 ,board:WHITE ""))))
	      (format nil "play-result-is-four-n-3 failed")))


(define-test play-result-is-four-n-4 ()
	     (assert-true
	      (playresult::play-result-is-four-n
	       `(1 1 1 ((2 ,board:WHITE "") (3 ,board:BLACK "") (4 ,board:WHITE "MATE"))))
	      (format nil "play-result-is-four-n-4 failed")))