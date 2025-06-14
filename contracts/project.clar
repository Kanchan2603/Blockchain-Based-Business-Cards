;; Blockchain-Based Business Cards
;; Store and share contact information securely on-chain

;; Constants
(define-constant err-already-registered (err u100))
(define-constant err-not-registered (err u101))
(define-constant err-empty-field (err u102))

;; Define a data structure for a business card
(define-map business-cards principal
  (tuple
    (name (string-ascii 50))
    (email (string-ascii 50))
    (phone (string-ascii 20))
    (company (string-ascii 50))
  )
)

;; Function to create a business card (only once per user)
(define-public (create-card
  (name (string-ascii 50))
  (email (string-ascii 50))
  (phone (string-ascii 20))
  (company (string-ascii 50))
)
  (begin
    (asserts! (not (is-some (map-get? business-cards tx-sender))) err-already-registered)
    (asserts! (> (len name) u0) err-empty-field)
    (asserts! (> (len email) u0) err-empty-field)
    (map-set business-cards tx-sender {
      name: name,
      email: email,
      phone: phone,
      company: company
    })
    (ok true)))

;; Function to read a business card by principal
(define-read-only (get-card (user principal))
  (match (map-get? business-cards user)
    some-card (ok some-card)
    none err-not-registered))
