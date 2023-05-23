# SQL-UEFA-Champions-League-2016-2022
![Language](https://img.shields.io/badge/Language-SQL-blue)

This repository contains the code for SQL database of UEFA champions league (2016-2022), involving the creation of a database schema and various SQL queries. The database schema is designed to store information related to football matches, teams, players, stadiums, goals, and managers.

## Schema

The database schema consists of the following tables:

- `cities`: Stores information about cities, including the city name and country name.
- `stadiums`: Stores information about stadiums, including the stadium ID, name, city, and seating capacity. It also has a foreign key relationship with the `cities` table.
- `teams`: Stores information about football teams, including the team ID, name, country, and the stadium they play in. It has a foreign key relationship with the `stadiums` table.
- `players`: Stores information about football players, including the player ID, first name, last name, nationality, date of birth, team ID, jersey number, position, height, weight, and preferred foot. It has a foreign key relationship with the `teams` table.
- `managers`: Stores information about football managers, including the manager ID, first name, last name, nationality, date of birth, and team they manage. It has a foreign key relationship with the `teams` table.
- `matches`: Stores information about football matches, including the match ID, season, date and time, home team ID, away team ID, stadium ID, scores, penalty shoot-out status, and attendance. It has foreign key relationships with the `teams` and `stadiums` tables.
- `goals`: Stores information about goals scored in matches, including the goal ID, match ID, player ID, goal duration, assisting player ID, and goal description. It has foreign key relationships with the `matches` and `players` tables.

## Queries

The SQL code includes several sample queries that can be executed on the database. These queries cover a range of scenarios, such as
- Retrieve all the players that have played under a specific manager.
- Fetch all the matches that have been played in a specific country.
- Retrieve all the teams that have won more than 3 matches in their home stadium.
- Retrieve all the teams with foreign managers.
- Fetch all the matches that were played in stadiums with a seating capacity greater than 60,000.
- And more...

Please refer to the SQL files for the complete list of queries and their descriptions.

## How to Use

To set up the database, execute the SQL code in a database management system that supports the SQL syntax used in the code. The code can be copied and pasted into an SQL editor or executed directly from a file.

Make sure to create a database named `assignment3` before executing the code. Once the code is executed, you can run the provided sample queries to retrieve specific information from the database.

## License

This project is licensed under the [MIT License](LICENSE).

