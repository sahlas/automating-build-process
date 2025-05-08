from pathlib import Path

import pytest

from python_project_00.states_info import is_city_capital_of_state

THIS_DIR = Path(__file__).parent
CITIES_JSON_FPATH = THIS_DIR / "./my_folder/cities.json"

slow = pytest.mark.slow  # Simple MarkDecorator


# Test cases
def test_is_city_capital_of_state_valid():
    assert is_city_capital_of_state("Boston", "Massachusetts") is True
    assert is_city_capital_of_state("Albany", "New York") is True
    assert is_city_capital_of_state("Sacramento", "California") is True


def test_is_city_capital_of_state_invalid():
    assert is_city_capital_of_state("Boston", "California") is False
    assert is_city_capital_of_state("Albany", "Massachusetts") is False
    assert is_city_capital_of_state("Sacramento", "New York") is False


def test_is_city_capital_of_state_city_not_found(monkeypatch):
    assert is_city_capital_of_state("Not a City", "Massachusetts") is False
