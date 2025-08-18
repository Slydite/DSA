# Pattern 2: Two Pointers & Sliding Window

The Two Pointers technique is one of the most versatile patterns for solving array and string problems. It involves using two integer pointers to iterate through a data structure, tracking different indices or positions. The pointers can move in the same direction, opposite directions, or a combination, depending on the problem.

The Sliding Window is a specific application of this pattern where the pointers (`left` and `right`) define a "window" or a subarray. The window size can be fixed or dynamic, and it slides over the array to find a solution.

---

### 4. Remove duplicates from Sorted array
`[EASY]` `#two-pointers` `#inplace`

#### Problem Statement
Given a sorted array of integers, remove the duplicates in-place such that each unique element appears only once. The relative order of the elements should be kept the same. Return the number of unique elements.

*Example:*
- **Input:** `arr = [0, 0, 1, 1, 1, 2, 2, 3, 3, 4]`
- **Output:** `5` (and `arr` becomes `[0, 1, 2, 3, 4, _, _, _, _, _]`)

#### Implementation Overview
This is a classic application of the "fast and slow pointer" approach.
1. Use a "slow" pointer `i` that points to the last known unique element's position. Initialize `i = 0`.
2. Use a "fast" pointer `j` to iterate through the entire array, starting from the second element (`j = 1`).
3. As `j` iterates, if `arr[j]` is different from `arr[i]`, it means we've found a new unique element.
4. To record this new unique element, we increment `i` first, and then assign `arr[j]` to `arr[i]`.
5. The fast pointer `j` always moves forward. The slow pointer `i` only moves when a new unique element is found.
6. The number of unique elements is `i + 1`.

#### Python Code Snippet
```python
def remove_duplicates(arr):
  if not arr:
    return 0

  i = 0 # Slow pointer
  for j in range(1, len(arr)): # Fast pointer
    if arr[j] != arr[i]:
      i += 1
      arr[i] = arr[j]

  return i + 1
```

#### Tricks/Gotchas
- **In-place Modification:** The key is to modify the array directly without using extra space.
- **Sorted Array:** This algorithm relies on the array being sorted.

#### Related Problems
- 7. Move Zeros to end

---

### 6. Left rotate an array by D places
`[EASY]` `#two-pointers` `#reversal-algorithm`

#### Problem Statement
Given an array, rotate it to the left by `D` places. `D` can be greater than the size of the array.

*Example:*
- **Input:** `arr = [1, 2, 3, 4, 5, 6, 7]`, `D = 3`
- **Output:** `[4, 5, 6, 7, 1, 2, 3]`

#### Implementation Overview
While using a temporary array is straightforward, the "Reversal Algorithm" is an elegant in-place solution that uses two pointers for reversals.
1. First, handle `D` being larger than array length `n` by taking `D = D % n`.
2. **Step 1:** Reverse the first `D` elements of the array. (e.g., `[3, 2, 1, 4, 5, 6, 7]`)
3. **Step 2:** Reverse the remaining `n-D` elements. (e.g., `[3, 2, 1, 7, 6, 5, 4]`)
4. **Step 3:** Reverse the entire array. (e.g., `[4, 5, 6, 7, 1, 2, 3]`)
Each reversal is a standard two-pointer operation where you swap elements from the start and end of a segment, moving inwards.

#### Python Code Snippet
```python
def reverse(arr, start, end):
  while start < end:
    arr[start], arr[end] = arr[end], arr[start]
    start += 1
    end -= 1

def rotate_left(arr, d):
  n = len(arr)
  if n == 0:
    return
  d = d % n
  if d == 0:
    return

  reverse(arr, 0, d - 1)
  reverse(arr, d, n - 1)
  reverse(arr, 0, n - 1)
```

#### Tricks/Gotchas
- **Modulus for D:** Always take `D % n` to handle cases where `D` is larger than the array length.
- **In-place:** The reversal algorithm is O(1) space complexity.

#### Related Problems
- 5. Left Rotate an array by one place

