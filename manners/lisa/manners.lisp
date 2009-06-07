(deftemplate guest ()
  (slot name)
  (slot sex)
  (slot hobby))

(deftemplate last_seat ()
  (slot seat))

(deftemplate seating ()
  (slot seat1)
  (slot name1)
  (slot name2)
  (slot seat2)
  (slot id) 
  (slot pid)
  (slot path_done))

(deftemplate ctxt ()
  (slot state))

(deftemplate path ()
  (slot id)
  (slot name)
  (slot seat))

(deftemplate chosen ()
  (slot id)
  (slot name)
  (slot hobby))

(deftemplate count ()
  (slot c))

(defrule assign_first_seat ()
   (?f1 (ctxt (state start)))
   (guest (name ?n))
   (?f3 (count (c ?c)))
   =>
   (assert (seating (seat1 1) (name1 ?n) (name2 ?n) (seat2 1) (id ?c) (pid 0) (path_done yes)))
   (assert (path (id ?c) (name ?n) (seat 1)))
   (modify ?f3 (c (+ ?c 1)))
   (format t "seat 1 ~A ~A 1 ~A 0 1~%" ?n ?n ?c)
   (modify ?f1 (state assign_seats)))

(defrule find_seating ()
   (?f1 (ctxt (state assign_seats)))
   (seating (seat1 ?seat1) (seat2 ?seat2) (name2 ?n2) (id ?id) (pid ?pid) (path_done yes))
   (guest (name ?n2) (sex ?s1) (hobby ?h1))
   (guest (name ?g2) (sex ?s2) (hobby ?h1))
   (test (not (equal ?s1 ?s2)))
   (?f5 (count (c ?c)))
   (not (path (id ?id) (name ?g2)))
   (not (chosen (id ?id) (name ?g2) (hobby ?h1)))
   =>
   (assert (seating (seat1 ?seat2) (name1 ?n2) (name2 ?g2) (seat2 (+ ?seat2 1)) (id ?c) (pid ?id) (path_done no)))
   (assert (path (id ?c) (name ?g2) (seat (+ ?seat2 1))))
   (assert (chosen (id ?id) (name ?g2) (hobby ?h1)))
   (modify ?f5 (c (+ ?c 1)))
   (format t "seat ~A ~A ~A~%" ?seat2 ?n2 ?g2)
   (modify ?f1 (state make_path)))

(defrule make_path ()
   (declare (salience 1))

   (ctxt (state make_path))
   (seating (id ?id) (pid ?pid) (path_done no))
   (path (id ?pid) (name ?n1) (seat ?s))
   (not (path (id ?id) (name ?n1)))
   =>
   (assert (path (id ?id) (name ?n1) (seat ?s))))

(defrule path_done ()
   (?f1 (ctxt (state make_path)))
   (?f2 (seating (path_done no)))
   =>
   (modify ?f2 (path_done yes))
   (modify ?f1 (state check_done)))

(defrule are_we_done ()
   (?f1 (ctxt (state check_done)))
   (last_seat (seat ?l_seat))
   (seating (seat2 ?l_seat))
   =>
   (format t "~&Yes, we are done!!")
   (modify ?f1 (state print_results)))

(defrule continue ()
   (?f1 (ctxt (state check_done)))
   =>
   (modify ?f1 (state assign_seats)))

(defrule print_results ()
   (ctxt (state print_results))
   (seating (id ?id) (seat2 ?s2))
   (last_seat (seat ?s2))
   (?f4 (path (id ?id) (name ?n) (seat ?s)))
   =>
   (retract ?f4)
   (format t "~A ~A~%" ?n ?s))

(defrule all_done ()
   (ctxt (state print_results))
   =>
   (halt))