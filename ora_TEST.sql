-- SQL �������� ��������
-- ���� 1. 2015�� ��� �������� ���� ��� ������ ��ȸ�ϼ���.
-- ���̺�� : populations
SELECT LIFE_EXPECTANCY
    , POP_ID
    , YEAR
FROM populations
WHERE YEAR IN '2015'
    AND AVG(LIFE_EXPECTANCY) < LIFE_EXPECTACY 

    

-- ���� 2. subquery_countries ���̺� �ִ� capital�� 
-- ��Ī�Ǵ� cities ���̺��� ������ ��ȸ�ϼ���. 
-- ��ȸ�� �÷����� name, country_code, urbanarea_pop


-- ���� 3. 
-- ���� 1. economies ���̺��� country code, inflation rate, unemployment rate�� ��ȸ�Ѵ�.
-- ���� 2. inflation rate ������������ �����Ѵ�.
-- ���� 3. subquery_countries ���̺� gov_form �÷����� Constitutional Monarchy �Ǵ� `Republic`�� �� ������ �����Ѵ�.
-- Select fields
-- �����ͼ�


-- ���� 4. 2010�� �� ����� inflation_rate�� ���� ���� ������ inflation_rate�� ���ϼ���. 
-- ��Ʈ 1. �Ʒ� ���� ����
SELECT country_name, continent, inflation_rate
  FROM subquery_countries 
  	INNER JOIN economies
    USING (code)
WHERE year = 2010;
-- �� ����� inflation_rate�� ���� ���� ���� �����ϴ� �ڵ带 �ۼ��Ѵ�. 


-- SQL ������ �Լ� ��������
-- ���� 1. �� �࿡ ���ڸ� 1, 2, 3, ..., ���·� �߰��Ѵ�. (row_n ���� ǥ��)
-- row_n �������� ������������ ���
-- ���̺�� alias�� �����Ѵ�. 


-- ���� 2. �ø��� �⵵�� �������� ������� �ۼ��� �Ѵ�. 
-- ��Ʈ : ���������� ������ �Լ��� �̿��Ѵ�. 


-- ���� 3. 
-- (1) WITH �� ����Ͽ� �� ��������� ȹ���� �޴� ������ ������������ �����ϵ��� �մϴ�. 
-- (2) (1) ������ Ȱ���Ͽ� �׸��� �������� ��ŷ�� �߰��Ѵ�. 
-- ���� 5���� ���� : OFFSET 0 ROWS FETCH NEXT 5 ROWS ONLY
-- WITH AS (1�� ����)
-- 2�� ����



-- ���� 4
-- ���������� �����Ѵ�. 
-- ���� 69KG ���� ��⿡�� �ų� �ݸ޴޸���Ʈ ��ȸ�ϵ��� �մϴ�. 
SELECT
    Year,
    Country AS champion
  FROM summer_medals
  WHERE
    Discipline = 'Weightlifting' AND
    Event = '69KG' AND
    Gender = 'Men' AND
    Medal = 'Gold';
    
-- ���� �������� �ų� ���⵵ è�Ǿ� ���� ��ȸ�ϵ��� �մϴ�.
-- LAG & WITH �� ���