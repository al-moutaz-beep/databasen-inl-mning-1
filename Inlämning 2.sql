För inlämning 1




-- Al Motaz ballh Al Mushref , YH25


create database Bokhandel;
Use Bokhandel;


-- Tabell: Kund
CREATE TABLE Kund (
    Epost      VARCHAR(255) PRIMARY KEY,
    Namn       VARCHAR(255) NOT NULL,
    Telefon    VARCHAR(50),
    Adress     VARCHAR(255)
);

-- Tabell: Bok
CREATE TABLE Bok (
    ISBN        VARCHAR(13) PRIMARY KEY,
    Titel       VARCHAR(255) NOT NULL,
    Forfattare  VARCHAR(255) NOT NULL,
    Pris        DECIMAL(10,2) NOT NULL,
    Lagerstatus INT NOT NULL
);

-- Tabell: Bestallning
CREATE TABLE Bestallning (
    Ordernummer INT PRIMARY KEY,
    KundEpost   VARCHAR(255) NOT NULL,
    Datum       DATE NOT NULL,
    Totalbelopp DECIMAL(10,2) NOT NULL,
    CONSTRAINT fk_bestallning_kund
        FOREIGN KEY (KundEpost) REFERENCES Kund(Epost)
);

-- Tabell: Orderrad (koppling mellan Bestallning och Bok)
CREATE TABLE Orderrad (
    Ordernummer INT NOT NULL,
    ISBN        VARCHAR(13) NOT NULL,
    PRIMARY KEY (Ordernummer, ISBN),
    CONSTRAINT fk_orderrad_bestallning
        FOREIGN KEY (Ordernummer) REFERENCES Bestallning(Ordernummer),
    CONSTRAINT fk_orderrad_bok
        FOREIGN KEY (ISBN) REFERENCES Bok(ISBN)
);

-- Exempeldata för att fylla databasen

INSERT INTO Kund (Epost, Namn, Telefon, Adress) VALUES
('anna@example.com',   'Anna Andersson',   '070-1111111', 'Storgatan 1'),
('bertil@example.com', 'Bertil Bengtsson', '070-2222222', 'Lillegatan 2');

INSERT INTO Bok (ISBN, Titel, Forfattare, Pris, Lagerstatus) VALUES
('9789144035965', 'Databasteknik',              'Elmasri & Navathe',      599.00, 10),
('9780131101630', 'The C Programming Language', 'Kernighan & Ritchie',    499.00, 5),
('9780201633610', 'Design Patterns',            'Gamma et al.',           699.00, 3);

INSERT INTO Bestallning (Ordernummer, KundEpost, Datum, Totalbelopp) VALUES
(1, 'anna@example.com',   '2024-09-01', 1098.00),
(2, 'bertil@example.com', '2024-09-02',  699.00);

INSERT INTO Orderrad (Ordernummer, ISBN) VALUES
(1, '9789144035965'),
(1, '9780131101630'),
(2, '9780201633610');


Förinlämning 2


-- =========================
-- 1. SKAPA DATABAS
-- =========================

USE Bokhandel;

-- =========================
-- 2. TABELLER + CONSTRAINTS
-- =========================

