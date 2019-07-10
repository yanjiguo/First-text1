--�ռ̹�
-- Create table ѧ����Ϣ
create table HAND_STUDENT
(
  STUDENT_NO     VARCHAR2(10) not null,
  STUDENT_NAME   VARCHAR2(20),
  STUDENT_AGE    NUMBER(2),
  STUDENT_GENDER VARCHAR2(5)
);
-- Add comments to the table 
comment on table HAND_STUDENT
  is 'ѧ����Ϣ��';
-- Add comments to the columns 
comment on column HAND_STUDENT.STUDENT_NO
  is 'ѧ��';
comment on column HAND_STUDENT.STUDENT_NAME
  is '����';
comment on column HAND_STUDENT.STUDENT_AGE
  is '����';
comment on column HAND_STUDENT.STUDENT_GENDER
  is '�Ա�';
-- Create/Recreate primary, unique and foreign key constraints 
alter table HAND_STUDENT add primary key (STUDENT_NO);

-- Create table ��ʦ��Ϣ��
create table HAND_TEACHER
(
  TEACHER_NO   VARCHAR2(10) not null,
  TEACHER_NAME VARCHAR2(20),
  MANAGER_NO   VARCHAR2(10)
);
-- Add comments to the table 
comment on table HAND_TEACHER
  is '��ʦ��Ϣ��';
-- Add comments to the columns 
comment on column HAND_TEACHER.TEACHER_NO
  is '��ʦ���';
comment on column HAND_TEACHER.TEACHER_NAME
  is '��ʦ����';
comment on column HAND_TEACHER.MANAGER_NO
  is '�ϼ����';
-- Create/Recreate primary, unique and foreign key constraints 
alter table HAND_TEACHER add primary key (TEACHER_NO);

-- Create table �γ���Ϣ��
create table HAND_COURSE
(
  COURSE_NO   VARCHAR2(10) not null,
  COURSE_NAME VARCHAR2(20),
  TEACHER_NO  VARCHAR2(20) not null
);
-- Add comments to the table 
comment on table HAND_COURSE
  is '�γ���Ϣ��';
-- Add comments to the columns 
comment on column HAND_COURSE.COURSE_NO
  is '�γ̺�';
comment on column HAND_COURSE.COURSE_NAME
  is '�γ�����';
comment on column HAND_COURSE.TEACHER_NO
  is '��ʦ���';
-- Create/Recreate primary, unique and foreign key constraints 
alter table HAND_COURSE add constraint PK_COURSE primary key (COURSE_NO, TEACHER_NO);

-- Create table �ɼ���Ϣ��
create table HAND_STUDENT_CORE
(
  STUDENT_NO VARCHAR2(10) not null,
  COURSE_NO  VARCHAR2(10) not null,
  CORE       NUMBER(4,2)
);
-- Add comments to the table 
comment on table HAND_STUDENT_CORE
  is 'ѧ���ɼ���';
-- Add comments to the columns 
comment on column HAND_STUDENT_CORE.STUDENT_NO
  is 'ѧ��';
comment on column HAND_STUDENT_CORE.COURSE_NO
  is '�γ̺�';
comment on column HAND_STUDENT_CORE.CORE
  is '����';
-- Create/Recreate primary, unique and foreign key constraints 
alter table HAND_STUDENT_CORE add constraint PK_SC primary key (STUDENT_NO, COURSE_NO);


/*******��ʼ��ѧ���������******/
insert into HAND_STUDENT values ('s001','����',23,'��');
insert into HAND_STUDENT values ('s002','����',23,'��');
insert into HAND_STUDENT values ('s003','����',25,'��');
insert into HAND_STUDENT values ('s004','����',20,'Ů');
insert into HAND_STUDENT values ('s005','����',20,'Ů');
insert into HAND_STUDENT values ('s006','�',21,'��');
insert into HAND_STUDENT values ('s007','����',21,'��');
insert into HAND_STUDENT values ('s008','����',21,'Ů');
insert into HAND_STUDENT values ('s009','������',23,'Ů');
insert into HAND_STUDENT values ('s010','����',22,'Ů');
commit;
/******************��ʼ����ʦ��***********************/
insert into HAND_TEACHER values ('t001', '����','');
insert into HAND_TEACHER values ('t002', '����','t001');
insert into HAND_TEACHER values ('t003', '������','t002');
commit;
/***************��ʼ���γ̱�****************************/
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
/***************��ʼ���ɼ���***********************/
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

