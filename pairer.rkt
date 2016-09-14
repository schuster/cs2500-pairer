#!/usr/bin/env racket
#lang racket

;; A simple command-line app for entering new pairs into pairs.rktd. Expects to find the users.rktd
;; and pairs.rktd files in the directory where this script lives.

(require
 racket/runtime-path)

(define-runtime-path this-dir ".")

(define valid-usernames
  (call-with-input-file (build-path this-dir "users.rktd")
    (lambda (users-file)
      (for/list ([user (read users-file)])
        (symbol->string (first user))))))

;; Every "pair" is a list of either one or two username strings
(define current-pairs (call-with-input-file (build-path this-dir "pairs.rktd") read))

;; Prompts the user for their username, asking repeatedly if the given user is not in the
;; list or is already in a pair. Returns the valid entered username.
(define (ask-for-username which)
  (let loop ()
    (printf "Please enter the username for user ~s: " which)
    (define username (read-line))
    (cond
      [(not (member username valid-usernames))
       (displayln "That is not an existing username.")
       (displayln "Usernames should be of the form <first-part>.<last-part>.")
       (displayln "Please try again.\n")
       (loop)]
      [(findf (lambda (some-pair)
                (or (equal? (first some-pair) username)
                    (and (> (length some-pair) 1) (equal? (second some-pair) username))))
              current-pairs)
       (printf "~a is already part of a pair.\n" username)
       (displayln "Please try again.\n")
       (loop)]
      [else username])))

(define user1 (ask-for-username 1))
(define user2 (ask-for-username 2))

(cond
  [(equal? user1 user2)
   (displayln "You can't be paired with yourself!")]
  [else
   (call-with-output-file (build-path this-dir "pairs.rktd")
     (lambda (pairs-file)
       (pretty-write (append current-pairs (list (sort (list user1 user2) string<?))) pairs-file))
     #:exists 'truncate)
   (displayln "Your pair has been registered. Thank you!")])
