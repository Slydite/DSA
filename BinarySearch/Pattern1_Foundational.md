# Pattern 1: Foundational Binary Search

This pattern covers the core binary search algorithm and its direct variations. These are the fundamental building blocks for all other binary search problems. The key is always a sorted search space and shrinking the problem by half in each step.

---

### 1. Binary Search to Find X
`[FUNDAMENTAL]` `#binary-search` `#core-logic`

#### Problem Statement
Given a sorted array of `n` elements and a target element `t`, find the index of `t` in the array. Return -1 if the target is not found.

#### Implementation Overview
The algorithm maintains two pointers, `low` and `high`, representing the boundaries of the search space.
1.  Initialize `low = 0`, `high = n - 1`.
2.  Loop as long as `low <= high`.
3.  Calculate the middle index: `mid = low + (high - low) // 2` (this prevents overflow).
4.  If `arr[mid] == t`, the target is found. Return `mid`.
5.  If `arr[mid] < t`, the target must be in the right half. Discard the left half by setting `low = mid + 1`.
6.  If `arr[mid] > t`, the target must be in the left half. Discard the right half by setting `high = mid - 1`.
7.  If the loop finishes, the target was not found. Return -1.

#### Python Code Snippet
```python
def binary_search(arr, target):
    low, high = 0, len(arr) - 1
    while low <= high:
        mid = low + (high - low) // 2
        if arr[mid] == target:
            return mid
        elif arr[mid] < target:
            low = mid + 1
        else:
            high = mid - 1
    return -1
```

---

### 2. Implement Lower Bound / Upper Bound
`[FUNDAMENTAL]` `#binary-search` `#lower-bound` `#upper-bound`

#### Problem Statement
- **Lower Bound:** Find the index of the first element in a sorted array that is **greater than or equal to** a given value `x`.
- **Upper Bound:** Find the index of the first element in a sorted array that is **strictly greater than** a given value `x`.

#### Implementation Overview (Lower Bound)
The logic is a slight modification of the standard binary search.
1.  Initialize `low = 0`, `high = n - 1`, and `ans = n` (a placeholder for the case where no element is >= x).
2.  Loop while `low <= high`.
3.  If `arr[mid] >= x`: This is a potential answer. Store it (`ans = mid`) and try to find an even smaller index in the left half (`high = mid - 1`).
4.  If `arr[mid] < x`: The element is too small. Discard the left half (`low = mid + 1`).
5.  Return `ans`.

#### Python Code Snippet (Lower Bound)
```python
def lower_bound(arr, x):
    low, high = 0, len(arr) - 1
    ans = len(arr)
    while low <= high:
        mid = low + (high - low) // 2
        if arr[mid] >= x:
            # This could be our answer, so store it and look for a better one on the left
            ans = mid
            high = mid - 1
        else:
            # This element is too small, discard the left half
            low = mid + 1
    return ans
```
#### Tricks/Gotchas
- The implementation for `Upper Bound` is nearly identical, but the condition changes to `arr[mid] > x`.
- `Search Insert Position` is a direct application of `Lower Bound`.

---

### 3. First and Last Occurrence of a Number
`[EASY]` `#binary-search` `#lower-bound`

#### Problem Statement
Given a sorted array with duplicate elements, find the first and last occurrences of a given number `x`.

**Example:** `arr = [2, 4, 10, 10, 10, 18, 20]`, `x = 10`. **Output:** `[2, 4]`

#### Implementation Overview
This is a perfect use case for lower and upper bounds.
1.  **First Occurrence:** The first occurrence of `x` is simply the `lower_bound(arr, x)`.
2.  **Last Occurrence:** The last occurrence of `x` can be found by searching for the `upper_bound(arr, x)` and subtracting 1. The `upper_bound` gives the index of the first element *greater than* `x`, so the element just before it must be the last occurrence of `x`.
3.  Handle edge cases where the element is not found. If `lower_bound` points to an element that is not `x`, then `x` is not in the array.

#### Related Problems
- **Count Occurrences:** This can be solved with `last_occurrence - first_occurrence + 1`.

---

### 4. Floor/Ceil in Sorted Array
`[MEDIUM]` `#binary-search`

#### Problem Statement
- **Floor:** Find the largest number in a sorted array less than or equal to `x`.
- **Ceil:** Find the smallest number in a sorted array greater than or equal to `x`.

#### Implementation Overview
- **Ceil:** The ceil of `x` is a direct application of `lower_bound(arr, x)`.
- **Floor:** The floor can be found with a binary search variation similar to lower bound. Keep track of a potential answer `ans` whenever `arr[mid] <= x` and continue searching in the right half (`low = mid + 1`) for a potentially larger value that still meets the condition.
