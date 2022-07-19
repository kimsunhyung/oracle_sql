SELECT table_name FROM user_tables;

-- sql vs pl/sql
-- sql (분석가, 개발자)
---- 프로그래밍 성격이 얕음
-- pl/sql (분석가, 개발자, dba)

-- 입문 : sql 테이블, 뷰 -> pl/sql 함수, 프로시저

-- 테이블 생성
/*
CREATE TABLE 테이블명(
    컬럼 1 컬럼 1_데이터 타입 결측치 허용 유무,
    
)
*/
-- 테이블생성 예시
CREATE TABLE ex2_1(
    COLUMN1     CHAR(10),
    COLUMN2     VARCHAR2(10),
    COLUMN3     VARCHAR2(10),
    COLUMN4     NUMBER
);

-- 데이터 추가 (웹 개발 시 아이디 추가할때 필요한 코드)
INSERT INTO ex2_1 (column1, column2) VALUES ('abc', 'abc');

-- 데이터 조회
SELECT column1, LENGTH(column1) as len1
FROM ex2_1;

--p.53
-- 영어에서 한문자 1byte
-- 한글에서는 한문자 2byte(삼십글자가 들어올경우 30*2=60으로 해서 데이터 생성해야함)
CREATE TABLE ex2_2(
    COLUMN1     VARCHAR2(3), -- 디폴트 값이 byte 적용
    COLUMN2     VARCHAR2(3 byte),
    COLUMN3     VARCHAR2(3 char)
);

-- 기존의 객체가 이름을 사용하고 있다는 오류가 뜨면 새로고침을 실행해야함.
INSERT INTO ex2_2 VALUES('abc', 'abc', 'abc');

SELECT column1
        , LENGTH(column1) as len1
        , column2
        , LENGTH(column2) as len2
        , column3
        , LENGTH(column3) as len3
    FROM ex2_2;
    
-- 한글 추가
INSERT INTO ex2_2 VALUES('홍길동', '홍길동', '홍길동');--입력 불가

-- p.54
INSERT INTO ex2_2 (column3) values('홍길동');

SELECT column3
        , LENGTH(column3) AS len3
        , LENGTHB(column3) AS bytelen
FROM ex2_2;

-- 숫자 데이터 타입

CREATE TABLE ex2_3(
    COL_INT INTEGER,
    COL_DEC DECIMAL,
    COL_NUM NUMBER
);

SELECT column_id
    , column_name
    , data_type
    , data_length
FROM user_tab_cols
WHERE table_name = 'EX2_3'
ORDER BY column_id;
-- select 컬럼명
-- from 테이블명
-- where 조건식(위치정보)
-- order by 정렬
-- * 모든 컬럼을 가지고 온다

-- 날짜 데이터 타입
CREATE TABLE ex2_5(
    COL_DATE        DATE,
    COL_TIMESTAMP   TIMESTAMP
);

INSERT INTO ex2_5 VALUES(SYSDATE, SYSTIMESTAMP);
SELECT * FROM ex2_5;

-- null : 값이 없음
-- 해당 컬럼은 null
-- 결측치 허용 x : not null
--p.60
CREATE TABLE ex2_6(
        COL_NULL        VARCHAR2(10),--결측치 허용
        COL_NOT_NULL    VARCHAR2(10) NOT NULL -- 결측치 허용 X
);

INSERT INTO ex2_6 VALUES ('AA',''); --  에러 발생
INSERT INTO ex2_6 VALUES('','BB');-- 정상적으로 삽입됨
SELECT *FROM ex2_6

INSERT INTO ex2_6 VALUES('AA','BB');
SELECT*FROM ex2_6
-- 테이블 생성, 추가, 삭제, 수정 코드
-- 파이썬, 자바에서 다 사용될 코드들

SELECT constraint_name
        , constraint_type
        , table_name
        , search_condition
FROM user_constraints
WHERE table_name = 'EX2_6';

-- UNIQUE 
-- 중복 값 허용 

