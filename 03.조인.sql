# 문제1. 현재 급여가 많은 직원부터 직원의 사번, 이름, 그리고 연봉을 출력하시오.
select em.emp_no, concat(em.first_name, " ", em.last_name) as name, sal.salary
from employees as em
join salaries as sal 
on em.emp_no = sal.emp_no
order by sal.salary desc;

# 문제2. 전체 사원의 사번, 이름, 현재 직책을 이름 순서로 출력하세요.
select em.emp_no, concat(em.first_name, " ", em.last_name) as name, t.title
from employees as em
join titles as t
on em.emp_no = t.emp_no
order by name;

# 문제3. 전체 사원의 사번, 이름, 현재 부서를 이름 순서로 출력하세요.
select em.emp_no, concat(em.first_name, " ", em.last_name) as name, dp.dept_name
from employees as em
join dept_emp as dp_em
on em.emp_no = dp_em.emp_no
join departments as dp
on dp_em.dept_no = dp.dept_no
order by name;

# 문제4. 전체 사원의 사번, 이름, 연봉, 직책, 부서를 모두 이름 순서로 출력합니다.
select em.emp_no, concat(em.first_name, " ", em.last_name) as name, sal.salary, t.title, dp.dept_name
from employees as em
join salaries as sal 
on em.emp_no = sal.emp_no
join titles as t
on em.emp_no = t.emp_no
join dept_emp as dp_em
on em.emp_no = dp_em.emp_no
join departments as dp
on dp_em.dept_no = dp.dept_no
order by name;

# 문제5. "Technique Leader"의 직책으로 과거에 근무한 적이 있는 모든 사원의 사번과 이름을 출력하세요. 
# (현재 "Technique Leader"의 직책으로 근무하는 사원은 고려하지 않습니다.)
# 이름은 합쳐서 출력합니다.
select em.emp_no, concat(em.first_name, " ", last_name) as name
from employees as em
join titles as t
on em.emp_no = t.emp_no
where t.title = "Technique Leader"
and t.to_date not like "9999-%";

# 문제6. 직원 이름(last_name) 중에서 S(대문자)로 시작하는 직원들의 이름, 부서명, 직책을 조회하세요.
select concat(em.first_name, " ", last_name) as name, dp.dept_name, t.title
from employees as em
join dept_emp as dp_em
on em.emp_no = dp_em.emp_no
join departments as dp
on dp_em.dept_no = dp.dept_no
join titles as t
on em.emp_no = t.emp_no
where em.last_name like "S%";

# 문제7. 현재 직책이 "Engineer"인 사원 중에서 현재 급여가 40000 이상인 사원 중
# 급여가 큰 순서대로 출력하세요.
select concat(em.first_name, " ", last_name) as name, sal.salary, t.title
from employees as em
join salaries as sal 
on em.emp_no = sal.emp_no
join titles as t
on em.emp_no = t.emp_no
where t.to_date like "9999-%"
and sal.salary >= 40000
and t.title = "Engineer"
order by sal.salary desc;

# 문제8. 현재 급여가 50000이 넘는 직책을 직책, 급여로 급여가 큰 순서대로 출력하시오.
select t.title, sal.salary as salary
from employees as em
join salaries as sal 
on em.emp_no = sal.emp_no
join titles as t
on em.emp_no = t.emp_no
where t.to_date like "9999-%"
and salary >= 50000
order by salary desc;

# 문제9. 현재 부서별 평균 연봉을 연봉이 큰 부서 순서대로 출력하세요.
select dp.dept_name, round(avg(sal.salary)) as salary
from employees as em
join salaries as sal 
on em.emp_no = sal.emp_no
join dept_emp as dp_em
on em.emp_no = dp_em.emp_no
join departments as dp
on dp_em.dept_no = dp.dept_no
where t.to_date like "9999-%"
group by dp.dept_no
order by salary desc;

# 문제10. 현재 직책별 평균 연봉을 연봉이 큰 직책 순서대로 출력하세요.
select t.title, round(avg(sal.salary)) as avg_salary
from employees as em
join salaries as sal 
on em.emp_no = sal.emp_no
join titles as t
on em.emp_no = t.emp_no
where t.to_date like "9999-%"
group by t.title
order by avg_salary desc;
