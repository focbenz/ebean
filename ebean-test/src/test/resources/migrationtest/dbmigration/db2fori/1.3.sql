-- Migrationscripts for ebean unittest
-- drop dependencies
alter table migtest_ckey_detail drop constraint fk_migtest_ckey_detail_parent;
alter table migtest_fk_cascade drop constraint fk_migtest_fk_cascade_one_id;
alter table migtest_fk_none drop constraint fk_migtest_fk_none_one_id;
alter table migtest_fk_none_via_join drop constraint fk_migtest_fk_none_via_join_one_id;
alter table migtest_fk_set_null drop constraint fk_migtest_fk_set_null_one_id;
alter table migtest_e_basic drop constraint ck_migtest_e_basic_status;
alter table migtest_e_basic drop constraint ck_migtest_e_basic_status2;
alter table migtest_e_basic drop constraint uq_migtest_e_basic_description;
alter table migtest_e_basic drop constraint fk_migtest_e_basic_user_id;
alter table migtest_e_basic drop constraint uq_migtest_e_basic_status_indextest1;
alter table migtest_e_basic drop constraint uq_migtest_e_basic_name;
alter table migtest_e_basic drop constraint uq_migtest_e_basic_indextest4;
alter table migtest_e_basic drop constraint uq_migtest_e_basic_indextest5;
alter table migtest_e_enum drop constraint ck_migtest_e_enum_test_status;
drop index ix_migtest_e_basic_indextest3;
drop index ix_migtest_e_basic_indextest6;
-- apply changes
create table migtest_e_ref (
  id                            integer generated by default as identity not null,
  name                          varchar(127) not null,
  constraint pk_migtest_e_ref primary key (id)
);


update migtest_e_basic set status2 = 'N' where status2 is null;

update migtest_e_basic set user_id = 23 where user_id is null;

-- NOTE: table has @History - special migration may be necessary
update migtest_e_history6 set test_number2 = 7 where test_number2 is null;
-- apply alter tables
alter table migtest_e_basic alter column status drop default;
alter table migtest_e_basic alter column status drop not null;
alter table migtest_e_basic alter column status2 set data type varchar(1);
alter table migtest_e_basic alter column status2 set default 'N';
alter table migtest_e_basic alter column status2 set not null;
alter table migtest_e_basic alter column user_id set default 23;
alter table migtest_e_basic alter column user_id set not null;
alter table migtest_e_basic add column description_file blob(64M);
alter table migtest_e_basic add column old_boolean smallint default 0 default false not null;
alter table migtest_e_basic add column old_boolean2 smallint default 0;
alter table migtest_e_basic add column eref_id integer;
alter table migtest_e_history2 alter column test_string drop default;
alter table migtest_e_history2 alter column test_string drop not null;
alter table migtest_e_history2 add column obsolete_string1 varchar(255);
alter table migtest_e_history2 add column obsolete_string2 varchar(255);
alter table migtest_e_history4 alter column test_number set data type integer;
alter table migtest_e_history6 alter column test_number1 drop default;
alter table migtest_e_history6 alter column test_number1 drop not null;
alter table migtest_e_history6 alter column test_number2 set default 7;
alter table migtest_e_history6 alter column test_number2 set not null;
-- apply post alter
alter table migtest_e_ref add constraint uq_migtest_e_ref_name unique  (name);
alter table migtest_e_basic add constraint ck_migtest_e_basic_status check ( status in ('N','A','I'));
alter table migtest_e_basic add constraint ck_migtest_e_basic_status2 check ( status2 in ('N','A','I'));
create unique index uq_migtest_e_basic_indextest2 on migtest_e_basic(indextest2) exclude null keys;
create unique index uq_migtest_e_basic_indextest6 on migtest_e_basic(indextest6) exclude null keys;
alter table migtest_e_enum add constraint ck_migtest_e_enum_test_status check ( test_status in ('N','A','I'));
comment on column migtest_e_history.test_string is '';
comment on table migtest_e_history is '';
-- foreign keys and indices
alter table migtest_fk_cascade add constraint fk_migtest_fk_cascade_one_id foreign key (one_id) references migtest_fk_cascade_one (id) on delete cascade;
alter table migtest_fk_set_null add constraint fk_migtest_fk_set_null_one_id foreign key (one_id) references migtest_fk_one (id) on delete set null;
create index ix_migtest_e_basic_eref_id on migtest_e_basic (eref_id);
alter table migtest_e_basic add constraint fk_migtest_e_basic_eref_id foreign key (eref_id) references migtest_e_ref (id) on delete restrict;

create index ix_migtest_e_basic_indextest1 on migtest_e_basic (indextest1);
create index ix_migtest_e_basic_indextest5 on migtest_e_basic (indextest5);