# Pattern 1: Basic Traversal & Simple Manipulations

This pattern covers problems that can be solved by iterating through the array once or a fixed number of times. The logic inside the loop is typically simple, involving comparisons, assignments, or basic arithmetic. These problems form the foundation of array manipulation.

---

### 1. Largest Element in an Array
`[FUNDAMENTAL]` `[EASY]` `#traversal`

#### Problem Statement
Given an array of integers, find the largest element in it.

*Example:*
- **Input:** `arr = [2, 5, 1, 3, 0]`
- **Output:** `5`

#### Implementation Overview
The logic is to maintain a variable, `max_element`, that stores the largest element found so far.
1. Initialize `max_element` with the first element of the array.
2. Iterate through the array from the second element (`i = 1` to `n-1`).
3. In each iteration, compare the current element `arr[i]` with `max_element`.
4. If `arr[i]` is greater than `max_element`, update `max_element` to `arr[i]`.
5. After the loop completes, `max_element` will hold the largest value in the array.

#### Python Code Snippet
```python
def find_largest_element(arr):
  if not arr:
    return None
  max_element = arr[0]
  for i in range(1, len(arr)):
    if arr[i] > max_element:
      max_element = arr[i]
  return max_element
```

#### Tricks/Gotchas
- **Edge Case:** Always consider an empty array. The code above handles it by returning `None`. A single-element array is also a valid case and is handled correctly.

#### Related Problems
- 2. Second Largest Element in an Array

---

### 2. Second Largest Element in an Array without sorting
`[EASY]` `#traversal`

#### Problem Statement
Given an array of integers, find the second largest element. If no second largest element exists, return -1.

*Example:*
- **Input:** `arr = [12, 35, 1, 10, 34, 1]`
- **Output:** `34`

#### Implementation Overview
We can find the second largest element in a single pass. The idea is to maintain two variables: `largest` and `second_largest`.
1. Initialize `largest` to the first element and `second_largest` to a very small number (or handle it logically).
2. Iterate through the array from the second element.
3. For each element `arr[i]`:
    - If `arr[i]` is greater than `largest`, it becomes the new largest. The old `largest` becomes the new `second_largest`.
    - Else, if `arr[i]` is smaller than `largest` but greater than `second_largest`, it becomes the new `second_largest`.
4. This ensures we correctly track both values, even with duplicates.

#### Python Code Snippet
```python
def find_second_largest(arr):
  if len(arr) < 2:
    return -1

  largest = float('-inf')
  second_largest = float('-inf')

  for num in arr:
    if num > largest:
      second_largest = largest
      largest = num
    elif num > second_largest and num != largest:
      second_largest = num

  return second_largest if second_largest != float('-inf') else -1
```

#### Tricks/Gotchas
- **Duplicates:** The condition `num != largest` is crucial to handle cases like `[10, 10, 5]` where `10` is the largest and `5` is the second largest. Without it, `second_largest` could become `10`.
- **No Second Largest:** If all elements are the same (e.g., `[5, 5, 5]`), there is no second largest. The code should handle this, for instance by returning -1.

#### Related Problems
- 1. Largest Element in an Array

---

### 3. Check if the array is sorted
`[EASY]` `#traversal`

#### Problem Statement
Given an array of integers, determine if the array is sorted in non-decreasing (ascending) order.

*Example:*
- **Input:** `arr = [1, 2, 2, 3, 4]`
- **Output:** `True`
- **Input:** `arr = [1, 3, 2, 4, 5]`
- **Output:** `False`

#### Implementation Overview
This can be checked with a single pass through the array.
1. Iterate from the first element up to the second-to-last element (`i = 0` to `n-2`).
2. In each iteration, compare the current element `arr[i]` with the next element `arr[i+1]`.
3. If you find any pair where `arr[i] > arr[i+1]`, the array is not sorted, and you can immediately return `False`.
4. If the loop completes without finding such a pair, the array is sorted, so you return `True`.

#### Python Code Snippet
```python
def is_sorted(arr):
  n = len(arr)
  if n <= 1:
    return True
  for i in range(n - 1):
    if arr[i] > arr[i+1]:
      return False
  return True
```

#### Tricks/Gotchas
- **Edge Cases:** Empty arrays and single-element arrays are considered sorted. The code handles this correctly.
- **Strictly Increasing vs. Non-decreasing:** The problem usually implies non-decreasing (i.e., `[1, 2, 2, 3]` is sorted). Be clear on this requirement.

#### Related Problems
- None in this list.

---

### 5. Left Rotate an array by one place
`[EASY]` `#traversal` `#inplace`

#### Problem Statement
Given an array, rotate its elements to the left by one position. The first element moves to the last position.

*Example:*
- **Input:** `arr = [1, 2, 3, 4, 5]`
- **Output:** `[2, 3, 4, 5, 1]`

#### Implementation Overview
This is a simple in-place manipulation.
1. Store the first element (`arr[0]`) in a temporary variable.
2. Iterate from the first element to the second-to-last element (`i = 0` to `n-2`).
3. In each step, shift the element at `i+1` to position `i`. That is, `arr[i] = arr[i+1]`.
4. After the loop, assign the value from the temporary variable to the last element of the array (`arr[n-1]`).

