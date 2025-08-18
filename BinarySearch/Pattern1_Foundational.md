# Pattern 1: Foundational Binary Search

This pattern covers the core binary search algorithm and its direct variations. These are the fundamental building blocks for all other binary search problems. The key is always a sorted search space and shrinking the problem by half in each step.

---

### 1. Binary Search to Find X
`[FUNDAMENTAL]` `#binary-search` `#core-logic`

#### Problem Statement
Given a sorted array of `n` elements and a target element `t`, find the index of `t` in the array. Return -1 if the target is not found.

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

### 2. Implement Lower Bound
`[FUNDAMENTAL]` `#binary-search` `#lower-bound`

#### Problem Statement
Find the index of the first element in a sorted array that is **greater than or equal to** a given value `x`. This is the definition of `lower_bound`.

#### Implementation Overview
1.  Initialize `low = 0`, `high = n - 1`, and `ans = n`.
2.  Loop while `low <= high`.
3.  If `arr[mid] >= x`: This is a potential answer. Store it (`ans = mid`) and try to find a better one in the left half (`high = mid - 1`).
4.  If `arr[mid] < x`: The element is too small. Discard the left half (`low = mid + 1`).
5.  Return `ans`.

---

### 3. Implement Upper Bound
`[FUNDAMENTAL]` `#binary-search` `#upper-bound`

#### Problem Statement
Find the index of the first element in a sorted array that is **strictly greater than** a given value `x`. This is the definition of `upper_bound`.

#### Implementation Overview
The implementation is nearly identical to `lower_bound`.
1.  Initialize `low = 0`, `high = n - 1`, and `ans = n`.
2.  Loop while `low <= high`.
3.  If `arr[mid] > x`: This is a potential answer. Store it (`ans = mid`) and search left (`high = mid - 1`).
4.  If `arr[mid] <= x`: The element is too small or equal. Discard the left half (`low = mid + 1`).
5.  Return `ans`.

---

### 4. Search Insert Position
`[EASY]` `#binary-search` `#lower-bound`

#### Problem Statement
Given a sorted array of distinct integers and a target value, return the index if the target is found. If not, return the index where it would be if it were inserted in order.

#### Implementation Overview
This problem is a direct application of `Lower Bound`. The definition of `lower_bound` (the first element >= x) is exactly the index where the element should be inserted to maintain order.

#### Related Problems
- `Implement Lower Bound`

---

### 5. Find the First or Last Occurrence of a Number
`[EASY]` `#binary-search` `#lower-bound`

#### Problem Statement
Given a sorted array with duplicate elements, find the first and last occurrences of a given number `x`.

#### Implementation Overview
1.  **First Occurrence:** This is a direct application of `lower_bound(arr, x)`.
2.  **Last Occurrence:** This can be found by searching for `upper_bound(arr, x) - 1`.

---

### 6. Count Occurrences of a Number
`[EASY]` `#binary-search`

#### Problem Statement
Given a sorted array with duplicates, count the number of occurrences of a number `x`.

#### Implementation Overview
1.  Find the `first` occurrence using `lower_bound`.
2.  Find the `last` occurrence using `upper_bound(arr, x) - 1`.
3.  The count is `last - first + 1`.

#### Related Problems
- `Find the First or Last Occurrence of a Number`

---

### 7. Floor/Ceil in Sorted Array
`[MEDIUM]` `#binary-search`

#### Problem Statement
- **Floor:** Find the largest number in a sorted array less than or equal to `x`.
- **Ceil:** Find the smallest number in a sorted array greater than or equal to `x`.

#### Implementation Overview
- **Ceil:** This is a direct application of `lower_bound`.
- **Floor:** This requires a slight modification to the binary search logic to keep track of the largest element seen so far that is `<= x`.
