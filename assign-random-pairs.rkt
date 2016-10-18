#!/usr/bin/env racket
#lang racket

;; Returns a list of 2-element lists of elements from the given list, with each original element
;; appearing exactly once in the output. If the input list contains an odd number of elements, the
;; output will also contain a 1-element list with a remaining element
(define (random-pairs users)
  (if (odd? (length users))
      (match (remove-random users)
        [(list odd-user remaining)
         (cons (list odd-user) (random-pairs/even remaining))])
      (random-pairs/even users)))

;; Same as random-pairs, except it assumes its input is of even length
(define (random-pairs/even users)
  (cond
    [(empty? users) null]
    [else
     (match-define (list u1 rem1) (remove-random users))
     (match-define (list u2 rem2) (remove-random rem1))
      (cons (sort (list u1 u2) string<?)
            (random-pairs/even rem2))]))

(define (remove-random users)
  (define to-remove (list-ref users (random (length users))))
  (list to-remove (remove to-remove users)))

(pretty-write (random-pairs INPUT-GOES-HERE))
