drop trigger if exists check_sos_insert on table2;
drop trigger if exists check_sos_update on table2;

drop function if exists function_check_sos_update;
drop function if exists function_check_sos_insert;

create or replace function function_check_sos_insert()
	returns trigger
	language plpgsql
	as
$$
begin
	if ((new.fio_employee not in (select fio_boss from table1)) and 
	(((select sum(share_occupied_stavki) from table2 t2
	where new.fio_employee = t2.fio_employee) + new.share_occupied_stavki)
	> 1.5)) or
	((new.fio_employee in (select fio_boss from table1)) and 
	(((select sum(share_occupied_stavki) from table2 t2
	where new.fio_employee = t2.fio_employee)+ new.share_occupied_stavki) > 1.0))
	then
		raise exception 'UNABLE TO INSERT (share_occupied_stavki = %)', NEW.share_occupied_stavki; 
	else
		return new;
	end if;
end;
$$;

create trigger check_sos_insert
	before insert on table2
	for each row
	execute procedure function_check_sos_insert();


create or replace function function_check_sos_update()
	returns trigger
	language plpgsql
	as
$$
begin
	if ((new.fio_employee not in (select fio_boss from table1)) and 
	(((select sum(share_occupied_stavki) from table2 t2
	where new.fio_employee = t2.fio_employee) - 
	old.share_occupied_stavki + new.share_occupied_stavki) > 1.5)) or
	((new.fio_employee in (select fio_boss from table1)) and 
	(((select sum(share_occupied_stavki) from table2 t2
	where new.fio_employee = t2.fio_employee)- 
	old.share_occupied_stavki + new.share_occupied_stavki) > 1.0))
	then
		raise exception 'UNABLE TO UPDATE % to %', OLD.share_occupied_stavki, NEW.share_occupied_stavki; 
	else
		return new;
	end if;
end;
$$;


create trigger check_sos_update
	before update on table2
	for each row
	execute procedure function_check_sos_update();
