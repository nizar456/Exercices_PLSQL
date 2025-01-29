create table agence(code_agence int primary key,
    nom varchar(20) not null ,
    ville varchar(20));
    
create table agent(matricule varchar(20) primary key,
    nom varchar(20) not null ,
    prenom varchar(20) not null ,
    salaire float,
    date_embauche date,
    code_agence int, 
    FOREIGN KEY (code_agence) REFERENCES agence(code_agence));
    
    
create table compte(num_compte INT primary key,
    solde float check(solde>100) ,
    matricule varchar(20), 
    code_agence int, 
    FOREIGN KEY (matricule) REFERENCES agent(matricule),
    FOREIGN KEY (code_agence) REFERENCES agence(code_agence));
    
begin
for i in 1..10 loop
insert into agence values(i,'agence' || i ,'ville' || i);
insert into agent values('ag' || i,'agent' || i ,'agent_prenom' || i,
i*1000, sysdate + i,i);
insert into compte values(i+100,i+200 ,'ag' || i,i);
end loop;
end;

SET SERVEROUTPUT ON;

DECLARE
   
    v_nom          VARCHAR2(20);
    v_prenom       VARCHAR2(20);
    v_salaire      FLOAT;
    v_date_embauche DATE;
    v_code_agence  INT;

    v_matricule    VARCHAR2(20);
BEGIN
    
    DBMS_OUTPUT.PUT_LINE('Entrez le matricule de l''agent :');
    v_matricule := '&matricule';

    SELECT nom, prenom, salaire, date_embauche, code_agence
    INTO v_nom, v_prenom, v_salaire, v_date_embauche, v_code_agence
    FROM agent
    WHERE matricule = v_matricule;

    DBMS_OUTPUT.PUT_LINE('Informations de l''agent :');
    DBMS_OUTPUT.PUT_LINE('Nom           : ' || v_nom);
    DBMS_OUTPUT.PUT_LINE('Prénom        : ' || v_prenom);
    DBMS_OUTPUT.PUT_LINE('Salaire       : ' || v_salaire);
    DBMS_OUTPUT.PUT_LINE('Date Embauche : ' || TO_CHAR(v_date_embauche, 'DD-MM-YYYY'));
    DBMS_OUTPUT.PUT_LINE('Code Agence   : ' || v_code_agence);

END;

SET SERVEROUTPUT ON;
DECLARE
    
    v_salaire       FLOAT;
    v_matricule     VARCHAR2(20);
    v_etat_agent    VARCHAR2(50);

BEGIN
    
    DBMS_OUTPUT.PUT_LINE('Entrez le matricule de l''agent :');
    v_matricule := '&matricule';

    SELECT salaire
    INTO v_salaire
    FROM agent
    WHERE matricule = v_matricule;

    IF v_salaire BETWEEN 2000 AND 3000 THEN
        v_etat_agent := 'Agent ouvrier';
    ELSIF v_salaire > 3000 AND v_salaire <= 8000 THEN
        v_etat_agent := 'Agent personnel';
    ELSIF v_salaire > 6000 THEN
        v_etat_agent := 'Agent Responsable';
    ELSE
        v_etat_agent := 
        'Salaire non défini pour un état valide';
    END IF;

    DBMS_OUTPUT.PUT_LINE
    ('L''état de l''agent avec le matricule ' 
    || v_matricule || ' est : ' || v_etat_agent);

END;

SET SERVEROUTPUT ON;

DECLARE

    v_salaire       FLOAT;
    v_matricule     VARCHAR2(20);
    v_etat_agent    VARCHAR2(50);

BEGIN
    
    DBMS_OUTPUT.PUT_LINE('Entrez le matricule de l''agent :');
    v_matricule := '&matricule';

    SELECT salaire
    INTO v_salaire
    FROM agent
    WHERE matricule = v_matricule;

    v_etat_agent := CASE 
        WHEN v_salaire BETWEEN 2000 AND 3000 
        THEN 'Agent ouvrier'
        WHEN v_salaire > 3000 AND v_salaire <= 8000 
        THEN 'Agent personnel'
        WHEN v_salaire > 6000 
        THEN 'Agent Responsable'
        ELSE 'Salaire non défini pour un état valide'
    END;

    DBMS_OUTPUT.PUT_LINE('L''état de l''agent avec le matricule ' || v_matricule || ' est : ' || v_etat_agent);

END;

SET SERVEROUTPUT ON;

DECLARE
    CURSOR cur_agences IS
        SELECT DISTINCT a.code_agence
        FROM agence a
        JOIN agent ag ON a.code_agence = ag.code_agence
        WHERE ag.salaire < 8000;

    v_code_agence agence.code_agence%TYPE;

BEGIN
    OPEN cur_agences;

    LOOP
        FETCH cur_agences INTO v_code_agence;
        
        EXIT WHEN cur_agences%NOTFOUND;
        
        DELETE FROM compte WHERE code_agence = v_code_agence;
        DELETE FROM agent WHERE code_agence = v_code_agence;
        DELETE FROM agence WHERE code_agence = v_code_agence;

        DBMS_OUTPUT.PUT_LINE
        ('Agence avec Code_Agence ' 
        || v_code_agence || ' supprimée.');
    END LOOP;

    CLOSE cur_agences;
