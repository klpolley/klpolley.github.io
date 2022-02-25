-- TABLES DOWN

DROP TABLE IF EXISTS holds
DROP TABLE IF EXISTS circulation
DROP TABLE IF EXISTS patrons
DROP TABLE IF EXISTS copies
DROP TABLE IF EXISTS music
DROP TABLE IF EXISTS instrumentations
DROP TABLE IF EXISTS languages
DROP TABLE IF EXISTS composers
DROP TABLE IF EXISTS countries
DROP TABLE IF EXISTS historical_periods

GO

-- TABLES UP

CREATE TABLE historical_periods (
    period_id INT IDENTITY NOT NULL,
    period_name VARCHAR(100) NOT NULL

    CONSTRAINT pk_period_id PRIMARY KEY (period_id)
)

INSERT INTO historical_periods (period_name) 
    VALUES ('21st Century'), ('20th Century'), ('Romantic'), ('Classical'), ('Baroque')

CREATE TABLE countries (
    country_id INT IDENTITY NOT NULL,
    country_name VARCHAR(100) NOT NULL,

    CONSTRAINT pk_country_id PRIMARY KEY (country_id)
)

INSERT INTO countries (country_name)
    VALUES ('United States'), ('Italy'), ('Germany')

CREATE TABLE composers (
    composer_id INT IDENTITY NOT NULL,
    composer_firstname VARCHAR(100) NOT NULL,
    composer_lastname VARCHAR(100) NOT NULL,
    composer_year_of_birth DATE NOT NULL,
    composer_year_of_death DATE,
    composer_period_id INT,
    composer_country_id INT,

    CONSTRAINT pk_composer_id PRIMARY KEY (composer_id),
    CONSTRAINT ck_composer_dates CHECK (composer_year_of_death > composer_year_of_birth),
    CONSTRAINT fk_composer_period_id FOREIGN KEY (composer_period_id) REFERENCES historical_periods(period_id),
    CONSTRAINT fk_composer_country_id FOREIGN KEY (composer_country_id) REFERENCES countries(country_id)
)

INSERT INTO composers
     (composer_firstname, composer_lastname, composer_year_of_birth, composer_year_of_death, composer_period_id, composer_country_id)
VALUES
    ('Regina', 'Spektor', '1980', NULL, 1, 1), --1
    ('Margaret', 'Bonds', '1913', '1972', 2, 1),  --2
    ('Barbara', 'Strozzi', '1619', '1677', 5, 2),  --3
    ('Clara', 'Schumann', '1819', '1896', 3, 3),  --4
    ('Florence', 'Price', '1887', '1953', 2, 1),  --5
    ('Emma', 'Shanley', '1998', NULL, 1, 1),  --6
    ('Elizabeth', 'Bauman', '1997', NULL, 1, 1),  --7
    ('Hannah', 'Episcopia', '2000', NULL, 1, 1), --8
    ('Michelle', 'Li', '1995', NULL, 1, 1),  --9
    ('Kelly', 'Martin', '1992', NULL, 1, 1)  --10


CREATE TABLE languages (
    language_id INT IDENTITY NOT NULL,
    language_name VARCHAR(100),

    CONSTRAINT pk_language_id PRIMARY KEY (language_id)
)

INSERT INTO languages (language_name) VALUES ('English'), ('Italian'), ('Not Applicable')

CREATE TABLE instrumentations (
    instrumentation_id INT IDENTITY NOT NULL,
    instrumentation_name VARCHAR(100) NOT NULL,

    CONSTRAINT pk_instrumentation_id PRIMARY KEY (instrumentation_id)
)

INSERT INTO instrumentations (instrumentation_name) VALUES 
    ('Voice and Piano'), ('Voice and Basso Continuo'), ('Piano and Orchestra'), ('Orchestra'), 
    ('Flute, Strings, and Percussion'), ('Orchestra and Choir'), ('Orchestra and Solo Voice'), 
    ('Orchestra, Piano, and Solo Voice'), ('Guitar and Orchestra'), ('Penny Whistle and Orchestra'), ('Strings')


