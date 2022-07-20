-- SELECT 문
-- P.92
-- 급여가 5000이 넘는 사원번호와 사원명 조회
SELECT * FROM employees;
SELECT
    employee_id
    , emp_name
    , salary
FROM employees
WHERE salary < 3000
ORDER BY employee_id;

-- 급여가 5000 이상, job_id, it_prog 사원조회
SELECT employee_id
    , emp_name
    , salary
FROM employees
WHERE salary >5000
    AND job_id = 'IT_PROG'
ORDER BY employee_id;

-- 테이블에 별칭 줄 수 있음
SELECT
-- a테이블에서 옴
    a.employee_id
    , a.emp_name
    , a.department_id
    , b.department_name
-- b테이블에서 옴
FROM
    employees a,
    departments b
WHERE a.department_id =  b.department_id;

-- insert 문 & updated 문
-- 4교시 개별진행

-- p101
-- merge, 데이터를 합치거나 추가
-- 조건을 비교해서 테이블에 해당 조건에 맞는 데이터가 없으면 추가
-- 있으면 UPDATE문을 추가

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
    
-- MERGE 를 통해 작성
-- 관리자 사번 146인 것 중, ex3_3 테이블에 없는
-- 사원의 사번, 관리자 사번, 급여, 급여*0.001 .조회
-- ex3_3 테이블의 160번 사원의 보너스 금액 7.5로 신규 입력

SELECT*FROM ex3_3;
-- 서브퀴리 개념 : 메인 퀄리 안에 추가된 쿼리
-- UPDATE & INSERT 구문
-- 두개의 데이터를 병합
MERGE INTO ex3_3 d 
    USING (SELECT employee_id, salary, manager_id
                  FROM employees 
                  WHERE manager_id = 146) b
    ON (d.employee_id = b.employee_id)
WHEN MATCHED THEN 
    UPDATE SET d.bonus_amt = d.bonus_amt + b.salary * 0.01 
    -- DELETE WHERE(b.employee_id = 161) 데이터를 제거해줌
WHEN NOT MATCHED THEN
    INSERT (d.employee_id, d.bonus_amt) VALUES (b.employee_id, b.salary * .001)
    WHERE (b.salary < 8000);
    
SELECT * FROM ex3_3 ORDER BY employee_id;

-- p.106
-- 테이블 삭제
DELETE ex3_3;
SELECT*FROM ex3_3 ORDER BY employee_id;

-- p.107
-- commit & rollback : 개발자들에게 가장 중요하다!
-- commit : 변경한 데이터를 데이터베이스에 마지막으로 반영
-- rollback : 변경한 데이터를 변경하기 이전 상태로 돌림

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

-- ROWID, 주소값
-- DBA, DB모델링 (쿼리속도 측정, 특성)
SELECT
    ROWNUM
    , employee_id
    , ROWID
FROM employees
WHERE ROWNUM<5;

-- 연산자
-- operator 연산 수행
-- 수식 연산자 & 문자 연산자
-- || 두 문자를 붙이는 연산자
SELECT
    employee_id||'-'||emp_name AS employee_info
FROM employees
WHERE ROWNUM < 5;

-- 표현식
-- 조건문, IF 조건문 (PL/SQL)
-- CASE 표현식
SELECT
    employee_id
    , salary
    , CASE WHEN salary <= 5000 THEN 'C등급'
        WHEN salary >5000 AND salary <=15000 THEN 'B등급'
        ELSE 'A등급'
     END AS salary_grade
FROM employees;

-- 조건식
-- TRUE, FALSE, UNKNOWN 세가지 타입으로 반환
-- 비교 조건식
-- 분석, DB 데이터 추출시, 서브쿼리 사용\

SELECT
    employee_id
    , salary
FROM employees
WHERE salary = ANY(2000,3000,4000)
ORDER BY employee_id;

-- ANY --> OR 연산자 변환
SELECT
    employee_id
    , salary
FROM employees
WHERE salary = 2000 OR salary = 3000 OR salary = 4000
ORDER BY employee_id; -- 너무 길어서 데이터를 가공하기 어려움

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

-- NOT 조건식
SELECT
    employee_id
    , salary
FROM employees
WHERE NOT(salary >=2500)
ORDER BY employee_id;

-- NULL 조건식

-- IN 조건식
-- 조건절에 명시한 값이 포함된 건을 반환하는데 앞에서 배웠던 ANT

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

-- EXIST 조건식
-- 서브쿼리만 올 수 있음
-- 네카라쿠배토당야
-- 개발자들 코딩테스트 진행(알고리즘)/기술면접/임원면접
-- 분석가들,sql/ 분석과제/ 

-- LIKE 조건
-- 문자열을 패턴으로 검색해서 사용하는 조건식
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

