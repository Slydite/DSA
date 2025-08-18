---

### 1. Remove Outermost Parentheses
`[EASY]` `#string` `#stack` `#parentheses`

#### Problem Statement
A valid parentheses string is a string that is either `""`, `"( )"`, or `A+B` where `A` and `B` are valid parentheses strings. A primitive valid parentheses string is a nonempty valid parentheses string `S` that cannot be split into `S = A+B` with `A` and `B` being nonempty valid parentheses strings.

Given a valid parentheses string `s`, consider its primitive decomposition: `s = P_1 + P_2 + ... + P_k`. Return `s` after removing the outermost parentheses of every primitive string in the decomposition.

Example: `s = "(()())(())"`. The primitive decomposition is `P_1 = "(()())"` and `P_2 = "(())"`. Removing the outer parentheses gives `"()()"` + `"()"` = `"()()()"`.

#### Implementation Overview
The key is to identify the primitive components. We can do this by keeping track of the balance of open and closed parentheses.

1.  **Initialize**: Create a result list or string builder to construct the output. Initialize a counter `balance` (or `opened`) to 0.
2.  **Iterate Through String**: Traverse the input string `s` character by character.
3.  **Track Balance**:
    -   If you see an opening parenthesis `(`, increment the `balance`.
    -   If you see a closing parenthesis `)`, decrement the `balance`.
4.  **Identify Primitive Parts**:
    -   A primitive string starts when the balance becomes 1 (the first `(`).
    -   A primitive string ends when the balance returns to 0.
5.  **Append to Result**:
    -   The outermost parentheses are the ones encountered when the balance *becomes* 1 (the first open parenthesis) and when the balance is *about to become* 0 (the last closing parenthesis). We should not append these.
    -   A simple rule: If you see `(` and the balance *before* incrementing was greater than 0, append it.
    -   If you see `)` and the balance *after* decrementing is greater than 0, append it.

#### Python Code Snippet
```python
def remove_outer_parentheses(s: str) -> str:
    """
    Removes the outermost parentheses of every primitive string in the decomposition.
    """
    result = []
    balance = 0

    for char in s:
        if char == '(':
            # Only append if this is not the first '(' of a primitive part
            if balance > 0:
                result.append(char)
            balance += 1
        else: # char == ')'
            balance -= 1
            # Only append if this is not the last ')' of a primitive part
            if balance > 0:
                result.append(char)

    return "".join(result)
```

#### Tricks/Gotchas
- **Balance Counter**: The balance counter is the most crucial part of the logic. It correctly identifies the boundaries of the primitive components without needing to explicitly store them.
- **When to Append**: The conditions for appending are the core of the solution. Appending `(` only when `balance > 0` and `)` only when `balance` (after decrement) is still `> 0` correctly omits the outermost layer.

#### Related Problems
- Maximum Nesting Depth of Parentheses
- Valid Parentheses (classic stack problem)

---

### 2. Maximum Nesting Depth of the Parentheses
`[EASY]` `#string` `#stack` `#parentheses`

#### Problem Statement
Given a valid parentheses string `s`, return the maximum nesting depth of `s`. The nesting depth of `""` is 0, the depth of `A+B` is `max(depth(A), depth(B))`, and the depth of `(A)` is `1 + depth(A)`.

Example: `s = "(1+(2*3)+((8)/4))+1"`. The digits are ignored, we only care about the parentheses structure `()(()())()`. The nesting depth is 3.

#### Implementation Overview
This is a simpler version of the parentheses balance problem. We only need to track the current depth and the maximum depth seen so far.

1.  **Initialize**:
    -   `max_depth = 0`: To store the maximum depth found.
    -   `current_depth = 0`: To track the current level of nesting.
2.  **Iterate Through String**: Traverse the input string `s`.
3.  **Update Depth**:
    -   When an opening parenthesis `(` is encountered, it means we are going one level deeper. Increment `current_depth` and update `max_depth = max(max_depth, current_depth)`.
    -   When a closing parenthesis `)` is encountered, it means we are leaving a level of nesting. Decrement `current_depth`.
    -   Ignore all other characters.
4.  Return `max_depth`.

#### Python Code Snippet
```python
def max_depth(s: str) -> int:
    """
    Calculates the maximum nesting depth of parentheses in a string.
    """
    max_d = 0
    current_d = 0
    for char in s:
        if char == '(':
            current_d += 1
            max_d = max(max_d, current_d)
        elif char == ')':
            current_d -= 1
    return max_d
```

#### Tricks/Gotchas
- **Simplicity**: Don't overthink this with a stack. A simple counter is sufficient because we are guaranteed a valid parentheses string (no need to check for mismatches like `)(`).
- **What to Track**: The key is realizing you only need to update the max depth when the current depth *increases*.

#### Related Problems
- Remove Outermost Parentheses

---

### 3. Roman to Integer and Integer to Roman
`[EASY]` `#string` `#hashmap` `#parsing`

#### Problem Statement
Given a Roman numeral, convert it to an integer. Also, solve the reverse problem: given an integer, convert it to a Roman numeral.

#### Implementation Overview

**Roman to Integer:**
The trick to Roman numerals is the subtraction rule (e.g., `IV` is 4, `IX` is 9). A larger numeral placed before a smaller one means addition, but a smaller one before a larger one means subtraction.

