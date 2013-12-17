--2. ������
--������� ������ ��������� ��������� �������: ������������ � ����� ������� �� ����� �������� ��������� ������ (������ �����-�� ����� �� ������� ����� ���� �� ���������� �� ������ �����).
--��� � ��� ���������� ��������� ������� �������. ��������������� ������� - ���� ����� �� ����� ������������ �������� � ����������� �������� (�� ��������� ����� ����� �� �������� �� � ����� �������)
CREATE OR REPLACE TRIGGER NoMoreThanOneHorse
    BEFORE INSERT OR UPDATE OF Jockey_ID
    ON Horses
    FOR EACH ROW
DECLARE
    NumOfHorsesForJockey NUMBER(4);
BEGIN
    SELECT COUNT(*) INTO NumOfHorsesForJockey FROM Horses
        WHERE Jockey_ID = :NEW.Jockey_ID AND Horse_ID <> :NEW.Horse_ID;
    IF NumOfHorsesForJockey > 0
        THEN RAISE_APPLICATION_ERROR (-20445, '������ ��������� �� ������� ��� �������� �����!');
        END IF;
END NoMoreThanOneHorse;

--�������� (������������, ��� ������� Horses ������)
INSERT INTO Horses
    VALUES (1, 1, 1, '1', 'M', to_date('01-01-1981', 'dd-mm-yyyy'));

--�� ������ ���������
INSERT INTO Horses
    VALUES (2, 1, 1, '2', 'M', to_date('01-01-1981', 'dd-mm-yyyy'));

--���������
INSERT INTO Horses
    VALUES (2, 2, 1, '2', 'M', to_date('01-01-1981', 'dd-mm-yyyy'));

--�� ������ ���������
UPDATE Horses
    SET Jockey_ID = 2
    WHERE Horse_ID = 1;