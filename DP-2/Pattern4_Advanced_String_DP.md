# Pattern 4: Advanced String DP

This pattern covers string-based DP problems that, while still often using a 2D DP table, have more complex recurrence relations or state transitions than the LCS family. These problems often require careful handling of multiple choices at each step (like in Edit Distance) or dealing with special characters that represent complex matching logic (like in Wildcard Matching).

---

### 1. Distinct Subsequences
`[HARD]` `#string-dp` `#count`

#### Problem Statement
Given two strings, `s` and `t`, count the number of distinct subsequences of `s` which equals `t`.

*Example:* `s = "rabbbit"`, `t = "rabbit"`. **Output:** `3`

#### Implementation Overview
-   **DP State:** `dp[i][j]` = the number of distinct subsequences of `s[0...i-1]` that can form `t[0...j-1]`.
-   **Recurrence Relation:**
    -   If `s[i-1] == t[j-1]`: The character `s[i-1]` can be used. The total ways are (ways to form `t` without this `s[i-1]`) + (ways to form `t`'s prefix using this `s[i-1]`). So, `dp[i][j] = dp[i-1][j] + dp[i-1][j-1]`.
    -   If `s[i-1] != t[j-1]`: The character `s[i-1]` cannot be used. `dp[i][j] = dp[i-1][j]`.
-   **Base Cases:** `dp[i][0] = 1` for all `i` (one way to form an empty subsequence: delete all chars from `s`).
-   **Space Optimization:** Can be optimized to O(N) where N is the length of `t`.

#### Python Code Snippet (Space Optimized)
```python
def num_distinct(s: str, t: str) -> int:
    n, m = len(s), len(t)
    # dp[j] will store the number of ways to form t[:j]
    dp = [0] * (m + 1)
    dp[0] = 1 # Base case: one way to form an empty string

    for i in range(1, n + 1):
        # Iterate backwards to use the dp values from the previous 's' character (i-1)
        for j in range(m, 0, -1):
            if s[i-1] == t[j-1]:
                dp[j] = dp[j] + dp[j-1]

    return dp[m]
```

---

### 2. Edit Distance
`[MEDIUM]` `#string-dp` `#edit-distance`

#### Problem Statement
Given two strings, `word1` and `word2`, find the minimum number of operations required to convert `word1` to `word2`. The allowed operations are: insert, delete, or replace a character.

*Example:* `word1 = "horse"`, `word2 = "ros"`. **Output:** `3`

#### Implementation Overview
This is a classic DP problem, also known as Levenshtein distance.
-   **DP State:** `dp[i][j]` = min operations to convert `word1[0...i-1]` to `word2[0...j-1]`.
-   **Recurrence Relation:**
    -   If `word1[i-1] == word2[j-1]`: No operation needed. `dp[i][j] = dp[i-1][j-1]`.
    -   If they differ, choose the minimum of the three possible operations:
        1.  **Insert:** `1 + dp[i][j-1]`
        2.  **Delete:** `1 + dp[i-1][j]`
        3.  **Replace:** `1 + dp[i-1][j-1]`
-   **Base Cases:** `dp[0][j] = j` (j insertions) and `dp[i][0] = i` (i deletions).

#### Python Code Snippet (Space Optimized)
```python
def min_distance(word1: str, word2: str) -> int:
    n, m = len(word1), len(word2)
    prev = [0] * (m + 1)
    for j in range(m + 1):
        prev[j] = j # Base case for empty word1

    for i in range(1, n + 1):
        curr = [0] * (m + 1)
        curr[0] = i # Base case for empty word2
        for j in range(1, m + 1):
            if word1[i-1] == word2[j-1]:
                curr[j] = prev[j-1]
            else:
                insert_op = curr[j-1]
                delete_op = prev[j]
                replace_op = prev[j-1]
                curr[j] = 1 + min(insert_op, delete_op, replace_op)
        prev = curr

    return prev[m]
```

---

### 3. Wildcard Matching
`[HARD]` `#string-dp` `#wildcard`

#### Problem Statement
Given an input string `s` and a pattern `p`, implement wildcard pattern matching with support for `?` and `*`.
-   `?` Matches any single character.
-   `*` Matches any sequence of characters (including the empty sequence).

*Example:* `s = "adceb"`, `p = "*a*b"`. **Output:** `true`

#### Implementation Overview
-   **DP State:** `dp[i][j]` = boolean, if `s[0...i-1]` matches `p[0...j-1]`.
-   **Recurrence Relation:**
    -   If `p[j-1]` is `?` or matches `s[i-1]`: Match depends on the previous state, `dp[i-1][j-1]`.
    -   If `p[j-1]` is `*`: This is complex. The `*` can either match an empty sequence (result is `dp[i][j-1]`) OR match one or more characters (result is `dp[i-1][j]`). So, `dp[i][j] = dp[i][j-1] or dp[i-1][j]`.
    -   Otherwise, `dp[i][j] = false`.
-   **Base Cases:**
    -   `dp[0][0] = true` (empty matches empty).
    -   `dp[0][j]` can be true if `p`'s prefix is all `*`.

#### Python Code Snippet (Space Optimized)
```python
def is_match_wildcard(s: str, p: str) -> bool:
    n, m = len(s), len(p)
    prev = [False] * (m + 1)
    prev[0] = True # Base case

    # Fill first row for patterns like "a*", "b*", etc.
    for j in range(1, m + 1):
        if p[j-1] == '*':
            prev[j] = prev[j-1]

    for i in range(1, n + 1):
        curr = [False] * (m + 1)
        # First column is always false unless s is empty, handled by prev[0]
        for j in range(1, m + 1):
            if p[j-1] == '?' or p[j-1] == s[i-1]:
                curr[j] = prev[j-1]
            elif p[j-1] == '*':
                # * matches empty sequence (curr[j-1]) or
                # * matches one more char (prev[j])
                curr[j] = curr[j-1] or prev[j]
            else:
                curr[j] = False
        prev = curr

    return prev[m]
```