CREATE TABLE ex2_7(
    COL_UNIQUE_NULL     VARCHAR2(10)UNIQUE
    , COL_UNIQUE_NNULL  VARCHAR2(10) UNIQUE NOT NULL
    , COL_UNIQUE        VARCHAR2(10)
    , CONSTRAINTS unique_nml UNIQUE (COL_UNIQUE)-- CONSTRAINT 제약을 걸다
);

SELECT constraint_name
        , constraint_type
        , table_name
        , search_condition
FROM user_constraints
WHERE table_name = 'EX2_7';

-- DROP TABLE 테이블 명 ;  테이블 삭제하는법

INSERT INTO ex2_7 VALUES('AA','AA','AA'); 
INSERT INTO ex2_7 VALUES('','BB','CC'); 

-- 기본키 중요
-- Primary Key
-- unique(중복허용 안됨), not null(결측치허용 안됨)
-- 테이블 당 1개의 기본키만 설정 가능

CREATE TABLE ex2_8(
    COL1 VARCHAR2(10) PRIMARY KEY
    , COL2 VARCHAR2(10)
);

-- INSERT INTO ex2_8 VALUES('','AA'); - 삽입 불가
INSERT INTO ex2_8 VALUES('AA','AA');

-- 외래키 : 테이블 간의 참조 데이터 무결성을 위한 제약 조건
-- 참조 무결성 보장 : 잘못된 정보가 입력되는 것을 방지

-- CHECK
-- 컬럼에 입력되는 데이터를 체크해 특정 조건에 맞는 데이터만 입력

CREATE TABLE ex2_9(
    num1        NUMBER
    , CONSTRAINTS check1 CHECK (num1 BETWEEN 1 AND 9)
    , gender        VARCHAR2(10)
    , CONSTRAINTS check2 CHECK (gender IN('MALE','FEMALE'))
);

SELECT constraint_name
        , constraint_type
        , table_name
        , search_condition
FROM user_constraints
WHERE table_name = 'EX2_9';

INSERT INTO ex2_9 VALUES(10,'MAN'); -- MALE 이들어가지 않아서 오류가 남
INSERT INTO ex2_9 VALUES(5, 'FEMALE')

-- DEFAULT : 고정 값 무조건 들어가라, 날짜, 시간
alter session set nls_date_format='YYYY/MM/DD HH24:MI:SS';

CREATE TABLE ex2_10(
    COL1 VARCHAR2(10) NOT NULL
    , COL2 VARCHAR2(10) NULL
    , CREATE_date DATE DEFAULT SYSDATE
);

INSERT INTO ex2_10 (col1,col2) VALUES('AA','BB');
SELECT*FROM ex2_10;

-- 테이블 변경
-- alter table

ALTER TABLE ex2_10 RENAME COLUMN Col1 TO Col11;
SELECT *FROM ex2_10;

DESC ex2_10;
-- 컬럼 변경
ALTER TABLE ex2_10 MODIFY COL2 VARCHAR2(30);

DESC ex2_10;

-- 신규 컬럼 추가
ALTER TABLE ex2_10 ADD COL3 NUMBER;
DESC ex2_10

-- 컬럼 삭제
ALTER TABLE ex2_10 DROP COLUMN COL3;
DESC ex2_10;

-- 제약 조건 추가
ALTER TABLE ex2_10 ADD CONSTRAINTS pk_ex2_10 PRIMARY KEY (COL11);
SELECT constraint_name
        , constraint_type
        , table_name
        , search_condition
FROM user_constraints
WHERE table_name = 'EX2_10';
-- 제약 조건 삭제
ALTER TABLE ex2_10 DROP CONSTRAINTS pk_ex2_10;
SELECT constraint_name
        , constraint_type
        , table_name
        , search_condition
FROM user_constraints
WHERE table_name = 'EX2_10';

-- 테이블 복사
CREATE TABLE ex2_9_1 AS
SELECT *
    FROM ex2_9;

-- 뷰 생성
CREATE OR REPLACE VIEW emp_dept_vl AS
SELECT a.employee_id
        , a.emp_name
        , a.department_id
        , b.department_name
FROM employees a
    , departments b
WHERE a.department_id = b.department_id;

-- 뷰 제거
DROP VIEW emp_dept_vl;
