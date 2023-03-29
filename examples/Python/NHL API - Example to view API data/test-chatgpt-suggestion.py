import unittest
from datetime import datetime as dt, timedelta
import NHLAPIExample  # assuming your code is in a file named "NHLAPIExample.py"


class TestNHLAPI(unittest.TestCase):

    def setUp(self):
        self.start_date = dt.today() - timedelta(days=5)
        self.end_date = dt.today()
        self.team_id = NHLAPIExample.NHL_TEAM_ID_SEATTLE_KRAKEN
        self.season = NHLAPIExample.NHL_SEASON
        self.game_id = NHLAPIExample.NHL_GAME_ID
        self.hydrate_csv_string = "team,linescore,metadata,seriesSummary(series)"

    def test_convertToLocalDateTimeString(self):
        input_date_time_string = "2023-01-20T03:00:00Z"
        expected_output = "2023-01-19 7:00pm PST"
        self.assertEqual(NHLAPIExample.convertToLocalDateTimeString(
            input_date_time_string), expected_output)

    def test_convertToLocalYearMonthDayString(self):
        input_date = dt(2023, 3, 28)
        expected_output = "2023-03-28"
        self.assertEqual(NHLAPIExample.convertToLocalYearMonthDayString(
            input_date), expected_output)

    def test_load_live_data_for_game(self):
        live_data = NHLAPIExample.load_live_data_for_game(self.game_id)
        self.assertIsNotNone(live_data)

    def test_load_schedule_for_season_and_team(self):
        schedule_data = NHLAPIExample.load_schedule_for_season_and_team(
            self.season, self.team_id)
        self.assertIsNotNone(schedule_data)

    def test_load_schedule_for_team_with_start_and_end_dates(self):
        schedule_data = NHLAPIExample.load_schedule_for_team_with_start_and_end_dates(
            self.team_id, self.start_date, self.end_date, self.hydrate_csv_string)
        self.assertIsNotNone(schedule_data)


if __name__ == '__main__':
    unittest.main()
