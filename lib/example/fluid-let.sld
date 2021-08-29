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

(define-library (example fluid-let)
  (export define-fluid
	  fluid-let
	  fluid-let*)
  (import (scheme base)
	  (srfi 211 syntax-case)
	  (srfi 211 identifier-syntax)
	  (srfi 213))
  (begin
    (define-syntax parameter (syntax-rules ()))

    (define-syntax define-fluid
      (syntax-rules ()
	((define-fluid id expr)
	 (begin
	   (define param (make-parameter expr))
	   (define-syntax id
	     (identifier-syntax
	      (_ (param))
	      ((set! _ e) (param e))))
	   (define-property id parameter #'param)))))

    (define-syntax fluid-let
      (lambda (stx)
	(syntax-case stx ()
	  ((_ ((id init) ...) . body)
	   (lambda (lookup)
	     (with-syntax
		 (((param ...)
		   (map
		    (lambda (id)
		      (let ((param (lookup id #'parameter)))
			(unless param
			  (syntax-violation
			   'fluid-let "not a fluid" stx id))
			param))
		    #'(id ...))))
	       #'(parameterize ((param init) ...) . body)))))))

    (define-syntax fluid-let*
      (syntax-rules ()
	((fluid-let* () . body)
	 (let* () . body))
	((fluid-let* ((id1 init1) (id2 init2) ...) . body)
	 (fluid-let ((id1 init1))
	   (fluid-let* ((id2 init2) ...) . body)))))))
