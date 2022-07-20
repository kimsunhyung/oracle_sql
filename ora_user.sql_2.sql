-- SELECT ��
-- P.92
-- �޿��� 5000�� �Ѵ� �����ȣ�� ����� ��ȸ
SELECT * FROM employees;
SELECT
    employee_id
    , emp_name
    , salary
FROM employees
WHERE salary < 3000
ORDER BY employee_id;

-- �޿��� 5000 �̻�, job_id, it_prog �����ȸ
SELECT employee_id
    , emp_name
    , salary
FROM employees
WHERE salary >5000
    AND job_id = 'IT_PROG'
ORDER BY employee_id;

-- ���̺� ��Ī �� �� ����
SELECT
-- a���̺��� ��
    a.employee_id
    , a.emp_name
    , a.department_id
    , b.department_name
-- b���̺��� ��
FROM
    employees a,
    departments b
WHERE a.department_id =  b.department_id;

-- insert �� & updated ��
-- 4���� ��������

-- p101
-- merge, �����͸� ��ġ�ų� �߰�
-- ������ ���ؼ� ���̺� �ش� ���ǿ� �´� �����Ͱ� ������ �߰�
-- ������ UPDATE���� �߰�

CREATE TABLE ex3_3(
    employee_id NUMBER
    , bonus_amt NUMBER DEFAULT 0
);

INSERT INTO ex3_3(employee_id)
SELECT
    e.employee_id
FROM employees e, sales s
WHERE e.employee_id = s.employee_id
    AND s.SALES_MONTH BETWEEN '200010' AND '200012'
GROUP BY e.employee_id;

SELECT*FROM ex3_3 ORDER BY employee_id;

-- 103p

SELECT employee_id
    , manager_id
    , salary
    , salary * 0.01
FroM employees
WHERE employee_id IN(SELECT employee_id FROM ex3_3);

SELECT employee_id
    , manager_id
    , salary
    , salary * 0.001
FroM employees
WHERE employee_id NOT IN(SELECT employee_id FROM ex3_3)
    AND manager_id = 146;
    
-- MERGE �� ���� �ۼ�
-- ������ ��� 146�� �� ��, ex3_3 ���̺� ����
-- ����� ���, ������ ���, �޿�, �޿�*0.001 .��ȸ
-- ex3_3 ���̺��� 160�� ����� ���ʽ� �ݾ� 7.5�� �ű� �Է�

SELECT*FROM ex3_3;
-- �������� ���� : ���� ���� �ȿ� �߰��� ����
-- UPDATE & INSERT ����
-- �ΰ��� �����͸� ����
MERGE INTO ex3_3 d 
    USING (SELECT employee_id, salary, manager_id
                  FROM employees 
                  WHERE manager_id = 146) b
    ON (d.employee_id = b.employee_id)
WHEN MATCHED THEN 
    UPDATE SET d.bonus_amt = d.bonus_amt + b.salary * 0.01 
    -- DELETE WHERE(b.employee_id = 161) �����͸� ��������
WHEN NOT MATCHED THEN
    INSERT (d.employee_id, d.bonus_amt) VALUES (b.employee_id, b.salary * .001)
    WHERE (b.salary < 8000);
    
SELECT * FROM ex3_3 ORDER BY employee_id;

-- p.106
-- ���̺� ����
DELETE ex3_3;
SELECT*FROM ex3_3 ORDER BY employee_id;

-- p.107
-- commit & rollback : �����ڵ鿡�� ���� �߿��ϴ�!
-- commit : ������ �����͸� �����ͺ��̽��� ���������� �ݿ�
-- rollback : ������ �����͸� �����ϱ� ���� ���·� ����

CREATE TABLE ex3_4(
    employee_id NUMBER
);

INSERT INTO ex3_4 VALUES(100);

commit;

-- P.109
TRUNCATE TABLE ex3_4

-- p.110
SELECT 
    ROWNUM, employee_id
FROM employees
WHERE ROWNUM <5;

-- ROWID, �ּҰ�
-- DBA, DB�𵨸� (�����ӵ� ����, Ư��)
SELECT
    ROWNUM
    , employee_id
    , ROWID
FROM employees
WHERE ROWNUM<5;

