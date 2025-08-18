This pattern, often called the "pick/don't-pick" method, is a fundamental backtracking strategy used to generate all possible subsets, subsequences, or combinations of a given set of elements. The core idea is to recursively explore two choices for each element: either include it in the current solution or exclude it.

---
### 1. Generate all binary strings
`[MEDIUM]` `#recursion` `#backtracking`

#### Problem Statement
Given a positive integer `N`, generate all possible binary strings of length `N`. A binary string is a sequence of '0's and '1's.

**Example 1:**
- **Input:** N = 3
- **Output:** ["000", "001", "010", "011", "100", "101", "110", "111"]

#### Implementation Overview
This is a classic introductory problem for recursion. For each position in the string (from 0 to N-1), we have two independent choices: place a '0' or a '1'.

1.  **Recursive Function Signature:** The function typically takes the current index `i` and the string (or character array) being built.
2.  **Base Case:** When the index `i` reaches `N`, it means we have filled all positions. The current string is a complete binary string, so we add it to our list of results and return.
3.  **Recursive Step:** At index `i`:
    -   **Choice 1:** Place '0' at the current position and make a recursive call for the next position, `i + 1`.
    -   **Choice 2:** Place '1' at the current position and make a recursive call for the next position, `i + 1`.

This naturally explores all 2^N possibilities.

#### Tricks/Gotchas
- **Immutability:** If using strings, remember they are immutable in many languages. You might need to pass new strings in recursive calls (`current_string + '0'`) or use a mutable data structure like a character array or list for better performance.

---
### 2. Print all subsequences/Power Set
`[MEDIUM]` `#recursion` `#backtracking` `#subsequences` `#power-set`

#### Problem Statement
Given a string or an array of integers, generate all of its subsequences. A subsequence is a sequence that can be derived from the original by deleting some (or none) of the elements without changing the order of the remaining elements. The set of all subsequences is also known as the power set.

**Example 1:**
- **Input:** `[1, 2, 3]`
- **Output:** `[[], [1], [2], [3], [1, 2], [1, 3], [2, 3], [1, 2, 3]]`

#### Implementation Overview
This is the canonical "pick/don't-pick" problem. For each element in the input array, we decide whether to include it in the current subsequence or not.

1.  **Recursive Function Signature:** `solve(index, current_subsequence)`
2.  **Base Case:** When `index` equals the length of the input array, we have considered all elements. The `current_subsequence` is a valid subsequence, so we add a copy of it to our results.
3.  **Recursive Step:** At `index`:
    -   **Pick:** Add `array[index]` to `current_subsequence`. Recursively call `solve(index + 1, current_subsequence)`.
    -   **Backtrack:** After the "pick" call returns, remove `array[index]` from `current_subsequence` to revert the state for the next choice.
    -   **Don't-Pick:** Recursively call `solve(index + 1, current_subsequence)` without adding the element.

#### Python Code Snippet
```python
def get_subsequences(arr):
    result = []
    current_subsequence = []

    def solve(index):
        if index == len(arr):
            result.append(list(current_subsequence))
            return

        # Pick the element
        current_subsequence.append(arr[index])
        solve(index + 1)

        # Don't-pick the element (and backtrack)
        current_subsequence.pop()
        solve(index + 1)

    solve(0)
    return result
```

#### Tricks/Gotchas
- **Backtracking:** The `pop()` operation after the first recursive call is the most crucial part. It ensures that the state is clean for the "don't-pick" path.
- **Copying the Result:** When adding `current_subsequence` to the final result list, you must add a *copy*. Otherwise, you'd be adding a reference to the list that will be modified later, leading to incorrect output.

---
### 3. Count all subsequences with sum K
`[HARD]` `#recursion` `#backtracking` `#subsequences` `#dynamic-programming`

#### Problem Statement
Given an array of integers `arr` and an integer `K`, count the total number of subsequences of `arr` that sum up to `K`.

**Example 1:**
- **Input:** `arr = [1, 2, 1]`, `K = 2`
- **Output:** 2 (The subsequences are `{1, 1}` and `{2}`)

#### Implementation Overview
This is a "pick/don't-pick" problem where we are not generating the subsequences themselves, but counting them based on a condition. The recursive function returns the count of valid subsequences found from its state.

1.  **Recursive Function Signature:** `count_subsequences(index, current_sum)`
2.  **Base Case:** When `index` reaches the end of the array:
    - If `current_sum == K`, we have found one valid subsequence. Return 1.
    - Otherwise, return 0.
3.  **Recursive Step:** At `index`:
    -   **Pick:** Call `count_subsequences(index + 1, current_sum + arr[index])`. This gives the count of valid subsequences including the current element.
    -   **Don't-Pick:** Call `count_subsequences(index + 1, current_sum)`. This gives the count of valid subsequences *not* including the current element.
    -   The total count for the current state is the sum of the results from the "pick" and "don't-pick" calls.

