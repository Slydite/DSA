# Pattern 3: Binary Search on the Answer Space

This is a powerful and often non-obvious application of binary search. Instead of searching on the array indices, we define a search space for the **answer** itself. The key is to find a **monotonic** property: if an answer `k` is achievable, then any answer "better" than `k` (e.g., `k+1` for maximization, `k-1` for minimization) is also achievable.

The core structure is:
1.  Define a search space `[low, high]` for the possible answers.
2.  Write a predicate function `is_possible(value)` that returns `true` if an answer of `value` can satisfy the constraints.
3.  Use binary search on the `[low, high]` range to find the optimal answer.

---

### 1. Find Square Root of a Number
`[MEDIUM]` `#binary-search-on-answer`

#### Problem Statement
Given a non-negative integer `x`, compute and return the square root of `x`. Since the return type is an integer, the decimal digits are truncated.

#### Implementation Overview
1.  **Search Space:** The answer is between `1` and `x`.
2.  **Binary Search:** If `mid*mid > x`, the guess is too high (`high = mid - 1`). If `mid*mid <= x`, `mid` is a potential answer, so store it and try for a larger root (`ans = mid`, `low = mid + 1`).

---

### 2. Find the Nth Root of a Number
`[MEDIUM]` `#binary-search-on-answer`

#### Problem Statement
Find the Nth root of a number `M`.

#### Implementation Overview
1.  **Search Space:** The answer is between `1` and `M`.
2.  **Binary Search:** If `mid^N > M`, the guess is too high (`high = mid - 1`). If `mid^N <= M`, `mid` is a potential answer, so try for a larger one (`low = mid + 1`). Be careful about integer overflow when calculating `mid^N`.

---

### 3. Koko Eating Bananas
`[HARD]` `#binary-search-on-answer` `#minimization`

#### Problem Statement
Koko must eat all bananas in `n` piles in `h` hours. Find the minimum integer eating speed `k` to finish on time.

#### Implementation Overview
1.  **Search Space:** `low = 1`, `high = max(piles)`.
2.  **Predicate `is_possible(k)`:** Calculate `total_hours = sum(ceil(pile / k) for each pile)`. Return `total_hours <= h`.
3.  **Binary Search:** If `is_possible(mid)`, `mid` is valid. Try for a smaller `k`: `ans = mid`, `high = mid - 1`. Else, `low = mid + 1`.

---

### 4. Minimum Days to Make M Bouquets
`[HARD]` `#binary-search-on-answer` `#minimization`

#### Problem Statement
Given `bloomDay`, `m` bouquets, and `k` adjacent flowers per bouquet. Find the minimum days to wait to make `m` bouquets.

#### Implementation Overview
1.  **Search Space:** `low = min(bloomDay)`, `high = max(bloomDay)`.
2.  **Predicate `is_possible(day)`:** Can we make `m` bouquets? Iterate through `bloomDay`, counting consecutive flowers where `bloomDay[i] <= day`. If count reaches `k`, increment bouquet counter and reset count. Return `bouquets_made >= m`.
3.  **Binary Search:** If `is_possible(mid)`, try for fewer days: `ans = mid`, `high = mid - 1`. Else, `low = mid + 1`.

---

### 5. Find the Smallest Divisor
`[EASY]` `#binary-search-on-answer` `#minimization`

#### Problem Statement
Given an array `nums` and a `threshold`, find the smallest divisor such that the sum of the divisions (rounded up) is less than or equal to the threshold.

#### Implementation Overview
This is identical to Koko Eating Bananas.
1.  **Search Space:** `low = 1`, `high = max(nums)`.
2.  **Predicate `is_possible(divisor)`:** `sum(ceil(num / divisor))` must be `<= threshold`.
3.  **Binary Search:** Search for the minimum possible divisor.

---

### 6. Capacity to Ship Packages within D Days
`[HARD]` `#binary-search-on-answer` `#minimize-the-maximum`

#### Problem Statement
Given package `weights` and `D` days, find the least weight capacity of a ship to ship all packages within `D` days.

#### Implementation Overview
1.  **Search Space:** `low = max(weights)`, `high = sum(weights)`.
2.  **Predicate `is_possible(capacity)`:** Can we ship all packages in `D` days with `capacity`? Greedily load packages. If adding the next package exceeds `capacity`, increment day count. Return `days_needed <= D`.
3.  **Binary Search:** If `is_possible(mid)`, try for a smaller capacity: `ans = mid`, `high = mid - 1`. Else, `low = mid + 1`.

---

### 7. Aggressive Cows
`[HARD]` `#binary-search-on-answer` `#maximize-the-minimum`

#### Problem Statement
You are given `n` stalls and `k` aggressive cows. Place the cows such that the minimum distance between any two is maximized.

#### Implementation Overview
This is a "maximize the minimum" problem.
1.  **Search Space:** The answer (minimum distance) ranges from `1` to `max(stalls) - min(stalls)`.
2.  **Predicate `is_possible(dist)`:** Can we place `k` cows with at least `dist` between them? Greedily place the first cow, then iterate and place subsequent cows only when the distance from the last placed cow is `>= dist`. Return `cows_placed >= k`.
3.  **Binary Search:** If `is_possible(mid)` is true, `mid` is a valid distance. Store it and try for a larger distance: `ans = mid`, `low = mid + 1`. Otherwise, `high = mid - 1`.

---

### 8. Book Allocation Problem
`[HARD]` `#binary-search-on-answer` `#minimize-the-maximum`

#### Problem Statement
Given `n` books with `pages[i]` pages and `m` students, allocate the books consecutively to students to minimize the maximum number of pages allocated to any student.

#### Implementation Overview
This is a "minimize the maximum" problem, identical in structure to `Capacity to Ship Packages`.
1.  **Search Space:** The answer (max pages) ranges from `max(pages)` to `sum(pages)`.
2.  **Predicate `is_possible(max_pages)`:** Can we allocate books so no student has more than `max_pages`? Greedily assign books to a student until the sum exceeds `max_pages`, then move to the next student. Return `students_needed <= m`.
3.  **Binary Search:** If `is_possible(mid)`, try for a smaller max page count: `ans = mid`, `high = mid - 1`. Else, `low = mid + 1`.

---

### 9. Split Array - Largest Sum
`[HARD]` `#binary-search-on-answer` `#minimize-the-maximum`

#### Problem Statement
Given an array `nums` and an integer `k`, split `nums` into `k` non-empty subarrays. Minimize the largest sum among these `k` subarrays.

#### Implementation Overview
This is a direct restatement of the `Book Allocation` problem and is solved identically.

#### Related Problems
- `Book Allocation Problem`
- `Painter's Partition`
- `Capacity to Ship Packages`

---

### 10. Painter's Partition Problem
`[HARD]` `#binary-search-on-answer` `#minimize-the-maximum`

#### Problem Statement
Given `n` boards of lengths `boards[i]` and `k` painters, partition the boards so that each painter gets a contiguous section. Minimize the maximum time any painter works (time is proportional to board length).

#### Implementation Overview
This is another direct restatement of the `Book Allocation` problem and is solved identically.