CREATE TABLE music (
    music_id INT IDENTITY NOT NULL,
    music_title VARCHAR(100) NOT NULL,
    music_composer_id INT NOT NULL, 
    music_length VARCHAR(10) NOT NULL,
    music_year_completed DATE NOT NULL,
    music_year_published DATE NOT NULL,
    music_movements VARCHAR(150),
    music_language_id INT NOT NULL,
    music_author_of_text_firstname VARCHAR(100),
    music_author_of_text_lastname VARCHAR(100),
    music_instrumentation_id INT NOT NULL,

    CONSTRAINT pk_music_music_id PRIMARY KEY (music_id),
    CONSTRAINT ck_music_dates CHECK (music_year_published >= music_year_completed),
    CONSTRAINT fk_music_composer_id FOREIGN KEY (music_composer_id) REFERENCES composers(composer_id),
    CONSTRAINT fk_music_language_id FOREIGN KEY (music_language_id) REFERENCES languages(language_id),
    CONSTRAINT fk_music_instrumentation_id FOREIGN KEY (music_instrumentation_id) REFERENCES instrumentations(instrumentation_id)
)

INSERT INTO music
    (music_title, music_composer_id, music_length, music_year_completed, music_year_published, music_movements, music_language_id, music_author_of_text_firstname, music_author_of_text_lastname, music_instrumentation_id)
VALUES
    ('Fidelity', 1, '3:48', '2006', '2006', NULL, 1, 'Regina', 'Spektor', 1),
    ('Three Dream Portraits', 2, '6:15', '1959', '1959', '1. Minstrel Man; 2. Dream Variation; 3. I, Too', 1, 'Langston', 'Hughes', 1),
    ('Sino alla morte', 3, '14:00', '1659', '1659', NULL, 2, 'Sebastiano', 'Baldini', 2),
    ('Piano Concerto in A Minor', 4, '23:00', '1835', '1836', '1. Allegro maestoso; 2. Romanze: Andante non troppo con grazia; 3. Finale: Allegro non troppo – Allegro molto', 3, NULL, NULL, 3),
    ('Symphony No. 4 in D Minor', 5, '32:00', '1945', '2018', '1. Tempo moderato; 2. Andante cantabile; 3. Allegro: Juba; 4. Scherzo', 3, NULL, NULL, 4),
    ('A Season Passed', 6, '3:00', '2018', '2018', NULL, 3, NULL, NULL, 5),
    ('Aurora', 9, '4:00', '2016', '2016', NULL, 1, NULL, NULL, 6),
    ('Forgotten in the Storm', 6, '3:00', '2019', '2019', NULL, 3, NULL, NULL, 4),
    ('Guardian Angel', 10, '6:20', '2017', '2017', NULL, 1, 'Kelly', 'Martin', 7),  
    ('Hiraeth', 9, '2:45', '2015', '2015', NULL, 3, NULL, NULL, 3),
    ('Long Way Home', 9, '6:00', '2016', '2016', NULL, 3, NULL, NULL, 4),
    ('L.O.T.I.S.', 6, '3:20', '2017', '2017', NULL, 3, NULL, NULL, 4),
    ('maybe', 9, '2:45', '2017', '2017', NULL, 1, 'Michelle', 'Li', 8),
    ('Misguided Compass', 8, '3:20', '2019', '2019', NULL, 3, NULL, NULL, 4),
    ('Return', 9, '4:10', '2017', '2017', NULL, 3, NULL, NULL, 9),
    ('The Irish One', 7, '2:45', '2019', '2019', NULL, 3, NULL, NULL, 10),
    ('Waltz Disney', 7, '2:00', '2018', '2018', NULL, 3, NULL, NULL, 11)

