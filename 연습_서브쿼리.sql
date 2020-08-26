# ex1) 현재 "Fai Bale"이 근무하는 부서에서 근무하는 직원의 사번, 전체 이름을 출력해보세요.
# sol1) 개별 쿼리 해결 -> 안좋은 방법(가능하면 하나의 쿼리로 해결)
select b.dept_no
  from employees a, dept_emp b
 where a.emp_no = b.emp_no
   and b.to_date = '9999-01-01'
   and concat(a.first_name, ' ', a.last_name) = 'Fai Bale';
   
select a.emp_no, concat(first_name, ' ', last_name)
  from employees a, dept_emp b
 where a.emp_no = b.emp_no
   and b.to_date = '9999-01-01'
   and b.dept_no = 'd004';

# sol2) 서브쿼리를 사용해서 한 번의 퀄리로 해결
select a.emp_no, concat(first_name, ' ', last_name)
  from employees a, dept_emp b
 where a.emp_no = b.emp_no
   and b.to_date = '9999-01-01'
   and b.dept_no = (select b.dept_no
                      from employees a, dept_emp b
                     where a.emp_no = b.emp_no
					   and b.to_date = '9999-01-01'
                       and concat(a.first_name, ' ', a.last_name) = 'Fai Bale');




# ex2) 현재 전체 사원의 평균연봉 보다 적은 급여를 받는 사원의 이름, 급여를 출력해보세요.
select concat(em.first_name, " ", em.last_name) as name, sal.salary
from employees as em
join salaries sal
on em.emp_no=sal.emp_no
where sal.to_date like "9999-%"
and sal.salary < (select avg(salary)
				  from salaries
				  where to_date like "9999-%")
order by sal.salary;




# ex3) 현재 급여가 50000 이상인 직원 이름 출력
# sol1) join으로 해결
select concat(em.first_name, " ", em.last_name) as name
from employees as em
join salaries as sal
on sal.emp_no = em.emp_no
where sal.to_date like "9999-%"
and sal.salary > 50000;

# sol2) subquery 로 해결
select a.first_name, b.salary
  from employees a, salaries b
 where a.emp_no = b.emp_no
   and b.to_date = '9999-01-01'
   and (a.emp_no, b.salary) =any (select emp_no, salary
									from salaries
                                   where to_date='9999-01-01'
                                     and salary > 50000);




# ex4) 현재 가장적은 평균급여를 받고 있는 직책의 직책, 평균급여를 출력해보세요.
# sol1)
select t.title, round(avg(sal.salary)) as avg_salary
from titles as t
join salaries as sal
on sal.emp_no = t.emp_no
where t.to_date like "9999-%"
and sal.to_date like "9999-%"
group by t.title
having avg_salary = (select min(avg_salary)
					from (select round(avg(sal.salary)) as avg_salary
						  from titles as t
						  join salaries as sal
						  on t.emp_no = sal.emp_no
						  where t.to_date like "9999-%"
						  and sal.to_date like "9999-%"
						  group by t.title) avg_sal);

# sol2)
select t.title, avg(sal.salary) as avg_salary
from titles t, salaries sal
where t.emp_no = sal.emp_no
and t.to_date like "9999-%"
and sal.to_date like "9999-%"
group by t.title
order by avg_salary 
limit 0, 1;




# ex5) 각 부서별로 최고 급여를 받는 직원의 이름과 급여를 출력하세요.
select dp_em.dept_no, max(sal.salary)
from dept_emp dp_em, salaries sal
where dp_em.emp_no = sal.emp_no
and dp_em.to_date like "9999-%"
and sal.to_date like "9999-%"
group by dp_em.dept_no;

-- ex5-sol1) where절 subquery
select a.first_name, b.dept_no, d.dept_name, c.salary
  from employees a, dept_emp b, salaries c, departments d
 where a.emp_no = b.emp_no
   and b.emp_no = c.emp_no
   and b.dept_no = d.dept_no
   and b.to_date = '9999-01-01'
   and c.to_date = '9999-01-01'
   and (b.dept_no, c.salary) =any (  select a.dept_no, max(b.salary)
	                                   from dept_emp a, salaries b
                                      where a.emp_no = b.emp_no
                                        and a.to_date = '9999-01-01'
                                        and b.to_date = '9999-01-01'
								   group by a.dept_no)
order by c.salary desc;                                   
   
  
-- ex5-sol2) from절 subquery
select a.first_name, b.dept_no, d.dept_name, c.salary
  from employees a,
	   dept_emp b,
       salaries c,
       departments d,
       (  select a.dept_no, max(b.salary) as max_salary
	        from dept_emp a, salaries b
           where a.emp_no = b.emp_no
             and a.to_date = '9999-01-01'
			 and b.to_date = '9999-01-01'
        group by a.dept_no) e
 where a.emp_no = b.emp_no
   and b.emp_no = c.emp_no
   and b.dept_no = d.dept_no
   and b.dept_no = e.dept_no
   and c.salary = e.max_salary
   and b.to_date = '9999-01-01'
   and c.to_date = '9999-01-01';
