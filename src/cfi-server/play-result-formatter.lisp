;;
;; Helper functions to format the response of a play command
;;

(in-package :cfi-server)

(defun play-result-formatter-move (result)
  (format nil "~a"
	  (if (not (engine:play-result-is-move result))
	      "NULL"
	      (engine:play-result-column result))))

(defun play-result-formatter-four (result)
  (if (engine:play-result-is-four-n result)
      (list-to-string
       (engine:play-result-players-move-sequence result)
       (lambda (i) (format nil "~a" i))
       :item-separator "/"
       :string-prefix "--four ")))

(defun play-result-formatter-score (result)
  (if (engine:play-result-is-move result)
      (format nil "--score ~a" (format-score (engine:play-result-score result)))
      ""))

(defun get-line (board x y color)
  (mapcar
   (lambda (i)
     (list (first i) (- (board:get-height board) (second i) 1)))
   (board:get-connected-pieces
    (board:set-field board x y color)
    x y)))
  
(defun play-result-formatter-line (board result)
  (if (engine:play-result-is-four-1 result)
      (list-to-string
       (get-line
	board
	(engine:play-result-column result)
	(engine:play-result-row result)
	(engine:play-result-players-color result))
       (lambda (i) (format nil "~a;~a" (first i) (second i)))
       :item-separator "/"
       :string-prefix "--line ")))

(defun format-play-result (board result)
  (format nil "bestmove ~a ~a ~a ~a"
	  (play-result-formatter-move result)
	  (play-result-formatter-score result)
	  (play-result-formatter-four result)
	  (play-result-formatter-line board result)
	  ))