CREATE TABLE Kunder (
    kund_id INT AUTO_INCREMENT PRIMARY KEY,
    namn VARCHAR(100) NOT NULL,
    epost VARCHAR(100) UNIQUE,
    skapad_tid TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Böcker (
    ISBN VARCHAR(20) PRIMARY KEY,
    titel VARCHAR(150) NOT NULL,
    pris DECIMAL(10,2) NOT NULL CHECK (pris > 0),
    lagerstatus INT DEFAULT 0
);

CREATE TABLE Beställningar (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    kund_id INT,
    datum TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (kund_id) REFERENCES Kunder(kund_id)
);

CREATE TABLE Orderrader (
    orderrad_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT,
    ISBN VARCHAR(20),
    antal INT NOT NULL,
    FOREIGN KEY (order_id) REFERENCES Beställningar(order_id),
    FOREIGN KEY (ISBN) REFERENCES Böcker(ISBN)
);

-- =========================
-- 3. TESTDATA
-- =========================

INSERT INTO Kunder (namn, epost) VALUES
('Ali Hassan', 'ali@mail.com'),
('Sara Ahmed', 'sara@mail.com'),
('Omar Khaled', 'omar@mail.com');

INSERT INTO Böcker (ISBN, titel, pris, lagerstatus) VALUES
('9781111111111', 'SQL Grund', 50, 10),
('9782222222222', 'Avancerad SQL', 80, 5),
('9783333333333', 'Databasdesign', 70, 7);

INSERT INTO Beställningar (kund_id) VALUES
(1), (1), (2);

INSERT INTO Orderrader (order_id, ISBN, antal) VALUES
(1, '9781111111111', 2),
(1, '9782222222222', 1),
(2, '9783333333333', 1),
(3, '9781111111111', 1);

-- =========================
-- 4. HÄMTA + FILTRERA + SORTERA
-- =========================

SELECT * FROM Kunder;
SELECT * FROM Beställningar;

SELECT * FROM Kunder
WHERE namn LIKE '%Ali%' OR epost LIKE '%mail.com%';

SELECT * FROM Böcker
ORDER BY pris ASC;

-- =========================
-- 5. UPDATE + DELETE + TRANSAKTION
-- =========================

UPDATE Kunder
SET epost = 'ali_ny@mail.com'
WHERE kund_id = 1;

DELETE FROM Kunder
WHERE kund_id = 3;

START TRANSACTION;

UPDATE Böcker
SET pris = 100
WHERE ISBN = '9781111111111';

ROLLBACK;

-- =========================
-- 6. JOIN + GROUP BY + HAVING
-- =========================

-- INNER JOIN
SELECT k.namn, b.order_id
FROM Kunder k
INNER JOIN Beställningar b ON k.kund_id = b.kund_id;

-- LEFT JOIN
SELECT k.namn, b.order_id
FROM Kunder k
LEFT JOIN Beställningar b ON k.kund_id = b.kund_id;

-- GROUP BY
SELECT k.namn, COUNT(b.order_id) AS antal_beställningar
FROM Kunder k
LEFT JOIN Beställningar b ON k.kund_id = b.kund_id
GROUP BY k.namn;

-- HAVING
SELECT k.namn, COUNT(b.order_id) AS antal_beställningar
FROM Kunder k
JOIN Beställningar b ON k.kund_id = b.kund_id
GROUP BY k.namn
HAVING COUNT(b.order_id) > 2;

-- =========================
-- 7. INDEX
-- =========================

CREATE INDEX idx_epost ON Kunder(epost);

-- =========================
-- 8. TRIGGERS
-- =========================

CREATE TABLE Kundlogg (
    logg_id INT AUTO_INCREMENT PRIMARY KEY,
    kund_id INT,
    meddelande VARCHAR(255),
    skapad_tid TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

DELIMITER //

CREATE TRIGGER trg_minska_lager
AFTER INSERT ON Orderrader
FOR EACH ROW
BEGIN
    UPDATE Böcker
    SET lagerstatus = lagerstatus - NEW.antal
    WHERE ISBN = NEW.ISBN;
END;
//

CREATE TRIGGER trg_logga_kund
AFTER INSERT ON Kunder
FOR EACH ROW
BEGIN
    INSERT INTO Kundlogg (kund_id, meddelande)
    VALUES (NEW.kund_id, 'Ny kund registrerad');
END;
//

DELIMITER ;

-- =========================
-- 9. BACKUP & RESTORE
-- =========================

-- Backup:
-- mysqldump -u root -p Bokhandel > backup.sql

-- Restore:
-- mysql -u root -p Bokhandel < backup.sql
