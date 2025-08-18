# Pattern 4: Advanced String DP

This pattern covers string-based DP problems that, while still often using a 2D DP table, have more complex recurrence relations or state transitions than the LCS family. These problems often require careful handling of multiple choices at each step (like in Edit Distance) or dealing with special characters that represent complex matching logic (like in Wildcard Matching).

---

### 1. Distinct Subsequences (DP-32)
`[HARD]` `#string-dp` `#count`

#### Problem Statement
Given two strings, `s` and `t`, count the number of distinct subsequences of `s` which equals `t`.

#### Implementation Overview
-   **DP State:** `dp[i][j]` = the number of distinct subsequences of `s[0...i-1]` that can form the string `t[0...j-1]`.
-   **Recurrence Relation:** We are trying to match `t` using characters from `s`.
    -   If `s[i-1] != t[j-1]`: The character `s[i-1]` cannot be used to form the end of `t[0...j-1]`. So, the number of ways is the same as if we didn't have `s[i-1]`. `dp[i][j] = dp[i-1][j]`.
    -   If `s[i-1] == t[j-1]`: The character `s[i-1]` *can* be used. We have two sources of subsequences:
        1.  We don't use `s[i-1]` to match `t[j-1]`. The number of ways is `dp[i-1][j]`.
        2.  We *do* use `s[i-1]` to match `t[j-1]`. The number of ways is `dp[i-1][j-1]`.
        The total is the sum: `dp[i][j] = dp[i-1][j] + dp[i-1][j-1]`.
-   **Base Cases:** `dp[i][0] = 1` for all `i`. There is always one way to form an empty subsequence (by deleting all characters). `dp[0][j] = 0` for `j > 0`. An empty `s` cannot form a non-empty `t`.

#### Tricks/Gotchas
-   The DP state can be large, so be mindful of potential integer overflows if the counts are very high. The problem might require using 64-bit integers.

---

### 2. Edit Distance (DP-33)
`[HARD]` `#string-dp` `#edit-distance`

#### Problem Statement
Given two strings, `word1` and `word2`, find the minimum number of operations required to convert `word1` to `word2`. The allowed operations are:
1.  Insert a character
2.  Delete a character
3.  Replace a character

#### Implementation Overview
This is a classic DP problem, also known as Levenshtein distance.
-   **DP State:** `dp[i][j]` = the minimum number of operations to convert `word1[0...i-1]` to `word2[0...j-1]`.
-   **Recurrence Relation:**
    -   If `word1[i-1] == word2[j-1]`: The last characters match, so no operation is needed for this position. The cost is the same as the subproblem without these characters: `dp[i][j] = dp[i-1][j-1]`.
    -   If `word1[i-1] != word2[j-1]`: The characters differ. We must perform one operation. We choose the operation that results from the minimum-cost subproblem:
        1.  **Insert:** Convert `word1[0...i-1]` to `word2[0...j-2]` and then insert `word2[j-1]`. Cost: `1 + dp[i][j-1]`.
        2.  **Delete:** Convert `word1[0...i-2]` to `word2[0...j-1]` and then delete `word1[i-1]`. Cost: `1 + dp[i-1][j]`.
        3.  **Replace:** Convert `word1[0...i-2]` to `word2[0...j-2]` and then replace `word1[i-1]` with `word2[j-1]`. Cost: `1 + dp[i-1][j-1]`.
        `dp[i][j] = 1 + min(dp[i][j-1], dp[i-1][j], dp[i-1][j-1])`.
-   **Base Cases:** To convert an empty string to `word2[0...j-1]` requires `j` insertions. So `dp[0][j] = j`. To convert `word1[0...i-1]` to an empty string requires `i` deletions. So `dp[i][0] = i`.

---

### 3. Wildcard Matching (DP-34)
`[MEDIUM]` `#string-dp` `#wildcard`

#### Problem Statement
Given an input string `s` and a pattern `p`, implement wildcard pattern matching with support for `?` and `*`.
-   `?` Matches any single character.
-   `*` Matches any sequence of characters (including the empty sequence).

#### Implementation Overview
-   **DP State:** `dp[i][j]` = a boolean indicating if the first `i` characters of `s` match the first `j` characters of `p`.
-   **Recurrence Relation:**
    -   If `p[j-1]` is a normal character or `?`: The characters must match. `dp[i][j] = (s[i-1] == p[j-1] || p[j-1] == '?') && dp[i-1][j-1]`.
    -   If `p[j-1]` is `*`: This is the complex case. The `*` can do two things:
        1.  **Match an empty sequence:** In this case, `*` is ignored, and the result depends on whether `s[0...i]` matches `p[0...j-1]`. This corresponds to `dp[i][j-1]`.
        2.  **Match one or more characters:** If `*` matches at least one character, it means it matches `s[i-1]`. The result then depends on whether `s[0...i-1]` matches `p[0...j]`. This corresponds to `dp[i-1][j]`.
        Combining these, `dp[i][j] = dp[i][j-1] || dp[i-1][j]`.
-   **Base Cases:**
    -   `dp[0][0] = true` (empty string matches empty pattern).
    -   `dp[i][0] = false` for `i > 0` (non-empty string cannot match empty pattern).
    -   `dp[0][j]` can be true if the prefix of `p` consists only of `*`s. `dp[0][j] = p[j-1] == '*' && dp[0][j-1]`.
