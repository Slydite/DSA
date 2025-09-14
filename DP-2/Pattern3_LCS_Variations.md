# Pattern 3: Longest Common Subsequence (LCS) & Variations

The Longest Common Subsequence (LCS) is a fundamental DP pattern for problems involving two strings. The core idea is to build a 2D DP table where `dp[i][j]` represents the solution for the prefixes of the strings. Many string problems can be solved by applying the LCS algorithm directly or by slightly modifying its recurrence relation.

---

### 1. Longest Common Subsequence
`[MEDIUM]` `#lcs` `#string-dp`

#### Problem Statement
Given two strings, `text1` and `text2`, return the length of their longest common subsequence.

#### Recurrence Relation
Let `solve(i, j)` be the LCS length for `text1[0...i]` and `text2[0...j]`.
- If `text1[i] == text2[j]`: The characters match. The LCS length is `1 + solve(i-1, j-1)`.
- If `text1[i] != text2[j]`: The characters don't match. We have two choices:
    - Ignore the character from `text1`: `solve(i-1, j)`.
    - Ignore the character from `text2`: `solve(i, j-1)`.
    We take the maximum of these two choices.

---
#### a) Memoization (Top-Down)
```python
def lcs_memo(text1: str, text2: str) -> int:
    n, m = len(text1), len(text2)
    dp = [[-1] * m for _ in range(n)]

    def solve(i, j):
        if i < 0 or j < 0:
            return 0
        if dp[i][j] != -1:
            return dp[i][j]

        if text1[i] == text2[j]:
            dp[i][j] = 1 + solve(i - 1, j - 1)
        else:
            dp[i][j] = max(solve(i - 1, j), solve(i, j - 1))
        return dp[i][j]

    return solve(n - 1, m - 1)
```
- **Time Complexity:** O(n * m).
- **Space Complexity:** O(n * m) for DP table + O(n+m) for recursion stack.

---
#### b) Tabulation (Bottom-Up)
```python
def lcs_tab(text1: str, text2: str) -> int:
    n, m = len(text1), len(text2)
    dp = [[0] * (m + 1) for _ in range(n + 1)]

    for i in range(1, n + 1):
        for j in range(1, m + 1):
            if text1[i-1] == text2[j-1]:
                dp[i][j] = 1 + dp[i-1][j-1]
            else:
                dp[i][j] = max(dp[i-1][j], dp[i][j-1])

    return dp[n][m]
```
- **Time Complexity:** O(n * m).
- **Space Complexity:** O(n * m).

---
#### c) Space Optimization
```python
def lcs_optimized(text1: str, text2: str) -> int:
    n, m = len(text1), len(text2)
    prev_row = [0] * (m + 1)

    for i in range(1, n + 1):
        curr_row = [0] * (m + 1)
        for j in range(1, m + 1):
            if text1[i-1] == text2[j-1]:
                curr_row[j] = 1 + prev_row[j-1]
            else:
                curr_row[j] = max(prev_row[j], curr_row[j-1])
        prev_row = curr_row

    return prev_row[m]
```
- **Time Complexity:** O(n * m).
- **Space Complexity:** O(m), where m is the length of the shorter string.

---

### 2. Longest Palindromic Subsequence
`[MEDIUM]` `#lps` `#lcs` `#string-dp`

#### Problem Statement
Given a string `s`, find the length of the longest palindromic subsequence.

#### Implementation Overview
- **Insight:** A palindrome reads the same forwards and backwards. Therefore, the longest palindromic subsequence of `s` is simply the **Longest Common Subsequence of `s` and `reverse(s)`**.
- **Algorithm:** Create a reversed copy of `s` and use any of the LCS implementations above to find the length.

#### Python Code Snippet
```python
def longest_palindromic_subsequence(s: str) -> int:
    # This is just LCS(s, reverse(s))
    return lcs_optimized(s, s[::-1])
```
- **Time/Space Complexity:** Same as the underlying LCS implementation used.

---

### 3. Minimum Insertions to Make a String Palindrome
`[HARD]` `#lps` `#lcs` `#string-dp`

#### Problem Statement
Given a string `s`, find the minimum number of insertions required to make it a palindrome.

