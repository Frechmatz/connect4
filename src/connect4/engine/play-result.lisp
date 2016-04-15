
#|
Accessor functions for the result of the play() function
|#


(in-package :engine)

(defun play-result-is-line-four (line)
  (equal (third line) "MATE"))

(defun play-result-column (result)
  (first result))

(defun play-result-row (result)
  (second result))

(defun play-result-score (result)
  (third result))

(defun play-result-no-move-available (result)
  (not (first result)))

(defun play-result-move-sequence (result)
  (fourth result))

;; not to be exported
(defun play-result-players-color (result)
  (second (first (fourth result))))

;; not to be exported
(defun play-result-filter-move-sequence-by-token (result token)
  (remove-if-not (lambda (item) (eql (second item) token)) (play-result-move-sequence result)))

;; public
(defun play-result-players-move-sequence (result)
  (if (not (play-result-no-move-available result))
      (mapcar (lambda (item) (first item)) (play-result-filter-move-sequence-by-token result (play-result-players-color result)))
      nil))

(defun play-result-is-four-1 (result)
  (play-result-is-line-four (first (fourth result))))

(defun play-result-is-four-n (result)
  (let ((is-four nil))
    (dolist (move (fourth result))
	     (if (not is-four)
		 (setf is-four (play-result-is-line-four move))))
    is-four))

