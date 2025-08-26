# Pattern 3: Longest Common Subsequence (LCS) & Variations

The Longest Common Subsequence (LCS) is one of the most fundamental and versatile patterns in Dynamic Programming, especially for problems involving two strings. The core idea is to build a 2D DP table where `dp[i][j]` represents the solution for the prefixes of the strings. A remarkable number of string problems can be solved by either applying the LCS algorithm directly or by slightly modifying its recurrence relation or interpretation.

---

### 1. Longest Common Subsequence
`[MEDIUM]` `#lcs` `#string-dp`

#### Problem Statement
Given two strings, `text1` and `text2`, return the length of their longest common subsequence. A subsequence is a new string generated from the original string with some characters deleted without changing the relative order of the remaining characters.

*Example:* `text1 = "abcde"`, `text2 = "ace"`. **Output:** `3` (LCS is "ace").

#### Implementation Overview
-   **DP State:** `dp[i][j]` = the length of the LCS of `text1[0...i-1]` and `text2[0...j-1]`.
-   **Recurrence Relation:**
    -   If `text1[i-1] == text2[j-1]`, the characters match: `dp[i][j] = 1 + dp[i-1][j-1]`.
    -   If they don't match: `dp[i][j] = max(dp[i-1][j], dp[i][j-1])`.
-   **Space Optimization:** The `dp` table can be space-optimized to O(n) where n is the length of the shorter string.

#### Python Code Snippet (Space Optimized)
```python
def longest_common_subsequence(text1: str, text2: str) -> int:
    n, m = len(text1), len(text2)
    prev = [0] * (m + 1)

    for i in range(1, n + 1):
        curr = [0] * (m + 1)
        for j in range(1, m + 1):
            if text1[i-1] == text2[j-1]:
                curr[j] = 1 + prev[j-1]
            else:
                curr[j] = max(prev[j], curr[j-1])
        prev = curr

    return prev[m]
```

---

### 2. Print Longest Common Subsequence
`[MEDIUM]` `#lcs` `#string-dp` `#backtracking`

#### Problem Statement
Given two strings, find and print one of their longest common subsequences.

#### Implementation Overview
1.  First, compute the entire `dp` table for the LCS lengths.
2.  Backtrack from `dp[m][n]` to reconstruct the LCS string.
3.  Start at `i = m`, `j = n`.
    -   If `text1[i-1] == text2[j-1]`, this character is part of the LCS. Prepend it and move diagonally up-left: `i--`, `j--`.
    -   If they don't match, compare `dp[i-1][j]` and `dp[i][j-1]`. Move in the direction of the larger value.

#### Python Code Snippet
```python
def print_lcs(text1: str, text2: str) -> str:
    n, m = len(text1), len(text2)
    dp = [[0] * (m + 1) for _ in range(n + 1)]
    for i in range(1, n + 1):
        for j in range(1, m + 1):
            if text1[i-1] == text2[j-1]:
                dp[i][j] = 1 + dp[i-1][j-1]
            else:
                dp[i][j] = max(dp[i-1][j], dp[i][j-1])

    res = []
    i, j = n, m
    while i > 0 and j > 0:
        if text1[i-1] == text2[j-1]:
            res.append(text1[i-1])
            i -= 1
            j -= 1
        elif dp[i-1][j] > dp[i][j-1]:
            i -= 1
        else:
            j -= 1
    return "".join(reversed(res))
```

---

### 3. Longest Common Substring
`[MEDIUM]` `#lcs` `#string-dp` `#substring`

#### Problem Statement
Given two strings, find the length of the longest common **substring**. A substring is a contiguous block of characters.

*Example:* `text1 = "abcde"`, `text2 = "abce"`. **Output:** `2` (Substring is "ab" or "ce").

#### Implementation Overview
-   **DP State:** `dp[i][j]` = the length of the common substring *ending* at `text1[i-1]` and `text2[j-1]`.
-   **Recurrence Relation:**
    -   If `text1[i-1] == text2[j-1]`: `dp[i][j] = 1 + dp[i-1][j-1]`.
    -   If they don't match, the common substring is broken: `dp[i][j] = 0`.
-   **Final Answer:** The length is the **maximum value found anywhere** in the `dp` table.

#### Python Code Snippet
```python
def longest_common_substring(text1: str, text2: str) -> int:
    n, m = len(text1), len(text2)
    dp = [[0] * (m + 1) for _ in range(n + 1)]
    max_len = 0
    for i in range(1, n + 1):
        for j in range(1, m + 1):
            if text1[i-1] == text2[j-1]:
                dp[i][j] = 1 + dp[i-1][j-1]
                max_len = max(max_len, dp[i][j])
            else:
                dp[i][j] = 0
    return max_len
```

