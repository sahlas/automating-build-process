# -*- coding: utf-8 -*-
"""Test slow_add function from slow module."""
# This file is part of the python_project_00 package.
# It is subject to the license terms in the LICENSE file found in the top-level
# directory of this distribution and at

import pytest
from python_project_00.slow import slow_add
from time import time

slow = pytest.mark.slow  # Simple MarkDecorator

@slow
def test_slow_add_no_delay():
    """Test slow_add with no delay."""
    result = slow_add(3, 5, delay=0)
    assert result == 8


def test_slow_add_with_delay():
    """Test slow_add with a delay."""
    start_time = time()
    result = slow_add(2, 4, delay=2)
    end_time = time()
    assert result == 6
    assert end_time - start_time >= 2


def test_slow_add_negative_numbers():
    """Test slow_add with negative numbers."""
    result = slow_add(-3, -7)
    assert result == -10


def test_slow_add_mixed_sign_numbers():
    """Test slow_add with mixed sign numbers."""
    result = slow_add(-5, 10)
    assert result == 5


def test_slow_add_large_numbers():
    """Test slow_add with large numbers."""
    result = slow_add(1000000, 2000000)
    assert result == 3000000