-- ������
-- operator ���� ����
-- ���� ������ & ���� ������
-- || �� ���ڸ� ���̴� ������
SELECT
    employee_id||'-'||emp_name AS employee_info
FROM employees
WHERE ROWNUM < 5;

-- ǥ����
-- ���ǹ�, IF ���ǹ� (PL/SQL)
-- CASE ǥ����
SELECT
    employee_id
    , salary
    , CASE WHEN salary <= 5000 THEN 'C���'
        WHEN salary >5000 AND salary <=15000 THEN 'B���'
        ELSE 'A���'
     END AS salary_grade
FROM employees;

-- ���ǽ�
-- TRUE, FALSE, UNKNOWN ������ Ÿ������ ��ȯ
-- �� ���ǽ�
-- �м�, DB ������ �����, �������� ���\

SELECT
    employee_id
    , salary
FROM employees
WHERE salary = ANY(2000,3000,4000)
ORDER BY employee_id;

-- ANY --> OR ������ ��ȯ
SELECT
    employee_id
    , salary
FROM employees
WHERE salary = 2000 OR salary = 3000 OR salary = 4000
ORDER BY employee_id; -- �ʹ� �� �����͸� �����ϱ� �����

-- ALL
SELECT
    employee_id
    , salary
FROM employees
WHERE salary = All(2000,3000,4000)
ORDER BY employee_id;

-- SOME
SELECT
    employee_id
    , salary
FROM employees
WHERE salary = SOME(2000,3000,4000)
ORDER BY employee_id;

-- NOT ���ǽ�
SELECT
    employee_id
    , salary
FROM employees
WHERE NOT(salary >=2500)
ORDER BY employee_id;

-- NULL ���ǽ�

-- IN ���ǽ�
-- �������� ����� ���� ���Ե� ���� ��ȯ�ϴµ� �տ��� ����� ANT

SELECT
 employee_id
 , salary
FROM employees
WHERE salary IN(2000,3000,4000)
ORDER BY employee_id;

SELECT
 employee_id
 , salary
FROM employees
WHERE salary NOT IN(2000,3000,4000)
ORDER BY employee_id;

-- EXIST ���ǽ�
-- ���������� �� �� ����
-- ��ī���������
-- �����ڵ� �ڵ��׽�Ʈ ����(�˰���)/�������/�ӿ�����
-- �м�����,sql/ �м�����/ 

-- LIKE ����
-- ���ڿ��� �������� �˻��ؼ� ����ϴ� ���ǽ�
SELECT
    emp_name
FROM employees
WHERE emp_name LIKE '%__A__%'
ORDER BY emp_name;

SELECT
    emp_name
FROM employees
WHERE emp_name LIKE 'Al%'
ORDER BY emp_name;

-- 4�� ���� �Լ�
-- P.126
SELECT ABS(10), ABS(-10), ABS(-10.123)
FROM DUAL;
-- ���� ��ȯ
-- �ø�
SELECT CEIL(10.123),CEIL(10.541), CEIL (11.001)
FROM DUAL
-- ����
SELECT FLOOR(10.123),FLOOR(10.541), FLOOR (11.001)
FROM DUAL
 
-- �ݿø�
SELECT ROUND(10.123,2),ROUND(10.541,2), ROUND (11.001,2)
FROM DUAL

-- TRUNC
-- �ݿø� ����. �Ҽ��� ����. �ڸ��� ���� ����
SELECT TRUNC(115.155),TRUNC(115.155,1),TRUNC(115.155,2),TRUNC(115.155,-2)
    FROM DUAL;
    
-- POWER
-- POWER �Լ�, SQRT
SELECT POWER(3,2), POWER(3,3), POWER(3,3.001)
FROM DUAL;

-- ������
SELECT SQRT(2), SQRT(5), SQRT(9)
FROM DUAL;

-- ���� : SQL,DB ���� �ڷḦ ��ȸ�ϴ� ��
-- ���� : SQL --> ����& ��� ����ó�� ��ȭ
-- ����Ŭ 19C\

-- �Լ��� ���� ������ �� ��ȯ
SELECT MOD(19,4),MOD(19.123,4.2)
    FROM DUAL;
    