#### Tricks/Gotchas
- **Handling Zeros:** If the array contains zeros, multiple subsequences can have the same sum. The standard pick/don't-pick approach handles this correctly.
- **Optimization:** For larger inputs, this recursive solution is very slow due to overlapping subproblems. It can be optimized with memoization (Dynamic Programming), where you store the results for `(index, current_sum)` pairs to avoid re-computation.

---
### 4. Check if there exists a subsequence with sum K
`[MEDIUM]` `#recursion` `#backtracking` `#subsequences` `#dynamic-programming`

#### Problem Statement
Given an array of non-negative integers `arr` and a target sum `K`, determine if there is a subsequence of `arr` with a sum equal to `K`.

**Example 1:**
- **Input:** `arr = [2, 3, 7, 8, 10]`, `K = 11`
- **Output:** `True` (The subsequence is `{3, 8}`)

#### Implementation Overview
This is a decision-based version of the previous problem. We don't need to count all possibilities, we just need to find one. The recursive function can return a boolean.

1.  **Recursive Function Signature:** `check_sum(index, target)`
2.  **Base Case:**
    - If `target == 0`, we have successfully found a subsequence that sums to the original `K`. Return `True`.
    - If `index` reaches the end of the array (and `target` is not 0), this path is a dead end. Return `False`.
3.  **Recursive Step:** At `index`:
    -   **Pick:** If `arr[index] <= target`, make a recursive call `check_sum(index + 1, target - arr[index])`. If this call returns `True`, we have found a solution, so we can immediately return `True`.
    -   **Don't-Pick:** If the "pick" path didn't return `True`, we must explore the "don't-pick" path: `check_sum(index + 1, target)`.
    -   The result is `pick_result OR dont_pick_result`.

#### Related Problems
- This is the classic **Subset Sum Problem**, which is a well-known NP-complete problem and a foundational dynamic programming problem.

---
### 5. Combination Sum
`[MEDIUM]` `#recursion` `#backtracking`

#### Problem Statement
Given an array of **distinct** integers `candidates` and a target integer `target`, return a list of all **unique combinations** of `candidates` where the chosen numbers sum to `target`. You may return the combinations in any order. The **same number may be chosen from `candidates` an unlimited number of times**.

**Example 1:**
- **Input:** `candidates = [2, 3, 6, 7]`, `target = 7`
- **Output:** `[[2, 2, 3], [7]]`

#### Implementation Overview
The key difference from a standard subsequence problem is that we can reuse elements. This changes the recursive step for the "pick" choice.

1.  **Recursive Function Signature:** `find_combinations(index, target, current_combination)`
2.  **Base Case:**
    - If `target == 0`, we've found a valid combination. Add a copy of `current_combination` to the results and return.
    - If `index` is out of bounds or `target < 0`, this path is invalid. Return.
3.  **Recursive Step:** At `index`:
    -   **Pick:** If `candidates[index] <= target`:
        - Add `candidates[index]` to `current_combination`.
        - Recursively call `find_combinations` on the **same index** (`index`, not `index + 1`) with the new target: `target - candidates[index]`. This allows the element to be reused.
        - Backtrack by removing `candidates[index]` from `current_combination`.
    -   **Don't-Pick:** To move to the next candidate, call `find_combinations(index + 1, target, current_combination)`.

#### Tricks/Gotchas
- **Reusing Elements:** The crucial trick is that the recursive call for the "pick" option stays at the *same index*, while the "don't-pick" option moves to the *next index*. This structure ensures all combinations are found without generating duplicate combinations like `[2, 3]` and `[3, 2]`.

---
### 6. Combination Sum-II
`[MEDIUM]` `#recursion` `#backtracking`

#### Problem Statement
Given a collection of candidate numbers `candidates` (which **may contain duplicates**) and a target integer `target`, find all unique combinations in `candidates` where the numbers sum to `target`. **Each number in `candidates` may only be used once in each combination.**

**Example 1:**
- **Input:** `candidates = [10, 1, 2, 7, 6, 1, 5]`, `target = 8`
- **Output:** `[[1, 1, 6], [1, 2, 5], [1, 7], [2, 6]]`

#### Implementation Overview
This problem introduces two new constraints: numbers cannot be reused, and the input may have duplicates.

1.  **Sort the Input:** First, sort the `candidates` array. This is essential for efficiently skipping duplicate combinations.
2.  **Recursive Logic:** The core logic is now closer to a standard subsequence problem because each element can be used only once.
3.  **Handling Duplicates:** The main challenge is to avoid duplicate combinations (e.g., using the first '1' and '7' vs. the second '1' and '7' in the example). The sorted array helps here. Inside our recursive function, we iterate through candidates to pick from. If we encounter a candidate that is the same as the one before it, and we are not at the beginning of the iteration for this level of recursion, we skip it.
    - Loop from `i = index` to `len(candidates)`.
    - Add the check: `if i > index and candidates[i] == candidates[i-1]: continue`. This ensures that we only generate combinations starting with the first occurrence of a repeated number.

