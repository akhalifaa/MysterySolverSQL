-- A Log of my SQL queries to solve the mystery!

/*Query 1: Start with the crime scene reports table, look at reports for our given date and street*/
SELECT *
FROM crime_scene_reports
WHERE year = 2021
AND month = 7
AND day = 28
AND street = "Humphrey Street";

/*Query 2: Look into the interview scripts of the 3 witnesses*/
SELECT *
FROM interviews
WHERE year = 2021
AND month = 7
AND day = 28
AND transcript LIKE "%thief%"
OR "%theft%";

/*Query 3: Look into bakery security footage: find the potential getaway car LICENSE PLATES(one of these belong to thief)*/
SELECT license_plate
FROM bakery_security_logs
WHERE year = 2021
AND month = 7
AND day = 28
AND hour = 10
AND minute >= 15
AND minute <= 25;

/*Query 4: look at atm transactions at legget st before 10:15: list of potential ACCOUNT NUMBERS of the thief*/
SELECT account_number
FROM atm_transactions
WHERE year = 2021
AND month = 7
AND day = 28
AND atm_location = "Leggett Street"
AND NOT transaction_type = "deposit";

/*Query 5: Look into phone calls duration less than a minute, within 10 minutes of 10:15*/
SELECT *
FROM phone_calls
WHERE year = 2021
AND month = 7
AND day = 28
AND duration < 60;

/*Query 6: Look at flights early morning day after theft*/ --> (answer's where the thief went to...earliest flight next morning.)
SELECT *
FROM flights
JOIN airports ON flights.destination_airport_id = airports.id
WHERE year = 2021
AND month = 7
AND day = 29
ORDER BY hour;

/*Query 7: Passport numbers of potential suspects that took earliest flight*/
SELECT passport_number
FROM passengers
JOIN flights
ON passengers.flight_id = flights.id
JOIN airports
ON flights.destination_airport_id = airports.id
WHERE passengers.flight_id = 36;

/*Query 8: Search in the people table conditioning it to the previous findings: bank accounts, passport number, phone number, license plate and account number*/
SELECT *
FROM people
JOIN bank_accounts
ON people.id = bank_accounts.person_id
WHERE passport_number
IN (SELECT passport_number
    FROM passengers
    JOIN flights
    ON passengers.flight_id = flights.id
    JOIN airports
    ON flights.destination_airport_id = airports.id
    WHERE passengers.flight_id = 36)
AND phone_number
IN (SELECT caller
    FROM phone_calls
    WHERE year = 2021
    AND month = 7
    AND day = 28
    AND duration < 60)
AND license_plate
IN (SELECT license_plate
    FROM bakery_security_logs
    WHERE year = 2021
    AND month = 7
    AND day = 28
    AND hour = 10
    AND minute >= 15
    AND minute <= 25)
AND account_number
IN (SELECT account_number
    FROM atm_transactions
    WHERE year = 2021
    AND month = 7
    AND day = 28
    AND atm_location = "Leggett Street"
    AND NOT transaction_type = "deposit");

/*Query 9: Find out who the accomplice is by querying the reciever's phone number*/
SELECT name
FROM people
WHERE phone_number =
    (SELECT receiver
    FROM phone_calls
    WHERE caller
    = (SELECT phone_number
       FROM people
       WHERE name = "Bruce")
       AND year = 2021
       AND month = 7
       AND day = 28
       AND duration < 60);


/*Query 10: Final Query is to obtain the reciever's name (ANSWER)*/

SELECT receiver
FROM phone_calls
WHERE caller
= (SELECT phone_number
   FROM people
   WHERE name = "Bruce")
AND year = 2021
AND month = 7
AND day = 28
AND duration < 60;