--1 ��ѯûѧ�������ࡱ��ʦ�ε�ͬѧ����ʾ��ѧ�š���������6�֣�
select STUDENT_NO, STUDENT_NAME
  from HAND_STUDENT --ѧ����
 where STUDENT_NO in
       (select student_no
          from HAND_STUDENT_CORE --�ɼ���
         where course_no not in
               (select course_no
                  from HAND_COURSE  --�γ̱�
                 where teacher_no = (select teacher_no
                                       from HAND_TEACHER --��ʦ��
                                      where teacher_name = '����')));

--2 ��ѯû��ѧȫ���пε�ͬѧ����ʾ��ѧ�š���������6�֣�

select count(1) as courseNum   from HAND_STUDENT hs , HAND_STUDENT_CORE  hsc where  hs.student_no = hsc.student_no group by hs.student_no;

select hs.student_no,hs.student_name  from HAND_STUDENT hs,HAND_STUDENT_CORE hsc where  hs.student_no = hsc.student_no group by hs.student_no having count(hsc.course_no)<(select count(*) from  hand_course);

select count(1) from  hand_course;--�ܿγ���


--���Ȳ�ѯ���пε�����
--�ڲ�ѯÿһ��ѧ��ѡ�ε�����
SELECT hs.student_no, hs.student_name
  FROM HAND_STUDENT hs, HAND_STUDENT_CORE hsc
 WHERE hs.student_no = hsc.student_no(+) --�ڳɼ�����û�е�ѧ��idҲҪ��ʾ
 GROUP BY hs.student_no, hs.student_name  
 HAVING COUNT(hsc.course_no) < (SELECT COUNT(*) FROM hand_course c); --�γ���С���ܹ��Ŀγ���


--3 ��ѯ��c001���γ̱ȡ�c002���γ̳ɼ��ߵ�����ѧ������ʾ��ѧ�š���������6�֣�
select hs.student_no,hs.student_name from HAND_STUDENT hs,HAND_STUDENT_CORE hsc  WHERE hs.student_no = hsc.student_no(+);


select * from HAND_STUDENT_CORE where course_no='c001'  --��Ӧ��ѧ��
select * from HAND_STUDENT_CORE where course_no='c002'  --��Ӧ��ѧ��

select stu.student_no, stu.student_name
  from hand_student stu,
       (select t1.student_no
          from (select *
                  from hand_student_core sc
                 where sc.course_no = 'c001') t1, --��ѯ����c001�γ̵���Ϣ
               (select *
                  from hand_student_core sc
                 where sc.course_no = 'c002') t2  --��ѯ����c002�γ̵���Ϣ
         where t1.student_no = t2.student_no  --������ͬһ��ѧ��
           and t1.core > t2.core) tt
 where stu.student_no = tt.student_no
 
 
--4 ������ƽ���ɼ��ͼ����ʵİٷ������������ʸߵ��͵�˳��������ʾ���γ̺š�ƽ���֡������ʣ���6�֣�--������

    select * from HAND_COURSE;
    select * from HAND_STUDENT_CORE;
    select course_no, avg(core) from HAND_STUDENT_CORE group by course_no;
    
--5 1992��֮�������ѧ�������ҳ�����������С��ͬѧ����ʾ��ѧ�š����������䣩��6�֣�

    select student_no, student_name, student_age
      from HAND_STUDENT
     where student_age = (select max(student_age) --��ȡ�����ֵ
                            from HAND_STUDENT
                           where student_age > (SELECT floor(months_between(SYSDATE,
                                                                            to_date('1992',
                                                                                    'yyyy')) / 12)--���㵱ǰʱ�䵽1999�������
                                                  from dual))
           or student_age = (select min(student_age)--��ȡ����Сֵ
                            from HAND_STUDENT
                           where student_age > (SELECT floor(months_between(SYSDATE,
                                                                            to_date('1992',
                                                                                    'yyyy')) / 12)--���㵱ǰʱ�䵽1999�������
                                                  from dual));
                                                  
--6 ͳ���г��������͸�����������������Ϊ������[100-85]��[85-70]��[70-60]��[<60]������Ϊ�γ̺š��γ����ƣ���ʾʹ��case when��ʽ����7�֣�
    
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
 
