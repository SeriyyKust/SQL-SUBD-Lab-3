drop table if exists logging;
create type action as enum('insert', 'update', 'delete', 'select');

create table logging(
	id serial not null,
	username text not null,
	action action not null,
	change text,
	timechange TIMESTAMP(6) not null
);

CREATE OR REPLACE FUNCTION audit()
  RETURNS TRIGGER 
  LANGUAGE PLPGSQL
  AS
$$
BEGIN
	IF (TG_OP = 'DELETE') THEN
		INSERT INTO logging(username, action, change, timechange) VALUES(current_user, 'delete', 
					format('name: ''%s''; department name: ''%s', old.fio_employee,old.department_name), now());
		RETURN OLD;
	ELSIF (TG_OP = 'UPDATE') THEN
		INSERT INTO logging(username, action, change, timechange) VALUES(current_user, 'update', 
					format('name employee: ''%s''jot_title: ''%s'' characteristic: ''%s', old.fio_employee, new.job_title, new.characteristic), now());
		RETURN NEW;
	ELSIF (TG_OP = 'INSERT') THEN
		INSERT INTO logging(username, action, change, timechange) VALUES(current_user, 'insert', 
					format('name employee: ''%s', new.fio_employee), now());
		RETURN NEW;
	END IF;
    RETURN NULL;
END;
$$;


CREATE OR REPLACE TRIGGER t_audit
	AFTER INSERT OR UPDATE OR DELETE ON tabletwo
	FOR EACH ROW EXECUTE PROCEDURE audit();

