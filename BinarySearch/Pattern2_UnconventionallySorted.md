# Pattern 2: BS on Unconventionally Sorted Arrays

This pattern focuses on applying binary search to arrays that are not perfectly sorted in a single direction but have a distinct, exploitable structure. The core idea is to modify the binary search condition to identify which half of the array is "well-behaved" or sorted, and then decide whether to search in that half or the other, potentially unsorted, half.

---

### 1. Search in a Rotated Sorted Array I
`[MEDIUM]` `#binary-search` `#rotated-array`

#### Problem Statement
An array of **distinct values** sorted in ascending order is rotated at some unknown pivot. Given a `target`, return its index if it exists, otherwise return -1.

*Example:*
- **Input:** `nums = [4,5,6,7,0,1,2]`, `target = 0`
- **Output:** `4`
- **Input:** `nums = [4,5,6,7,0,1,2]`, `target = 3`
- **Output:** `-1`

#### Implementation Overview
The key is to identify the sorted half in each step of the binary search.
1.  Initialize `low = 0`, `high = n - 1`.
2.  In each iteration, calculate `mid`.
3.  Check if the left half (`nums[low]` to `nums[mid]`) is sorted by testing `if nums[low] <= nums[mid]`.
4.  **If Left Half is Sorted:**
    -   Check if the `target` lies within the range of this sorted half (`nums[low] <= target < nums[mid]`).
    -   If yes, the target must be here. Discard the right half: `high = mid - 1`.
    -   If no, the target must be in the unsorted right half. Discard the left half: `low = mid + 1`.
5.  **If Right Half is Sorted:** (`else` block)
    -   Check if the `target` lies within the range of the sorted right half (`nums[mid] < target <= nums[high]`).
    -   If yes, search right: `low = mid + 1`.
    -   If no, search left: `high = mid - 1`.

#### Python Code Snippet
```python
def search_in_rotated_array(nums, target):
    low, high = 0, len(nums) - 1
    while low <= high:
        mid = low + (high - low) // 2
        if nums[mid] == target:
            return mid

        # Check if the left half is sorted
        if nums[low] <= nums[mid]:
            if nums[low] <= target < nums[mid]:
                high = mid - 1 # Target is in the sorted left half
            else:
                low = mid + 1  # Target is in the unsorted right half
        # Otherwise, the right half must be sorted
        else:
            if nums[mid] < target <= nums[high]:
                low = mid + 1  # Target is in the sorted right half
            else:
                high = mid - 1 # Target is in the unsorted left half
    return -1
```

#### Tricks/Gotchas
- **Identifying the Sorted Part:** The condition `nums[low] <= nums[mid]` is the most reliable way to check if the left part of the array is sorted. If it is, the pivot is on the right. If not, the pivot is on the left.

---

### 2. Search in a Rotated Sorted Array II
`[MEDIUM]` `#binary-search` `#rotated-array` `#duplicates`

#### Problem Statement
This is a follow-up to the above problem, but the array can contain **duplicate values**.

*Example:*
- **Input:** `nums = [2,5,6,0,0,1,2]`, `target = 0`
- **Output:** `true`

#### Implementation Overview
The core logic is the same, but it breaks down in one specific case: when `nums[low] == nums[mid] == nums[high]`. In this scenario (e.g., `[3, 1, 2, 3, 3, 3, 3]`), we cannot determine which half is sorted.
- **Solution:** When this specific condition is met, we cannot make an informed decision. We can, however, safely shrink the search space by moving the `low` and `high` pointers inwards (`low += 1`, `high -= 1`) and then continue the binary search. This slightly degrades the worst-case performance to O(N) but maintains an average case of O(log N).

#### Python Code Snippet
```python
def search_in_rotated_array_ii(nums, target):
    low, high = 0, len(nums) - 1
    while low <= high:
        mid = low + (high - low) // 2
        if nums[mid] == target:
            return True

        # The tricky case: duplicates
        if nums[low] == nums[mid] and nums[mid] == nums[high]:
            low += 1
            high -= 1
            continue

        # Rest of the logic is the same
        if nums[low] <= nums[mid]:
            if nums[low] <= target < nums[mid]:
                high = mid - 1
            else:
                low = mid + 1
        else:
            if nums[mid] < target <= nums[high]:
                low = mid + 1
            else:
                high = mid - 1
    return False
```

---

### 3. Find Minimum in Rotated Sorted Array
`[MEDIUM]` `#binary-search` `#rotated-array`

#### Problem Statement
Given a rotated sorted array of **unique elements**, find its minimum element.

*Example:* `[3,4,5,1,2]`. **Output:** `1`.

#### Implementation Overview
The minimum element is the pivot point. We can find it by always moving our search towards the unsorted part of the array, because the minimum element will always be the start of the sorted segment that follows the "drop".
1.  Initialize `low = 0`, `high = n - 1`. Keep track of the minimum found so far in `ans`.
2.  Loop while `low <= high`.
3.  Identify the sorted half. A simple way is to compare `nums[low]` and `nums[mid]`.
    -   If `nums[low] <= nums[mid]`, the left half is sorted. The minimum in this half is `nums[low]`. We record it and then search for a potentially smaller value in the unsorted right half (`low = mid + 1`).
    -   If `nums[low] > nums[mid]`, the right half is sorted. The minimum must be in the unsorted left half, which includes `nums[mid]`. We record `nums[mid]` as a potential answer and search left (`high = mid - 1`).
