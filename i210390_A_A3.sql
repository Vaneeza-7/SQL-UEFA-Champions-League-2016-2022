create database assignment3
use assignment3

CREATE TABLE cities (
    cityname VARCHAR(50) primary key not null,
    countryname VARCHAR(50),
);
drop table cities
CREATE TABLE stadiums (
    sid VARCHAR(10) PRIMARY KEY not null,
    name VARCHAR(50),
    city VARCHAR(50),
    capacity INT
	foreign key(city) references cities(cityname)
);

drop table stadiums
CREATE TABLE teams (
    team_id VARCHAR(10) PRIMARY KEY not null,
    team_name VARCHAR(50),
    country VARCHAR(50),
    stadium VARCHAR(10)
	foreign key(stadium) references stadiums(sid)
);

drop table teams

CREATE TABLE players (
    pid VARCHAR(10) PRIMARY KEY not null,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    nationality VARCHAR(50),
    dob DATE,
    team_id VARCHAR(10),
    jy_num INT,
    position VARCHAR(20),
    height INT,
    weight INT,
    foot CHAR CHECK (foot = 'R' OR foot = 'L')
	foreign key(team_id) references teams(team_id)
);
drop table players

CREATE TABLE managers (
    mid VARCHAR(10) PRIMARY KEY not null,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    nationality VARCHAR(50),
    dob DATE,
    team VARCHAR(10)
	foreign key(team) references teams(team_id)
);
drop table matches

CREATE TABLE matches (
    mid VARCHAR(10) PRIMARY KEY not null,
    season VARCHAR(10),
	date_time TIMESTAMP,
	home_team VARCHAR(10),
    away_team VARCHAR(10),
    stadium VARCHAR(10),
	ht_score INT,
    at_score INT,
    pso INT CHECK (pso = 0 OR pso = 1),
    attendance INT
	foreign key(home_team) references teams(team_id),
	foreign key(away_team) references teams(team_id),
	foreign key(stadium) references stadiums(sid)
	
);
drop table managers

CREATE TABLE goals (
    goal_id VARCHAR(10) PRIMARY KEY not null,
    match_id VARCHAR(10),
    pid VARCHAR(10),
    duration INT,
    assist VARCHAR(10),
    goal_desc VARCHAR(25)
	foreign key(match_id) references matches(mid),
	foreign key(pid) references players(pid),
	foreign key(assist) references players(pid)
);

select* from cities
select* from players
select* from stadiums
select* from goals
select* from managers
select* from matches
select* from teams

SELECT match_id, season, CAST(date_time AS DATETIME) AS dateTime from matches 

select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS

select C.COLUMN_NAME FROM  
INFORMATION_SCHEMA.TABLE_CONSTRAINTS T  
JOIN INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE C  
ON C.CONSTRAINT_NAME=T.CONSTRAINT_NAME  
WHERE  
C.TABLE_NAME='players'  
and T.CONSTRAINT_TYPE='PRIMARY KEY' 

select* from managers
-----------------QUERIES--------------

--1. All the players that have played under a specific manager.

select player_id, CONCAT(players.first_name,' ', players.last_name) as PlayerName, 
players.nationality, players.dob, players.team_id, jersey_number, 
position, height, weight, foot   
from dbo.players inner join dbo.managers 
on players.team_id=managers.team_id 

--2. All the matches that have been played in a specific country.

select match_id, season, CAST(date_time AS DATETIME) AS dateTime, matches.home_team_id, matches.away_team_id, matches.home_team_score,
matches.away_team_score, matches.penalty_shoot_out, matches.attendance,matches.stadium_id ,cities.country_name from matches
inner join stadiums on matches.stadium_id=stadiums.sid 
inner join cities on cities.city_name=stadiums.city
order by country_name

--3. All the teams that have won more than 3 matches in their home stadium.
--(Assume a team wins only if they scored more goals then other team)

select team_id, team_name, count(home_team_id) as NumberofWins 
from matches 
inner join teams on matches.home_team_id = teams.team_id --join on home teams id not on home team stadiums
where home_team_score > away_team_score
group by team_id, team_name
having count(*) >3

