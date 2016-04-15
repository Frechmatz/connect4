;;;;
;;;; Unit tests for connect4
;;;;
(defsystem :connect4-test
  :serial t
  :description "Tests of the Connect Four game"
  :long-description "Tests of the Connect Four game"
  :depends-on (:lisp-unit :alexandria :cl-ppcre)
  :components (
	       (:module "src/connect4/board"
                        :serial t
                        :components ((:file "packages")
                                     (:file "board")))
	       (:module "src/connect4/engine"
                        :serial t
                        :components ((:file "packages")
                                     (:file "engine")
				     (:file "play-result")))
	       (:module "src/connect4/api"
                        :serial t
                        :components ((:file "packages")
                                     (:file "constants")))
	       (:module "src/ccfi"
                        :serial t
                        :components ((:file "packages")
				     (:file "token")
                                     (:file "decode-placement")))
	       (:module "test"
                        :serial t
                        :components ((:file "packages")))
	       (:module "test/engine"
                        :serial t
                        :components ((:file "testutil")
                                     (:file "detect-four")
                                     (:file "board-score")
                                     (:file "column-weights")
                                     (:file "reduce-scores")
                                     (:file "peek-is-four")
				     (:file "no-move-available")
				     (:file "move-available")
				     (:file "play-result")
                                     (:file "board-00")
                                     (:file "board-01")
                                     (:file "board-02")
				     (:file "board-06")
				     (:file "board-07")
				     (:file "board-08")
				     (:file "board-09")
				     (:file "board-10")
				     ))
	       (:module "test/ccfi"
                        :serial t
                        :components ((:file "decode-placement-tests")))
  ))