#### Python Code Snippet
```python
def left_rotate_by_one(arr):
  n = len(arr)
  if n <= 1:
    return arr

  temp = arr[0]
  for i in range(n - 1):
    arr[i] = arr[i+1]
  arr[n-1] = temp
  return arr
```

#### Tricks/Gotchas
- **In-place Modification:** The goal is usually to modify the array in-place to save memory.
- **Edge Case:** An array with 0 or 1 elements does not need rotation.

#### Related Problems
- 6. Left rotate an array by D places

---

### 8. Linear Search
`[FUNDAMENTAL]` `[EASY]` `#traversal` `#search`

#### Problem Statement
Given an array of integers and a target value, find the index of the first occurrence of the target in the array. If the target is not present, return -1.

*Example:*
- **Input:** `arr = [4, 5, 6, 7, 0, 1, 2]`, `target = 0`
- **Output:** `4`

#### Implementation Overview
This is the most straightforward search algorithm.
1. Iterate through the array from the first element to the last (`i = 0` to `n-1`).
2. In each iteration, check if the current element `arr[i]` is equal to the `target`.
3. If a match is found, return the current index `i`.
4. If the loop completes without finding the target, it means the element is not in the array. Return -1.

#### Python Code Snippet
```python
def linear_search(arr, target):
  for i in range(len(arr)):
    if arr[i] == target:
      return i
  return -1
```

#### Tricks/Gotchas
- **Simplicity:** Don't overthink it. Linear search is the brute-force approach and is efficient for small or unsorted arrays.
- **Return Value:** Be clear about what to return if the element is not found (commonly -1, but could be `None` or an exception).

#### Related Problems
- None in this list.

---

### 10. Find missing number in an array
`[EASY]` `#traversal` `#math` `#summation` `#bitwise`

#### Problem Statement
Given an array containing `N-1` distinct integers from the range `[1, N]`, find the single missing number.

*Example:*
- **Input:** `arr = [1, 2, 4, 5]`, `N = 5`
- **Output:** `3`

#### Implementation Overview
There are two common and efficient approaches.

**1. Summation Method:**
1. Calculate the expected sum of the first `N` natural numbers using the formula: `expected_sum = N * (N + 1) // 2`.
2. Calculate the actual sum of all elements present in the input array.
3. The missing number is the difference between the `expected_sum` and the `actual_sum`.

**2. XOR Method:**
1. The XOR property `x ^ x = 0` is key.
2. XOR all numbers from 1 to `N`. Let this be `xor1`.
3. XOR all elements in the given array. Let this be `xor2`.
4. The result of `xor1 ^ xor2` will be the missing number, as all other numbers will appear twice in the combined set and cancel each other out.

#### Python Code Snippet (Summation)
```python
def find_missing_number_sum(arr, N):
  expected_sum = N * (N + 1) // 2
  actual_sum = sum(arr)
  return expected_sum - actual_sum
```

#### Tricks/Gotchas
- **Integer Overflow:** For very large `N`, the summation method could potentially lead to an integer overflow if using fixed-size integers in other languages. The XOR method avoids this.
- **Range:** This solution assumes the range is `[1, N]`. If the range is `[0, N-1]`, the formulas must be adjusted.

#### Related Problems
- 37. Find the repeating and missing number
- 12. Find the number that appears once, and other numbers twice

---

### 11. Maximum Consecutive Ones
`[EASY]` `#traversal` `#counting`

#### Problem Statement
Given a binary array (containing only 0s and 1s), find the maximum number of consecutive 1s.

*Example:*
- **Input:** `arr = [1, 1, 0, 1, 1, 1, 0, 1, 1]`
- **Output:** `3`

#### Implementation Overview
This can be solved in a single pass.
1. Initialize two variables: `max_count = 0` (to store the final answer) and `current_count = 0` (to track the current streak of 1s).
2. Iterate through the array.
3. If the current element is `1`, increment `current_count`.
4. If the current element is `0`:
    - The streak is broken. Compare `current_count` with `max_count` and update `max_count` if `current_count` is larger.
    - Reset `current_count` to `0`.
5. After the loop, there's a final check: `max_count = max(max_count, current_count)`. This is crucial for cases where the longest streak of 1s is at the end of the array.

#### Python Code Snippet
```python
def max_consecutive_ones(arr):
  max_count = 0
  current_count = 0
  for num in arr:
    if num == 1:
      current_count += 1
    else:
      max_count = max(max_count, current_count)
      current_count = 0
  max_count = max(max_count, current_count)
  return max_count
```

#### Tricks/Gotchas
- **Final Update:** Forgetting the final `max(max_count, current_count)` after the loop is a common mistake. It handles inputs like `[1, 1, 1]`.

#### Related Problems
- None in this list.

---

### 12. Find the number that appears once, and other numbers twice
`[MEDIUM]` `#traversal` `#bitwise` `#xor`

