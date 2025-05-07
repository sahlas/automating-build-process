from python_project_00.states_info import is_city_capital_of_state
import pytest

@pytest.mark.parametrize(
    "city_name, state, expected",
    [
        ("Boston", "Massachusetts", True),
        ("Albany", "New York", True),
        ("Albany", "Massachusetts", False),
    ],
)

def test_is_city_capital_of_state_parametrized(city_name, state, expected):
    assert is_city_capital_of_state(city_name=city_name, state=state) == expected


