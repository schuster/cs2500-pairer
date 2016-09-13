#!/usr/bin/env racket
#lang racket

;; Usage: ./find-unpaired-users.rktd
;;
;; Reports any users in users.rktd not in any student-tuple in pairs.rktd. Expects to find both of
;; those files in the directory where this script lives.

(require
 racket/runtime-path)

(define-runtime-path this-dir ".")

(define all-usernames
  (call-with-input-file (build-path this-dir "users.rktd")
    (lambda (users-file)
      (for/list ([user (read users-file)])
        (symbol->string (first user))))))

;; Every "pair" is a list of either one or two username strings
(define current-pairs (call-with-input-file (build-path this-dir "pairs.rktd") read))

(match (filter (lambda (username) (not (findf (curry member username) current-pairs)))
               all-usernames)
  [(list)
   (displayln "All users are registered")]
  [unregistered-users
   (displayln "Users not found in pairs.rktd:")
   (for ([user unregistered-users])
     (printf "~a\n" user))])
