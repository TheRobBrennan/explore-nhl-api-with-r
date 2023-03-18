import arrow
import json
import requests

from datetime import datetime as dt, timedelta

# Constants
OUTPUT_SEPARATOR = "\n\n*****\n\n"

# Date and time
START_DATE = dt.today() - timedelta(days=5)  # '2023-02-20 16:13:23.094026'
END_DATE = dt.today()   # '2023-02-25 16:13:23.094026'
LOCAL_DATE_TIME_FORMAT_STRING = "YYYY-MM-DD h:mma ZZZ"  # '2023-01-19 7:00pm PST'
LOCAL_YEAR_DATE_MONTH_FORMAT_STRING = "%Y-%m-%d"

# NHL API
NHL_API_BASE_URL = "https://statsapi.web.nhl.com/api/v1"
NHL_API_DATE_TIME_FORMAT_STRING = "%Y-%m-%dT%H:%M:%SZ"  # '2023-01-20T03:00:00Z'

# NHL settings and configuration
NHL_SEASON = 20222023
NHL_TEAM_ID_SEATTLE_KRAKEN = 55

# Click on an individual game in the scorebar at https://www.nhl.com to get the game ID
NHL_GAME_ID = 2022021098


def convertToLocalDateTimeString(dateTimeString):
    # Convert '2023-01-20T03:00:00Z' to '2023-01-19 7:00pm PST'
    # See https://arrow.readthedocs.io/en/latest/guide.html#supported-tokens
    return arrow.get(dt.strptime(
        dateTimeString, NHL_API_DATE_TIME_FORMAT_STRING)).to('local').format(LOCAL_DATE_TIME_FORMAT_STRING)


def convertToLocalYearMonthDayString(dateTime):
    return dateTime.strftime(LOCAL_YEAR_DATE_MONTH_FORMAT_STRING)


def printJSON(data, indent=0):  # Utility method to either log or pretty print JSON data
    if indent == 0:
        print(OUTPUT_SEPARATOR + data + OUTPUT_SEPARATOR)
    else:
        print(OUTPUT_SEPARATOR + json.dumps(data,
                                            indent=indent) + OUTPUT_SEPARATOR)


# Load live data for a specific game ID from the NHL API
def load_live_data_for_game(gameId):
    # https://statsapi.web.nhl.com/api/v1/game/2022020728/feed/live
    NHL_API_LIVE_GAME_DATA_URL = NHL_API_BASE_URL + \
        "/game/" + str(gameId) + "/feed/live"
    live_data = requests.get(NHL_API_LIVE_GAME_DATA_URL).json()
    return live_data


# Load schedule data for a specific season and team ID from the NHL API
def load_schedule_for_season_and_team(season, teamId):
    # Build our schedule URL using team information from above
    NHL_API_SCHEDULE_URL = NHL_API_BASE_URL + \
        "/schedule?season=" + str(season) + \
        "&teamId=" + str(teamId)
    season_schedule = requests.get(NHL_API_SCHEDULE_URL).json()
    printJSON(season_schedule, 1)
    return season_schedule


# Load schedule data using a specified start and end date for a specific team ID with an optional hydrate CSV string from the NHL API
def load_schedule_for_team_with_start_and_end_dates(teamId, startDate, endDate, hydrateCSVString=""):
    # https://statsapi.web.nhl.com/api/v1/schedule?startDate=2023-01-19&endDate=2023-01-21&hydrate=team,linescore,metadata,seriesSummary(series)&teamId=55

    # Build our partial schedule URL using team information from above
    NHL_API_PARTIAL_SCHEDULE_URL = NHL_API_BASE_URL + \
        "/schedule?" + \
        "&startDate=" + convertToLocalYearMonthDayString(startDate) + \
        "&endDate=" + convertToLocalYearMonthDayString(endDate) + \
        "&teamId=" + str(teamId) + \
        "&hydrate=" + hydrateCSVString
    partial_schedule = requests.get(NHL_API_PARTIAL_SCHEDULE_URL).json()
    printJSON(partial_schedule, 1)
    return partial_schedule


# ------------------------------------------------------------------------------------------------
# Examples
# ------------------------------------------------------------------------------------------------
try:
    print('\nLet\'s explore the NHL API with Python 🐍\n')

    # - Load the Seattle Kraken schedule for the 2022-23 season
    # print('\tLoad the Seattle Kraken schedule for the 2022-23 season...')
    # load_schedule_for_season_and_team(NHL_SEASON, NHL_TEAM_ID_SEATTLE_KRAKEN)

    # - Load a subset of Seattle Kraken games and hydrate our response with additional details
    # print('\tLoad a subset of Seattle Kraken games and hydrate our response with additional details...')
    # hydrateWithCSVString = "team,linescore,metadata,seriesSummary(series)"
    # load_schedule_for_team_with_start_and_end_dates(
    #     NHL_TEAM_ID_SEATTLE_KRAKEN, START_DATE, END_DATE, hydrateWithCSVString)

    # Load live data for a specific NHL game
    # print('\tLoad live data for a specific NHL game...\n')
    # content = load_live_data_for_game(NHL_GAME_ID)
    # printJSON(content, 1)

except:
    print('\nWelp, that didn\'t work as expected.\n')
# ------------------------------------------------------------------------------------------------
