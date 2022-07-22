-- 기본집계함수
SELECT count(*) FROM employees;

SELECT count(employee_id) FROM employees;

---- NULL은 카운트 하지 않음
SELECT count(department_id) FROM employees;

---- 유일한 값만 조회됨
SELECT count(DISTINCT department_id)
FROM employees;

---- 정렬
SELECT DISTINCT department_id
FROM employees
order by 1;


-- p.154 기초 통계량
----합계, 평균, 최소, 최대, 분산, 표준편차
---- SQL --> 통계도구 & 머신러닝, 데이터 과학도구로 변환

SELECT SUM(salary)
FROM employees;

SELECT SUM(salary), SUM(DISTINCT salary)
FROM employees;

---- 평균값
SELECT AVG(salary), AVG(DISTINCT salary)
FROM employees;

---- 최대값, 최소값
SELECT MIN(salary), MAX(salary)
FROM employees;

SELECT MIN(DISTINCT salary), MAX(DISTINCT salary)
FROM employees;

---- 분산 및 표준편차
SELECT VARIANCE(salary), STDDEV(salary)
FROM employees;

---- GROUP BY, HAVING
---- 그전까지는 전체 데이터를 기준으로 집계
SELECT
    department_id
    ,SUM(salary)
FROM employees
GROUP BY department_id
ORDER BY department_id;

SELECT*
FROM kor_loan_status;--가계대출 단위 십억
SELECT 
    period
    , region
    , SUM(loan_jan_amt)totl_jan
FROM kor_loan_status
WHERE period LIKE '2013%'
GROUP BY period, region
ORDER BY period, region;

----2013년  11월 총 잔액만 구하기

SELECT
    period
    , region
    , SUM(loan_jan_amt)totl_jan
FROM KOR_LOAN_STATUS
WHERE period = '201311'
GROUP BY region
ORDER BY region;
---- period 가 group by 에 명시될만한 컬럼이 되지 않아 오류가 남.

SELECT
    period
    , region
    , SUM(loan_jan_amt)totl_jan
FROM KOR_LOAN_STATUS
WHERE period = '201311'
GROUP BY period, region
HAVING SUM(loan_jan_amt)>100000
ORDER BY region;

---- ROLLUP, CUBE
SELECT period, gubun, SUM(loan_jan_amt)totl_jan
FROM kor_loan_status
WHERE period LIKE '2013%'
GROUP BY period, gubun
ORDER BY period;
---- ROLLUP 추가적인 집계 정보를 순차적으로 반환
SELECT period, gubun, SUM(loan_jan_amt)totl_jan
FROM kor_loan_status
WHERE period LIKE '2013%'
GROUP BY ROLLUP(period, gubun);
---- CUBE 조합별로 집계한 정보를 반환
SELECT period, gubun, SUM(loan_jan_amt)totl_jan
FROM kor_loan_status
WHERE period LIKE '2013%'
GROUP BY CUBE(period, gubun);
---- 위치가 달라질 때마다 반환되는 값이 다름

---- 집합연산자
CREATE TABLE exp_goods_asia (
           country VARCHAR2(10),
           seq     NUMBER,
           goods   VARCHAR2(80));

    INSERT INTO exp_goods_asia VALUES ('한국', 1, '원유제외 석유류');
    INSERT INTO exp_goods_asia VALUES ('한국', 2, '자동차');
    INSERT INTO exp_goods_asia VALUES ('한국', 3, '전자집적회로');
    INSERT INTO exp_goods_asia VALUES ('한국', 4, '선박');
    INSERT INTO exp_goods_asia VALUES ('한국', 5,  'LCD');
    INSERT INTO exp_goods_asia VALUES ('한국', 6,  '자동차부품');
    INSERT INTO exp_goods_asia VALUES ('한국', 7,  '휴대전화');
    INSERT INTO exp_goods_asia VALUES ('한국', 8,  '환식탄화수소');
    INSERT INTO exp_goods_asia VALUES ('한국', 9,  '무선송신기 디스플레이 부속품');
    INSERT INTO exp_goods_asia VALUES ('한국', 10,  '철 또는 비합금강');

    INSERT INTO exp_goods_asia VALUES ('일본', 1, '자동차');
    INSERT INTO exp_goods_asia VALUES ('일본', 2, '자동차부품');
    INSERT INTO exp_goods_asia VALUES ('일본', 3, '전자집적회로');
    INSERT INTO exp_goods_asia VALUES ('일본', 4, '선박');
    INSERT INTO exp_goods_asia VALUES ('일본', 5, '반도체웨이퍼');
    INSERT INTO exp_goods_asia VALUES ('일본', 6, '화물차');
    INSERT INTO exp_goods_asia VALUES ('일본', 7, '원유제외 석유류');
    INSERT INTO exp_goods_asia VALUES ('일본', 8, '건설기계');
    INSERT INTO exp_goods_asia VALUES ('일본', 9, '다이오드, 트랜지스터');
    INSERT INTO exp_goods_asia VALUES ('일본', 10, '기계류');
