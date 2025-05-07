from time import sleep

def slow_add(a: int, b: int, delay: int = 0) -> int:
    """Add two numbers with an intentional delay of 4 seconds.
    
    Args:
        a (int): The first number.
        b (int): The second number.
        delay (int, optional): Time in seconds to delay the operation. Defaults to 0.
    """
    if delay > 0:
        sleep(delay)
    return a + b

def subtract(a: int, b: int, delay: int = 0) -> int:
    """Subtract two numbers with an optional delay."""
    if delay > 0:
        sleep(delay)
    return a - b

def multiply(a: int, b: int) -> int:
    """Multiply two numbers."""
    return a * b
def divide(a: int, b: int) -> float:
    """Divide two numbers."""
    if b == 0:
        raise ValueError("Cannot divide by zero.")
    return a / b
def power(a: int, b: int) -> int:
    """Raise a number to the power of another."""
    return a ** b
def factorial(n: int) -> int:
    """Calculate the factorial of a number."""
    if n < 0:
        raise ValueError("Cannot calculate factorial of a negative number.")
    if n == 0 or n == 1:
        return 1
    result = 1
    for i in range(2, n + 1):
        result *= i
    return result
def fibonacci(n: int) -> int:
    """Calculate the nth Fibonacci number."""
    if n < 0:
        raise ValueError("Cannot calculate Fibonacci of a negative number.")
    if n == 0:
        return 0
    elif n == 1:
        return 1
    else:
        a, b = 0, 1
        for _ in range(2, n + 1):
            a, b = b, a + b
        return b