CREATE TABLE copies (
    copy_id INT IDENTITY NOT NULL,
    copy_music_id INT NOT NULL,
    copy_location VARCHAR(100),
    copy_available BINARY NOT NULL,

    CONSTRAINT pk_copy_id PRIMARY KEY (copy_id),
    CONSTRAINT fk_copy_music_id FOREIGN KEY (copy_music_id) REFERENCES music(music_id)
)

INSERT INTO copies (copy_music_id, copy_available) 
    VALUES 
(1, 1), (1, 0), (1, 1), 
(2, 1), 
(3, 0), (3, 0), 
(4, 1), (4, 0), 
(5, 1), (5, 1), (5, 1), (5, 1),
(6, 0),
(7, 1), 
(8, 1), (8, 1),
(9, 0), (9, 1),
(10, 0), (10, 0), (10, 1), (10, 1),
(11, 1), (11, 1), (11, 0), 
(12, 1), 
(13, 0), (13, 0), 
(14, 1), (14, 0), 
(15, 1), (15, 1), (15, 1), (15, 1),
(16, 0),
(17, 1)

CREATE TABLE patrons (
    patron_id INT IDENTITY NOT NULL,
    patron_firstname VARCHAR(100) NOT NULL,
    patron_lastname VARCHAR(100) NOT NULL,
    patron_email VARCHAR(50) NOT NULL,
    patron_date_of_birth DATE,
    patron_address_street VARCHAR(100),
    patron_address_city VARCHAR(100),
    patron_address_state CHAR(2),
    patron_address_zip VARCHAR(10),

    CONSTRAINT pk_patron_id PRIMARY KEY (patron_id),
    CONSTRAINT u_patron_email UNIQUE (patron_email)
)

INSERT INTO patrons
    (patron_firstname, patron_lastname, patron_email, patron_date_of_birth, patron_address_street, patron_address_city, patron_address_state, patron_address_zip)
VALUES
    ('Cardi', 'Acharest', 'flutist7@email.com', '1990-11-18', '57 Made Up Street', 'Syracuse', 'NY', '55555'),
    ('Ella', 'Minterry', 'violinist8@email.com', '1982-05-17', '68 Does Not Exist Street', 'Fayetteville', 'NY', '66666'),
    ('Russ', 'Tichens', 'tenor88@wahoo.net', '1999-08-07', '2 Imaginary Road', 'Manlius', 'NY', '77777'),
    ('Daniel', 'Davingsport', 'guitarplayer7@silly.edu', '1994-01-01', '42 Not Here Way', 'Syracuse', 'NY', '55555'),
    ('Foo', 'Bar', 'musicologist@yikes.org', '1977-07-24', '12 Fake Avenue', 'Syracuse', 'NY', '55555'),
    ('Karen', 'Splattersburg', 'soprano@dramatic.com', '1998-02-01', '208 Imaginary Street', 'Fayetteville', 'NY', '66666'),
    ('Vivian', 'Tompkins', 'musiclibrarian@email.com', '1994-11-17', '99 Nope Street', 'Syracuse', 'NY', '55555')

CREATE TABLE circulation (
    circulation_id INT IDENTITY NOT NULL,
    circ_copy_id INT NOT NULL,
    circ_patron_id INT NOT NULL,
    circ_date_checked_out DATE NOT NULL,
    circ_date_due DATE NOT NULL,
    circ_date_returned DATE,

    CONSTRAINT pk_circulation_id PRIMARY KEY (circulation_id),
    CONSTRAINT fk_circ_copy_id FOREIGN KEY (circ_copy_id) REFERENCES copies(copy_id),
    CONSTRAINT fk_circ_patron_id FOREIGN KEY (circ_patron_id) REFERENCES patrons(patron_id),
    CONSTRAINT ck_due_date CHECK (circ_date_due > circ_date_checked_out),
    CONSTRAINT ck_date_returned CHECK (circ_date_returned >= circ_date_checked_out)
)