commit;

SELECT * FROM exp_goods_asia;

SELECT goods
FROM exp_goods_asia
WHERE country = '한국'
ORDER BY seq

SELECT goods
FROM exp_goods_asia
WHERE country = '일본'
ORDER BY seq

---- 두국가가 겹치는 수출품목은 한번만 조회하도록 함

---- UNION 두 데이터 집합이 있으면 각 집합 원소를 모두 포함한 결과 반환하는 합집합 함수
SELECT goods
FROM exp_goods_asia
WHERE country = '한국'
UNION
SELECT goods
FROM exp_goods_asia
WHERE country = '일본';

---- UNION ALL  중복된 데이터도 모두 반환함
SELECT goods
FROM exp_goods_asia
WHERE country = '한국'
UNION ALL
SELECT goods
FROM exp_goods_asia
WHERE country = '일본';

---- INTERSECT, 공통된 항목만 반환하는 교집합 함수

SELECT goods
FROM exp_goods_asia
WHERE country = '한국'
INTERSECT
SELECT goods
FROM exp_goods_asia
WHERE country = '일본';

---- MINUS 공통된 항목을 제외한 항목만 반환하는 차집합
SELECT goods
FROM exp_goods_asia
WHERE country = '한국'
MINUS
SELECT goods
FROM exp_goods_asia
WHERE country = '일본';

---- GROUPING SETS
SELECT 
    period, gubun, SUM(loan_jan_amt)totl_jan
FROM kor_loan_status
WHERE period LIKE '2013%'
GROUP BY GROUPING SETS(period,gubun);

SELECT 
    period, gubun, region, SUM(loan_jan_amt)totl_jan
FROM kor_loan_status
WHERE period LIKE '2013%'
    AND region IN('서울','경기')
GROUP BY GROUPING SETS(period,(gubun,region));

---- 불친절한 pl/sql 프로그래밍 책 읽어보기

SELECT a.employee_id
        , a.emp_name
        , a.department_id
        , b.department_name
FROM employees a, departments b
WHERE a.department_id = b.department_id;

----세미 조인
---- 서브 쿼리를 이용해 서브쿼리에 존재하는 데이터만 메인 쿼리에서 추출
---- exist
SELECT 
    department_id
    , department_name
FROM departments a
WHERE EXISTS(SELECT*
    FROM departments a, employees b
    WHERE a.department_id = b.department_id
    AND b.salary>3000);

SELECT 
    department_id
    , department_name
FROM departments a
    WHERE a.department_id IN(SELECT b.department_id
                            FROM employees b
                            WHERE b.salary> 3000)
ORDER BY department_name;

SELECT
    a.department_id
    , a.department_name
FROM departments a, employees b
WHERE a.department_id = b.department_id
    AND b.salary >3000
ORDER BY a.department_name;

---- 안티조인
---- 세미조인의 반대 개념
---- NOT EXSITS, NOT IN 
SELECT
    a. employee_id
    , a.emp_name
    , a.department_id
    , b.department_name
FROM employees a
    , departments b
WHERE a.department_id = b.department_id
    AND a.department_id NOT IN(SELECT department_id
                                FROM departments
                                WHERE manager_id IS NULL);


---- P. 180
SELECT count(*)
FROM employees a 
WHERE NOT EXISTS(SELECT 1
                FROM departments C
                WHERE a.department_id = c.department_id
                    AND manager_id IS NULL)

