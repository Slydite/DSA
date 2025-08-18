# Pattern 1: Simple Traversal & Manipulation

This file covers fundamental array problems that can be solved with a single, straightforward pass through the array, simple loops, or a basic greedy choice at each step. These problems form the foundation of array manipulation and are crucial for understanding more complex patterns.

---

### 1. Largest Element in an Array
`[FUNDAMENTAL]` `#traversal`

#### Problem Statement
Given an array of integers, find the largest element in it.

**Example:** `arr = [8, 10, 5, 7, 9]`, **Output:** `10`

#### Implementation Overview
1.  Initialize a variable, `max_element`, with the first element of the array.
2.  Iterate through the array from the second element.
3.  For each element, compare it with `max_element`. If the current element is greater, update `max_element`.
4.  After the loop, `max_element` will hold the largest value.

---

### 2. Second Largest Element in an Array
`[FUNDAMENTAL]` `#traversal`

#### Problem Statement
Given an array of integers, find the second largest element without sorting.

**Example:** `arr = [12, 35, 1, 10, 34, 1]`, **Output:** `34`

#### Implementation Overview
1.  Initialize `largest` and `second_largest` to a very small number (e.g., negative infinity).
2.  Iterate through the array. For each element `current`:
    -   If `current > largest`, update `second_largest = largest`, then `largest = current`.
    -   Else if `current > second_largest` and `current < largest`, update `second_largest = current`.

#### Tricks/Gotchas
- The `current < largest` check is crucial for cases with duplicate largest elements (e.g., `[10, 5, 10]`).

---

### 3. Remove Duplicates from Sorted Array
`[EASY]` `#two-pointers`

#### Problem Statement
Given a sorted array, remove duplicates in-place such that each unique element appears once. Return `k`, the number of unique elements.

**Example:** `nums = [0,0,1,1,1,2,2]`, **Output:** `k = 3`, with `nums` becoming `[0,1,2,...]`

#### Implementation Overview
Use a "slow" pointer `i` for the position of the next unique element and a "fast" pointer `j` to scan the array.
1.  Initialize `i = 0`.
2.  Iterate with `j` from `1` to `n-1`.
3.  If `nums[j] != nums[i]`, it's a new unique element. Increment `i` and then set `nums[i] = nums[j]`.
4.  The number of unique elements is `i + 1`.

---

### 4. Left Rotate an Array by D Places
`[TRICK]` `#reversal-algorithm` `#inplace`

#### Problem Statement
Given an array, left rotate it by `d` places.

**Example:** `arr = [1,2,3,4,5,6,7]`, `d = 3`, **Output:** `[4,5,6,7,1,2,3]`

#### Implementation Overview
The optimal O(N) time, O(1) space solution is the Reversal Algorithm.
1.  Handle `d >= n` by taking the modulus: `d = d % n`.
2.  Reverse the first `d` elements.
3.  Reverse the remaining `n-d` elements.
4.  Reverse the entire array.

#### Python Code Snippet
```python
def reverse(arr, start, end):
    while start < end:
        arr[start], arr[end] = arr[end], arr[start]
        start += 1
        end -= 1

def rotate_left(arr, d):
    n = len(arr)
    d = d % n
    if d == 0:
        return

    # 1. Reverse the first d elements
    reverse(arr, 0, d - 1)
    # 2. Reverse the remaining n-d elements
    reverse(arr, d, n - 1)
    # 3. Reverse the entire array
    reverse(arr, 0, n - 1)
```

---

### 5. Move Zeros to End
`[FUNDAMENTAL]` `#two-pointers` `#inplace`

#### Problem Statement
Move all `0`s to the end of an array while maintaining the relative order of non-zero elements.

**Example:** `nums = [0, 1, 0, 3, 12]`, **Output:** `[1, 3, 12, 0, 0]`

#### Implementation Overview
1.  Initialize a pointer `j = 0`. This pointer marks the position where the next non-zero element should be placed.
2.  Iterate through the array with `i`.
3.  If `nums[i]` is not zero, swap `nums[i]` with `nums[j]` and increment `j`.

---

### 6. Leaders in an Array
`[EASY]` `#greedy` `#traversal`

#### Problem Statement
Find all elements that are greater than or equal to all elements to their right.

**Example:** `A = [16, 17, 4, 3, 5, 2]`, **Output:** `[17, 5, 2]`

#### Implementation Overview
The optimal solution scans from right to left.
1.  Initialize `max_from_right` to the last element (which is always a leader).
2.  Iterate from the second-to-last element to the start.
3.  If the current element is greater than `max_from_right`, it's a leader.
4.  Update `max_from_right` in each step.

---

### 7. Stock Buy and Sell
`[EASY]` `#greedy`

#### Problem Statement
Find the maximum profit from buying a stock on one day and selling it on a future day.

**Example:** `prices = [7, 1, 5, 3, 6, 4]`, **Output:** `5`

#### Implementation Overview
A greedy single pass is most efficient.
1.  Initialize `min_price` to a very large value and `max_profit` to 0.
2.  Iterate through the prices. For each price:
    -   Update `min_price = min(min_price, current_price)`.
    -   Calculate potential profit: `profit = current_price - min_price`.
    -   Update `max_profit = max(max_profit, profit)`.

#### Python Code Snippet
```python
def max_profit(prices):
    min_price = float('inf')
    max_profit = 0
    for price in prices:
        # Update the minimum price seen so far
        if price < min_price:
            min_price = price
        # Calculate profit if selling today and update max_profit
        elif price - min_price > max_profit:
            max_profit = price - min_price
    return max_profit
```
