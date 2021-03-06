
(in-package :connect4-console)


;;;;
;;;; Command line argument parsers
;;;;

(define-condition invalid-arguments (error)
  ((text :initarg :text :reader text)))

(defun parse-arguments (args parsers context)
  (let ((result ()))
    (labels ((parse (args parsers context)
	       (let ((arg (car args)) (parser (car parsers)))
		 (cond 
		   ((and (not arg) (not parser)) nil)
		   ((and (not arg) parser) (error 'invalid-arguments :text "Missing arguments"))
		   ((and arg (not parser)) (error 'invalid-arguments :text "Too many arguments"))
		   (t 
		    (push (funcall parser arg context) result)
		    (parse (cdr args) (cdr parsers) context))
		   ))))
      (parse args parsers context))
    (reverse result)
    ))

(defun parse-number (n min-n max-n &key (radix 10))
  "Parse a number out of a hex string."
  (setf n
	(handler-case
	    (parse-integer (format nil "~a" n) :radix radix)
	  (parse-error  nil)))
  (cond 
    ((not (integerp n)) (error 'invalid-arguments :text "Not a number"))
    ((> n max-n) (error 'invalid-arguments :text (format nil "Number too large: ~a. Allowed values are ~a...~a" n min-n max-n)))
    ((< n min-n) (error 'invalid-arguments :text (format nil "Number too small: ~a. Allowed values are ~a...~a" n min-n max-n)))
    (t n)
    ))

(defun parse-x (x context)
  (parse-number x 0 (+ -1 (get-width (slot-value context 'board))) :radix 16))

(defun parse-level (level context)
  (declare (ignore context))
  (parse-number level 1 10))

(defun parse-color (c context)
  (declare (ignore context))
  (if (equal c 'W) WHITE
    (if (equal c 'B) BLACK
      (error 'invalid-arguments :text "Invalid color. Valid colors are W and B")
      )))

(defun parse-board-dimension (n  context)
  (declare (ignore context))
  ;; board dimension > 16 is not supported by the board-formatter
  (parse-number n 4 16 ))