#### Tricks/Gotchas
- **Sorting:** Sorting the input array is the first and most important step.
- **Duplicate Skipping Logic:** The condition `if i > index and candidates[i] == candidates[i-1]: continue` is the key trick. It says: "If this number is the same as the previous one, and I'm not the first number being considered at this recursive level, then skip it, because the combination starting with this number will be a duplicate of one I've already generated."

---
### 7. Subset Sum-I
`[MEDIUM]` `#recursion` `#backtracking` `#subsequences`

#### Problem Statement
Given a list of `N` integers, find the sum of all the subsets in it.

**Example 1:**
- **Input:** `[2, 3]`
- **Output:** `[0, 2, 3, 5]` (Sums of `[]`, `[2]`, `[3]`, `[2, 3]`)

#### Implementation Overview
This is a direct and simple application of the "pick/don't-pick" pattern, where we are interested in the final sum of each generated subset.

1.  **Recursive Function Signature:** `find_sums(index, current_sum)`
2.  **Base Case:** When `index` reaches the end of the array, `current_sum` represents the sum of one complete subset. Add this sum to the result list.
3.  **Recursive Step:** At `index`:
    -   **Pick:** Make a recursive call for the next index with an updated sum: `find_sums(index + 1, current_sum + arr[index])`.
    -   **Don't-Pick:** Make a recursive call for the next index with the same sum: `find_sums(index + 1, current_sum)`.

#### Tricks/Gotchas
- The initial call should be `find_sums(0, 0)`.
- The problem is straightforward, serving as a good exercise to solidify the basic pick/don't-pick pattern.

---
### 8. Subset Sum-II
`[MEDIUM]` `#recursion` `#backtracking` `#subsequences`

#### Problem Statement
Given an integer array `nums` that may contain **duplicates**, return all possible **unique** subsets (the power set). The solution set must not contain duplicate subsets.

**Example 1:**
- **Input:** `[1, 2, 2]`
- **Output:** `[[], [1], [1, 2], [1, 2, 2], [2], [2, 2]]`

#### Implementation Overview
This problem combines the "generate all subsequences" idea with the "handle duplicates" technique from Combination Sum-II.

1.  **Sort the Input:** Sort the input array `nums` to handle duplicates gracefully.
2.  **Recursive Logic:** The recursive function will build the subsets. A common way to structure the recursion here is to make a decision at each step about which element to add next.
3.  **Handling Duplicates:**
    - The recursive function is called once for each starting `index`.
    - Inside the function, loop from the `index` to the end of the array.
    - The key logic: `if i > index and nums[i] == nums[i-1]: continue`. This prevents creating duplicate subsets. For a block of identical elements like `[2, 2, 2]`, it ensures that a `2` is only added if the previous element considered at this level was also a `2`.

#### Python Code Snippet
```python
def subsetsWithDup(nums):
    result = []
    current_subset = []
    nums.sort()

    def find_subsets(start_index):
        result.append(list(current_subset))

        for i in range(start_index, len(nums)):
            # Skip duplicates
            if i > start_index and nums[i] == nums[i-1]:
                continue

            current_subset.append(nums[i])
            find_subsets(i + 1)
            current_subset.pop()

    find_subsets(0)
    return result
```

---
### 9. Combination Sum - III
`[HARD]` `#recursion` `#backtracking`

#### Problem Statement
Find all valid combinations of `k` numbers that sum up to `n` such that the following conditions are true:
- Only numbers from 1 to 9 are used.
- Each number is used **at most once**.

**Example 1:**
- **Input:** k = 3, n = 7
- **Output:** `[[1, 2, 4]]`

**Example 2:**
- **Input:** k = 3, n = 9
- **Output:** `[[1, 2, 6], [1, 3, 5], [2, 3, 4]]`

#### Implementation Overview
This is a highly constrained combination sum problem. We are given `k` (the required size of the combination) and `n` (the target sum). The candidate numbers are implicitly the set `{1, 2, ..., 9}`.

1.  **Recursive Function Signature:** `find_combinations(start_num, k, n, current_combination)`
2.  **Base Case:**
    - If `len(current_combination) == k` and `n == 0`, we have found a valid combination. Add a copy to the results.
    - Return if `n < 0` or `len(current_combination) == k`.
3.  **Recursive Step:**
    - Iterate through the candidate numbers. The loop should go from `start_num` to 9.
    - For each number `i` in the loop:
        - Add `i` to `current_combination`.
        - Make a recursive call: `find_combinations(i + 1, k, n - i, current_combination)`. We use `i + 1` as the next starting number because each number can be used at most once.
        - Backtrack by removing `i` from `current_combination`.

#### Tricks/Gotchas
- **Pruning:** The search can be pruned. For example, the loop for `i` doesn't need to go all the way to 9 if `i` is already greater than the remaining target `n`.
- **State Management:** The recursive state must track not only the remaining sum but also the starting number to pick from and the number of elements still needed (`k`).
