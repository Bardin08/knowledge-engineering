; факти про осіб та можливі професії
(deffacts people
    (person Voronko)
    (person Pavlenko)
    (person Levytsky)
    (person Saharov)
)

(deffacts professions
    (profession dancer)
    (profession artist)
    (profession singer)
    (profession writer)
)

; факти, що відображають відому інформацію з задачі
(deffacts known-information
    (saw-concert Voronko singer)
    (saw-concert Levytsky singer)
    (posed-with Pavlenko writer)
    (posed-with writer artist)
    (wrote-about writer Saharov)
    (plans-to-write-about writer Voronko)
    (never-heard-of Voronko Levytsky)
)

; правила для виведення професій кожної особи
(defrule determine-professions
    ?p1 <- (posed-with Pavlenko ?profession1)
    ?p2 <- (posed-with ?profession1 artist)
    ?w <- (wrote-about writer Saharov)
    ?w2 <- (plans-to-write-about writer Voronko)
    ?c1 <- (saw-concert Voronko singer)
    ?c2 <- (saw-concert Levytsky singer)
    ?nh <- (never-heard-of Voronko Levytsky)
    =>
    (assert (profession Pavlenko artist))
    (assert (profession Saharov singer))
    (assert (profession writer))
    (assert (profession Voronko dancer))
    (assert (profession Levytsky writer))
)

(defrule print-professions
    (profession ?person ?job)
    =>
    (printout t ?person " is a " ?job ".\n")
)
