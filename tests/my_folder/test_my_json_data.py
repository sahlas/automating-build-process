import json
from pathlib import Path

import pytest

from python_project_00.my_folder.my_json_data import process_json_list

THIS_DIR = Path(__file__).parent
DATA_JSON_FPATH = THIS_DIR / "../../python_project_00/my_folder/my_data.json"



@pytest.fixture
def sample_json_file(tmp_path):
    """Fixture to create a sample JSON file for testing."""
    # Create a temporary JSON file for testing
    # test_data = {
    #     "items": ["item1", "item2", "item3"]
    # }
    # temp_file = tmp_path / "test_data.json"
    # with open(temp_file, "w") as file:
    #     json.dump(test_data, file)
    # return temp_file
    return DATA_JSON_FPATH  # Use the existing JSON file for testing



def test_process_json_list(capsys, sample_json_file):
    # Test the process_json_list function
    process_json_list(sample_json_file)
    captured = capsys.readouterr()
    assert "item1" in captured.out
    assert "item2" in captured.out
    assert "item3" in captured.out

def test_process_json_list_empty(capsys, tmp_path):
    # Test with an empty list in the JSON file
    test_data = {
        "items": []
    }
    temp_file = tmp_path / "test_data_empty.json"
    with open(temp_file, "w") as file:
        json.dump(test_data, file)

    process_json_list(temp_file)
    captured = capsys.readouterr()
    assert captured.out == ""

def test_process_json_list_missing_key(tmp_path):
    # Test with a missing 'items' key in the JSON file
    test_data = {
        "other_key": ["item1", "item2"]
    }
    temp_file = tmp_path / "test_data_missing_key.json"
    with open(temp_file, "w") as file:
        json.dump(test_data, file)

    with pytest.raises(KeyError):
        process_json_list(temp_file)
