

#|
    *********************************************
    Engine of classic Connect4
    *********************************************
|#

;;
;; Board dimensions of the original game
;;
(defparameter *CLASSIC-WIDTH* 7) 
(defparameter *CLASSIC-HEIGHT* 6) 

;;
;; Skip randomizer by setting to not nil.
;;
(defvar *classic-skip-randomizer* nil)

;;
;; Evaluate the score of the board
;; x y: The latest move
;; returns 1.0 or 0.0
;;
(defun board-score (board x y)
  (if (is-four board x y) 1.0 0.0))

;;
;; Move Generator
;; Returns a list of (x y) coordinates of all possible moves
;; board: The board
;;
(defun generate-moves (board)
  (let ( (moves ()) (row nil))
    (dotimes (x (get-board-width board))
      (setf row (find-row board x))
      (if row (push (list x row) moves))
      )
    moves
    ))

;;
;; Check if a move is available for the given board
;; Todo: Optimize
;;
(defun is-move-available (board)
  (let (( move-left nil))
    (dotimes (x (get-board-width board))
      (if (not (is-field-set board x 0)) (setf move-left t))
      )
  move-left
  ))

;;
;; Chooses a random move from all moves that have same the score as the given one
;; Moves list of tupels (x y score)
;;
(defun get-random-move (moves filter-score-value)
  (setf moves (remove-if-not (lambda (move) (equal filter-score-value (third move))) moves))
  (let ((index (/ (random (* 1000 (length moves))) 1000)))
    (nth (floor index) moves)
    ))

;;
;; Reduce list of possible moves
;; moves: list of tupels (x y score)
;; is-opponent: t -> score will be minimized, nil -> score will be maximized
;; Maximize: #'> Minimize: #'<
;; skip-randomizer: nil -> If multiple moves are available choose a random one. t -> choose first one
;; returns move with minimum or maximum score
;;
(defun reduce-scores (moves is-opponent &key (skip-randomizer nil))
  (let ((move nil) (fn (if is-opponent #'< #'>)))
    (setf move (reduce (lambda (best item)
			 (if (funcall fn (third item) (third best)) item best)) 
		       moves))
    (if (and move (not skip-randomizer) (not *classic-skip-randomizer*))
	(get-random-move moves (third move))
      move)
    ))

;;
;; 
;; Minimax implementation
;; Calculates a move
;; returns a tupel (x y score) where x represents the column, y the row and score the score of the column
;; max-depth: Maximum number of half-moves to execute (1..n)
;; color: The computers color
;;
(defun minmax (the-board color max-depth)
  ;; create a clone of the board that for performance reasons will be manipulated during the traversal
  (let ((board (clone-board the-board)))
    (labels ((minmax-inner (board color is-opponent cur-depth)
	       (let ((generated-moves (generate-moves board))  (moves ()) (score nil) (is-four nil))
		 (dolist (move generated-moves)
		   (nset-field board (first move) (second move) color) ;; do move
		   (setf score (board-score board (first move) (second move) )) ;; calc score
		   (setf is-four (equal score 1.0)) ;; 4 pieces in a row? 
		   (setf score (/ score (+ cur-depth 1.0))) ;; adapt score to current search depth
		   (if is-opponent (setf score (* -1.0 score))) ;; invert score if opponents draw
		   ;; final state or no more moves availabe or max depth reached
		   (if (or is-four (not (is-move-available board)) (equal cur-depth max-depth))
		       (progn
			 (push (list (first move) (second move) score) moves)
			 )
		       (progn
			 (setf score (minmax-inner board (invert-color color) (not is-opponent) (+ cur-depth 1)))
			 (push (list (first move) (second move) (third score)) moves)))
		   (nset-field board (first move) (second move) *EMPTY*) ;; undo move
		   )
		 ;; we now have a list of (x y score) tuples. Reduce them to a final move
		 (reduce-scores moves is-opponent :skip-randomizer nil)
		 )))
      (minmax-inner board color nil 1)
      )))