INSERT INTO circulation
    (circ_copy_id, circ_patron_id, circ_date_checked_out, circ_date_due, circ_date_returned)
VALUES
    (1, 4, '2021-03-20', '2021-04-17', '2021-04-15'),
    (2, 1, '2021-04-25', '2021-05-23', NULL),
    (4, 5, '2021-05-01', '2021-05-29', NULL),
    (8, 2, '2021-04-20', '2021-05-18', '2021-05-03')

CREATE TABLE holds (
    hold_id INT IDENTITY NOT NULL,
    hold_copy_id INT NOT NULL,
    hold_patron_id INT NOT NULL,
    hold_date_requested DATE NOT NULL,
    hold_date_fulfilled DATE,

    CONSTRAINT pk_hold_id PRIMARY KEY (hold_id),
    CONSTRAINT fk_hold_copy_id FOREIGN KEY (hold_copy_id) REFERENCES copies(copy_id),
    CONSTRAINT fk_hold_patron_id FOREIGN KEY (hold_patron_id) REFERENCES patrons(patron_id),
)

INSERT INTO holds 
    (hold_copy_id, hold_patron_id, hold_date_requested, hold_date_fulfilled)
VALUES
    (8, 6, '2021-05-01', '2021-05-04'),
    (2, 7, '2021-04-29', NULL),
    (1, 1, '2021-03-28', NULL)

GO

-- VIEWS DOWN

DROP VIEW IF EXISTS v_music_info
DROP VIEW IF EXISTS v_circ_info
DROP VIEW IF EXISTS v_hold_info
DROP VIEW IF EXISTS v_avail_holds
DROP VIEW IF EXISTS v_avail_copies
DROP VIEW IF EXISTS v_not_avail

GO

-- VIEWS UP

CREATE VIEW v_music_info AS 
SELECT 
    music_id,
    music_title, 
    composer_firstname + ' ' + composer_lastname as composer_name,
    music_length,
    music_year_published,
    music_movements, 
    language_name,
    music_author_of_text_firstname + ' ' + music_author_of_text_lastname as author_of_text,
    instrumentation_name,
    period_name, 
    country_name
FROM music
JOIN composers ON music_composer_id = composer_id
JOIN languages ON music_language_id = language_id
JOIN instrumentations ON music_instrumentation_id = instrumentation_id
JOIN historical_periods ON composer_period_id = period_id
JOIN countries ON composer_country_id = country_id

GO

CREATE VIEW v_circ_info AS
SELECT 
    circulation_id, music_title, 
    composer_firstname + ' ' + composer_lastname AS composer_name,
    patron_firstname + ' ' + patron_lastname AS patron_name,
    circ_date_checked_out, circ_date_due, circ_date_returned
FROM circulation
JOIN copies ON circ_copy_id = copy_id
JOIN music ON copy_music_id = music_id
JOIN composers ON music_composer_id = composer_id
JOIN patrons ON circ_patron_id = patron_id

GO

CREATE VIEW v_hold_info AS
SELECT 
    hold_id, music_title, 
    composer_firstname + ' ' + composer_lastname AS composer_name,
    patron_firstname + ' ' + patron_lastname AS patron_name,
    hold_date_requested, hold_date_fulfilled
FROM holds
JOIN copies ON hold_copy_id = copy_id
JOIN music ON copy_music_id = music_id
JOIN composers ON music_composer_id = composer_id
JOIN patrons ON hold_patron_id = patron_id

GO

CREATE VIEW v_avail_holds AS
SELECT 
    hold_id, music_title, 
    composer_firstname + ' ' + composer_lastname AS composer_name,
    patron_firstname + ' ' + patron_lastname AS patron_name,
    hold_date_requested
FROM holds
JOIN copies ON hold_copy_id = copy_id
JOIN music ON copy_music_id = music_id
JOIN composers ON music_composer_id = composer_id
JOIN patrons ON hold_patron_id = patron_id
WHERE hold_date_fulfilled IS NULL
AND copy_available = 1