#### Implementation Overview
- **Insight:** The characters that are already part of the Longest Palindromic Subsequence (LPS) form a "stable" core that doesn't need to be touched. The characters *not* in the LPS are the ones that are "unmatched" and each requires a corresponding character to be inserted to make the whole string a palindrome.
- **Algorithm:**
    1.  Find the length of the LPS (`len_lps`).
    2.  The number of insertions needed is `len(s) - len_lps`.

#### Python Code Snippet
```python
def min_insertions_to_palindrome(s: str) -> int:
    len_lps = longest_palindromic_subsequence(s) # Reuse function from above
    return len(s) - len_lps
```
- **Time/Space Complexity:** Dominated by the LPS calculation.

---

### 4. Minimum Deletions/Insertions to Convert String A to B
`[MEDIUM]` `#lcs` `#string-dp`

#### Problem Statement
Given `str1` and `str2`, find the minimum number of deletions and insertions to convert `str1` to `str2`.

#### Implementation Overview
- **Insight:** The Longest Common Subsequence is the part of `str1` that can be kept and reused to form `str2`.
    -   Characters in `str1` that are *not* in the LCS must be **deleted**.
    -   Characters in `str2` that are *not* in the LCS must be **inserted**.
- **Algorithm:**
    1.  Calculate `len_lcs = LCS(str1, str2)`.
    2.  Number of deletions = `len(str1) - len_lcs`.
    3.  Number of insertions = `len(str2) - len_lcs`.
    4.  Total operations = `deletions + insertions`.

#### Python Code Snippet
```python
def min_ops_to_convert(str1: str, str2: str) -> int:
    len_lcs = lcs_optimized(str1, str2) # Reuse function from above
    return len(str1) + len(str2) - 2 * len_lcs
```
- **Time/Space Complexity:** Dominated by the LCS calculation.

---

### 5. Shortest Common Supersequence
`[HARD]` `#lcs` `#string-dp` `#scs`

#### Problem Statement
Given `str1` and `str2`, return the shortest string that has both as subsequences.

#### Implementation Overview
- **Length Insight:** A naive supersequence is `str1 + str2`. To make it shortest, we should only include the common parts (the LCS) once. Thus, `len(SCS) = len(str1) + len(str2) - len(LCS)`.
- **Printing Algorithm:**
    1.  Compute the full LCS `dp` table.
    2.  Backtrack from `dp[n][m]` to build the SCS string.
        - If `str1[i-1] == str2[j-1]`, this character is common. Add it to the SCS once and move diagonally (`i--`, `j--`).
        - If they differ, find which subproblem gave the better LCS. If `dp[i-1][j]` was larger, it means `str1[i-1]` is unique to this path. Add it and move up (`i--`).
        - Otherwise, `str2[j-1]` is unique. Add it and move left (`j--`).
    3.  After the loop, append any remaining characters from the non-empty string.

#### Python Code Snippet
```python
def shortest_common_supersequence(str1: str, str2: str) -> str:
    n, m = len(str1), len(str2)
    dp = [[0] * (m + 1) for _ in range(n + 1)]
    # Standard LCS table calculation
    for i in range(1, n + 1):
        for j in range(1, m + 1):
            if str1[i-1] == str2[j-1]:
                dp[i][j] = 1 + dp[i-1][j-1]
            else:
                dp[i][j] = max(dp[i-1][j], dp[i][j-1])

    # Backtrack to build the SCS string
    res = []
    i, j = n, m
    while i > 0 and j > 0:
        if str1[i-1] == str2[j-1]:
            res.append(str1[i-1])
            i -= 1; j -= 1
        elif dp[i-1][j] > dp[i][j-1]:
            res.append(str1[i-1])
            i -= 1
        else:
            res.append(str2[j-1])
            j -= 1

    # Append any remaining characters
    while i > 0: res.append(str1[i-1]); i -= 1
    while j > 0: res.append(str2[j-1]); j -= 1

    return "".join(reversed(res))
```
- **Time Complexity:** O(n * m) to build the table.
- **Space Complexity:** O(n * m) for the DP table.
