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

SELECT match_id, CAST(date_time AS DATETIME) AS dateTime from matches 

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

select team_id, team_name, count(*) as matches_won_in_HomeStd from teams inner join 
matches on matches.stadium_id=teams.home_stadium_id where home_team_score>away_team_score
group by team_id, team_name
having count(*) >3

select count(home_team_id) as matches_won , team_id 
from matches 
inner join teams on teams.home_stadium_id = matches. stadium_id 
where home_team_id in (select home_team_id from matches where 
--matches.home_team_id =teams.team_id  and 
home_team_score > away_team_score)
group by team_id


select * from matches where home_team_id=15 
and home_team_score > away_team_score

select count(home_team_id) as matches_won, match_id
from matches
where home_team_score > away_team_score
group by match_id

select team_id, team_name, country, home_stadium_id from teams inner join matches on matches.stadium_id = teams.home_stadium_id
where teams.team_id in 
(select home_team_id from matches where home_team_score > away_team_score )

select count(home_team_id) as matches_won, team_id
from matches 
inner join teams on matches.stadium_id = teams.home_stadium_id
where home_team_score > away_team_score
group by team_id
having count(*) >3

SELECT matches.home_team_id, COUNT(matches.home_team_id) AS NumberOfWins FROM matches
inner JOIN teams ON teams.home_stadium_id = matches.stadium_id
where home_team_score > away_team_score

GROUP BY home_team_id;

select* from teams