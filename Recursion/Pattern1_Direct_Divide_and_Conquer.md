---
### 1. Recursive Implementation of atoi()
`[MEDIUM]` `#recursion` `#string-manipulation`

#### Problem Statement
The `atoi()` function converts a string to an integer. The function should handle optional leading whitespace, an optional sign character ('+' or '-'), and a sequence of digits. It should stop parsing when it encounters a non-digit character and handle integer overflow by clamping the result to the `INT_MAX` or `INT_MIN` range. Implement the core logic of this function recursively.

**Example 1:**
- **Input:** "42"
- **Output:** 42

**Example 2:**
- **Input:** "   -42"
- **Output:** -42

**Example 3:**
- **Input:** "4193 with words"
- **Output:** 4193

#### Implementation Overview
A recursive solution processes the string one character at a time. The main recursive function takes the current index, sign, and accumulated result as parameters.

1.  **Base Case:** The recursion stops when the index reaches the end of the string or a non-digit character is found. At this point, the final result (multiplied by the sign) is returned.
2.  **Recursive Step:**
    - The function is called with the next index (`index + 1`).
    - The current character is converted to a digit.
    - Before adding the digit to the result, check for potential overflow. If `result > (INT_MAX - digit) / 10`, it means adding the next digit will cause an overflow. In this case, return `INT_MAX` or `INT_MIN` depending on the sign.
    - The digit is added to the accumulated result: `result = result * 10 + digit`.
3.  **Initial Call:** A helper function is used to handle leading whitespace and the optional sign. It determines the sign and the starting index of the digits before making the first call to the recursive function.

#### Tricks/Gotchas
- **Integer Overflow:** This is the main challenge. The check `result > (INT_MAX - digit) / 10` must be performed *before* the multiplication to prevent the intermediate value itself from overflowing.
- **Leading Whitespace:** The string must be trimmed of leading spaces before processing begins.
- **Sign Character:** The sign ('+' or '-') is processed only once at the beginning.
- **Empty/Invalid String:** If the string contains no valid digits after whitespace and sign, the result is 0.

---
### 2. Pow(x, n)
`[MEDIUM]` `#recursion` `#divide-and-conquer` `#binary-exponentiation`

#### Problem Statement
Implement `pow(x, n)`, which calculates `x` raised to the power `n` (i.e., x^n).

**Example 1:**
- **Input:** x = 2.00000, n = 10
- **Output:** 1024.00000

**Example 2:**
- **Input:** x = 2.10000, n = 3
- **Output:** 9.26100

**Example 3:**
- **Input:** x = 2.00000, n = -2
- **Output:** 0.25000 (1/4)

#### Implementation Overview
The naive approach of multiplying `x` by itself `n` times is too slow (O(n)). A much more efficient solution uses recursion with a divide-and-conquer approach, often called binary exponentiation.

The core idea is based on the following observations:
- `x^n = x^(n/2) * x^(n/2)` if `n` is even.
- `x^n = x * x^((n-1)/2) * x^((n-1)/2)` if `n` is odd.

1.  **Base Case:** If `n` is 0, the result is 1.
2.  **Recursive Step:**
    - Call the function recursively with `n/2`. Let the result be `half`.
    - Square `half` to get `half * half`.
    - If `n` is even, this squared value is the answer.
    - If `n` is odd, multiply the squared value by `x` one more time.
3.  **Handling Negative Exponents:** If `n` is negative, the problem becomes calculating `(1/x)^(-n)`. The initial call can handle this by converting `x` to `1/x` and `n` to `-n`.

This approach reduces the time complexity to O(log n) because the problem size is halved at each recursive step.

#### Python Code Snippet
```python
def myPow(x: float, n: int) -> float:
    if n == 0:
        return 1.0

    # Handle negative exponent
    if n < 0:
        x = 1 / x
        n = -n

    # Recursive calculation using binary exponentiation
    def power(base, exp):
        if exp == 0:
            return 1.0

        half = power(base, exp // 2)
        half_sq = half * half

        if exp % 2 == 0:
            return half_sq
        else:
            return base * half_sq

    return power(x, n)
```

#### Tricks/Gotchas
- **Negative Exponent:** The most common edge case. Remember that `x^-n = 1 / x^n`.
- **Integer Minimum:** If `n` is the minimum integer value (e.g., -2^31), then `-n` will cause an overflow. This can be handled by calculating `x * myPow(x, n + 1)` for the negative case, or by using a 64-bit integer for the exponent.
- **Floating-Point Precision:** Be aware of standard floating-point inaccuracies, although for this problem it's usually not a major issue.

---
### 3. Count Good numbers
`[EASY]` `#recursion` `#modular-arithmetic`