1.  **Create a Mapping**: Store the values of Roman numerals in a hash map (e.g., `{'I': 1, 'V': 5, ...}`).
2.  **Iterate from Right to Left**: Traverse the Roman numeral string from right to left. This makes handling the subtraction rule easier.
3.  **Logic**:
    -   The rightmost numeral is always added. Initialize `total` with its value.
    -   For each subsequent numeral to the left, compare it with the numeral to its right.
    -   If the current numeral is smaller than the one to its right, subtract it from the `total`.
    -   Otherwise, add it to the `total`.

**Integer to Roman:**
This is a greedy problem.
1.  **Create Mappings**: Create a list of tuples or two parallel arrays mapping values to their Roman numeral strings, sorted in descending order of value. Crucially, this must include the subtraction cases (e.g., `(900, "CM")`, `(400, "CD")`, etc.).
2.  **Greedy Subtraction**:
    -   Iterate through the mappings from largest to smallest.
    -   For each value, while the input `num` is greater than or equal to the value, append the corresponding Roman string to the result and subtract the value from `num`.

#### Python Code Snippet
```python
def roman_to_int(s: str) -> int:
    roman_map = {'I': 1, 'V': 5, 'X': 10, 'L': 50, 'C': 100, 'D': 500, 'M': 1000}
    total = roman_map[s[-1]] # Start with the last numeral

    for i in range(len(s) - 2, -1, -1):
        # If current numeral is smaller than the one to its right, subtract
        if roman_map[s[i]] < roman_map[s[i+1]]:
            total -= roman_map[s[i]]
        else:
            total += roman_map[s[i]]
    return total

def int_to_roman(num: int) -> str:
    val_map = [
        (1000, "M"), (900, "CM"), (500, "D"), (400, "CD"),
        (100, "C"), (90, "XC"), (50, "L"), (40, "XL"),
        (10, "X"), (9, "IX"), (5, "V"), (4, "IV"),
        (1, "I")
    ]
    result = []
    for val, roman in val_map:
        while num >= val:
            result.append(roman)
            num -= val
    return "".join(result)
```

#### Tricks/Gotchas
- **Right-to-Left Traversal**: For Roman-to-Integer, iterating from the right simplifies the logic for the subtraction rule immensely compared to a left-to-right approach.
- **Complete Mapping**: For Integer-to-Roman, the mapping must include the special subtraction cases (`CM`, `CD`, `XC`, `XL`, `IX`, `IV`) to handle numbers like 4 and 9 correctly in a greedy fashion.

#### Related Problems
- Implement Atoi

---

### 4. Implement Atoi (String to Integer)
`[MEDIUM]` `#string` `#parsing`

#### Problem Statement
Implement the `atoi` function, which converts a string to a 32-bit signed integer. The function should handle:
1.  Leading whitespace.
2.  An optional `+` or `-` sign.
3.  A sequence of digits.
4.  Stops parsing at the first non-digit character.
5.  Handles overflow by clamping the result to the 32-bit signed integer range `[-2^31, 2^31 - 1]`.

#### Implementation Overview
This is a careful, step-by-step parsing problem. State needs to be managed carefully.

1.  **Initialize**:
    -   `result = 0`
    -   `sign = 1`
    -   `i = 0` (index for traversing the string)
    -   `n = len(s)`
2.  **Skip Whitespace**: Increment `i` while `s[i]` is a space.
3.  **Handle Sign**:
    -   If `s[i]` is `+` or `-`, set the `sign` accordingly (`-1` for `-`). Increment `i`.
4.  **Convert Digits**:
    -   Loop while `i` is within bounds and `s[i]` is a digit.
    -   In each iteration, update the result: `result = result * 10 + int(s[i])`.
    -   **Crucially, check for overflow *before* the update**. Compare `result` against `INT_MAX // 10`. If it's greater, or if it's equal and the current digit is greater than `7`, then overflow will occur.
    -   Increment `i`.
5.  **Apply Sign and Clamp**:
    -   The final result is `sign * result`.
    -   Check if this final result is outside the `[-2^31, 2^31 - 1]` range and clamp if necessary.

#### Python Code Snippet
```python
def my_atoi(s: str) -> int:
    INT_MAX = 2**31 - 1
    INT_MIN = -2**31

    i = 0
    n = len(s)

    # 1. Skip whitespace
    while i < n and s[i] == ' ':
        i += 1

    # 2. Handle sign
    sign = 1
    if i < n and (s[i] == '+' or s[i] == '-'):
        if s[i] == '-':
            sign = -1
        i += 1

    # 3. Convert digits and handle overflow
    result = 0
    while i < n and s[i].isdigit():
        digit = int(s[i])

        # Check for overflow before updating result
        if result > INT_MAX // 10 or (result == INT_MAX // 10 and digit > 7):
            return INT_MAX if sign == 1 else INT_MIN

        result = result * 10 + digit
        i += 1

    return sign * result
```

#### Tricks/Gotchas
- **Overflow Check**: The most difficult part is checking for overflow *before* it happens. Multiplying `result` by 10 can cause overflow, so the check must be done on the previous `result`. `if result > INT_MAX // 10` is the key.
- **State Machine**: Think of this as a simple state machine: (1) whitespace state, (2) sign state, (3) digit conversion state, (4) end state.

#### Related Problems
- Roman to Integer
