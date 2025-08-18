# Pattern 3: Hashing Techniques

This pattern groups problems where a `HashMap` or `HashSet` is the key to an optimal solution, typically by enabling O(1) average time complexity for lookups, insertions, and deletions. This is especially powerful for problems involving sums, frequencies, and uniqueness checks.

---

### 1. Longest Subarray with a Given Sum K (with negatives)
`[MEDIUM]` `[FUNDAMENTAL]` `#prefix-sum` `#hashmap`

#### Problem Statement
Given an array `nums` containing positive, negative, and zero elements, and an integer `k`, find the length of the **longest** subarray with a sum equal to `k`.

#### Implementation Overview
The sliding window approach fails when negative numbers are present. The optimal solution uses a `HashMap` to store prefix sums. The logic is: if `prefix_sum[j] - prefix_sum[i-1] = k`, then `prefix_sum[i-1] = prefix_sum[j] - k`.

1.  Initialize a `HashMap` to store the first seen index of each prefix sum: `map = {prefix_sum: index}`.
2.  Initialize `current_sum = 0` and `max_len = 0`.
3.  **Important:** Start by putting `(0, -1)` into the map. This handles cases where a subarray starts from index 0.
4.  Iterate through the array with index `i`:
    -   Update the running sum: `current_sum += nums[i]`.
    -   Calculate the required past prefix sum: `rem = current_sum - k`.
    -   If `rem` is in the map, it means a valid subarray exists. The length is `i - map.get(rem)`. Update `max_len` with this length if it's greater.
    -   If the current `current_sum` is **not** already in the map, add it: `map.put(current_sum, i)`. We only store the first occurrence because we want the *longest* possible subarray.

#### Python Code Snippet
```python
def longest_subarray_with_sum_k(nums, k):
    prefix_sum_map = {0: -1}  # {prefix_sum: index}
    current_sum = 0
    max_len = 0

    for i, num in enumerate(nums):
        current_sum += num

        # Check if a subarray with sum k can be formed
        remainder = current_sum - k
        if remainder in prefix_sum_map:
            max_len = max(max_len, i - prefix_sum_map[remainder])

        # Store the first occurrence of the current prefix sum
        if current_sum not in prefix_sum_map:
            prefix_sum_map[current_sum] = i

    return max_len
```
#### Related Problems
- **Largest Subarray with 0 Sum:** A special case of this problem where `k=0`.
- **Count Subarrays with Given Sum K:** A variation that uses a frequency map instead.

---

### 2. Count Subarrays with a Given Sum K / XOR K
`[MEDIUM]` `[HARD]` `#prefix-sum` `#frequency-map`

#### Problem Statement
Find the **total number** of continuous subarrays whose sum (or XOR) equals `k`.

#### Implementation Overview
This is a frequency-based variation of the prefix sum pattern.
1.  Use a `HashMap` to store prefix sum frequencies: `map = {prefix_sum: frequency}`.
2.  Initialize `current_sum = 0` and `count = 0`.
3.  **Crucially, start by putting `(0, 1)` in the map.** This handles cases where a subarray starts from index 0 and itself sums to `k`.
4.  Iterate through the array:
    -   Update `current_sum` (or `current_xor`).
    -   Calculate the required remainder: `rem = current_sum - k` (or `rem = current_xor ^ k`).
    -   If `rem` exists in the map, you've found `map.get(rem)` new subarrays that sum to `k`. Add this frequency to your `count`.
    -   Update the frequency of the current `current_sum` in the map.

---

### 3. Longest Consecutive Sequence
`[MEDIUM]` `[TRICK]` `#hashset`

#### Problem Statement
Given an unsorted array of integers `nums`, return the length of the longest consecutive elements sequence.

**Example:** `nums = [100, 4, 200, 1, 3, 2]`, **Output:** `4` (for the sequence `1, 2, 3, 4`).

#### Implementation Overview
The optimal O(N) solution uses a `HashSet` to eliminate duplicates and provide O(1) lookups, with a clever trick to avoid redundant checks.
1.  Add all numbers to a `HashSet`.
2.  Initialize `longest_streak = 0`.
3.  Iterate through each number `num` in the set.
4.  **Key Optimization:** Check if `num` is the start of a sequence. A number is a start if `num - 1` is **not** in the set.
5.  If it is a starting point, use a `while` loop to find the length of the sequence by checking for `num + 1`, `num + 2`, etc., in the set. Update `longest_streak`.
This check ensures that we only start counting from the beginning of each sequence, making the overall complexity O(N).

#### Python Code Snippet
```python
def longest_consecutive(nums):
    if not nums:
        return 0

    num_set = set(nums)
    longest_streak = 0

    for num in num_set:
        # Check if it's the start of a sequence
        if num - 1 not in num_set:
            current_num = num
            current_streak = 1

            # Count the length of the sequence
            while current_num + 1 in num_set:
                current_num += 1
                current_streak += 1

            longest_streak = max(longest_streak, current_streak)

    return longest_streak
```
