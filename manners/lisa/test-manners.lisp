(defpackage :lisa-manners
  (:use :LISA-LISP))
(in-package :lisa-manners)

(defvar *path-to-files* "~/Projects/benchmarks/manners/lisa/")

(defun init-manners (n)
  (make-inference-engine)
  (clear)
  (load (merge-pathnames *path-to-files* "manners.lisp"))
  (load (merge-pathnames *path-to-files* (format nil "manners~A.lisp" n)))

  t)

(defun run-manners (times)
  (let ((result '())
        (sum 0))
    (dotimes (i times)
      (let ((start (get-internal-run-time))
            (stop nil)
            (elapsed-time nil))
        (reset)
        (run)
        (setf stop (get-internal-run-time))
        (setf elapsed-time (/ (- stop start) internal-time-units-per-second))
        (setf sum (+ elapsed-time sum))
        (push (format nil "~,2F sec" elapsed-time) result)))
    (values (format nil "~,2F sec (avg of ~A runs)" (/ sum times) times) result)))

