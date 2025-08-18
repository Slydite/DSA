# Pattern 2: BS on Unconventionally Sorted Arrays

This pattern focuses on applying binary search to arrays that are not perfectly sorted in a single direction but have a distinct, exploitable structure. The core idea is to modify the binary search condition to identify which half of the array is "well-behaved" or sorted, and then decide whether to search in that half or the other.

---

### 1. Search in a Rotated Sorted Array (I & II)
`[MEDIUM]` `#binary-search` `#rotated-array`

#### Problem Statement
You are given an integer array `nums` sorted in ascending order (with distinct values in Part I, with duplicates in Part II), that has been rotated at an unknown pivot. Given a `target`, return the index of the `target` if it is in `nums`, or -1 otherwise.

**Example (Part I):** `nums = [4,5,6,7,0,1,2]`, `target = 0`. **Output:** `4`

#### Implementation Overview (Part I)
The key is to determine which half of the array (from `low` to `mid`, or `mid` to `high`) is sorted in each step.
1.  Initialize `low = 0`, `high = n - 1`.
2.  Loop while `low <= high`.
3.  Calculate `mid`. If `nums[mid] == target`, return `mid`.
4.  **Identify the sorted half:**
    -   Check if the left half is sorted: `if nums[low] <= nums[mid]`.
        -   If it is, check if the `target` lies within the range of the sorted left half (`nums[low] <= target < nums[mid]`).
        -   If yes, search left (`high = mid - 1`).
        -   If no, the target must be in the unsorted right half, so search right (`low = mid + 1`).
    -   Else, the right half must be sorted: `if nums[mid] <= nums[high]`.
        -   Check if the `target` lies within the range of the sorted right half (`nums[mid] < target <= nums[high]`).
        -   If yes, search right (`low = mid + 1`).
        -   If no, search left (`high = mid - 1`).

#### Python Code Snippet (Part I)
```python
def search_rotated(nums, target):
    low, high = 0, len(nums) - 1
    while low <= high:
        mid = low + (high - low) // 2
        if nums[mid] == target:
            return mid

        # Check if the left half is sorted
        if nums[low] <= nums[mid]:
            # Check if target is in the sorted left half
            if nums[low] <= target < nums[mid]:
                high = mid - 1
            else:
                low = mid + 1
        # Otherwise, the right half must be sorted
        else:
            # Check if target is in the sorted right half
            if nums[mid] < target <= nums[high]:
                low = mid + 1
            else:
                high = mid - 1
    return -1
```

#### Tricks/Gotchas (Part II - with duplicates)
- The condition `nums[low] <= nums[mid]` becomes ambiguous when `nums[low] == nums[mid] == nums[high]`. For example, in `[3, 1, 3, 3, 3]`, you cannot determine which half is sorted.
- **Solution:** If `nums[low] == nums[mid]`, you cannot be sure. In this specific case, you can safely shrink the search space by incrementing `low` (`low += 1`) and continue. This slightly degrades the worst-case performance to O(N) but maintains an average of O(log N).

#### Related Problems
- **Find Minimum in Rotated Sorted Array:** A variation where you find the pivot point. The logic is similar: find the sorted half and move towards the unsorted half to find the minimum.
- **Find out how many times an array has been rotated:** This is the same as finding the index of the minimum element.

---

### 2. Find Peak Element
`[HARD]` `#binary-search` `#bitonic-array`

#### Problem Statement
A peak element is an element that is strictly greater than its neighbors. Given an integer array `nums`, find a peak element, and return its index.

**Example:** `nums = [1,2,3,1]`. **Output:** `2` (The peak is 3).

#### Implementation Overview
We can use binary search because we can make a decision to go left or right at each step.
1.  Handle edge cases for arrays of size 1 or 2.
2.  Initialize `low = 1`, `high = n - 2`. We can ignore the first and last elements initially because if the peak is there, the loop will find it anyway.
3.  Loop while `low <= high`.
4.  Check `nums[mid]`. If `nums[mid] > nums[mid-1]` and `nums[mid] > nums[mid+1]`, it's a peak. Return `mid`.
5.  **Make a decision:**
    -   If `nums[mid-1] < nums[mid] < nums[mid+1]`, we are on an "uphill" slope. A peak must exist to the right. So, `low = mid + 1`.
    -   If `nums[mid-1] > nums[mid] > nums[mid+1]`, we are on a "downhill" slope. A peak must exist to the left. So, `high = mid - 1`.
    -   If `nums[mid]` is a valley (`nums[mid-1] > nums[mid] < nums[mid+1]`), a peak exists on both sides. We can go either way, e.g., `low = mid + 1`.

#### Python Code Snippet
```python
def find_peak_element(nums):
    n = len(nums)
    if n == 1: return 0
    if nums[0] > nums[1]: return 0
    if nums[n-1] > nums[n-2]: return n-1

    low, high = 1, n - 2
    while low <= high:
        mid = low + (high - low) // 2

        # Check if mid is a peak
        if nums[mid-1] < nums[mid] and nums[mid] > nums[mid+1]:
            return mid
        # If we are on an increasing slope, a peak is to the right
        elif nums[mid] < nums[mid+1]:
            low = mid + 1
        # If we are on a decreasing slope, a peak is to the left
        else: # nums[mid] > nums[mid+1]
            high = mid - 1
    return -1 # Should not be reached given problem constraints
```

---

### 3. Single Element in a Sorted Array
`[EASY]` `#binary-search` `#observation`

#### Problem Statement
You are given a sorted array consisting of only integers where every element appears exactly twice, except for one element which appears only once. Find this single element.

**Example:** `[1,1,2,3,3,4,4,8,8]`. **Output:** `2`.

#### Implementation Overview
The key observation is the indices. In the half of the array *before* the single element, pairs are at `(even, odd)` indices (e.g., `(0,1)`, `(2,3)`). *After* the single element, pairs are at `(odd, even)` indices. We can use this to guide our search.
1.  Initialize `low = 0`, `high = n - 2`. We can ignore the last element as it can't be the first of a pair.
2.  Loop while `low <= high`.
3.  Calculate `mid`.
4.  We want to ensure we are always on the left element of a potential pair, so if `mid` is odd, we can decrement it.
5.  Check if `nums[mid] == nums[mid+1]`.
    -   If they are equal, it means the pair at `(mid, mid+1)` is intact. The single element must be to the right. So, `low = mid + 2`.
    -   If they are not equal, it means the single element is in the current pair or to the left. So, `high = mid - 1`.
6.  The single element will be at index `low`.