GO

CREATE VIEW v_avail_copies AS 
SELECT 
    copy_id,
    music_title + ', ' + composer_firstname + ' ' + composer_lastname AS music_piece
FROM copies
JOIN music ON copy_music_id = music_id
JOIN composers ON music_composer_id = composer_id
LEFT JOIN holds ON copy_id = hold_copy_id
WHERE copy_available = 1
AND hold_date_fulfilled IS NULL

GO

CREATE VIEW v_not_avail AS 
SELECT 
    copy_id,
    music_title + ', ' + composer_firstname + ' ' + composer_lastname AS music_piece
FROM copies
JOIN music ON copy_music_id = music_id
JOIN composers ON music_composer_id = composer_id
LEFT JOIN holds ON copy_id = hold_copy_id
WHERE copy_available = 0

GO

-- DOWN PROCEDURES

DROP PROCEDURE IF EXISTS dbo.p_return
DROP PROCEDURE IF EXISTS dbo.p_hold_check_out
DROP PROCEDURE IF EXISTS dbo.p_hold
DROP PROCEDURE IF EXISTS dbo.p_check_out

GO

-- UP PROCEDURES

CREATE PROCEDURE dbo.p_check_out (
    @copy_id INT,
    @patron_id INT
) AS BEGIN
    BEGIN TRY
        BEGIN TRANSACTION
            DECLARE @out DATE = GETDATE()
            DECLARE @due DATE = DATEADD(dd, 28, @out)
            UPDATE copies SET copy_available = 0 WHERE copy_id=(@copy_id)
            INSERT INTO circulation(circ_copy_id, circ_patron_id, circ_date_checked_out, circ_date_due)
                VALUES (@copy_id, @patron_id, @out, @due)
        COMMIT
    END TRY
    BEGIN CATCH
        ROLLBACK
        ;
        THROW
    END CATCH
END

GO

CREATE PROCEDURE dbo.p_hold (
    @copy_id INT,
    @patron_id INT
) AS BEGIN
    BEGIN TRY
        BEGIN TRANSACTION
            DECLARE @date DATE = GETDATE()
            INSERT INTO holds (hold_copy_id, hold_patron_id, hold_date_requested)
                VALUES (@copy_id, @patron_id, @date)
        COMMIT
    END TRY
    BEGIN CATCH
        ROLLBACK
        ;
        THROW
    END CATCH
END

GO

CREATE PROCEDURE dbo.p_hold_check_out (
    @hold_id INT
) AS BEGIN
    BEGIN TRY
        BEGIN TRANSACTION
            DECLARE @date DATE = GETDATE()
            DECLARE @copy_id INT = (SELECT hold_copy_id FROM holds WHERE hold_id = @hold_id)
            DECLARE @patron_id INT = (SELECT hold_patron_id FROM holds WHERE hold_id = @hold_id)
            UPDATE holds SET hold_date_fulfilled = @date WHERE hold_id = @hold_id
            EXECUTE p_check_out @copy_id=@copy_id, @patron_id=@patron_id
        COMMIT
    END TRY
    BEGIN CATCH
        ROLLBACK
        ;
        THROW
    END CATCH
END

GO

CREATE PROCEDURE dbo.p_return (
    @circ_id INT
) AS BEGIN
    BEGIN TRY
        BEGIN TRANSACTION
            DECLARE @in DATE = GETDATE()
            DECLARE @copy_id INT = (SELECT circ_copy_id FROM circulation WHERE circulation_id = @circ_id)
            UPDATE copies SET copy_available = 1 WHERE copy_id=(@copy_id)
            UPDATE circulation SET circ_date_returned = @in WHERE circulation_id = @circ_id
        COMMIT
    END TRY
    BEGIN CATCH
        ROLLBACK
        ;
        THROW
    END CATCH
END

GO