#### Problem Statement
Given a non-empty array of integers, every element appears twice except for one. Find that single one.

*Example:*
- **Input:** `arr = [4, 1, 2, 1, 2]`
- **Output:** `4`

#### Implementation Overview
This problem has a beautiful and highly efficient solution using the bitwise XOR operator.
- The XOR operation has two key properties: `A ^ A = 0` (XORing a number with itself results in zero) and `A ^ 0 = A` (XORing a number with zero results in the number itself).
- It is also commutative and associative.
1. Initialize a variable, `single_element`, to 0.
2. Iterate through every number in the array.
3. In each iteration, XOR `single_element` with the current number: `single_element = single_element ^ num`.
4. Because all duplicate numbers will cancel each other out (`num ^ num = 0`), the final value of `single_element` will be the one number that did not have a pair.

#### Python Code Snippet
```python
def find_single_number(arr):
  single_element = 0
  for num in arr:
    single_element ^= num
  return single_element
```

#### Tricks/Gotchas
- **The XOR Trick:** This is the core of the problem. While a hashmap could also solve it, it would use extra space. The XOR solution is O(N) time and O(1) space, making it optimal.
- **Problem Constraints:** This trick only works if all other numbers appear exactly twice.

#### Related Problems
- 10. Find missing number in an array
- 30. Majority Element (n/3 times) (more advanced bitwise/voting)

---

### 20. Stock Buy and Sell
`[EASY]` `#traversal` `#greedy`

#### Problem Statement
You are given an array `prices` where `prices[i]` is the price of a given stock on the `i`-th day. You want to maximize your profit by choosing a single day to buy one stock and choosing a different day in the future to sell that stock. Return the maximum profit you can achieve. If you cannot achieve any profit, return 0.

*This problem has multiple variations. The version on the list implies you can transact multiple times (buy and sell on the same day is allowed), which simplifies to a greedy approach.*

#### Implementation Overview (Multiple Transactions)
The key insight is that you can accumulate profits from all upward price movements.
1. Initialize `total_profit = 0`.
2. Iterate through the `prices` array from the second day (`i = 1` to `n-1`).
3. If `prices[i]` is greater than `prices[i-1]`, it represents a profitable one-day transaction.
4. Add the difference `prices[i] - prices[i-1]` to `total_profit`.
5. This works because a long upward trend `(p3 - p0)` is the sum of its smaller parts `(p1 - p0) + (p2 - p1) + (p3 - p2)`.

#### Python Code Snippet
```python
def max_profit_multiple(prices):
  total_profit = 0
  for i in range(1, len(prices)):
    if prices[i] > prices[i-1]:
      total_profit += prices[i] - prices[i-1]
  return total_profit
```

#### Tricks/Gotchas
- **Problem Variation:** Be very careful which version of the "Stock Buy and Sell" problem you are solving. The "buy once, sell once" version requires a different approach (tracking min price so far).
- **Greedy Choice:** The greedy choice of taking every small profit is optimal for the multiple-transaction version.

#### Related Problems
- 18. Kadane's Algorithm, maximum subarray sum (The "buy once, sell once" variant is related to Kadane's).

---

### 23. Leaders in an Array problem
`[EASY]` `#traversal` `#suffix-max`

#### Problem Statement
Given an integer array, find all the "leaders". An element is a leader if it is greater than or equal to all the elements to its right side. The rightmost element is always a leader.

*Example:*
- **Input:** `arr = [16, 17, 4, 3, 5, 2]`
- **Output:** `[17, 5, 2]`

#### Implementation Overview
A naive solution would be O(N^2) (for each element, scan its right side). The optimal solution is O(N) by traversing from right to left.
1. Initialize an empty list `leaders` to store the result.
2. Initialize a variable `max_from_right` to the smallest possible value. The rightmost element `arr[n-1]` is always a leader, so we can start with it.
3. Add `arr[n-1]` to `leaders` and set `max_from_right = arr[n-1]`.
4. Iterate through the array from the second-to-last element down to the first (`i = n-2` down to `0`).
5. For each element `arr[i]`, if it is greater than `max_from_right`, it is a leader.
    - Add `arr[i]` to the `leaders` list.
    - Update `max_from_right = arr[i]`.
6. Since we traversed from the right, the `leaders` list is in reverse order. Reverse it before returning.

#### Python Code Snippet
```python
def find_leaders(arr):
  n = len(arr)
  if n == 0:
    return []

  leaders = []
  max_from_right = arr[n-1]
  leaders.append(max_from_right)

  for i in range(n - 2, -1, -1):
    if arr[i] >= max_from_right: # Note: problem says "greater than or equal to"
      max_from_right = arr[i]
      leaders.append(max_from_right)

  return leaders[::-1] # Reverse to get original order
```

#### Tricks/Gotchas
- **Traversal Direction:** Right-to-left is the key insight for an O(N) solution.
- **Output Order:** The problem statement doesn't always specify the required order of leaders. Reversing at the end is common to match the original array's relative order.

#### Related Problems
- None in this list.
