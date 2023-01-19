DROP DATABASE IF EXISTS practiques;
CREATE DATABASE IF NOT EXISTS practiques;
USE practiques;

CREATE TABLE IF NOT EXISTS homologacio (
	id INT NOT NULL AUTO_INCREMENT,
    	homologada_per_FCT BIT NOT NULL,
    	homologada_per_DUAL BIT NOT NULL,
	PRIMARY KEY (id)
	);

CREATE TABLE IF NOT EXISTS empresa (
	id INT NOT NULL AUTO_INCREMENT,
	nom VARCHAR(50) NOT NULL,
	adreça VARCHAR(50) NOT NULL,
	telefon NUMERIC NULL,
    	email VARCHAR(50) NOT NULL,
	PRIMARY KEY (id),
	FOREIGN KEY (id) REFERENCES homologacio(id)
	);

CREATE TABLE IF NOT EXISTS tutor (
	id INT NOT NULL AUTO_INCREMENT,
	nom VARCHAR(50) NOT NULL,
	cognoms VARCHAR(50) NOT NULL,
	data_de_naixement DATE NOT NULL,
	email VARCHAR(50) NOT NULL,
    	telefon NUMERIC NOT NULL,
	PRIMARY KEY (id)
	);

CREATE TABLE IF NOT EXISTS tipus_tutor (
	id INT NOT NULL AUTO_INCREMENT,
	tutor VARCHAR(50) NOT NULL,
	PRIMARY KEY (id),
	FOREIGN KEY (id) REFERENCES tutor(id)
	);

CREATE TABLE IF NOT EXISTS cicle_formatiu (
	id INT NOT NULL AUTO_INCREMENT,
	nom_cicle VARCHAR(50) NOT NULL,
	PRIMARY KEY (id)
	);

CREATE TABLE IF NOT EXISTS curs (
	id INT NOT NULL AUTO_INCREMENT,
	nom_curs VARCHAR(50) NOT NULL,
	PRIMARY KEY (id),
	FOREIGN KEY (id) REFERENCES cicle_formatiu(id)
	);


CREATE TABLE IF NOT EXISTS qualificacio (
	id INT NOT NULL AUTO_INCREMENT,
	nota VARCHAR(50) NOT NULL,
	PRIMARY KEY (id)
	);

CREATE TABLE IF NOT EXISTS exempcio (
	id INT NOT NULL AUTO_INCREMENT,
	tipus_exempcio VARCHAR(50) NOT NULL,
	PRIMARY KEY (id)
	);


CREATE TABLE IF NOT EXISTS alumne (
	id INT NOT NULL AUTO_INCREMENT,
	nom VARCHAR(50) NOT NULL,
	cognoms VARCHAR(50) NOT NULL,
	data_de_naixement DATE NOT NULL,
	email VARCHAR(50) NOT NULL,
    	telefon NUMERIC NOT NULL,
    	cicle_formatiu VARCHAR(50) NOT NULL,
    	curs VARCHAR(50) NOT NULL,
	PRIMARY KEY (id),
	FOREIGN KEY (id) REFERENCES empresa(id),
	FOREIGN KEY (id) REFERENCES tutor(id),
	FOREIGN KEY (id) REFERENCES cicle_formatiu(id),
	FOREIGN KEY (id) REFERENCES qualificacio(id),
	FOREIGN KEY (id) REFERENCES exempcio(id)
	);

CREATE TABLE IF NOT EXISTS practiques (
	id_praciques INT NOT NULLAUTO_INCREMENT,
	id_alumne INT NOT NULL,
	id_empresa INT NOT NULL,
	id_tutor INT NOT NULL,
	data_inici DATE NOT NULL,
	data_final DATE NOT NULL,
	nombre_hores INT NOT NULL,
	id_exempcio INT NOT NULL,
	id_tutor_centre INT NOT NULL,
	id_tutor_empresa INT NOT NULL,
	PRIMARY KEY (id_praciques),
	FOREIGN KEY (id_alumne) REFERENCES alumne(id),
	FOREIGN KEY (id_empresa) REFERENCES empresa(id),
	FOREIGN KEY (id_tutor) REFERENCES tutor(id),
	FOREIGN KEY (id_exempcio) REFERENCES exempcio(id)
	FOREIGN KEY (id_tutor_centre) REFERENCES tutor(id),
	FOREIGN KEY (id_tutor) REFERENCES tutor(id)
	);


delimiter //

CREATE TRIGGER practiques_1 BEFORE INSERT ON practiques
    FOR EACH ROW
    BEGIN

	IF NEW.data_inici > NOW() THEN
	SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ERROR!!! No es poden inserir practiques amb data inici anteriors a la data actual.';
    END IF;

  END; 
//

delimiter ;


delimiter //

CREATE TRIGGER practica_2 BEFORE UPDATE ON practiques
    FOR EACH ROW
    BEGIN

	IF NEW.data_final < OLD.data_inici THEN
	SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ERROR!!! No es poden actualitzar practiques amb data de finalitzacio anteriors a la data inici.';
     END IF;

  END;
//

delimiter ;


delimiter //

CREATE TRIGGER practica_3 BEFORE DELETE ON practiques
    FOR EACH ROW
    BEGIN
    	IF OLD.data_final < OLD.data_inici THEN
    	SIGNAL SQLSTATE '45000' SET message_text = 'ERROR!!! No es poden eliminar practiques que siguin única referencia a alumnes o empreses.';
    END IF;

  END; 
//

delimiter ;







