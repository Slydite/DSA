# Pattern 3: Binary Search on the Answer Space

This is a powerful and often non-obvious application of binary search. Instead of searching on the array indices, we define a search space for the **answer** itself. The key is to find a **monotonic** property: if an answer `k` is achievable, then any answer "better" than `k` (e.g., `k+1` for maximization, `k-1` for minimization) is also achievable. This allows us to binary search for the optimal value that satisfies the problem's constraints.

The core structure is:
1.  Define a search space `[low, high]` for the possible answers.
2.  Write a predicate function `is_possible(value)` that returns `true` if an answer of `value` can satisfy the constraints. This function is usually O(N).
3.  Use binary search on the `[low, high]` range. If `is_possible(mid)` is true, try to find a better answer. Otherwise, we need a "worse" answer.

---

### 1. Koko Eating Bananas
`[HARD]` `#binary-search-on-answer` `#minimization`

#### Problem Statement
Koko must eat all bananas in `n` piles in `h` hours. Find the minimum integer eating speed `k` (bananas/hour) to finish on time.

#### Implementation Overview
1.  **Search Space:** The answer `k` can range from `1` to `max(piles)`.
2.  **Predicate `is_possible(k)`:** Given speed `k`, can Koko finish in `h` hours? Calculate `total_hours = sum(ceil(pile / k) for each pile)`. Return `total_hours <= h`.
3.  **Binary Search:** If `is_possible(mid)` is true, `mid` is a valid speed. Store it and try for a smaller `k`: `ans = mid`, `high = mid - 1`. If false, `k` is too slow: `low = mid + 1`.

#### Python Code Snippet
```python
import math

def min_eating_speed(piles, h):
    low, high = 1, max(piles)
    min_speed = high

    while low <= high:
        k = low + (high - low) // 2
        hours_needed = sum(math.ceil(pile / k) for pile in piles)

        if hours_needed <= h:
            min_speed = k
            high = k - 1
        else:
            low = k + 1

    return min_speed
```

---

### 2. Minimum Days to Make M Bouquets
`[HARD]` `#binary-search-on-answer` `#minimization`

#### Problem Statement
Given `bloomDay` array, `m` bouquets, and `k` adjacent flowers per bouquet. Find the minimum number of days to wait to make `m` bouquets.

#### Implementation Overview
1.  **Search Space:** The answer (days) ranges from `min(bloomDay)` to `max(bloomDay)`.
2.  **Predicate `is_possible(day)`:** Can we make `m` bouquets if we wait `day` days? Iterate through `bloomDay`, counting consecutive flowers where `bloomDay[i] <= day`. If the consecutive count reaches `k`, we form a bouquet and reset the count. Return `bouquets_made >= m`.
3.  **Binary Search:** If `is_possible(mid)` is true, store `mid` as a potential answer and search for fewer days (`high = mid - 1`). Otherwise, `low = mid + 1`.

---

### 3. Capacity to Ship Packages / Split Array Largest Sum / Book Allocation
`[HARD]` `#binary-search-on-answer` `#minimize-the-maximum` `#important-pattern`

#### Problem Statement (Capacity to Ship)
Given package `weights` and `D` days, find the least weight capacity of a ship to ship all packages within `D` days.

#### Implementation Overview
This is a classic "minimize the maximum" problem.
1.  **Search Space:** The answer (capacity) ranges from `max(weights)` to `sum(weights)`.
2.  **Predicate `is_possible(capacity)`:** Can we ship all packages in `D` days with `capacity`? Greedily load packages. If adding the next package exceeds `capacity`, increment the day count. Return `days_needed <= D`.
3.  **Binary Search:** If `is_possible(mid)` is true, `mid` is a valid capacity. Store it and try for a smaller capacity (`high = mid - 1`). Otherwise, `low = mid + 1`.

#### Related Problems
- `Split Array Largest Sum`, `Book Allocation`, `Painter's Partition` are all identical to this pattern. The story changes, but the logic of finding the minimum possible value for the maximum sum of a subarray partition is the same.

---

### 4. Aggressive Cows
`[HARD]` `#binary-search-on-answer` `#maximize-the-minimum`

#### Problem Statement
Given `n` stalls and `k` cows, place the cows such that the minimum distance between any two is maximized.

#### Implementation Overview
This is a "maximize the minimum" problem.
1.  **Search Space:** The answer (minimum distance) ranges from `1` to `max(stalls) - min(stalls)`.
2.  **Predicate `is_possible(dist)`:** Can we place `k` cows with at least `dist` between them? Greedily place cows. Put the first cow at the first stall. Iterate and place the next cow at the first available stall that maintains the minimum distance `dist`. Return `cows_placed >= k`.
3.  **Binary Search:** If `is_possible(mid)` is true, `mid` is a valid distance. Store it and try for a larger distance (`low = mid + 1`). Otherwise, `high = mid - 1`.

#### Python Code Snippet
```python
def can_place_cows(stalls, k, dist):
    cows_placed, last_pos = 1, stalls[0]
    for i in range(1, len(stalls)):
        if stalls[i] - last_pos >= dist:
            cows_placed += 1
            last_pos = stalls[i]
    return cows_placed >= k

def aggressive_cows(stalls, k):
    stalls.sort()
    low, high = 1, stalls[-1] - stalls[0]
    max_min_dist = 0
    while low <= high:
        dist = low + (high - low) // 2
        if can_place_cows(stalls, k, dist):
            max_min_dist = dist
            low = dist + 1
        else:
            high = dist - 1
    return max_min_dist
```

---

### 5. Nth Root of a Number
`[MEDIUM]` `#binary-search-on-answer`

#### Problem Statement
Find the Nth root of a number `M`.

#### Implementation Overview
1.  **Search Space:** The answer is between `1` and `M`.
2.  **Binary Search:** If `mid^N > M`, the guess is too high (`high = mid - 1`). If `mid^N < M`, the guess is too low (`low = mid + 1`). Be careful about integer overflow when calculating `mid^N`.