--7 ��ѯ���Ƴɼ�ǰ�����ļ�¼:(�����ǳɼ��������)����ʾ��ѧ�š��γ̺š���������7�֣�
    --����������ʾ��ֵ�Ƚ϶࣬ʹ�÷�������
    SELECT * FROM (
              SELECT 
                HSC.STUDENT_NO,
                HSC.COURSE_NO,
                HSC.CORE,
                --row_number��� --�Կγ̱�ŷ�����ڸ��ݳɼ���������
                ROW_NUMBER() OVER(PARTITION BY HSC.COURSE_NO ORDER BY HSC.CORE DESC) rn
              FROM HAND_STUDENT_CORE HSC) A --��ʱ��
     WHERE rn <= 3  --��ȡ���ǰ������ѧ��            
     
--8 ��ѯѡ�ޡ����ࡱ��ʦ���ڿγ̵�ѧ����ÿ�Ƴɼ���ߵ�ѧ������ʾ��ѧ�š��������γ����ơ��ɼ�����7�֣�
   
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
                    and ht.teacher_name = '����')   aa --��ʱ��
    where
          numaa = 1;
   select * from user_indexes

--9 ��ѯ�������ϲ�����γ̵�ͬѧ��ƽ���ɼ�����ʾ��ѧ�š�������ƽ���ɼ���������λС��--round������7�֣�
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
            HAVING COUNT(sc.student_no) > 1)--���Ȳ�ѯ�������������Ʋ������ѧ����id
       AND hsc.student_no = hs.student_no --�ٸ��ݲ������ѧ��id�ڲ����ѧ����id��������ƽ��ֵ
     GROUP BY hsc.student_no, hs.student_name; 
    
--10 ��ѯ������������ѧ����������ʾ��ѧ�š���������������7�֣�

    SELECT hs.student_no, hs.student_name, ht.cnt
      FROM (SELECT SUBSTR(hs.student_name, 1, 1) surname,
                   COUNT(1) cnt,
                   dense_rank() OVER(ORDER BY COUNT(1) DESC) ranks
              FROM hand_student hs
             GROUP BY SUBSTR(hs.student_name, 1, 1)) ht,
           hand_student hs
     WHERE SUBSTR(hs.student_name, 1, 1) = ht.surname
       AND ht.ranks = 1;

--11 ��ѯ�γ�����Ϊ��J2SE����ѧ���ɼ���Ϣ��90����Ϊ�����㡱��80-90Ϊ�����á���60-80Ϊ�����񡱡�60������Ϊ�������񡱣���ʾ��ѧ�š��������γ����ơ��ɼ����ȼ���
     
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
                  when hsc.core>=90 then '����'
                  when hsc.core<90 and hsc.core>=80 then '����'
                  when hsc.core<80 and hsc.core>=60 then '����'
                  when hsc.core<60 then '������'
            end 
                  core_level
     from 
            HAND_COURSE hc,HAND_STUDENT_CORE hsc,hand_student hs
     where 
            hc.course_no = hsc.course_no and hs.student_no = hsc.student_no and hc.course_name = 'J2SE';
        
--12 ����һ�����ṹ����ѯ��ʦ�������ǡ����������ܼ�����:�������ܵĽ�ʦҲ��Ҫ��ʾ������ʾ����ʦ��š���ʦ���ơ����ܱ�š��������ƣ���7�֣�
     
     
--13 ��ѯ�������ڿγ̡�J2SE��������ѧ���ɼ���ѧ���γ���Ϣ����ʾ��ѧ�ţ��������γ����ơ���������7�֣�
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
            
--14 �ֱ���ݽ�ʦ���γ̡���ʦ�Ϳγ���������ͳ��ѡ�ε�ѧ������ ��ʹ��rollup),��ʾ����ʦ���ơ��γ����ơ�ѡ����������7�֣�
     select * from hand_student_core;
     select * from hand_teacher;
     select * from hand_course;
     
    --���Ҫͳ�ƾͱ���ʹ�õ�����
    --�����и���һ���ֶλ��߶���ֶ�
    --�Կγ̽��з�������γ̵�����count��1���γ̶�Ӧ����ʦ
    select 
           ht.teacher_name,
           hc.course_name��
           count(1) as student_num
    from
           hand_teacher ht,
           hand_course hc,
           hand_student_core hsc --��Ҫ������ͳ�ƿγ̶�Ӧ��ѧ��
    where
           ht.teacher_no = hc.teacher_no and hsc.course_no = hc.course_no --û�з��������
    group by rollup(ht.teacher_name,hc.course_name)--����ͳ��

--15 ��ѯ���пγ̳ɼ�ǰ�����İ������������ͷ�������������򱣳�Ĭ����ʾ��ѧ�š��ɼ�����7�֣�
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