---

### 7. Move Zeros to end
`[EASY]` `#two-pointers` `#inplace`

#### Problem Statement
Given an array of integers, move all the zeros to the end of it while maintaining the relative order of the non-zero elements.

*Example:*
- **Input:** `arr = [0, 1, 0, 3, 12]`
- **Output:** `[1, 3, 12, 0, 0]`

#### Implementation Overview
A highly effective method uses two pointers.
1. Use a pointer `j` to mark the position where the next non-zero element should be placed. Initialize `j = 0`.
2. Iterate through the array with a pointer `i` from `0` to `n-1`.
3. If `arr[i]` is a non-zero element, it's a candidate to be moved to the front part of the array.
4. Place `arr[i]` at the `arr[j]` position and increment `j`. A common way to do this is `arr[j] = arr[i]`.
5. After the first pass, all non-zero elements are at the beginning of the array, in their original relative order, up to index `j-1`.
6. Now, iterate from `j` to `n-1` and fill the rest of the array with zeros.

A slight variation is to swap `arr[i]` with `arr[j]` if `arr[i]` is non-zero, which can be more intuitive.

#### Python Code Snippet
```python
def move_zeros(arr):
  j = 0 # Pointer for the next non-zero position
  for i in range(len(arr)):
    if arr[i] != 0:
      arr[j], arr[i] = arr[i], arr[j] # Swap
      j += 1
```

#### Tricks/Gotchas
- **Relative Order:** The solution must preserve the original order of non-zero elements. The swap-based method shown above does this correctly.

#### Related Problems
- 4. Remove duplicates from Sorted array
- 21. Rearrange array in alternating positive and negative items

---

### 9. Find the Union of two sorted arrays
`[EASY]` `#two-pointers` `#hash-set`

#### Problem Statement
Given two sorted arrays, find their union. The union should contain each element only once.

*Example:*
- **Input:** `arr1 = [1, 2, 3, 4, 5]`, `arr2 = [1, 2, 3, 6, 7]`
- **Output:** `[1, 2, 3, 4, 5, 6, 7]`

#### Implementation Overview
For sorted arrays, a two-pointer approach is very efficient in time and space.
1. Use a pointer `i` for `arr1` and `j` for `arr2`.
2. Create a `union` list to store the results.
3. While `i` and `j` are within their array bounds:
    - If `arr1[i] < arr2[j]`, add `arr1[i]` to the union and increment `i`.
    - If `arr1[i] > arr2[j]`, add `arr2[j]` to the union and increment `j`.
    - If `arr1[i] == arr2[j]`, add one of them to the union and increment both `i` and `j`.
4. After the loop, one array may still have elements left. Add all remaining elements from that array to the union.
5. To handle duplicates within the same array, only add an element to the union if it's different from the last element added.

#### Python Code Snippet
```python
def find_union(arr1, arr2):
    i, j = 0, 0
    union = []
    while i < len(arr1) and j < len(arr2):
        if arr1[i] < arr2[j]:
            if not union or union[-1] != arr1[i]:
                union.append(arr1[i])
            i += 1
        elif arr2[j] < arr1[i]:
            if not union or union[-1] != arr2[j]:
                union.append(arr2[j])
            j += 1
        else:
            if not union or union[-1] != arr1[i]:
                union.append(arr1[i])
            i += 1
            j += 1

    # Add remaining elements
    while i < len(arr1):
        if not union or union[-1] != arr1[i]:
            union.append(arr1[i])
        i += 1
    while j < len(arr2):
        if not union or union[-1] != arr2[j]:
            union.append(arr2[j])
        j += 1

    return union
```

#### Tricks/Gotchas
- **Sorted Input:** This optimal approach assumes the input arrays are sorted. If not, using a `set` is easier but uses more space.
- **Handling Duplicates:** The check `if not union or union[-1] != ...` is crucial for ensuring the final union list has unique elements.

#### Related Problems
- 36. Merge two sorted arrays without extra space