---

### 4. Longest Palindromic Subsequence
`[MEDIUM]` `#lps` `#lcs` `#string-dp`

#### Problem Statement
Given a string `s`, find the length of the longest palindromic subsequence in `s`.

*Example:* `s = "bbbab"`. **Output:** `4` (LPS is "bbbb").

#### Implementation Overview
-   **Insight:** The longest palindromic subsequence of `s` is the LCS of `s` and `reverse(s)`.
-   **Algorithm:** Create a reversed copy of `s` and find the LCS length between the two strings.

#### Python Code Snippet
```python
def longest_palindromic_subsequence(s: str) -> int:
    # This is just LCS(s, reverse(s))
    text1 = s
    text2 = s[::-1]
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

---

### 5. Minimum Insertions to Make a String Palindrome
`[HARD]` `#lps` `#lcs` `#string-dp`

#### Problem Statement
Given a string `s`, find the minimum number of insertions required to make `s` a palindrome.

*Example:* `s = "mbadm"`. **Output:** `2` ("mbdadbm").

#### Implementation Overview
-   **Insight:** The characters that are already part of the LPS do not need to be touched. The characters *not* in the LPS are "unmatched" and each needs a partner inserted.
-   **Algorithm:**
    1.  Find the length of the longest palindromic subsequence (`len_lps`).
    2.  The number of insertions needed is `len(s) - len_lps`.

#### Python Code Snippet
```python
def min_insertions_to_palindrome(s: str) -> int:
    # len_lps can be calculated using the function from the previous problem
    len_lps = longest_palindromic_subsequence(s)
    return len(s) - len_lps
```

---

### 6. Minimum Deletions/Insertions to Convert String A to B
`[MEDIUM]` `#lcs` `#string-dp`

#### Problem Statement
Given two strings, `str1` and `str2`, find the minimum number of deletions and insertions required to convert `str1` into `str2`.

*Example:* `str1 = "heap"`, `str2 = "pea"`. **Output:** `3` (delete 'h', 'p'; insert 'p').

#### Implementation Overview
-   **Insight:** The LCS is the part of `str1` that can be kept.
    -   Characters in `str1` not in the LCS must be deleted.
    -   Characters in `str2` not in the LCS must be inserted.
-   **Algorithm:**
    1.  Calculate `len_lcs = LCS(str1, str2)`.
    2.  Deletions = `len(str1) - len_lcs`.
    3.  Insertions = `len(str2) - len_lcs`.
    4.  Total operations = `deletions + insertions`.

#### Python Code Snippet
```python
def min_ops_to_convert(str1: str, str2: str) -> int:
    len_lcs = longest_common_subsequence(str1, str2)
    deletions = len(str1) - len_lcs
    insertions = len(str2) - len_lcs
    return deletions + insertions
```

---

### 7. Shortest Common Supersequence
`[HARD]` `#lcs` `#string-dp` `#scs`

#### Problem Statement
Given two strings `str1` and `str2`, return the shortest string that has both `str1` and `str2` as subsequences.

*Example:* `str1 = "abac"`, `str2 = "cab"`. **Output:** `"cabac"`

#### Implementation Overview
-   **Length:** `len(SCS) = len(str1) + len(str2) - len(LCS)`.
-   **Printing:** Backtrack on the LCS `dp` table.
    -   If `str1[i-1] == str2[j-1]`, it's a common char. Add it and move diagonally.
    -   If not, find which subproblem gave the better LCS. If `dp[i-1][j]` was larger, it means `str1[i-1]` is unique. Add it and move up. Otherwise, add `str2[j-1]` and move left.
    -   Append any remaining characters from the non-empty string at the end.

#### Python Code Snippet
```python
def shortest_common_supersequence(str1: str, str2: str) -> str:
    n, m = len(str1), len(str2)
    dp = [[0] * (m + 1) for _ in range(n + 1)]
    for i in range(1, n + 1):
        for j in range(1, m + 1):
            if str1[i-1] == str2[j-1]:
                dp[i][j] = 1 + dp[i-1][j-1]
            else:
                dp[i][j] = max(dp[i-1][j], dp[i][j-1])

    res = []
    i, j = n, m
    while i > 0 and j > 0:
        if str1[i-1] == str2[j-1]:
            res.append(str1[i-1])
            i -= 1
            j -= 1
        elif dp[i-1][j] > dp[i][j-1]:
            res.append(str1[i-1])
            i -= 1
        else:
            res.append(str2[j-1])
            j -= 1

    # Append remaining chars
    while i > 0:
        res.append(str1[i-1])
        i -= 1
    while j > 0:
        res.append(str2[j-1])
        j -= 1

    return "".join(reversed(res))
```
