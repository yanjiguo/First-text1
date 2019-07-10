--颜继国
-- Create table 学生信息
create table HAND_STUDENT
(
  STUDENT_NO     VARCHAR2(10) not null,
  STUDENT_NAME   VARCHAR2(20),
  STUDENT_AGE    NUMBER(2),
  STUDENT_GENDER VARCHAR2(5)
);
-- Add comments to the table 
comment on table HAND_STUDENT
  is '学生信息表';
-- Add comments to the columns 
comment on column HAND_STUDENT.STUDENT_NO
  is '学号';
comment on column HAND_STUDENT.STUDENT_NAME
  is '姓名';
comment on column HAND_STUDENT.STUDENT_AGE
  is '年龄';
comment on column HAND_STUDENT.STUDENT_GENDER
  is '性别';
-- Create/Recreate primary, unique and foreign key constraints 
alter table HAND_STUDENT add primary key (STUDENT_NO);

-- Create table 教师信息表
create table HAND_TEACHER
(
  TEACHER_NO   VARCHAR2(10) not null,
  TEACHER_NAME VARCHAR2(20),
  MANAGER_NO   VARCHAR2(10)
);
-- Add comments to the table 
comment on table HAND_TEACHER
  is '教师信息表';
-- Add comments to the columns 
comment on column HAND_TEACHER.TEACHER_NO
  is '教师编号';
comment on column HAND_TEACHER.TEACHER_NAME
  is '教师名称';
comment on column HAND_TEACHER.MANAGER_NO
  is '上级编号';
-- Create/Recreate primary, unique and foreign key constraints 
alter table HAND_TEACHER add primary key (TEACHER_NO);

-- Create table 课程信息表
create table HAND_COURSE
(
  COURSE_NO   VARCHAR2(10) not null,
  COURSE_NAME VARCHAR2(20),
  TEACHER_NO  VARCHAR2(20) not null
);
-- Add comments to the table 
comment on table HAND_COURSE
  is '课程信息表';
-- Add comments to the columns 
comment on column HAND_COURSE.COURSE_NO
  is '课程号';
comment on column HAND_COURSE.COURSE_NAME
  is '课程名称';
comment on column HAND_COURSE.TEACHER_NO
  is '教师编号';
-- Create/Recreate primary, unique and foreign key constraints 
alter table HAND_COURSE add constraint PK_COURSE primary key (COURSE_NO, TEACHER_NO);

-- Create table 成绩信息表
create table HAND_STUDENT_CORE
(
  STUDENT_NO VARCHAR2(10) not null,
  COURSE_NO  VARCHAR2(10) not null,
  CORE       NUMBER(4,2)
);
-- Add comments to the table 
comment on table HAND_STUDENT_CORE
  is '学生成绩表';
-- Add comments to the columns 
comment on column HAND_STUDENT_CORE.STUDENT_NO
  is '学号';
comment on column HAND_STUDENT_CORE.COURSE_NO
  is '课程号';
comment on column HAND_STUDENT_CORE.CORE
  is '分数';
-- Create/Recreate primary, unique and foreign key constraints 
alter table HAND_STUDENT_CORE add constraint PK_SC primary key (STUDENT_NO, COURSE_NO);


