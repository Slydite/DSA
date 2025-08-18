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
    -   Else, the right half must be sorted.
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
            if nums[low] <= target < nums[mid]:
                high = mid - 1
            else:
                low = mid + 1
        # Otherwise, the right half must be sorted
        else:
            if nums[mid] < target <= nums[high]:
                low = mid + 1
            else:
                high = mid - 1
    return -1
```

#### Tricks/Gotchas (Part II - with duplicates)
- The condition `nums[low] <= nums[mid]` becomes ambiguous when `nums[low] == nums[mid] == nums[high]`.
- **Solution:** If `nums[low] == nums[mid]`, you cannot be sure which half is sorted. In this specific case, you can safely shrink the search space by incrementing `low` (`low += 1`) and continue. This slightly degrades the worst-case performance to O(N) but maintains an average of O(log N).

---

### 2. Find Minimum in Rotated Sorted Array
`[MEDIUM]` `#binary-search` `#rotated-array`

#### Problem Statement
Given a rotated sorted array of unique elements, find its minimum element.

**Example:** `[3,4,5,1,2]`. **Output:** `1`.

#### Implementation Overview
The minimum element is the pivot point. We can find it by always moving towards the unsorted half of the array.
1.  `low = 0`, `high = n - 1`. `ans = infinity`.
2.  Loop `low <= high`.
3.  Identify the sorted half. The minimum of the sorted half is its first element. Update `ans` with this minimum.
4.  Move towards the unsorted half to find an even smaller minimum.
    -   If left half (`nums[low] <= nums[mid]`) is sorted, the pivot must be in the right half. `low = mid + 1`.
    -   If right half is sorted, the pivot must be in the left half. `high = mid - 1`.

#### Related Problems
- **Find out how many times an array has been rotated:** This is the same as finding the index of the minimum element.

---

### 3. Find Peak Element
`[HARD]` `#binary-search` `#bitonic-array`

#### Problem Statement
A peak element is an element that is strictly greater than its neighbors. Given `nums`, find a peak element and return its index.

**Example:** `nums = [1,2,3,1]`. **Output:** `2` (The peak is 3).

#### Implementation Overview
We can use binary search because we can always decide whether to go left or right.
1.  Handle edge cases for arrays of size 1 or if the peak is at the ends.
2.  `low = 1`, `high = n - 2`.
3.  Loop while `low <= high`.
4.  Check `nums[mid]`. If it's greater than `nums[mid-1]` and `nums[mid+1]`, it's a peak.
5.  If `nums[mid] < nums[mid+1]`, we are on an "uphill" slope. A peak must be to the right. `low = mid + 1`.
6.  If `nums[mid] > nums[mid+1]`, we are on a "downhill" slope. A peak must be to the left. `high = mid - 1`.

---

### 4. Single Element in a Sorted Array
`[EASY]` `#binary-search` `#observation`

#### Problem Statement
You are given a sorted array where every element appears twice, except for one which appears once. Find this single element.

**Example:** `[1,1,2,3,3,4,4,8,8]`. **Output:** `2`.

#### Implementation Overview
The key observation is the indices. Before the single element, pairs are at `(even, odd)` indices. After, they are at `(odd, even)`.
1.  `low = 0`, `high = n - 2`.
2.  Loop `low <= high`.
3.  Calculate `mid`. We want to check pairs, so if `mid` is odd, decrement it to get to the start of a potential pair.
4.  If `nums[mid] == nums[mid+1]`, the pair is intact. The single element must be to the right. `low = mid + 2`.
5.  If they are not equal, the single element is in the current pair or to the left. `high = mid - 1`.
6.  The single element will be at index `low`.
