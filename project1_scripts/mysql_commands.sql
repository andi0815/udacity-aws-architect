SHOW DATABASES;
USE udacity;
SHOW TABLES;
CREATE TABLE COURSES( TITLE CHAR(100) NOT NULL, PARTICIPANTS INT);
INSERT INTO COURSES ( TITLE, PARTICIPANTS) VALUES ("Udacity AWS Architect", "22");
INSERT INTO COURSES ( TITLE, PARTICIPANTS) VALUES ("Udacity AWS Devops", 15);
INSERT INTO COURSES ( TITLE, PARTICIPANTS) VALUES ("AI for beginners", 150);
SELECT * FROM COURSES WHERE PARTICIPANTS > 10;

INSERT INTO COURSES ( TITLE, PARTICIPANTS) VALUES ("Foo Bar", 1122);