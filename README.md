# Documentation

## Part 1
The table definitions for Part 1 can be found in `schema.sql` under the **sql** folder

## Part 2
The code for Part 2 can all be found under the `process.py`. 

Python version `3.12` was used for this part's code, which is recommended for a consistent experience.

### Environment Setup
An `.env.template` is provided which contains an environment variable of which the PostgreSQL connection string is defined. 

Copy the `.env.template` file to `.env` and add the connection string to the env variable `CONNECTION`.

#### Create Environment
```
python -m venv .venv
```
#### Activate Environment
```
source .venv/bin/activate
```
#### Installing Python Dependencies
A `requirements.txt` has been provided to install all the necessary python dependencies that were used in this section.
```
pip install -r requirements.txt
```
### Running the code
To run the code for part 2, import the functions under the `process.py` module.
#### Example Usage
```{python}
import process

# For processing data for games table
process.process_games("games.csv")

# For processing data for linescores table
process.process_linescores("linescores.csv")

# For processing data for runner_play table
proccess.process_runners("runners.csv")

# This will process all games.csv files found under the test folder recursively.
process.process_games("<path>/test/**/games.csv") 
```

## Part 3
The queries for the part 3 can all be found under the **sql* folder. 
Each sql file under the folder is labelled corresponding to each question under this section (e.g. `3a.sql` contains the query solution to Question 3a and etc).

### 3 a)
The top 5 teams in regular season wins in 2025 are
1. Milwaukee Brewser (97 wins)
2. Philadelphia Phillies (96 wins)
3. New York Yankees (94 wins)
4. Toronto Blue Jays (94 wins)
5. Los Angeles Dodgers (93 wins)

### 3 b)
The players that had 35 or more stolen bases in the 2025 MLB regular season are:
1. José Caballero
2. José Ramírez
3. Chandler Simpson
4. Juan Soto
5. Oneil Cruz
6. Elly De La Cruz
7. Bobby Witt Jr.

**Note:** The result will be underestimated due to potential loss of information when summarizing runner's play. The event summary always naively chooses the last movement event type and movement (for simplicity) of the runner's play. This will cause in scenarios where the runner steals successfully + extra movement they won't be able to be counted.*

### 3 c)
The top 10 players that had the most extra bases taken are:
1. Elly De La Cruz
2. George Springer
3. Ernie Clement
4. Maikel Garcia
5. Mookie Betts
6. Aaron Judge
7. Fernando Tatis Jr.
8. CJ Abrams
9. TJ Friedl
10. Shohei Ohtani

### 3 d)
The team that had the largest deficit but came back to win in 2025:
| gamepk | team name | largest score deficit |
| -- | -- | -- |
| 776919 | Colorado Rockies | 9 |

### 3 e)
The top 5 teams that had the most come from behind wins in all games in 2025:
1. Toronto Blue Jays (62)
2. Los Angeles Dodgers (58)
3. Seattle Mariners (53)
4. Philadelphia Phillies (50)
5. San Francisco Giants (47)

### 3 f)
We define the baserunner's "aggressiveness" as the number of attempts in base stealing and extra bases taken.

The reason behind this definition is based on an assumption that being aggressive for base runners implies that they take risks outside of the expected play to advanced bases.

Since both base stealing and extra base taken are metrics that satisfy this criteria, then the number of attempts of such events (regardless if they get caught or not) can be used to dictate the amount of risk taking. Hence, under this definition, the higher number of said attempts means more frequent risk taking, which implies more aggressive base running.

*For simplicity, this query weighes each scenario equally*

So under this metric, the top 5 most aggressive baserunners are: 
| Runner Name | Aggressive Index|
| -- | -- |
| Elly De La Cruz | 96 |
|José Ramírez | 88 |
|Chandler Simpson | 83 |
|Maikel Garcia | 79 |
|Trea Turner | 78 |

*Aggressive Index = # of attempts on base stealing and extra base taken*