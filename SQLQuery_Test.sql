use ProjectManagement

-- NomeDipendente (concatenazione di Nome + Cognome)
-- Sesso (con la lettera 'M' o 'F')

select (e.Name + ' ' + e.Surname) as 'Name Surname', (CASE WHEN e.IsMale = 1 THEN 'M' ELSE 'F' END) as sex
from Employees as e

--Dipartimento (Name del dipartimento)
--Progetti (count dei progetti. NON si può usare un semplice count, come da mail di ieri!)

use ProjectManagement

select d.Name, SUM(case when p.ManagerId is not null then 1 else 0 end) as ProjectCount
from Departments as d
join  Employees as e ON d.Id = e.DepartmentId
join  Projects as p ON e.Id = p.ManagerId 
GROUP BY d.Name


-- Elenco di progetti non ancora chiusi.
-- Id (Id del progetto)
-- Dipartimento (Name del dipartimento del progetto, che sarebbe il nome del dipartimento del
-- manager!)
-- Nome (Name del progetto)
-- Manager (Nome del manager)

select p.Id as 'Project Id', d.Name as 'Department Name' , p.Name as 'Project name', (e.Name + ' ' + e.Surname) as 'Employee Name Surname'
from Projects  as p
join Employees as e on e.Id = p.ManagerId
join Departments as d on d.Id = e.DepartmentId
where (P.EndDate > getDate() or p.EndDate is Null)

-- Impiegato maschio che ha lavorato più ore a giugno, e quante ore ha fatto

select x.Name, x.NumberProjects
from
(select e.Name, count(h.quantity) as 'NumberProjects'
    from employees as e
    join hours as h on h.EmployeeId = e.Id
    where (month(h.Date) = 6 and e.IsMale = 1)
    group by e.name) x
    where (x.[NumberProjects]= 
        (select max(a.NumberProjects)
        from
        (select e.Name, count(h.quantity) as 'NumberProjects'
        from employees as e
        join hours as h on h.EmployeeId = e.Id
        where (month(h.Date) = 6 and e.IsMale = 1)
        group by e.name) a))


-- Impiegato femmina che ha lavorato più ore a giugno, e quante ore ha fatto

select x.Name, x.NumberProjects
from
(select e.Name, count(h.quantity) as 'NumberProjects'
    from employees as e
    join hours as h on h.EmployeeId = e.Id
    where (month(h.Date) = 6 and e.IsMale = 0)
    group by e.name) x
    where (x.[NumberProjects]= 
        (select min(a.NumberProjects)
        from
        (select e.Name, count(h.quantity) as 'NumberProjects'
        from employees as e
        join hours as h on h.EmployeeId = e.Id
        where (month(h.Date) = 6 and e.IsMale = 1)
        group by e.name) a))
