# Pattern 2: BS on Unconventionally Sorted Arrays

This pattern focuses on applying binary search to arrays that are not perfectly sorted in a single direction but have a distinct, exploitable structure. The core idea is to modify the binary search condition to identify which half of the array is "well-behaved" or sorted, and then decide whether to search in that half or the other.

---

### 1. Search in a Rotated Sorted Array I
`[MEDIUM]` `#binary-search` `#rotated-array`

#### Problem Statement
An array sorted in ascending order with **distinct values** is rotated at a pivot. Given a `target`, return its index or -1.

**Example:** `nums = [4,5,6,7,0,1,2]`, `target = 0`. **Output:** `4`

#### Implementation Overview
The key is to identify the sorted half in each step.
1.  In each step, check if the left half (`nums[low]` to `nums[mid]`) is sorted by testing `if nums[low] <= nums[mid]`.
2.  If it is, check if the `target` lies within the range of this sorted half. If yes, search left (`high = mid - 1`). If no, search right (`low = mid + 1`).
3.  If the left half is not sorted, the right half must be. Check if the `target` is in the right half's range. If yes, search right (`low = mid + 1`). If no, search left (`high = mid - 1`).

---

### 2. Search in a Rotated Sorted Array II
`[MEDIUM]` `#binary-search` `#rotated-array`

#### Problem Statement
This is a follow-up to the above problem, but the array can contain **duplicate values**.

#### Implementation Overview
The core logic is the same, but it breaks down in one specific case: when `nums[low] == nums[mid] == nums[high]`. In this scenario, we cannot determine which half is sorted.
- **Solution:** When this specific condition is met, we cannot make an informed decision. We can, however, safely shrink the search space by moving the `low` and `high` pointers inwards (`low += 1`, `high -= 1`) and then continue the binary search. This degrades the worst-case performance to O(N) but maintains an average of O(log N).

---

### 3. Find Minimum in Rotated Sorted Array
`[MEDIUM]` `#binary-search` `#rotated-array`

#### Problem Statement
Given a rotated sorted array of unique elements, find its minimum element.

**Example:** `[3,4,5,1,2]`. **Output:** `1`.

#### Implementation Overview
The minimum element is the pivot. We find it by always moving towards the unsorted part of the array.
1.  `low = 0`, `high = n - 1`. `ans = infinity`.
2.  Loop `low <= high`.
3.  Compare `nums[mid]` with `nums[high]`.
    -   If `nums[mid] < nums[high]`, the right half is sorted. The minimum could be `nums[mid]`, so we store it and search left for a smaller one (`ans = min(ans, nums[mid])`, `high = mid - 1`).
    -   If `nums[mid] > nums[high]`, the left half is sorted, but the pivot (minimum) must be in the unsorted right half. Search right (`low = mid + 1`).

---

### 4. Find How Many Times an Array has been Rotated
`[EASY]` `#binary-search` `#rotated-array`

#### Problem Statement
Given a rotated sorted array, find the number of times it has been rotated. This is equivalent to finding the index of the minimum element.

#### Implementation Overview
This is a direct application of `Find Minimum in Rotated Sorted Array`. The index of the minimum element is the number of rotations.

#### Related Problems
- `Find Minimum in Rotated Sorted Array`

---

### 5. Find Peak Element
`[HARD]` `#binary-search` `#bitonic-array`

#### Problem Statement
A peak element is strictly greater than its neighbors. Find any peak element and return its index.

#### Implementation Overview
1.  Handle edge cases (size 1, peak at ends).
2.  Search space `low = 1`, `high = n - 2`.
3.  If `nums[mid]` is a peak, return `mid`.
4.  If `nums[mid] < nums[mid+1]`, we are on an "uphill" slope. A peak must be to the right. `low = mid + 1`.
5.  If `nums[mid] > nums[mid+1]`, we are on a "downhill" slope. A peak must be to the left. `high = mid - 1`.

---

### 6. Single Element in a Sorted Array
`[EASY]` `#binary-search` `#observation`

#### Problem Statement
In a sorted array, every element appears twice, except for one which appears once. Find the single element.

#### Implementation Overview
The key is that before the single element, pairs start at even indices (`(0,1), (2,3)`). After, they start at odd indices.
1.  `low = 0`, `high = n - 2`.
2.  In the loop, calculate `mid`. If `mid` is odd, decrement it to land on the start of a potential pair.
3.  If `nums[mid] == nums[mid+1]`, the pair is intact. The single element is to the right (`low = mid + 2`).
4.  If not equal, the single element is at or to the left of `mid` (`high = mid - 1`).
5.  The answer is at index `low`.
