#!/usr/bin/env racket
#lang racket

;; Usage: ./find-unpaired-users.rktd
;;
;; Reports any users in users.rktd not in any student-tuple in pairs.rktd. Expects to find both of
;; those files in the directory where this script lives.

(require
 racket/runtime-path)

(define-runtime-path this-dir ".")

(define (get-user-id user)
  (symbol->string (first user)))

(define (get-user-name user)
  (match user
    [(list _ (list _ name _ _ _)) name]))

(define all-users
  (call-with-input-file (build-path this-dir "users.rktd")
    (lambda (users-file) (read users-file))))

;; Every "pair" is a list of either one or two username strings
(define current-pairs (call-with-input-file (build-path this-dir "pairs.rktd") read))

(match (filter (lambda (user) (not (findf (curry member (get-user-id user)) current-pairs)))
               all-users)
  [(list)
   (displayln "All users are registered")]
  [unregistered-users
   (displayln "Users not found in pairs.rktd:")
   (for ([user unregistered-users])
     (printf "~a (~a)\n" (get-user-id user) (get-user-name user)))])