END;

CREATE TABLE TB1 (
    Num_Compte NUMBER
);

CREATE TABLE TB2 (
    Num_Compte NUMBER
);

--9--
--jeux de donnees--
INSERT INTO agence (Code_Agence, Nom, Ville) VALUES (21, 'AgenceTest1', 'VilleTest1');
INSERT INTO agence (Code_Agence, Nom, Ville) VALUES (22, 'AgenceTest2', 'VilleTest2');
INSERT INTO agence (Code_Agence, Nom, Ville) VALUES (23, 'AgenceTest3', 'VilleTest3');

INSERT INTO agent (Matricule, Nom, Prenom, Salaire, Date_Embauche, Code_Agence) 
VALUES ('AG21', 'NomAgent21', 'PrenomAgent21', 4000, TO_DATE('2022-01-01', 'YYYY-MM-DD'), 21);

INSERT INTO agent (Matricule, Nom, Prenom, Salaire, Date_Embauche, Code_Agence) 
VALUES ('AG22', 'NomAgent22', 'PrenomAgent22', 7500, TO_DATE('2021-05-15', 'YYYY-MM-DD'), 22);

INSERT INTO agent (Matricule, Nom, Prenom, Salaire, Date_Embauche, Code_Agence) 
VALUES ('AG23', 'NomAgent23', 'PrenomAgent23', 9000, TO_DATE('2020-10-10', 'YYYY-MM-DD'), 23);

INSERT INTO compte (Num_Compte, Code_Agence, Matricule, Solde) 
VALUES (201, 21, 'AG21', 8000);

INSERT INTO compte (Num_Compte, Code_Agence, Matricule, Solde) 
VALUES (202, 22, 'AG22', 12000);

INSERT INTO compte (Num_Compte, Code_Agence, Matricule, Solde) 
VALUES (203, 23, 'AG23', 500);

--reponce--

DECLARE
    CURSOR compte_cursor IS
        SELECT Num_Compte, Solde
        FROM COMPTE;

    v_num_compte COMPTE.Num_Compte%TYPE;
    v_solde COMPTE.Solde%TYPE;

BEGIN
    OPEN compte_cursor;

    LOOP
        FETCH compte_cursor INTO v_num_compte, v_solde;
        EXIT WHEN compte_cursor%NOTFOUND;

        IF v_solde < 10000 THEN
            INSERT INTO TB1 (Num_Compte) VALUES (v_num_compte);
        ELSIF v_solde > 10000 THEN
            INSERT INTO TB2 (Num_Compte) VALUES (v_num_compte);
        END IF;
    END LOOP;

    CLOSE compte_cursor;

    DBMS_OUTPUT.PUT_LINE
    ('Insertion terminée dans TB1 et TB2.');
END;

--TEST--
SELECT * FROM TB1;

SELECT * FROM TB2;

--10--
--insertion--
INSERT INTO agent (Matricule, Nom, Prenom, Salaire, Date_Embauche, Code_Agence) 
VALUES ('AG31', 'AgentTest1', 'Prenom1', 4500, TO_DATE('2021-03-15', 'YYYY-MM-DD'), 21);

INSERT INTO agent (Matricule, Nom, Prenom, Salaire, Date_Embauche, Code_Agence) 
VALUES ('AG32', 'AgentTest2', 'Prenom2', 5000, TO_DATE('2021-07-20', 'YYYY-MM-DD'), 22);

INSERT INTO agent (Matricule, Nom, Prenom, Salaire, Date_Embauche, Code_Agence) 
VALUES ('AG33', 'AgentTest3', 'Prenom3', 6000, TO_DATE('2020-08-10', 'YYYY-MM-DD'), 23);

--solution--
DECLARE
    TYPE AgentNameTable IS TABLE OF agent.nom%TYPE INDEX BY PLS_INTEGER;
    agent_names AgentNameTable;

    v_index PLS_INTEGER := 0;
    CURSOR agent_cursor IS
        SELECT nom
        FROM agent
        WHERE EXTRACT(YEAR FROM date_embauche) = 2021; 

BEGIN
    FOR rec IN agent_cursor LOOP
        v_index := v_index + 1;               
        agent_names(v_index) := rec.nom;       
    END LOOP;

    IF agent_names.COUNT > 0 THEN
        DBMS_OUTPUT.PUT_LINE('Agents embauchés en 2021 :');
        FOR i IN 1..agent_names.COUNT LOOP
            DBMS_OUTPUT.PUT_LINE(' - ' || agent_names(i));
        END LOOP;
    ELSE
        DBMS_OUTPUT.PUT_LINE('Aucun agent embauché en 2021.');
    END IF;

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Erreur : ' || SQLERRM);
END;

---11---
CREATE TABLE Agence_Modifie (
    Code_Agence INT PRIMARY KEY,
    Nom VARCHAR(50) NOT NULL,
    Ville VARCHAR(50) NOT NULL
);


