/*******初始化学生表的数据******/
insert into HAND_STUDENT values ('s001','张三',23,'男');
insert into HAND_STUDENT values ('s002','李四',23,'男');
insert into HAND_STUDENT values ('s003','吴鹏',25,'男');
insert into HAND_STUDENT values ('s004','琴沁',20,'女');
insert into HAND_STUDENT values ('s005','王丽',20,'女');
insert into HAND_STUDENT values ('s006','李波',21,'男');
insert into HAND_STUDENT values ('s007','刘玉',21,'男');
insert into HAND_STUDENT values ('s008','萧蓉',21,'女');
insert into HAND_STUDENT values ('s009','陈萧晓',23,'女');
insert into HAND_STUDENT values ('s010','陈美',22,'女');
commit;
/******************初始化教师表***********************/
insert into HAND_TEACHER values ('t001', '刘阳','');
insert into HAND_TEACHER values ('t002', '谌燕','t001');
insert into HAND_TEACHER values ('t003', '胡明星','t002');
commit;
/***************初始化课程表****************************/
insert into HAND_COURSE values ('c001','J2SE','t002');
insert into HAND_COURSE values ('c002','Java Web','t002');
insert into HAND_COURSE values ('c003','SSH','t001');
insert into HAND_COURSE values ('c004','Oracle','t001');
insert into HAND_COURSE values ('c005','SQL SERVER 2005','t003');
insert into HAND_COURSE values ('c006','C#','t003');
insert into HAND_COURSE values ('c007','JavaScript','t002');
insert into HAND_COURSE values ('c008','DIV+CSS','t001');
insert into HAND_COURSE values ('c009','PHP','t003');
insert into HAND_COURSE values ('c010','EJB3.0','t002');
commit;
/***************初始化成绩表***********************/
insert into HAND_STUDENT_CORE values ('s001','c001',58.9);
insert into HAND_STUDENT_CORE values ('s002','c001',80.9);
insert into HAND_STUDENT_CORE values ('s003','c001',81.9);
insert into HAND_STUDENT_CORE values ('s004','c001',60.9);
insert into HAND_STUDENT_CORE values ('s001','c002',82.9);
insert into HAND_STUDENT_CORE values ('s002','c002',72.9);
insert into HAND_STUDENT_CORE values ('s003','c002',81.9);
insert into HAND_STUDENT_CORE values ('s001','c003','59');
commit;

select * from HAND_STUDENT;
select * from HAND_TEACHER;
select * from HAND_COURSE;
select * from HAND_STUDENT_CORE;

--1 查询没学过“谌燕”老师课的同学，显示（学号、姓名）（6分）
select STUDENT_NO, STUDENT_NAME
  from HAND_STUDENT --学生表
 where STUDENT_NO in
       (select student_no
          from HAND_STUDENT_CORE --成绩表
         where course_no not in
               (select course_no
                  from HAND_COURSE  --课程表
                 where teacher_no = (select teacher_no
                                       from HAND_TEACHER --老师表
                                      where teacher_name = '谌燕')));

--2 查询没有学全所有课的同学，显示（学号、姓名）（6分）

select count(1) as courseNum   from HAND_STUDENT hs , HAND_STUDENT_CORE  hsc where  hs.student_no = hsc.student_no group by hs.student_no;

select hs.student_no,hs.student_name  from HAND_STUDENT hs,HAND_STUDENT_CORE hsc where  hs.student_no = hsc.student_no group by hs.student_no having count(hsc.course_no)<(select count(*) from  hand_course);

select count(1) from  hand_course;--总课程数


--首先查询所有课的数量
--在查询每一个学生选课的数量
SELECT hs.student_no, hs.student_name
  FROM HAND_STUDENT hs, HAND_STUDENT_CORE hsc
 WHERE hs.student_no = hsc.student_no(+) --在成绩表中没有的学生id也要显示
 GROUP BY hs.student_no, hs.student_name  
 HAVING COUNT(hsc.course_no) < (SELECT COUNT(*) FROM hand_course c); --课程数小于总共的课程数


--3 查询“c001”课程比“c002”课程成绩高的所有学生，显示（学号、姓名）（6分）
select hs.student_no,hs.student_name from HAND_STUDENT hs,HAND_STUDENT_CORE hsc  WHERE hs.student_no = hsc.student_no(+);


select * from HAND_STUDENT_CORE where course_no='c001'  --对应的学号
select * from HAND_STUDENT_CORE where course_no='c002'  --对应的学号

select stu.student_no, stu.student_name
  from hand_student stu,
       (select t1.student_no
          from (select *
                  from hand_student_core sc
                 where sc.course_no = 'c001') t1, --查询出来c001课程的信息
               (select *
                  from hand_student_core sc
                 where sc.course_no = 'c002') t2  --查询出来c002课程的信息
         where t1.student_no = t2.student_no  --必须是同一个学生
           and t1.core > t2.core) tt
 where stu.student_no = tt.student_no
 
 
--4 按各科平均成绩和及格率的百分数，按及格率高到低的顺序排序，显示（课程号、平均分、及格率）（6分）--有问题

    select * from HAND_COURSE;
    select * from HAND_STUDENT_CORE;
    select course_no, avg(core) from HAND_STUDENT_CORE group by course_no;
    