---

### 13. Longest subarray with given sum K (positives)
`[MEDIUM]` `#two-pointers` `#sliding-window`

#### Problem Statement
Given an array of positive integers and an integer `K`, find the length of the longest subarray with a sum equal to `K`.

*Example:*
- **Input:** `arr = [4, 1, 1, 1, 2, 3, 5]`, `K = 5`
- **Output:** `4` (for subarray `[1, 1, 1, 2]`)

#### Implementation Overview
This is a classic sliding window problem. The window is a subarray defined by a `left` and `right` pointer.
1. Initialize `left = 0`, `right = 0`, `current_sum = 0`, `max_len = 0`.
2. Use the `right` pointer to expand the window by iterating through the array. In each step, add `arr[right]` to `current_sum`.
3. After expanding, check if the `current_sum` is greater than `K`.
4. If `current_sum > K`, the window is too large. Shrink it from the left by subtracting `arr[left]` from `current_sum` and incrementing `left`. Keep doing this in a `while` loop until `current_sum` is no longer greater than `K`.
5. If `current_sum == K`, we have a candidate subarray. Update `max_len = max(max_len, right - left + 1)`.
6. Repeat until `right` reaches the end of the array.

#### Python Code Snippet
```python
def longest_subarray_with_sum_k(arr, k):
    left, right = 0, 0
    current_sum = 0
    max_len = 0

    while right < len(arr):
        current_sum += arr[right]

        while current_sum > k:
            current_sum -= arr[left]
            left += 1

        if current_sum == k:
            max_len = max(max_len, right - left + 1)

        right += 1

    return max_len
```

#### Tricks/Gotchas
- **Positive Numbers Only:** This sliding window approach works because the numbers are all positive. Adding a number always increases the sum, and removing one always decreases it, which guarantees the window shrinking/expanding logic works. This fails for negative numbers.

#### Related Problems
- 14. Longest subarray with sum K (Positives + Negatives) (requires hashmaps)
- 28. Count subarrays with given sum

---

### 15. 2Sum Problem
`[MEDIUM]` `#two-pointers` `#hashing`

#### Problem Statement
Given an array of integers and a target integer, return the indices of the two numbers such that they add up to the target. Assume that each input would have exactly one solution, and you may not use the same element twice.

*Example:*
- **Input:** `nums = [2, 7, 11, 15]`, `target = 9`
- **Output:** `[0, 1]`

#### Implementation Overview
While a hashmap is a common O(N) time/space solution, a two-pointer approach is O(1) space if we're allowed to modify the array or if the output required is the numbers themselves, not indices.
1. Sort the input array. This is a crucial first step.
2. Initialize two pointers: `left = 0` at the beginning of the array and `right = len(arr) - 1` at the end.
3. Loop while `left < right`:
    - Calculate `current_sum = arr[left] + arr[right]`.
    - If `current_sum == target`, you have found the pair.
    - If `current_sum < target`, the sum is too small. To increase it, move the `left` pointer one step to the right (`left += 1`).
    - If `current_sum > target`, the sum is too large. To decrease it, move the `right` pointer one step to the left (`right -= 1`).
4. If the original indices are required, this approach is more complex as sorting disrupts them. You'd need to store `(value, original_index)` pairs.

#### Python Code Snippet (returns numbers, not indices)
```python
def two_sum_pointers(arr, target):
    arr.sort()
    left, right = 0, len(arr) - 1

    while left < right:
        current_sum = arr[left] + arr[right]
        if current_sum == target:
            return (arr[left], arr[right])
        elif current_sum < target:
            left += 1
        else:
            right -= 1

    return None
```

#### Tricks/Gotchas
- **Sorting:** The two-pointer approach for 2Sum only works on a sorted array.
- **Indices vs. Values:** Be clear about what the problem asks for. If original indices are needed, a hashmap is generally a more direct solution.

#### Related Problems
- 31. 3-Sum Problem
- 32. 4-Sum Problem

---

