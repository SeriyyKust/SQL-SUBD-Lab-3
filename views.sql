revoke all on database Labthree from employee_role3;
revoke all privileges on all tables in schema public from employee_role3;

revoke all on database Labthree from boss_role3;
revoke all privileges on all tables in schema public from boss_role3;


drop role if exists employee_role3;
drop role if exists boss_role3;

create role employee_role3;
create role boss_role3;


drop user if exists lilo3;
drop user if exists stich3;
drop user if exists petrovich3;

create user lilo3 with password 'lilo3';
create user stich3 with password 'stich3';
create user petrovich3 password 'petrovich3';

grant employee_role3 to lilo3;
grant boss_role3 to stich3;
grant boss_role3 to petrovich3;



--ALL VIEW
create or replace view info_all as
	select fio_employee, department_name, id_d1 as department_number, 
	fio_boss,share_occupied_stavki, job_title,characteristic, 
	number_of_stavok, payroll, number_of_employed_stavok
	from
	(select department_name, department_number as id_d1, fio_boss
	from tableone t1
	where (('employee_role3' in (SELECT rolname FROM pg_roles 
			WHERE pg_has_role(current_user, oid, 'member')))
	or
	(
		'boss_role3' in (SELECT rolname FROM pg_roles 
			WHERE pg_has_role(current_user, oid, 'member'))))
	and
	department_name in (SELECT department_name 
				from tabletwo where fio_employee = current_user)) v1
	left join
	(select fio_employee, department_number as id_d2, share_occupied_stavki,
		job_title, characteristic
		from tabletwo
		where (('employee_role3' in (SELECT rolname FROM pg_roles 
			WHERE pg_has_role(current_user, oid, 'member')))
			and
			   fio_employee = current_user)
	 		or
			((('boss_role3' in (SELECT rolname FROM pg_roles 
			WHERE pg_has_role(current_user, oid, 'member'))))
			and
			department_name in (SELECT department_name 
				from tableone where fio_boss = current_user))
			 or
			((('boss_role3' in (SELECT rolname FROM pg_roles 
			WHERE pg_has_role(current_user, oid, 'member'))))
			and
			fio_employee = current_user)
			 ) v2
		on (v1.id_d1 = v2.id_d2)
	left join 
	(select department_number as id_d3,
		number_of_stavok, payroll, number_of_employed_stavok
	from tableone t1
	where 
	(
		'boss_role3' in (SELECT rolname FROM pg_roles 
			WHERE pg_has_role(current_user, oid, 'member')))
	and
	fio_boss = current_user) v3
	on (v2.id_d2 = v3.id_d3)

grant select on info_all to employee_role3;
grant select on info_all to boss_role3;


grant update(job_title,characteristic) on info_all to boss_role3;


CREATE OR REPLACE FUNCTION update_job_title_characteristic()
  RETURNS TRIGGER LANGUAGE PLPGSQL AS
$$
BEGIN
	if(old.department_number in (select department_number from info_all
		where current_user = fio_boss))then
		return new;
	else
		raise exception 'error: permission deny';
	end if;
END;
$$;


CREATE OR REPLACE FUNCTION update_info_all_job_title()
  RETURNS TRIGGER LANGUAGE PLPGSQL AS
$$
BEGIN
	if(old.job_title != new.job_title) then
		UPDATE tabletwo SET job_title = new.job_title where department_number = old.department_number and fio_employee = old.fio_employee;
	elseif(old.job_title is NULL or new.job_title is NULL) then
		UPDATE tabletwo SET job_title = NEW.job_title where department_number = old.department_number and fio_employee = old.fio_employee;
	elseif(old.characteristic != new.characteristic) then
		UPDATE tabletwo SET characteristic = new.characteristic where department_number = old.department_number and fio_employee = old.fio_employee;
	elseif(old.characteristic is NULL or new.characteristic is NULL) then
		UPDATE tabletwo SET characteristic = NEW.characteristic where department_number = old.department_number and fio_employee = old.fio_employee;
	END IF;
	RETURN NEW;
END;
$$;


CREATE OR REPLACE TRIGGER trigger_update_tabletwo
	BEFORE UPDATE ON tabletwo
	FOR EACH ROW EXECUTE PROCEDURE update_job_title_characteristic();

CREATE OR REPLACE TRIGGER trigger_update_info_all_job_title
	INSTEAD OF UPDATE ON info_all
	FOR EACH ROW EECXUTE PROCEDURE update_info_all_job_title();


grant select(department_number, fio_employee) update(job_title, characteristic) on tabletwo to boss_role3;
grant all on logging to boss_role3;
grant usage, select on sequence logging_id_seq to boss_role3;