


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




