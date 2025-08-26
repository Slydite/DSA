### `[PATTERN] Recursion with Backtracking`

**Backtracking** is an algorithmic technique for solving problems recursively by trying to build a solution incrementally, one piece at a time. It removes those solutions that fail to satisfy the constraints of the problem at any point in time.

Think of it like navigating a maze. You explore one path. If you hit a dead end, you "backtrack" to the last junction and try a different path.

#### The Backtracking Template
Most backtracking problems can be solved using a common template:

```python
def backtrack(current_state, other_params):
    # Base Case: If the current state is a valid solution, add it to results.
    if is_a_solution(current_state):
        add_to_solutions(current_state)
        return

    # Iterate through all possible choices from the current state.
    for choice in all_possible_choices():
        # 1. Make a choice
        # Apply the choice to the current state.
        make_choice(choice)

        # 2. Recurse
        # Call the function with the updated state.
        backtrack(updated_state, other_params)

        # 3. Backtrack (Undo the choice)
        # Revert the state to what it was before making the choice.
        # This is the crucial step that allows exploring other paths.
        undo_choice(choice)
```

This pattern is powerful for solving problems related to permutations, combinations, subsets, and pathfinding.

---

### 1. Subsets (Power Set)
`[MEDIUM]` `#backtracking` `#subsets`

#### Problem Statement
Given an integer array `nums` of **unique** elements, return all possible subsets (the power set). The solution set must not contain duplicate subsets.

#### Implementation Overview
This is the canonical "pick / don't pick" backtracking problem. For each element in `nums`, we have two choices: either include it in our current subset or not include it.

- **Choice**: For each element, do we add it to the current subset?
- **State**: The current subset being built and the current index in `nums` we are considering.
- **Goal**: We have considered every element. Every state we reach is a valid subset.

#### Python Code Snippet
```python
def subsets(nums: list[int]) -> list[list[int]]:
    result = []
    current_subset = []

    def backtrack(index):
        # Base Case: Add the current subset configuration to the result.
        # This is a valid subset at every step.
        result.append(list(current_subset))

        # Explore choices for the remaining elements.
        for i in range(index, len(nums)):
            # 1. Make a choice: Include nums[i]
            current_subset.append(nums[i])

            # 2. Recurse: Explore further with this choice
            backtrack(i + 1)

            # 3. Backtrack: Undo the choice (remove nums[i])
            current_subset.pop()

    backtrack(0)
    return result
```

---

### 2. Subsets II (Contains Duplicates)
`[MEDIUM]` `#backtracking` `#subsets`

#### Problem Statement
Given an integer array `nums` that **may contain duplicates**, return all possible subsets (the power set). The solution set must not contain duplicate subsets.

#### Implementation Overview
This is a variation of the Subsets problem. To avoid duplicate subsets, we must handle the duplicate numbers in the input.
1.  **Sort the input array**: Sorting `nums` brings all duplicate elements together.
2.  **Modify the loop**: In the backtracking function, when we iterate through our choices, we add a condition: if the current element is the same as the previous one, and we are not at the beginning of the choices for this level, we **skip** it. This ensures that for a group of identical elements, we only pick the first one to start a new path, preventing duplicate subsets.

#### Python Code Snippet
```python
def subsets_with_dup(nums: list[int]) -> list[list[int]]:
    result = []
    current_subset = []
    nums.sort()  # Sort to handle duplicates

    def backtrack(index):
        result.append(list(current_subset))

        for i in range(index, len(nums)):
            # **The crucial part to avoid duplicates**
            # If the current element is the same as the previous one,
            # and we are not considering it for the first time in this level, skip it.
            if i > index and nums[i] == nums[i - 1]:
                continue

            current_subset.append(nums[i])
            backtrack(i + 1)
            current_subset.pop()

    backtrack(0)
    return result
```

---

### 3. Combination Sum
`[MEDIUM]` `#backtracking` `#combinations`

#### Problem Statement
Given an array of **distinct** integers `candidates` and a target integer `target`, return a list of all **unique combinations** of `candidates` where the chosen numbers sum to `target`. You may return the combinations in any order. The **same number may be chosen from `candidates` an unlimited number of times**.