### 16. Sort an array of 0's 1's and 2's
`[MEDIUM]` `#two-pointers` `#dutch-national-flag`

#### Problem Statement
Given an array containing only 0s, 1s, and 2s, sort it in-place.

*Example:*
- **Input:** `arr = [2, 0, 2, 1, 1, 0]`
- **Output:** `[0, 0, 1, 1, 2, 2]`

#### Implementation Overview
This is the famous "Dutch National Flag problem," solved efficiently using three pointers.
1. Initialize three pointers:
    - `low = 0`: The boundary for the 0s section.
    - `mid = 0`: The current element being considered.
    - `high = len(arr) - 1`: The boundary for the 2s section.
2. The array is partitioned into four sections: `0s | 1s | unsorted | 2s`.
3. Iterate while `mid <= high`:
    - If `arr[mid] == 0`: Swap `arr[low]` with `arr[mid]`. Increment both `low` and `mid`.
    - If `arr[mid] == 1`: The element is in the correct place. Just increment `mid`.
    - If `arr[mid] == 2`: Swap `arr[high]` with `arr[mid]`. Decrement `high`. Do not increment `mid` because the element swapped from `high` could be a 0 or 1 and needs to be processed.

#### Python Code Snippet
```python
def sort_colors(arr):
    low, mid, high = 0, 0, len(arr) - 1

    while mid <= high:
        if arr[mid] == 0:
            arr[low], arr[mid] = arr[mid], arr[low]
            low += 1
            mid += 1
        elif arr[mid] == 1:
            mid += 1
        else: # arr[mid] == 2
            arr[high], arr[mid] = arr[mid], arr[high]
            high -= 1
```

#### Tricks/Gotchas
- **`mid` pointer logic:** The most subtle part is not incrementing `mid` when a 2 is found and swapped. This is because the element brought to `mid` from the `high` position has not yet been inspected.

#### Related Problems
- 7. Move Zeros to end (a simpler, two-way partition)

---

### 21. Rearrange array in alternating positive and negative items
`[MEDIUM]` `#two-pointers`

#### Problem Statement
You are given an array of positive and negative numbers. Rearrange the array so that positive and negative numbers appear alternatively. If there are more of one type, they should appear at the end. The relative order of elements is not important.

*Example:*
- **Input:** `arr = [-1, 2, -3, 4, 5, 6, -7, 8, 9]`
- **Output:** `[9, -7, 8, -3, 5, -1, 2, 4, 6]` (one possible output)

