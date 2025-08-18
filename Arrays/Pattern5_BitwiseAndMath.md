# Pattern 5: Bitwise & Mathematical Tricks

This pattern covers problems where the most optimal solution is not immediately obvious and relies on a clever trick, either using bitwise manipulation (usually XOR) or a mathematical formula. These solutions are typically O(N) in time and O(1) in space.

---

### 1. Find the Number That Appears Once
`[EASY]` `[TRICK]` `[FUNDAMENTAL]` `#bitwise` `#xor`

#### Problem Statement
In an array where every element appears twice except for one, find that single one.

#### Implementation Overview
The XOR operator (`^`) has the properties `x ^ x = 0` and `x ^ 0 = x`. If you XOR all the elements in the array together, the pairs will cancel each other out, leaving only the unique number.

---

### 2. Find Missing Number in an Array
`[EASY]` `#bitwise` `#math`

#### Problem Statement
Given an array with `n` distinct numbers from the range `[0, n]`, find the one number that is missing.

#### Implementation Overview (XOR)
XOR all the numbers in the input array together, and then XOR that result with all the numbers in the full range `[0, n]`. Everything present in both will cancel out, leaving only the missing number.

#### Alternative (Math)
The sum of numbers from `0` to `n` is `S = n*(n+1)/2`. The missing number is `S` minus the actual sum of the input array. This is also O(N) time and O(1) space but can be prone to integer overflow.

---

### 3. Find the Repeating and Missing Number
`[HARD]` `[TRICK]` `#bitwise` `#xor`

#### Problem Statement
In an array of `n` integers from `1` to `n`, one number `A` repeats twice, and one number `B` is missing. Find `A` and `B`.

#### Implementation Overview (Advanced XOR)
1.  **Step 1: Get `A ^ B`**. XOR all elements in `nums` and all numbers from `1` to `n` together. The result is `xor_rm = A ^ B`.
2.  **Step 2: Find a differentiating bit.** Find the rightmost set bit in `xor_rm`. This bit is guaranteed to be different between `A` and `B`. A simple way is `diff_bit = xor_rm & -xor_rm`.
3.  **Step 3: Partition into two groups.** Initialize `group1 = 0` and `group2 = 0`. Iterate through `nums` and the range `1..n`. For each number, check if its `diff_bit` is set. If so, XOR it with `group1`. If not, XOR it with `group2`.
4.  **Step 4: Identify A and B.** `group1` and `group2` will hold `A` and `B`. A final pass through `nums` is needed to check which is which.

#### Python Code Snippet
```python
def find_repeating_and_missing(nums):
    n = len(nums)
    xor_rm = 0
    # Get the XOR of the repeating and missing numbers
    for i in range(1, n + 1):
        xor_rm ^= i
        xor_rm ^= nums[i-1]

    # Find the rightmost set bit
    diff_bit = xor_rm & -xor_rm

    group1, group2 = 0, 0
    # Partition all numbers into two groups based on the diff_bit
    for i in range(1, n + 1):
        if (i & diff_bit) != 0:
            group1 ^= i
        else:
            group2 ^= i

    for num in nums:
        if (num & diff_bit) != 0:
            group1 ^= num
        else:
            group2 ^= num

    # Identify which is repeating and which is missing
    for num in nums:
        if num == group1:
            return [group1, group2] # group1 is repeating
    return [group2, group1] # group2 is repeating
```
#### Related Problems
- This is a direct extension of "Find the Number That Appears Once".

---

### 4. Pascal's Triangle
`[EASY]` `[MEDIUM]` `#math` `#dynamic-programming`

#### Problem Statement
- **I:** Given `numRows`, generate the first `numRows` of Pascal's triangle.
- **II:** Given `rowIndex`, return only that specific row.
- **III:** Given `(r, c)`, find the element at that position.

#### Implementation Overview
- **I (Generation):** Build the triangle row by row. Each new row starts and ends with `1`. The elements in between are `new_row[j] = prev_row[j-1] + prev_row[j]`.
- **II (Specific Row):** To get row `k` in O(k) space, you can compute it iteratively. Start with `[1]`. For each subsequent row, compute the next row from the current one.
- **III (Specific Element):** The most efficient way is to use the binomial coefficient formula: `C(r, c) = r! / (c! * (r-c)!)`. This can be computed in O(r) time.

#### Python Code Snippet (Get a specific row)
```python
def get_pascal_row(rowIndex):
    row = [1] * (rowIndex + 1)
    for i in range(2, rowIndex + 1):
        # Calculate the row backwards to use previous values from the same list
        for j in range(i - 1, 0, -1):
            row[j] += row[j-1]
    return row
```