#### Problem Statement
A digit string is called "good" if the digits at even indices are even (0, 2, 4, 6, 8) and the digits at odd indices are prime (2, 3, 5, 7). Given an integer `n`, return the total number of good digit strings of length `n`. Since the answer may be large, return it modulo 10^9 + 7.

**Example 1:**
- **Input:** n = 1
- **Output:** 5 (The strings "0", "2", "4", "6", "8")

**Example 2:**
- **Input:** n = 4
- **Output:** 400

#### Implementation Overview
This problem can be solved by observing the number of choices for each position.
-   **Even indices:** 5 choices (0, 2, 4, 6, 8)
-   **Odd indices:** 4 choices (2, 3, 5, 7)

The total number of good strings is the product of the number of choices for each position.
-   Number of even indices in a string of length `n`: `ceil(n / 2.0)` which is `(n + 1) // 2`.
-   Number of odd indices in a string of length `n`: `floor(n / 2.0)` which is `n // 2`.

Total count = (5 ^ number of even indices) * (4 ^ number of odd indices)

Since `n` can be large, we cannot compute the powers directly. We must use a recursive function for modular exponentiation (similar to the `Pow(x, n)` problem) to calculate `(base^exp) % mod` efficiently in O(log exp) time.

The final result is `(pow(5, (n+1)//2, mod) * pow(4, n//2, mod)) % mod`.

#### Tricks/Gotchas
- **Modular Arithmetic:** All intermediate calculations for the powers must be done modulo 10^9 + 7 to prevent overflow and keep numbers small.
- **Large `n`:** The O(log n) complexity of modular exponentiation is crucial for passing test cases with large `n`. A naive loop would be too slow.

---
### 4. Sort a stack using recursion
`[MEDIUM]` `#recursion` `#stack`

#### Problem Statement
Given a stack, sort it using recursion. You are not allowed to use any explicit loop constructs (like `for` or `while`). You can only use the standard stack operations: `push`, `pop`, `peek`, and `isEmpty`.

**Example 1:**
- **Input:** Stack: [5, 1, 4, 2, 3]
- **Output:** Stack: [1, 2, 3, 4, 5] (bottom to top)

#### Implementation Overview
The solution involves two recursive functions.

1.  **`sortStack(stack)`:** This is the main function.
    - **Base Case:** If the stack is empty, do nothing.
    - **Recursive Step:** Pop the top element (`temp`). Recursively call `sortStack` on the rest of the stack. After the smaller stack is sorted, insert `temp` back into its correct sorted position using a helper function.

2.  **`sortedInsert(stack, element)`:** This helper function inserts an element into a sorted stack.
    - **Base Case:** If the stack is empty or the `element` is greater than the element at the top of the stack, push `element` onto the stack.
    - **Recursive Step:** If the `element` is smaller than the top element, pop the top element (`top`). Recursively call `sortedInsert` with the smaller stack and the `element`. After the `element` is inserted, push `top` back onto the stack.

This process effectively uses the call stack to hold elements while finding the correct position for each one, mimicking an insertion sort.

#### Tricks/Gotchas
- **Two Recursive Functions:** The key is to separate the main sorting logic from the logic for inserting an element into a sorted stack.
- **Call Stack as Storage:** The elegance of this solution lies in its use of the function call stack as temporary storage, avoiding any explicit data structures or loops.

---
### 5. Reverse a stack using recursion
`[EASY]` `#recursion` `#stack`

#### Problem Statement
Given a stack, reverse its elements using recursion. You are not allowed to use any explicit loop constructs.

**Example 1:**
- **Input:** Stack: [1, 2, 3, 4, 5] (top to bottom)
- **Output:** Stack: [5, 4, 3, 2, 1] (top to bottom)

#### Implementation Overview
This solution is structurally very similar to sorting a stack and uses two recursive functions.

1.  **`reverse(stack)`:** The main function.
    - **Base Case:** If the stack is empty, do nothing.
    - **Recursive Step:** Pop the top element (`temp`). Recursively call `reverse` on the rest of the stack. After the smaller stack is reversed, insert `temp` at the bottom of the stack using a helper function.

2.  **`insertAtBottom(stack, element)`:** This helper function inserts an element at the bottom of a stack.
    - **Base Case:** If the stack is empty, push the `element`.
    - **Recursive Step:** If the stack is not empty, pop the top element (`top`). Recursively call `insertAtBottom` with the smaller stack and the `element`. After the `element` is inserted at the bottom, push `top` back onto the stack.

This method uses the call stack to hold all stack elements. Once the stack is empty, it starts re-inserting them at the bottom, which effectively reverses the order.

#### Related Problems
- **Sort a stack using recursion:** Uses a similar recursive structure but with different logic in the helper function (`sortedInsert` vs. `insertAtBottom`).