#### Implementation Overview
A simple approach that doesn't preserve order involves partitioning and then interleaving.
1. **Partition:** Use a two-pointer approach (like in Quick Sort's partition step) to move all negative numbers to one side of the array and all positive numbers to the other. Let's say negatives are on the left.
2. **Interleave:**
    - Initialize a pointer `pos` to the first positive element and `neg` to the first negative element (`pos = first_positive_idx`, `neg = 0`).
    - While `neg` is in the negative section and `pos` is in the positive section:
        - Swap `arr[neg]` with `arr[pos]`.
        - Increment `pos` by 1.
        - Increment `neg` by 2 (to skip over the element just swapped into place).

#### Python Code Snippet
```python
def rearrange_alternating(arr):
    n = len(arr)
    # Partition step
    i = -1
    for j in range(n):
        if arr[j] < 0:
            i += 1
            arr[i], arr[j] = arr[j], arr[i]

    # Interleave step
    pos, neg = i + 1, 0
    while pos < n and neg < pos and arr[neg] < 0:
        arr[neg], arr[pos] = arr[pos], arr[neg]
        pos += 1
        neg += 2
    return arr
```

#### Tricks/Gotchas
- **Order Preservation:** This simple method does not preserve the original relative order of elements. If order must be preserved, a more complex O(N) time, O(1) space solution involves rotations.
- **Uneven counts:** This method correctly handles cases where there are more positives or negatives; the extras are left at the end.

#### Related Problems
- 7. Move Zeros to end

---

### 31. 3-Sum Problem
`[MEDIUM]` `#two-pointers` `#sorting`

#### Problem Statement
Given an integer array, return all the triplets `[arr[i], arr[j], arr[k]]` such that `i != j`, `i != k`, and `j != k`, and `arr[i] + arr[j] + arr[k] == 0`. The solution set must not contain duplicate triplets.

*Example:*
- **Input:** `nums = [-1, 0, 1, 2, -1, -4]`
- **Output:** `[[-1, -1, 2], [-1, 0, 1]]`

#### Implementation Overview
This problem builds on the 2-Sum problem.
1. **Sort the array.** This is essential.
2. Iterate through the array with a pointer `i` from `0` to `n-3`.
3. **Handle duplicates for `i`:** If `i > 0` and `arr[i] == arr[i-1]`, `continue` to the next iteration to avoid duplicate triplets.
4. For each `arr[i]`, use the two-pointer technique on the rest of the array:
    - Set `left = i + 1` and `right = n - 1`.
    - The target for the two-pointer sum is `target = -arr[i]`.
    - While `left < right`:
        - If `arr[left] + arr[right] == target`, you've found a triplet. Add `[arr[i], arr[left], arr[right]]` to the results.
        - **Handle duplicates for `left` and `right`:** After finding a valid triplet, increment `left` and decrement `right`. Also, move `left` forward as long as it's a duplicate, and similarly for `right`.
        - If the sum is less than the target, increment `left`.
        - If the sum is greater than the target, decrement `right`.

#### Python Code Snippet
```python
def three_sum(nums):
    nums.sort()
    result = []
    n = len(nums)
    for i in range(n - 2):
        if i > 0 and nums[i] == nums[i-1]:
            continue

        left, right = i + 1, n - 1
        while left < right:
            total = nums[i] + nums[left] + nums[right]
            if total == 0:
                result.append([nums[i], nums[left], nums[right]])
                # Skip duplicates
                while left < right and nums[left] == nums[left+1]:
                    left += 1
                while left < right and nums[right] == nums[right-1]:
                    right -= 1
                left += 1
                right -= 1
            elif total < 0:
                left += 1
            else:
                right -= 1
    return result
```

#### Tricks/Gotchas
- **Duplicate Handling:** This is the trickiest part. You must handle duplicates for the first element (`i`) and for the two pointers (`left`, `right`) to ensure the uniqueness of the output triplets.

#### Related Problems
- 15. 2Sum Problem
- 32. 4-Sum Problem

---

### 32. 4-Sum Problem
`[HARD]` `#two-pointers` `#sorting`

#### Problem Statement
Given an array of `n` integers, return an array of all the unique quadruplets `[nums[a], nums[b], nums[c], nums[d]]` such that they sum up to a given `target`.

*Example:*
- **Input:** `nums = [1, 0, -1, 0, -2, 2]`, `target = 0`
- **Output:** `[[-2, -1, 1, 2], [-2, 0, 0, 2], [-1, 0, 0, 1]]`

#### Implementation Overview
This is a direct extension of the 3-Sum problem.
1. **Sort the array.**
2. Use a nested loop structure. The outer loop iterates with pointer `i` from `0` to `n-4`. The inner loop iterates with `j` from `i+1` to `n-3`.
3. **Handle duplicates for `i` and `j`** similar to 3-Sum to avoid processing the same starting pairs.
4. For each pair `(arr[i], arr[j])`, solve the 2-Sum problem for the rest of the array (`arr[j+1]` to `arr[n-1]`).
    - The new target is `new_target = target - arr[i] - arr[j]`.
    - Set `left = j + 1` and `right = n - 1`.
    - Use the standard two-pointer approach to find pairs that sum to `new_target`.
    - Handle duplicates for `left` and `right` as in 3-Sum.

#### Python Code Snippet
```python
def four_sum(nums, target):
    nums.sort()
    result = []
    n = len(nums)
    for i in range(n - 3):
        if i > 0 and nums[i] == nums[i-1]:
            continue
        for j in range(i + 1, n - 2):
            if j > i + 1 and nums[j] == nums[j-1]:
                continue

            left, right = j + 1, n - 1
            while left < right:
                total = nums[i] + nums[j] + nums[left] + nums[right]
                if total == target:
                    result.append([nums[i], nums[j], nums[left], nums[right]])
                    while left < right and nums[left] == nums[left+1]:
                        left += 1
                    while left < right and nums[right] == nums[right-1]:
                        right -= 1
                    left += 1
                    right -= 1
                elif total < target:
                    left += 1
                else:
                    right -= 1
    return result
```

#### Tricks/Gotchas
- **Complexity:** The time complexity is O(N^3) due to the nested loops and the two-pointer scan.
- **Extensive Duplicate Checks:** Duplicate handling is even more critical here and must be done at every level of the nested loops.

#### Related Problems
- 15. 2Sum Problem
- 31. 3-Sum Problem

---

### 36. Merge two sorted arrays without extra space
`[MEDIUM]` `#two-pointers` `#gap-algorithm`

#### Problem Statement
Given two sorted arrays, `arr1` of size `n` and `arr2` of size `m`, merge them into a single sorted array without using any extra space. The result should be that the first `n` elements are in `arr1` and the next `m` elements are in `arr2`.

*Example:*
- **Input:** `arr1 = [1, 4, 8, 10]`, `arr2 = [2, 3, 9]`
- **Output:** `arr1 = [1, 2, 3, 4]`, `arr2 = [8, 9, 10]`

#### Implementation Overview
This is a complex problem with several solutions. The "Gap Algorithm," inspired by Shell Sort, is an elegant one.
1. The core idea is to compare elements that are a certain `gap` distance apart and swap them if they are in the wrong order.
2. The initial `gap` is `ceil((n + m) / 2)`.
3. The algorithm proceeds in a loop, reducing the `gap` by half in each iteration (`gap = ceil(gap / 2)`), until the `gap` becomes 0.
4. Inside the loop, use two pointers, `i` and `j`. `i` starts at `0`, and `j` starts at `i + gap`.
5. These pointers will traverse both arrays conceptually as if they were one.
    - If both `i` and `j` are in `arr1`, compare and swap `arr1[i]` and `arr1[j]`.
    - If `i` is in `arr1` and `j` is in `arr2`, compare and swap `arr1[i]` and `arr2[j - n]`.
    - If both `i` and `j` are in `arr2`, compare and swap `arr2[i - n]` and `arr2[j - n]`.
6. This process gradually sorts the combined (conceptual) array.

#### Python Code Snippet
```python
import math

def merge_no_extra_space(arr1, arr2):
    n, m = len(arr1), len(arr2)

    def next_gap(gap):
        if gap <= 1:
            return 0
        return math.ceil(gap / 2.0)

    gap = next_gap(n + m)
    while gap > 0:
        # Compare elements in the first array
        i = 0
        while i + gap < n:
            if arr1[i] > arr1[i + gap]:
                arr1[i], arr1[i + gap] = arr1[i + gap], arr1[i]
            i += 1

        # Compare elements in both arrays
        j = gap - n if gap > n else 0
        while i < n and j < m:
            if arr1[i] > arr2[j]:
                arr1[i], arr2[j] = arr2[j], arr1[i]
            i += 1
            j += 1

        # Compare elements in the second array
        if j < m:
            j = 0
            while j + gap < m:
                if arr2[j] > arr2[j + gap]:
                    arr2[j], arr2[j + gap] = arr2[j + gap], arr2[j]
                j += 1

        gap = next_gap(gap)
```

#### Tricks/Gotchas
- **Complexity:** The logic for handling pointers across two different arrays is tricky to implement correctly.
- **Gap Calculation:** The `ceil` function is important for the gap calculation to ensure it doesn't get stuck at 1.

#### Related Problems
- 9. Find the Union of two sorted arrays