---- 셀프 조인
---- 조인을 하려면 두개의 테이블
---- 하나의 테이블을 두개로 분리
---- 테이블 자기자신과 연결
---- 같은 부서 번호를 가진 사원 중 A사원번호가 B사원보다 작은 것 조회
SELECT 
    a.employee_id
    , a.emp_name
    , b.employee_id
    , b.emp_name
    , a.department_id
FROM   
    employees a
    , employees b
WHERE a.employee_id < b.employee_id
    AND a.department_id = b.department_id
    AND a.department_id =20;

---- p.181 일반 조인
SELECT
    a.department_id
    , a.department_name
    , b.job_id
    , b.department_id
FROM departments a,
     job_history b
WHERE a.department_id = b.department_id;

---- 외부조인
SELECT
    a.department_id
    , a.department_name
    , b.job_id
    , b.department_id
FROM departments a,
     job_history b
WHERE a.department_id = b.department_id(+);

SELECT
    a.employee_id
    , a. emp_name
    , b.job_id
    , b.department_id
FROM employees a
     , job_history b
WHERE a.employee_id = b.employee_id(+)
    AND a.department_id = b.department_id;

    
SELECT
    a.employee_id
    , a. emp_name
    , b.job_id
    , b.department_id
FROM employees a
     , job_history b
WHERE a.employee_id = b.employee_id(+)
    AND a.department_id = b.department_id(+);

---- ansi조인
SELECT 
    a.employee_id
    , a.emp_name
    , b.department_id
    , b.department_name
FROM employees a
INNER JOIN departments b
    ON(a.department_id = b.department_id)
WHERE a.hire_date>=TO_DATE('2003-01-01','YYYY-MM-DD')

---- p.186
---- 외부조인
SELECT
    a.employee_id
    , a.emp_name
    , b.job_id
    , b.department_id
FROM employees a
LEFT OUTER JOIN job_history b
    ON(a.employee_id = b.employee_id
        and a.department_id = b.department_id);


SELECT
    a.employee_id
    , a.emp_name
    , b.job_id
    , b.department_id
FROM employees a
RIGHT OUTER JOIN job_history b
    ON(a.employee_id = b.employee_id
        and a.department_id = b.department_id);


---- 서브쿼리
---- SQL 수업의 하이라이트
---- 서브쿼리가 사용되는 위치 SELECT, FROM, WHERE
SELECT AVG(salary)FROM employees;
---- 배치 자동화
SELECT count(*)
FROM employees
WHERE salary >= (SELECT AVG(salary)FROM employees);

SELECT count(*)
FROM employees
WHERE salary >= 서브쿼리에서 출력되는 값이 단일 행;

---- IN(복수 결과값을 넣을 수 있음)
SELECT count(*)
FROM employees
WHERE department_id IN(SELECT department_id
                       FROM departments
                       WHERE parent_id IS NULL)

SELECT employee_id
       , emp_name
       , job_id
FROM employees
WHERE (employee_id,job_id) IN(SELECT EMPLOYEE_ID
                                     , job_id
                                     FROM job_history);


---- 서브쿼리 SELECT 뿐아니라 UPDATE, DELETE에도 사용
---- 전 사원의 급여를 평균 금액으로 갱신
CREATE TABLE employees0721 AS
SELECT*FROM employees;

---- p/194 하단 SELECT에 서브쿼리
SELECT
    a.employee_id
    ,(SELECT b.emp_name
      FROM employees b
      WHERE a.employee_id =b.employee_id) AS emp_name
    , a.department_id
    , (SELECT b.department_name
      FROM departments b
      WHERE a.department_id = b.department_id) AS dep_name
FROM job_history a;

---- 메인쿼리
SELECT
FROM
WHERE(서브쿼리(서브쿼리2))

SELECT
    a.department_id
    ,a.department_name
FROM departments a
WHERE EXISTS(SELECT 1
             FROM employees b
             WHERE a.department_id = b.department_id
             AND b.salary>(SELECT avg(salary)FROM employees)
             );

---- 메인 쿼리, 부서테이블에서 부서 ID와 부서명

---- P.196
---- 메인쿼리 : 사원 테이블의 사원들의 부서별 평균 급여를 조회
---- 서브쿼리 : 상위부서가 기획부(부서 번호가 90)에 속함
SELECT department_id,AVG(salary)
FROM employees
WHERE department_id IN(SELECT department_id
                       FROM departments
                       WHERE parent_id = 90)
GROUP BY department_id;
