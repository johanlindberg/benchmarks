(defpackage "LISA-MANNERS-8"
  (:use "LISA-LISP"))

(in-package "LISA-MANNERS-8")

(make-inference-engine)
(load "~/Projects/benchmarks/manners/lisa/manners.lisp")
(load "~/Projects/benchmarks/manners/lisa/manners8-facts.lisp")
(reset)
(time (run))