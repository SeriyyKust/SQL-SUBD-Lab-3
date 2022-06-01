drop TABLE if exists tabletwo CASCADE;
drop TABLE if exists tableone CASCADE;

/*Create new tables */
CREATE TABLE tableone(
	department_name text not null,
	department_number int not null,
	fio_boss text not null,
	number_of_stavok int not null,
	payroll int not null,
	number_of_employed_stavok int not null,
	constraint pk_tableone primary key (department_name, department_number),
	constraint ak1_tableone unique (department_number, fio_boss)
);

CREATE TABLE tabletwo(
	fio_employee text not null,
	department_name text not null,
	department_number int not null,
	share_occupied_stavki float not null,
	job_title text not null,
	characteristic  text not null,
	/*constraint pk_tabletwo primary key (fio_employee),*/
	constraint fk1_tabletwo foreign key (department_name, department_number) references tableone(department_name, department_number)
);
/* INSERT Some data */
INSERT INTO tableone (department_name, department_number, fio_boss, number_of_stavok, payroll, number_of_employed_stavok)
VALUES ('grobovichkov', 1, 'rodrigez3', 50, 1000, 5);
INSERT INTO tableone (department_name, department_number, fio_boss, number_of_stavok, payroll, number_of_employed_stavok)
VALUES ('ost', 2, 'petrovich3', 16, 1705, 7);
INSERT INTO tableone (department_name, department_number, fio_boss, number_of_stavok, payroll, number_of_employed_stavok)
VALUES ('ohana', 3, 'stich3', 9, 98, 43);
/* Insert boss's data */
INSERT INTO tabletwo (fio_employee, department_name, department_number, share_occupied_stavki, job_title, characteristic)
VALUES ('petrovich3', 'ost', 2, 0.7, 'boss', 'good');
INSERT INTO tabletwo (fio_employee, department_name, department_number, share_occupied_stavki, job_title, characteristic)
VALUES ('rodrigez3', 'grobovichkov', 1, 0.7, 'boss', 'bad');
INSERT INTO tabletwo (fio_employee, department_name, department_number, share_occupied_stavki, job_title, characteristic)
VALUES ('stich3', 'ohana', 3, 0.7, 'boss', 'greate');
/* Insert employee's data */
INSERT INTO tabletwo (fio_employee, department_name, department_number, share_occupied_stavki, job_title, characteristic)
VALUES ('sveta3', 'grobovichkov', 1, 1.0, 'employee', 'good');
INSERT INTO tabletwo (fio_employee, department_name, department_number, share_occupied_stavki, job_title, characteristic)
VALUES ('sergey3', 'ost', 2, 1.3, 'employee', 'bad');
INSERT INTO tabletwo (fio_employee, department_name, department_number, share_occupied_stavki, job_title, characteristic)
VALUES ('lilo3', 'ohana', 3, 0.5, 'employee', 'greate');
INSERT INTO tabletwo (fio_employee, department_name, department_number, share_occupied_stavki, job_title, characteristic)
VALUES ('petrovich3', 'ohana', 3, 0.3, 'employee', 'good');
INSERT INTO tabletwo (fio_employee, department_name, department_number, share_occupied_stavki, job_title, characteristic)
VALUES ('rodrigez3', 'ohana', 3, 0.3, 'employee', 'bad');
INSERT INTO tabletwo (fio_employee, department_name, department_number, share_occupied_stavki, job_title, characteristic)
VALUES ('stich3', 'ost', 2, 0.2, 'employee', 'greate');
INSERT INTO tabletwo (fio_employee, department_name, department_number, share_occupied_stavki, job_title, characteristic)
VALUES ('stich3', 'grobovichkov', 1, 0.1, 'employee', 'greate');
/* Foreign key */
--ALTER TABLE tableone add constraint fk_tableone foreign key (fio_boss) references tabletwo(fio_employee);