#### Implementation Overview
This is a classic backtracking problem where we explore combinations that sum to a target.
- **Choice**: At each step, we can either choose the current candidate again (if the sum doesn't exceed the target) or move to the next candidate.
- **State**: The current combination, the current sum, and the index of the candidate we are considering.
- **Goal**: The current sum equals the `target`.

#### Python Code Snippet
```python
def combination_sum(candidates: list[int], target: int) -> list[list[int]]:
    result = []

    def backtrack(start_index, current_combination, current_sum):
        # Base Case: Successful solution
        if current_sum == target:
            result.append(list(current_combination))
            return

        # Base Case: Pruning - path is no longer viable
        if current_sum > target:
            return

        # Explore choices
        for i in range(start_index, len(candidates)):
            candidate = candidates[i]

            # 1. Make a choice
            current_combination.append(candidate)

            # 2. Recurse
            # We pass `i` instead of `i + 1` because we can reuse the same element.
            backtrack(i, current_combination, current_sum + candidate)

            # 3. Backtrack
            current_combination.pop()

    backtrack(0, [], 0)
    return result
```

---

### 4. Combination Sum II (No Duplicate Combinations)
`[MEDIUM]` `#backtracking` `#combinations`

#### Problem Statement
Given a collection of candidate numbers `candidates` (which **may contain duplicates**) and a target integer `target`, find all **unique combinations** in `candidates` where the candidate numbers sum to `target`. **Each number in `candidates` may only be used once** in the combination.

#### Implementation Overview
This problem has two key differences from Combination Sum I:
1.  Each candidate can be used only once.
2.  The input array can have duplicates, but the result should not have duplicate combinations.

This combination of constraints leads to a solution similar to Subsets II.
1.  **Sort the input**: Sort `candidates` to group duplicates.
2.  **Use each element once**: In the recursive call, pass `i + 1` as the next starting index, not `i`. This prevents reusing the same element.
3.  **Skip duplicates**: Just like in Subsets II, in the choice-making loop, if `i > start_index` and `candidates[i] == candidates[i - 1]`, we `continue`. This prevents creating duplicate combinations like `[1, 7]` and `[1, 7]` when the input is `[1, 1, 7]`.

#### Python Code Snippet
```python
def combination_sum2(candidates: list[int], target: int) -> list[list[int]]:
    result = []
    candidates.sort()

    def backtrack(start_index, current_combination, current_sum):
        if current_sum == target:
            result.append(list(current_combination))
            return

        if current_sum > target:
            return

        for i in range(start_index, len(candidates)):
            # Skip duplicates to avoid duplicate combinations
            if i > start_index and candidates[i] == candidates[i - 1]:
                continue

            candidate = candidates[i]

            # Pruning: if the current candidate is too large, the rest will be too.
            if current_sum + candidate > target:
                break

            current_combination.append(candidate)
            # Recurse with `i + 1` because each number can be used only once.
            backtrack(i + 1, current_combination, current_sum + candidate)
            current_combination.pop()

    backtrack(0, [], 0)
    return result
```

---

### 5. Generate Parentheses
`[MEDIUM]` `#backtracking` `#string-generation`

#### Problem Statement
Given `n` pairs of parentheses, write a function to generate all combinations of well-formed parentheses.

#### Implementation Overview
We build the string character by character, and at each step, we have two choices: add a '(' or add a ')'. However, we must follow constraints.
- **State**: The current string being built, the number of open parentheses used (`open_count`), and the number of closed parentheses used (`close_count`).
- **Choices & Constraints**:
    1. We can add an open parenthesis `(` if `open_count < n`.
    2. We can add a closed parenthesis `)` if `close_count < open_count`. This is the key constraint that ensures the parentheses are well-formed.
- **Goal**: The length of the string is `2 * n`.

#### Python Code Snippet
```python
def generate_parenthesis(n: int) -> list[str]:
    result = []

    def backtrack(current_string, open_count, close_count):
        # Base Case: A valid solution is found
        if len(current_string) == 2 * n:
            result.append(current_string)
            return

        # Choice 1: Add an open parenthesis
        if open_count < n:
            backtrack(current_string + "(", open_count + 1, close_count)

        # Choice 2: Add a closed parenthesis
        if close_count < open_count:
            backtrack(current_string + ")", open_count, close_count + 1)

    backtrack("", 0, 0)
    return result
```
