# 문제1. 현재 평균 연봉보다 많은 월급을 받는 직원은 몇 명이나 있습니까?
select count(em.emp_no)
from employees as em
join salaries as sal
on em.emp_no = sal.emp_no
where sal.to_date like "9999-%"
and sal.salary > (select avg(salary)
				  from salaries
				  where to_date like "9999-%");



# 문제2. 현재 각 부서별로 최고의 급여를 받는 사원의 사번, 이름, 부서, 연봉을 조회하세요.
# 단, 조회 결과는 연봉의 내림차순으로 정렬되어 나타나야 합니다.
select em.emp_no, concat(em.first_name, " ", em.last_name) as name, dp.dept_name, sal.salary
from employees as em
join dept_emp as dp_em
on dp_em.emp_no = em.emp_no
join departments as dp
on dp.dept_no = dp_em.dept_no
join salaries as sal
on sal.emp_no = dp_em.emp_no
where sal.to_date like "9999-%"
and dp_em.to_date like "9999-%"
and (dp_em.dept_no, sal.salary) = any(select dp_em.dept_no, max(sal.salary)
								  from dept_emp as dp_em
								   join salaries as sal
								   on sal.emp_no = dp_em.emp_no
								   where sal.to_date like "9999-%"
								   and dp_em.to_date like "9999-%"
                                   group by dp_em.dept_no)
order by sal.salary desc;



# 문제3. 현재 자신의 부서 평균 급여보다 연봉(salsary)이 많은 사원의 사번, 이름, 연봉을 조회하세요.
select em.emp_no, em.first_name, sal.salary
from employees em, salaries sal, dept_emp de, (select de.dept_no, avg(sal.salary) as avg_salary
											   from salaries sal, dept_emp de
											   where sal.emp_no = de.emp_no
											   and de.to_date like "9999-%"
											   and sal.to_date like "9999-%"
											   group by de.dept_no) sub
where em.emp_no = sal.emp_no
and sal.emp_no = de.emp_no
and de.dept_no = sub.dept_no
and de.to_date like "9999-%"
and sal.to_date like "9999-%"
and sal.salary > sub.avg_salary;
                         


# 문제4. 현재 사원들의 사번, 이름, 매니저 이름, 부서 이름으로 출력해 보세요.
select em.emp_no, concat(em.first_name, " ", em.last_name) as name, sub.manager_name, dp.dept_name
 from employees em, dept_emp de, departments dp, (select concat(em.first_name, " ", em.last_name) as manager_name
												  from employees em, dept_manager dm
                                                  where em.emp_no = dm.emp_no
                                                  and dm.to_date like "9999-%") sub
 where em.emp_no = de.emp_no
 and de.dept_no = dp.dept_no
 and de.to_date like "9999-%";



# 문제5. 현재 평균연봉이 가장 높은 부서의 사원들의 사번, 이름, 직책, 연봉을 조회하고 연봉 순으로 출력하세요.
explain
select em.emp_no, concat(em.first_name, " ", em.last_name) as name, t.title, sal.salary
from employees em, titles t, salaries sal, dept_emp dm
where em.emp_no = t.emp_no
and em.emp_no = sal.emp_no
and em.emp_no = dm.emp_no
and sal.to_date like "9999-%"
and t.to_date like "9999-%"
and dm.dept_no = (select dm.dept_no
				  from salaries sal, dept_emp dm
				  where sal.emp_no = dm.emp_no
				  group by dm.dept_no
				  order by avg(sal.salary) desc
				  limit 0, 1);




# 문제6. 평균 연봉이 가장 높은 부서는?
select dp.dept_name
  from departments dp
 where dp.dept_no = (select de.dept_no
				       from salaries sal, dept_emp de
				      where sal.emp_no = de.emp_no
				   group by de.dept_no
			       order by avg(sal.salary) desc
				      limit 0, 1);



# 문제7. 평균 연봉이 가장 높은 직책은?
select t.title
  from titles t, salaries sal
where t.emp_no = sal.emp_no
group by t.title
having round(avg(sal.salary)) = (select max(sub.avg_salary)
								   from (select t.title, round(avg(sal.salary)) as avg_salary
										 from salaries sal, titles t
										 where sal.emp_no = t.emp_no
										 group by t.title) sub
								  );
              


# 문제8. 현재 자신의 매니저보다 높은 연봉을 받고 있는 직원은?
# 부서이름, 사원이름, 매니저 이름, 매니저 연봉 순으로 출력합니다.
select dp.dept_name, em.first_name, sub.first_name, sub.salary
from employees em, dept_emp de, salaries sal, departments dp, (select dm.emp_no, em.first_name, sal.salary
															   from employees em, dept_manager dm, salaries sal
															   where em.emp_no = dm.emp_no
															   and em.emp_no = sal.emp_no
															   and dm.to_date like "9999-%"
															   and sal.to_date like "9999-%") sub
where em.emp_no = de.emp_no
and em.emp_no = sal.emp_no
and de.dept_no = dp.dept_no
and de.to_date like "9999-%"
and sal.to_date like "9999-%"
and sal.salary > sub.salary;