--5 1992年之后出生的学生名单找出年龄最大和最小的同学，显示（学号、姓名、年龄）（6分）

    select student_no, student_name, student_age
      from HAND_STUDENT
     where student_age = (select max(student_age) --获取到最大值
                            from HAND_STUDENT
                           where student_age > (SELECT floor(months_between(SYSDATE,
                                                                            to_date('1992',
                                                                                    'yyyy')) / 12)--计算当前时间到1999年的年龄
                                                  from dual))
           or student_age = (select min(student_age)--获取到最小值
                            from HAND_STUDENT
                           where student_age > (SELECT floor(months_between(SYSDATE,
                                                                            to_date('1992',
                                                                                    'yyyy')) / 12)--计算当前时间到1999年的年龄
                                                  from dual));
                                                  
--6 统计列出矩阵类型各分数段人数，横轴为分数段[100-85]、[85-70]、[70-60]、[<60]，纵轴为课程号、课程名称（提示使用case when句式）（7分）
    
    SELECT hsc.course_no,
           hc.course_name,
       SUM(  CASE
             WHEN hsc.core BETWEEN 85 AND 100 THEN
              1
             ELSE
              0
           END) AS "[ 100 - 85 ]",
       SUM(CASE
             WHEN hsc.core BETWEEN 70 AND 85 THEN
              1
             ELSE
              0
           END) AS " [ 85 - 70 ] ",
       SUM(CASE
             WHEN hsc.core BETWEEN 60 AND 70 THEN
              1
             ELSE
              0
           END) AS " [ 70 - 60 ] ",
       SUM(CASE
             WHEN hsc.core < 60 then
              1
             ELSE
              0
           END) AS " [ < 60 ] "
  FROM hand_student_core hsc, hand_course hc
 WHERE hsc.course_no = hc.course_no
 GROUP BY hsc.course_no, hc.course_name;
 
--7 查询各科成绩前三名的记录:(不考虑成绩并列情况)，显示（学号、课程号、分数）（7分）
    --有排序并且显示的值比较多，使用分析函数
    SELECT * FROM (
              SELECT 
                HSC.STUDENT_NO,
                HSC.COURSE_NO,
                HSC.CORE,
                --row_number编号 --以课程编号分组后在根据成绩降序排序
                ROW_NUMBER() OVER(PARTITION BY HSC.COURSE_NO ORDER BY HSC.CORE DESC) rn
              FROM HAND_STUDENT_CORE HSC) A --临时表
     WHERE rn <= 3  --截取编号前三名的学生            
     
--8 查询选修“谌燕”老师所授课程的学生中每科成绩最高的学生，显示（学号、姓名、课程名称、成绩）（7分）
   
    select 
            aa.student_no,
            aa.student_name,
            aa.course_name,
            aa.core  
    from
           (select 
                    hs.student_no,
                    hs.student_name,
                    hc.course_name,
                    ROW_NUMBER() OVER(PARTITION BY hc.course_name  order by hsc.core desc) as numaa,
                    hsc.core 
            from
                    hand_student_core hsc,
                    hand_course hc,
                    hand_teacher ht,
                    hand_student hs
            where 
                    hsc.student_no = hs.student_no 
                    and hsc.course_no = hc.course_no 
                    and ht.teacher_no = hc.teacher_no 
                    and ht.teacher_name = '谌燕')   aa --临时表
    where
          numaa = 1;
   select * from user_indexes

--9 查询两门以上不及格课程的同学及平均成绩，显示（学号、姓名、平均成绩（保留两位小数--round））（7分）
    select *from hand_student_core;
    
    
    SELECT hsc.student_no,
           hs.student_name,
           ROUND(AVG(hsc.core), 2) avg_core
      FROM hand_student_core hsc, hand_student hs
     WHERE EXISTS (SELECT sc.student_no
              FROM hand_student_core sc
             WHERE sc.core < 60
               AND sc.student_no = hsc.student_no
             GROUP BY sc.student_no
            HAVING COUNT(sc.student_no) > 1)--首先查询出来满足有两科不及格的学生的id
       AND hsc.student_no = hs.student_no --再根据查出来的学生id在查出来学生的id，姓名，平均值
     GROUP BY hsc.student_no, hs.student_name; 
    