--4. All the teams with foreign managers.

select teams.team_id, teams.team_name, teams.country, managers.nationality as ManagerNationality 
from teams
inner join managers on managers.team_id = teams.team_id
where teams.country!=managers.nationality


--5. All the matches that were played in stadiums with seating capacity greater
--than 60,000.

select match_id, season, CAST(date_time AS DATETIME) AS dateTime, stadium_id, capacity 
from matches
inner join stadiums on stadiums.sid=matches.stadium_id
where stadiums.capacity>60000

--6. All Goals made without an assist in 2020 by players having height greater
--than 180 cm.

select goal_id, goals.match_id, pid, assist, goal_desc, duration, height as playerHeight from goals 
inner join matches on matches.match_id=goals.match_id 
inner join players on players.player_id = goals.pid
where season = '2020-2021'
and assist is null
and players.height >180

--7. All Russian teams with win percentage less than 50% in home matches.

select team_id, team_name, country,
count(*) as matchesPlayed,
count(case when home_team_score > away_team_score then 1 else null end) as NumberofWins,
cast(count(case when home_team_score > away_team_score then 1 else null end) as float) / count(*) *100  as winPercentage
from matches t1
inner join teams on home_team_id = team_id --join on home teams id not on home team stadiums
where country='Russia'  
group by team_id, team_name, country
having cast(count(case when home_team_score > away_team_score then 1 else null end) as float) / count(*) *100 <50

--8. All Stadiums that have hosted more than 6 matches with host team having
--a win percentage less than 50%.

select sid, name, city,
count(*) as matchesHosted,
count(case when home_team_score > away_team_score then 1 else null end) as HostWins,
cast(count(case when home_team_score > away_team_score then 1 else null end) as float) / count(*) *100  as winPercentage
from matches t1
inner join stadiums on sid = stadium_id --join on home teams id not on home team stadiums  
group by sid, name, city
having cast(count(case when home_team_score > away_team_score then 1 else null end) as float) / count(*) *100 <50
and count(*) > 6

--9. The season with the greatest number of left-foot goals.

select matches.season, goals.goal_desc, count(goals.goal_id) as NumberofGoals
from matches 
inner join goals on matches.match_id=goals.match_id
where goals.goal_desc like '%left-footed%'
group by season, GOAL_DESC
having count(goals.goal_id)=
(select max(NumberofGoals)
 from (
 select matches.season, goals.goal_desc, count(goals.goal_id) as NumberofGoals
 from matches 
 inner join goals on matches.match_id=goals.match_id
 where goals.goal_desc like '%left-footed%'
 group by season, GOAL_DESC
      ) as t
)

--select matches.season, goals.goal_desc, count(goals.goal_id) as NumberofGoals
--from matches 
--inner join goals on matches.match_id=goals.match_id
--where goals.goal_desc like '%left-footed%'
--group by season, GOAL_DESC
--order by NumberofGoals desc

--10. The country with maximum number of players with at least one goal.

select top 1 nationality as country,
count(case when pid is not null then 1 else null end) as goalsMade,
count (distinct pid) as NumberofPlayers
from goals
inner join players on goals.PID=players.player_id
group by nationality
order by NumberofPlayers desc

--11.All the stadiums with greater number of left-footed shots than right-footed
--shots.
select * from goals
select distinct sid, name, city, capacity
from stadiums
inner join matches on matches.stadium_id = stadiums.sid
where matches.match_id in  
(select match_id
--count(case when goal_desc like '%left-footed%' then 1 else null end) as leftFootedGoals,
--count(case when goal_desc like '%right-footed%' then 1 else null end) as rightFootedGoals
from goals 
group by match_id
having count(case when goal_desc like '%left-footed%' then 1 else null end)  >
count(case when goal_desc like '%right-footed%' then 1 else null end) 
)



select* from matches


select match_id,
count(case when goal_desc like '%left-footed%' then 1 else null end) as leftFootedGoals,
count(case when goal_desc like '%right-footed%' then 1 else null end) as rightFootedGoals
from goals 
group by match_id