--5. ���� ������������ ���������
-- ������� ������ �������������� �������� ���������� � ��������, ���� � ���� ������ ���� �������� � ���������, ��������� ���� �������.
CREATE OR REPLACE TRIGGER NoSubjDelIfExamOrTest
    BEFORE DELETE OR UPDATE OF Predmet_ID, Nazvanie
    ON Uchebnyi_Predmet
    FOR EACH ROW
DECLARE
    PassedExamOrTest NUMBER(4);
BEGIN
    SELECT COUNT(*) INTO PassedExamOrTest FROM Ispytanie
        WHERE Predmet_ID = :OLD.Predmet_ID;
    IF PassedExamOrTest > 0
        THEN RAISE_APPLICATION_ERROR (-20134, '������ ������� �������, ��� ��� � ���� ���� �������� � ���������, ��������� ���');
        END IF;
END NoSubjDelIfExamOrTest;

--�������� (�� ������ ���������, ���� � ������� Ispytanie ���� ���� ���� ������)
DELETE FROM Uchebnyi_Predmet
    WHERE Predmet_ID IN (SELECT Predmet_ID
        FROM Ispytanie
        GROUP BY Predmet_ID);