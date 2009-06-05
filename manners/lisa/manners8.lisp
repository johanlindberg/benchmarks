(defpackage "LISA-MANNERS-8"
  (:use "LISA-LISP"))

(in-package "LISA-MANNERS-8")

(make-inference-engine)
(load "manners.lisp")
(load "manners8-facts.lisp")
(reset)
(time (run))