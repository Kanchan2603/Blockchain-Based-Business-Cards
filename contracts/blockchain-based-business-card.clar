;; Map to store business card per user
(define-map business-cards
  {user: principal}  ;; key
  {name: (string-ascii 50), title: (string-ascii 50), contact: (string-ascii 50)}) ;; value

(define-constant err-empty-field (err u100))

;; Public function to save/update business card
(define-public (set-business-card 
  (name (string-ascii 50)) 
  (title (string-ascii 50)) 
  (contact (string-ascii 50)))
  (begin
    (asserts! (> (len name) u0) err-empty-field)
    (asserts! (> (len title) u0) err-empty-field)
    (asserts! (> (len contact) u0) err-empty-field)
    (map-set business-cards 
             {user: tx-sender} 
             {name: name, title: title, contact: contact})
    (ok true)))

;; Read-only function to view own business card
(define-read-only (get-my-business-card)
  (let ((entry (map-get? business-cards {user: tx-sender})))
    (ok (match entry
         val (some {
           name: (get name val), 
           title: (get title val), 
           contact: (get contact val)
         })
         none))))
