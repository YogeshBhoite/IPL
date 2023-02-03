--Task 1
drop database ipl;

--Task 2
create database ipl;

--Task 3
use ipl;

--Task 4 Importing tables from disk

--Task 5 
select * from deliveries limit 20; 
 
--Task 6 
select * from matches limit 20; 
 
--Task 7 
select * from matches where date = '2008-04-27'; 
 
--Task 8 
select * from matches where result = 'runs' and result_margin > 100; 
 
--Task 9 
select * from matches where result ='runs' order by date desc; 
 
--Task 10 
select count(distinct city) from matches; 
 
--Task 11 
create table deliveries_v02 as select *,  
    CASE WHEN total_runs >= 4 then 'boundary'  
         WHEN total_runs = 0 THEN 'dot' 
   else 'other' 
     END as ball_result  
   FROM deliveries; 
   
select * from deliveries_v02;
 
--Task 12 
select ball_result, count(*) from deliveries_v02 group by ball_result; 
 
--Task 13 
select batting_team, count(*) from deliveries_v02 where ball_result = 'boundary' group by batting_team; 
 
--Task 14 
select bowling_team, count(*) from deliveries_v02 where ball_result = 'dot' group by bowling_team; 
 
--Task 15 
select dismissal_kind, count(*) from deliveries where dismissal_kind <> 'NA' group by dismissal_kind; 
 
--Task 16 
select bowler, sum(extra_runs) as total_extra_runs from deliveries group by bowler order by total_extra_runs desc limit 5; 
 
--Task 17 
create table  deliveries_v03 AS SELECT a.*, b.venue, b.match_date from  
deliveries_v02 as a  
left join (select max(venue) as venue, max(date) as match_date, id from matches group by id) as b 
on a.id = b.id; 
 
 select * from deliveries_v03;
 
--Task 18 
select venue, sum(total_runs) as runs from deliveries_v03 group by venue order by runs desc; 
 
--Task 19 
select extract(year from match_date) as IPL_year, sum(total_runs) as runs from  deliveries_v03  
where venue = 'M Chinnaswamy Stadium' group by IPL_year order by runs desc; 
 
--Task 20 
select distinct team1 from matches; 

create table matches_corrected as select *, replace(team1, 'Delhi Daredevils', 'Delhi Kings') as team1_corr 
, replace(team2, 'Delhi Daredevils', 'Delhi Kings') as team2_corr from matches; 

select * from matches_corrected;
 
select distinct team1_corr from matches_corrected; 
 
--Task 21 
create table deliveries_v04 
as select concat(id, '-', inning, '-', overs, '-', ball) 
as ball_id from deliveries_v03; 

select * from deliveries_v04;
 
--Task 22 
select * from deliveries_v04 limit 20; 
select count(distinct ball_id) from deliveries_v04; 
select count(*) from deliveries_v04; 
 
--Task 23 
drop table deliveries_v05; 
create table deliveries_v05 as select *, row_number() over (partition by ball_id) as r_num from deliveries_v04; 
 select * from deliveries_v05;
 
--Task 24 
select count(*) from deliveries_v05; 
select sum(r_num) from deliveries_v05; 
select * from deliveries_v05 order by r_num  limit 20; 
select * from deliveries_v05 WHERE r_num=1; 
 
--Task 25 
SELECT * FROM deliveries_v05 WHERE ball_id in (select BALL_ID from deliveries_v05 WHERE r_num=1); 