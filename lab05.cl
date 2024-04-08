; Оголошуємо структуру даних для вагона
(deftemplate wagon
   (slot reg-number (type INTEGER))
   (slot reg-name (type STRING))
   (slot reg-chief (type STRING))
   (slot type (type STRING))
   (slot year (type INTEGER))
   (slot repair-type (type STRING))
   (slot picture (type STRING))
   (slot money (type FLOAT))
   (slot bonus (type SYMBOL)) ; yes/no
   (slot bonus-percent (type INTEGER))
   (slot date-start (type SYMBOL))
   (slot date-stop (type SYMBOL))
   (slot reason (type STRING))
   (slot external (type SYMBOL)) ; yes/no
   (slot bank-external (type STRING))
   (slot inn-external (type INTEGER))
   (slot address-external (type STRING))
   (slot fio-chief (type STRING))
   (slot base-chief (type STRING))
   (slot fio-worker (type STRING))
   (slot base-worker (type STRING))
   (slot year-worker (type INTEGER))
   (slot special-worker (type STRING))
   (slot bonus-worker (type FLOAT))
   (slot comment (type STRING))
   (slot number-bank-kart (type STRING))
)

; Оголошуємо початкові дані
(deffacts initial-wagons
   (wagon (reg-number 12345) (reg-name "South Rail") (reg-chief "Chief-1") ... )
   ; Додайте інші вагони
)

(defrule schedule-depot-repair
   (wagon (reg-number ?num) (year ?y) (repair-type ?rt))
   (test (or (> (calculate-mileage ?num) 450000) (> (- (current-year) ?y) 2)))
   =>
   (printout t "Schedule depot repair for wagon: " ?num crlf)
   (modify ?*wagon* (repair-type "Depot Repair"))
)

(defrule schedule-TO-2
   ?w <- (wagon (reg-number ?num) (type ?t))
   (or (test (is-winter-season)) (test (is-summer-season)))
   =>
   (printout t "Schedule TO-2 for wagon type " ?t " with reg-number " ?num crlf)
   (modify ?w (repair-type "TO-2"))
)

(defrule schedule-TO-3
   (wagon (reg-number ?num) (year ?y))
   (test (or (> (calculate-mileage ?num) 150000) (> (- (current-year) ?y) 1)))
   =>
   (printout t "Schedule TO-3 for wagon: " ?num crlf)
   (modify ?*wagon* (repair-type "TO-3"))
)

(defrule schedule-current-repair
   ?w <- (wagon (reg-number ?num) (reason ?r&:(or (eq ?r "wheel-failure") (eq ?r "bogie-failure"))))
   =>
   (printout t "Schedule current repair for wagon: " ?num ", reason: " ?r crlf)
   (modify ?w (repair-type "Current Repair"))
)

(deffunction is-winter-season ()
   ; Припустимо, зима триває з листопада по лютий (включно)
   (bind ?current-month (get-month (current-date)))
   (if (or (>= ?current-month 11) (<= ?current-month 2))
      then (return TRUE)
      else (return FALSE))
)

; Допоміжна функція для розрахунку пробігу вагону:
(deffunction calculate-mileage (?reg-num)
   ; Припустимо, що фактичний пробіг зберігається в іншій частині системи або його потрібно запитати у користувача
   ; Тут ми просто виведемо заглушку
   (printout t "Enter mileage for wagon with reg-number " ?reg-num ": ")
   (bind ?mileage (read))
   (return ?mileage)
)

; Визначення поточної дати може включати в себе системні виклики або інтерактивний ввід
(deffunction current-date ()
   ; Припустимо, що ми отримуємо дату від системи
   ; В цьому прикладі ми просто повертаємо приблизну дату як строку
   (return "2024-04-08")
)

; Визначення поточного місяця з дати
(deffunction get-month (?date)
   (return (nth 2 (str-split "-" ?date))) ; Поділ строки за допомогою дефіса і взяти другий елемент
)

; Правило для визначення надання бонусів
(defrule calculate-bonus
   ?w <- (wagon (reg-number ?num) (bonus yes) (money ?m) (bonus-percent ?p))
   =>
   (bind ?bonus-amount (* ?m (/ ?p 100.0)))
   (printout t "Bonus for wagon " ?num " is $" ?bonus-amount crlf)
)
