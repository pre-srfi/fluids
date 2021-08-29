;; Copyright (C) Marc Nieper-Wißkirchen (2021).  All Rights Reserved.

;; Permission is hereby granted, free of charge, to any person
;; obtaining a copy of this software and associated documentation
;; files (the "Software"), to deal in the Software without
;; restriction, including without limitation the rights to use, copy,
;; modify, merge, publish, distribute, sublicense, and/or sell copies
;; of the Software, and to permit persons to whom the Software is
;; furnished to do so, subject to the following conditions:

;; The above copyright notice and this permission notice shall be
;; included in all copies or substantial portions of the Software.

;; THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
;; EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
;; MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
;; NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
;; BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
;; ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
;; CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
;; SOFTWARE.

(import (scheme base)
	(srfi 64)
	(example fluid-let))

(test-begin "Fluids")

(define-fluid x1 1)
(define-fluid x2 2)

(test-eqv 1 x1)
(test-eqv 2 x2)

(set! x1 3)
(test-eqv 3 x1)

(test-equal '(4 5 6)
  (fluid-let ((x1 4)
	      (x2 5))
    (let ((a x1) (b x2))
      (set! x1 6)
      (list a b x1))))

(test-eqv 3 x1)
(test-eqv 2 x2)

(test-eqv 8
  (fluid-let* ((x1 7)
	       (x1 (+ x1 1)))
    x1))

(test-end "Fluids")
