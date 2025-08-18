# Pattern 3: Two Pointers - Non-Contiguous Subsequences

This pattern involves using two pointers, but not necessarily to define a contiguous "window". Instead, the pointers often move through sequences to find a match or satisfy a condition where the elements are in the correct relative order but not necessarily adjacent. This is characteristic of subsequence problems.

---

### 1. Minimum Window Subsequence
`[HARD]` `#two-pointers` `#dynamic-programming`

#### Problem Statement
Given strings `s1` and `s2`, return the minimum contiguous window (substring) in `s1` which contains `s2` as a subsequence. If no such window exists, return an empty string `""`.

A subsequence is formed by deleting some characters from a string without changing the order of the remaining characters.

*Example:*
- **Input:** `s1 = "abcdebdde"`, `s2 = "bde"`
- **Output:** `"bcde"`

#### Implementation Overview
This problem cannot be solved with a standard sliding window because `s2` is a subsequence, not a substring. A two-pointer approach is more suitable. A Dynamic Programming solution is also common and often more optimal, but a clever two-pointer solution exists.

The two-pointer logic:
1.  Initialize two pointers, `i` for `s1` and `j` for `s2`. Also, initialize `min_len` to infinity and `result` to `""`.
2.  Iterate through `s1` with pointer `i`.
3.  If `s1[i] == s2[j]`, it means we've found the next character of our subsequence `s2`, so we increment `j`.
4.  Once `j == len(s2)`, we have successfully found an instance of `s2` as a subsequence within `s1`, ending at index `i`.
5.  Now, we must find the *start* of this minimal window.
    - Let `end = i`.
    - Backtrack `j` from `len(s2) - 1` down to `0`.
    - For each character `s2[j]`, backtrack `end` through `s1` until we find the corresponding `s1[end] == s2[j]`.
6.  Once the inner backtrack is complete, `end` will be at the starting character of the subsequence match. The window is `s1[end : i+1]`.
7.  Compare this window's length with `min_len` and update if it's shorter.
8.  **Crucially**, to find the next potential window, we must reset `j=0` and continue our scan of `s1` from `i = end + 1` (the character after the start of the window we just found).

#### Python Code Snippet
```python
def minWindow(s1: str, s2: str) -> str:
    i, j = 0, 0
    min_len = float('inf')
    res = ""

    while i < len(s1):
        # Forward pass to find the end of a potential window
        if s1[i] == s2[j]:
            j += 1

        # If we've found all of s2 as a subsequence
        if j == len(s2):
            end = i
            j -= 1 # Prepare for backward pass

            # Backward pass to find the start of this specific window
            while j >= 0:
                if s1[end] == s2[j]:
                    j -= 1
                end -= 1

            start = end + 1

            # Check if this window is the new minimum
            if (i - start + 1) < min_len:
                min_len = i - start + 1
                res = s1[start : i + 1]

            # Reset for the next search, starting after the window we just found
            i = start
            j = 0

        i += 1

    return res
```

#### Tricks/Gotchas
- **Subsequence vs. Substring:** This is the most important distinction. A sliding window tracks a *substring*. Two pointers are more flexible for *subsequences*.
- **Forward and Backward Pass:** The logic of a forward pass to find a valid endpoint, followed by a backward pass to find the minimal starting point, is a powerful two-pointer technique.
- **Resetting the Search:** After finding a window, correctly resetting the main pointer `i` to `start + 1` is essential for efficiency and correctness, preventing redundant checks.

#### Related Problems
- This problem is quite distinct from the others in the list. It shares more in common with other subsequence-based problems.