4.  Return the overall minimum found.

#### Python Code Snippet
```python
def find_min_in_rotated_array(nums):
    low, high = 0, len(nums) - 1
    ans = float('inf')

    while low <= high:
        mid = low + (high - low) // 2

        # If the whole search space is sorted, the minimum is at the start
        if nums[low] <= nums[high]:
            ans = min(ans, nums[low])
            break

        # If left half is sorted
        if nums[low] <= nums[mid]:
            ans = min(ans, nums[low])
            low = mid + 1 # Search in the unsorted right half
        # If right half is sorted
        else:
            ans = min(ans, nums[mid])
            high = mid - 1 # Search in the unsorted left half

    return ans
```

---

### 4. Find How Many Times an Array has been Rotated
`[EASY]` `#binary-search` `#rotated-array`

#### Problem Statement
Given a rotated sorted array, find the number of times it has been rotated. This is equivalent to finding the index of the minimum element.

*Example:*
- **Input:** `nums = [4,5,6,7,0,1,2]`
- **Output:** `4` (The array was rotated 4 times)

#### Implementation Overview
This is a direct application of `Find Minimum in Rotated Sorted Array`. We simply need to return the index of the minimum element instead of the element itself.

#### Python Code Snippet
```python
def count_rotations(nums):
    low, high = 0, len(nums) - 1
    min_val = float('inf')
    ans_index = -1

    while low <= high:
        mid = low + (high - low) // 2

        if nums[low] <= nums[high]:
            if nums[low] < min_val:
                min_val = nums[low]
                ans_index = low
            break

        if nums[low] <= nums[mid]:
            if nums[low] < min_val:
                min_val = nums[low]
                ans_index = low
            low = mid + 1
        else:
            if nums[mid] < min_val:
                min_val = nums[mid]
                ans_index = mid
            high = mid - 1

    return ans_index
```

#### Related Problems
- `Find Minimum in Rotated Sorted Array`

---

### 5. Find Peak Element
`[MEDIUM]` `#binary-search` `#bitonic-array`

#### Problem Statement
A peak element is an element that is strictly greater than its neighbors. Given an integer array `nums`, find a peak element, and return its index. If multiple peaks exist, returning the index to any of the peaks is fine.

*Example:*
- **Input:** `nums = [1,2,3,1]`
- **Output:** `2` (3 is a peak)

#### Implementation Overview
We can use binary search on the "slope" of the array.
1.  Handle edge cases: If the array has 1 element, it's a peak. Check if `nums[0]` or `nums[n-1]` are peaks.
2.  Search space `low = 1`, `high = n - 2`.
3.  If `nums[mid]` is a peak (`nums[mid] > nums[mid-1]` and `nums[mid] > nums[mid+1]`), return `mid`.
4.  If `nums[mid] < nums[mid+1]`, we are on an "uphill" slope. A peak must exist to the right. So, we search right: `low = mid + 1`.
5.  If `nums[mid] > nums[mid+1]`, we are on a "downhill" slope. A peak must exist to the left (or `mid` itself could be one). So, we search left: `high = mid - 1`.

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
        if nums[mid] > nums[mid-1] and nums[mid] > nums[mid+1]:
            return mid
        elif nums[mid] < nums[mid+1]:
            # We are on an uphill slope, peak is to the right
            low = mid + 1
        else:
            # We are on a downhill slope, peak is to the left
            high = mid - 1
    return -1 # Should not be reached given problem constraints
```

---

### 6. Single Element in a Sorted Array
`[MEDIUM]` `#binary-search` `#observation`

#### Problem Statement
You are given a sorted array consisting of only integers where every element appears exactly twice, except for one element which appears exactly once. Find this single element.

*Example:*
- **Input:** `nums = [1,1,2,3,3,4,4,8,8]`
- **Output:** `2`

#### Implementation Overview
The key observation is the indices of the pairs. Before the single element, the first element of a pair is at an even index (`0, 2, 4, ...`) and the second is at an odd index. After the single element, this pattern is reversed.
1.  We can use binary search to find the "break" in this pattern.
2.  Search space `low = 0`, `high = n - 2` (we can ignore the last element for pairing).
3.  In the loop, calculate `mid`.
4.  If `mid` is on an even index, its partner should be at `mid + 1`. If `nums[mid] == nums[mid+1]`, the pattern is intact up to this point. The single element must be to the right (`low = mid + 2`).
5.  If `mid` is on an odd index, its partner should be at `mid - 1`. If `nums[mid] == nums[mid-1]`, the pattern is intact. Search right (`low = mid + 1`).
6.  If the pair is broken at `mid`, the single element is in the left half, so search left (`high = mid - 1`).
7.  The answer will be at index `low` when the loop terminates.

#### Python Code Snippet
```python
def single_non_duplicate(nums):
    low, high = 0, len(nums) - 1
    while low < high:
        mid = low + (high - low) // 2
        # Ensure mid is at the start of a potential pair
        if mid % 2 == 1:
            mid -= 1

        # If the pair is intact, the single element is to the right
        if nums[mid] == nums[mid+1]:
            low = mid + 2
        # If the pair is broken, the single element is to the left
        else:
            high = mid

    return nums[low]
```