-- ���ڿ� ������ ��ó��
-- ���ӻ�
-- ä�� --> ���� ������
-- �ؽ�Ʈ ������ (��, ����Ŭ����)
-- 100GB / RAM 32GB, 64GB

SELECT INITCAP('never say goodbye'), INITCAP('never6say*good��bye')
FROM DUAL;

-- LOWER �Լ�
-- �ް������� ���ƿ��� ���ڸ� ��� �ҹ��ڷ� UPPDER �Լ��� �빮�ڷ� ��ȯ
SELECT LOWER('NEVER SAY GOODBYE'), UPPER('never say goodbye')
FROM DUAL;

-- CONCAT || �����ڿ� ���
SELECT CONCAT('I Have', 'A Dream'),'I Have'||'A Dream'
FROM DUAL;
 
-- SUBSTR
-- ���ڿ� ������
SELECT SUBSTR('ABCDEFG',1,4), SUBSTR('ABCDEFG',-1,4)
FROM DUAL;
-- ���ڸ� 1���� 3bYTE �� �ν� (����� 2Byte�� �ν�)
SELECT SUBSTRB('ABCDEFG',1,4), SUBSTRB('�����ٶ󸶹ٻ�',1,4)
FROM DUAL;

--ltrim, rtrim
SELECT 
    LTRIM('ABCDEFGABC','ABC')
    ,RTRIM('ABCDEFGABC','ABC')
FROM DUAL;

-- LPAD, RPAD

-- ��¥ �Լ�(P.138)
SELECT SYSDATE, SYSTIMESTAMP FROM DUAL;

-- ADD_MONTHS
-- ADD_MONTHS �Լ�, �Ű������� ���� ��¥, integer ��ŭ ���� ����
SELECT ADD_MONTHS(SYSDATE,1)FROM DUAL;

SELECT MONTHS_BETWEEN(SYSDATE,ADD_MONTHS(SYSDATE,1))mon1
FROM DUAL;

-- LAST_DATE : �ش���� ������ ����
SELECT LAST_DAY(SYSDATE)FROM DUAL;

-- ROUND, TRUNC �� ��¥�� ������ �ݿø��� ��¥, �߶� ��¥�� ��ȯ

-- NEXT_DAY
SELECT NEXT_DAY(SYSDATE,'�ݿ���')
FROM DUAL;

-- P.141 ��ȯ�Լ�
-- TO_CHAR(���� Ȥ�� ����, FORMAT)
SELECT TO_CHAR(123456789, '999,999,999')
FROM DUAL;

SELECT TO_CHAR(SYSDATE,'D')FROM DUAL;

-- ���ڸ� ���ڷ� ��ȯ
SELECT TO_NUMBER('123456')
FROM DUAL;

-- NULL ���� �Լ� �߿�!!!!!!!
SELECT manager_id, employee_id FROM employees;

-- NVL: ǥ���� 1�� NULL�϶�, ǥ���� 2�� ��ȯ��.
SELECT NVL(manager_id, employee_id)
FROM employees
WHERE manager_id IS NULL;

-- NVL2 ǥ���� 1�� NULL�� �ƴϸ� ǥ���� 2 ���
--      ǥ���� 2�� NULL�̸� ǥ���� 3�� ���
SELECT employee_id,commission_pct,salary FROM employees;

SELECT employee_id
                , salary
                , commission_pct
                , NVL2(commission_pct, salary + (salary * commission_pct), salary) AS salary2
FROM employees
WHERE employee_id IN (118, 179);

-- COALESCE(expr1,expr2)
-- �Ű������� ������ ǥ���Ŀ��� null�� �ƴ� ù��° ǥ���� ��ȯ
SELECT
    employee_id
    ,salary
    ,commission_pct
    ,COALESCE(salary * commission_pct, salary) as salary2
FROM employees;

-- DECODE
-- IF-ELIF-ELIF-ELIF-ELSE
SELECT * FROM sales;

SELECT prod_id
    ,DECODE(channel_id, 3, 'Direct',
                        9, 'Direct',
                        5, 'Indirect',
                        4, 'Indirect',
                           'Other') decodes
FROM sales
WHERE rownum<10;