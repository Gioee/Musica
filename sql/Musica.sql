CREATE DATABASE IF NOT EXISTS dbmusica
CHARACTER SET = 'utf8'
COLLATE = 'utf8_unicode_ci';

USE dbmusica;

DROP TABLE IF EXISTS brano;
CREATE TABLE brano
(
    id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    titolo VARCHAR(255) NOT NULL,
    artista VARCHAR(255) NOT NULL,
    durata VARCHAR(5) NOT NULL,
    prezzo DOUBLE(5,2) NOT NULL,
    nomemp3 VARCHAR(255) NOT NULL
);

DROP TABLE IF EXISTS utente;
CREATE TABLE utente
(
    username VARCHAR(20) NOT NULL PRIMARY KEY,
    salt VARCHAR(32) NOT NULL,
    password_hash VARCHAR(64) NOT NULL,
    cognome VARCHAR(50) NOT NULL,
    nome VARCHAR(50) NOT NULL
);

DROP PROCEDURE IF EXISTS cambiaPassword;
DELIMITER //
CREATE PROCEDURE cambiaPassword(
    param_username VARCHAR(50),
    param_pwd VARCHAR(50),
    param_pwdn VARCHAR(50)
)
    DETERMINISTIC
BEGIN
    UPDATE utente SET password_hash = SHA2(CONCAT(salt, param_pwdn), 256)
    WHERE username = param_username AND password_hash = SHA2(CONCAT(salt, param_pwd), 256);
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS nuovoUtente;
DELIMITER //
CREATE PROCEDURE nuovoUtente(
    param_username VARCHAR(20),
    param_password VARCHAR(20),
    param_cognome NVARCHAR(50),
    param_nome NVARCHAR(50)
)
    DETERMINISTIC
BEGIN
    SET @s = MD5(RAND());
    SET @h = SHA2(CONCAT(@s, param_password), 256);
    INSERT INTO utente(username, salt, password_hash, cognome, nome)
    VALUES (param_username, @s, @h, param_cognome, param_nome);
END //
DELIMITER ;
CALL nuovoUtente('demo', 'demo', 'Rossi', 'Mario');
CALL nuovoUtente('rossi', 'pwrossi', 'Rossi', 'Mario');
CALL nuovoUtente('verdi', 'pwverdi', 'Verdi', 'Carla');
CALL nuovoUtente('neri', 'pwneri', 'Neri', 'Giacomo');

INSERT INTO brano(titolo, artista, durata, prezzo, nomemp3) VALUES ('Heavydirtysoul', 'Twenty One Pilots', '3:54', '1.29', 'Twenty One Pilots - Heavydirtysoul');
INSERT INTO brano(titolo, artista, durata, prezzo, nomemp3) VALUES ('TE DESEO LO MEJOR', 'Bad Bunny', '2:19', '1.29', 'Bad Bunny - TE DESEO LO MEJOR');
INSERT INTO brano(titolo, artista, durata, prezzo, nomemp3) VALUES ('Avalanche', 'Bring Me the Horizon', '4:22', '1.29', 'Bring Me the Horizon - Avalanche');
INSERT INTO brano(titolo, artista, durata, prezzo, nomemp3) VALUES ('Il testamento di Tito', 'Fabrizio De André', '5:50', '1.29', 'Fabrizio De Andr_ - Il testamento di Tito');
INSERT INTO brano(titolo, artista, durata, prezzo, nomemp3) VALUES ('Come As You Are', 'Nirvana', '3:38', '1.29', 'Nirvana - Come As You Are');