--10 查询姓氏数量最多的学生名单，显示（学号、姓名、人数）（7分）

    SELECT hs.student_no, hs.student_name, ht.cnt
      FROM (SELECT SUBSTR(hs.student_name, 1, 1) surname,
                   COUNT(1) cnt,
                   dense_rank() OVER(ORDER BY COUNT(1) DESC) ranks
              FROM hand_student hs
             GROUP BY SUBSTR(hs.student_name, 1, 1)) ht,
           hand_student hs
     WHERE SUBSTR(hs.student_name, 1, 1) = ht.surname
       AND ht.ranks = 1;

--11 查询课程名称为“J2SE”的学生成绩信息，90以上为“优秀”、80-90为“良好”、60-80为“及格”、60分以下为“不及格”，显示（学号、姓名、课程名称、成绩、等级）
     
     select hsc.student_no, core
       from HAND_COURSE hc, HAND_STUDENT_CORE hsc
     where hc.course_no = hsc.course_no and course_name = 'J2SE';
       
     select * from hand_student where student_no in ( select hsc.student_no from HAND_COURSE hc, HAND_STUDENT_CORE hsc where hc.course_no = hsc.course_no and course_name = 'J2SE')
     
     select 
            hs.student_no,
            hs.student_name,
            hc.course_name,
            hsc.core,
            case
                  when hsc.core>=90 then '优秀'
                  when hsc.core<90 and hsc.core>=80 then '良好'
                  when hsc.core<80 and hsc.core>=60 then '及格'
                  when hsc.core<60 then '不及格'
            end 
                  core_level
     from 
            HAND_COURSE hc,HAND_STUDENT_CORE hsc,hand_student hs
     where 
            hc.course_no = hsc.course_no and hs.student_no = hsc.student_no and hc.course_name = 'J2SE';
        
--12 这是一个树结构，查询教师“胡明星”的所有主管及姓名:（无主管的教师也需要显示），显示（教师编号、教师名称、主管编号、主管名称）（7分）
     
     
--13 查询分数高于课程“J2SE”中所有学生成绩的学生课程信息，显示（学号，姓名，课程名称、分数）（7分）
     select 
            hs.student_no,
            hs.student_name,
            hc.course_name,
            hsc.core
     from 
            HAND_COURSE hc,HAND_STUDENT_CORE hsc,hand_student hs
     where 
            hc.course_no = hsc.course_no and hs.student_no = hsc.student_no and hc.course_name != 'J2SE' and hsc.core > all(select 
            hsc.core
     from 
            HAND_COURSE hc,HAND_STUDENT_CORE hsc,hand_student hs
     where 
            hc.course_no = hsc.course_no and hs.student_no = hsc.student_no and hc.course_name = 'J2SE');
            
--14 分别根据教师、课程、教师和课程三个条件统计选课的学生数量 （使用rollup),显示（教师名称、课程名称、选课数量）（7分）
     select * from hand_student_core;
     select * from hand_teacher;
     select * from hand_course;
     
    --如果要统计就必须使用到分组
    --分组有根据一个字段或者多个字段
    --对课程进行分组再求课程的数量count（1）课程对应的老师
    select 
           ht.teacher_name,
           hc.course_name，
           count(1) as student_num
    from
           hand_teacher ht,
           hand_course hc,
           hand_student_core hsc --主要是用来统计课程对应的学生
    where
           ht.teacher_no = hc.teacher_no and hsc.course_no = hc.course_no --没有分组的数据
    group by rollup(ht.teacher_name,hc.course_name)--分组统计

--15 查询所有课程成绩前三名的按照升序排在最开头，其余数据排序保持默认显示（学号、成绩）（7分）
     SELECT 
           hs.student_no, 
           hs.core 
     FROM 
           (SELECT 
            rownum rn, 
            hsc.student_no, 
            hsc.core, 
            row_number() OVER(ORDER BY hsc.core DESC) ranks 
     FROM hand_student_core hsc) hs ORDER BY CASE 
     WHEN ranks <= 3 THEN -ranks 
     ELSE 
      null 
     END, 
     rn;  
    select rownum from dual;
    select rowid from dual; --AAAAB0AABAAAAOhAAA
    select months_between(sysdate,to_date('20181007','yyyymmdd')) as months from dual;
    select sysdate from dual;