-- 4장 숫자 함수
-- P.126
SELECT ABS(10), ABS(-10), ABS(-10.123)
FROM DUAL;
-- 정수 반환
-- 올림
SELECT CEIL(10.123),CEIL(10.541), CEIL (11.001)
FROM DUAL
-- 내림
SELECT FLOOR(10.123),FLOOR(10.541), FLOOR (11.001)
FROM DUAL
 
-- 반올림
SELECT ROUND(10.123,2),ROUND(10.541,2), ROUND (11.001,2)
FROM DUAL

-- TRUNC
-- 반올림 안함. 소수점 질삭. 자리수 지정 가능
SELECT TRUNC(115.155),TRUNC(115.155,1),TRUNC(115.155,2),TRUNC(115.155,-2)
    FROM DUAL;
    
-- POWER
-- POWER 함수, SQRT
SELECT POWER(3,2), POWER(3,3), POWER(3,3.001)
FROM DUAL;

-- 제곱근
SELECT SQRT(2), SQRT(5), SQRT(9)
FROM DUAL;

-- 과거 : SQL,DB 에서 자료를 조회하는 용
-- 현재 : SQL --> 수학& 통계 도구처럼 진화
-- 오라클 19C\

-- 함수를 나눈 나머지 값 반환
SELECT MOD(19,4),MOD(19.123,4.2)
    FROM DUAL;
    
-- 문자열 데이터 전처리
-- 게임사
-- 채팅 --> 문자 데이터
-- 텍스트 마이팅 (빈도, 워드클라우드)
-- 100GB / RAM 32GB, 64GB

SELECT INITCAP('never say goodbye'), INITCAP('never6say*good가bye')
FROM DUAL;

-- LOWER 함수
-- 메가변수로 돌아오는 문자를 모두 소문자로 UPPDER 함수는 대문자로 반환
SELECT LOWER('NEVER SAY GOODBYE'), UPPER('never say goodbye')
FROM DUAL;

-- CONCAT || 연산자와 비슷
SELECT CONCAT('I Have', 'A Dream'),'I Have'||'A Dream'
FROM DUAL;
 
-- SUBSTR
-- 문자열 가르기
SELECT SUBSTR('ABCDEFG',1,4), SUBSTR('ABCDEFG',-1,4)
FROM DUAL;
-- 글자를 1개당 3bYTE 씩 인식 (교재는 2Byte씩 인식)
SELECT SUBSTRB('ABCDEFG',1,4), SUBSTRB('가나다라마바사',1,4)
FROM DUAL;

--ltrim, rtrim
SELECT 
    LTRIM('ABCDEFGABC','ABC')
    ,RTRIM('ABCDEFGABC','ABC')
FROM DUAL;

-- LPAD, RPAD

-- 날짜 함수(P.138)
SELECT SYSDATE, SYSTIMESTAMP FROM DUAL;

-- ADD_MONTHS
-- ADD_MONTHS 함수, 매개변수로 들어온 날짜, integer 만큼 월을 더함
SELECT ADD_MONTHS(SYSDATE,1)FROM DUAL;

SELECT MONTHS_BETWEEN(SYSDATE,ADD_MONTHS(SYSDATE,1))mon1
FROM DUAL;

-- LAST_DATE : 해당월의 마지막 일자
SELECT LAST_DAY(SYSDATE)FROM DUAL;

-- ROUND, TRUNC 에 날짜를 넣으면 반올림한 날짜, 잘라낸 날짜를 반환

-- NEXT_DAY
SELECT NEXT_DAY(SYSDATE,'금요일')
FROM DUAL;

-- P.141 변환함수
-- TO_CHAR(숫자 혹은 날씨, FORMAT)
SELECT TO_CHAR(123456789, '999,999,999')
FROM DUAL;

SELECT TO_CHAR(SYSDATE,'D')FROM DUAL;

-- 문자를 숫자로 변환
SELECT TO_NUMBER('123456')
FROM DUAL;

-- NULL 관련 함수 중요!!!!!!!
SELECT manager_id, employee_id FROM employees;

-- NVL: 표현식 1이 NULL일때, 표현식 2를 반환함.
SELECT NVL(manager_id, employee_id)
FROM employees
WHERE manager_id IS NULL;

-- NVL2 표현식 1이 NULL이 아니면 표현식 2 출력
--      표현식 2가 NULL이면 표현식 3을 출력
SELECT employee_id,commission_pct,salary FROM employees;

SELECT employee_id
                , salary
                , commission_pct
                , NVL2(commission_pct, salary + (salary * commission_pct), salary) AS salary2
FROM employees
WHERE employee_id IN (118, 179);

-- COALESCE(expr1,expr2)
-- 매개변수로 들어오는 표현식에서 null이 아닌 첫번째 표현식 반환
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