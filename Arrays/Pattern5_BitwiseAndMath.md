# Pattern 5: Bitwise & Mathematical Tricks

This pattern covers problems where the most optimal solution is not immediately obvious and relies on a clever trick, either using bitwise manipulation (usually XOR) or a mathematical formula. These solutions are typically O(N) in time and O(1) in space.

## Sub-pattern: XOR Properties

The XOR operator (`^`) is the key to several problems because of its properties: `x ^ x = 0` and `x ^ 0 = x`. When you XOR a list of numbers, any number that appears an even number of times will cancel itself out.

### 1. Find the Number That Appears Once
`[EASY]` `[TRICK]` `[FUNDAMENTAL]`
- **Problem:** In an array where every element appears twice except for one, find that single one.
- **Overview:** Simply XOR all the elements in the array together. The pairs will cancel out to zero, leaving only the unique number.

### 2. Find Missing Number in an Array
`[EASY]`
- **Problem:** Given an array with `n` distinct numbers from the range `[0, n]`, find the one number that is missing.
- **Overview (XOR):** XOR all the numbers in the array together, and then XOR that result with all the numbers in the full range `[0, n]`. Everything present in both the array and the range will be XORed twice and cancel out, leaving only the missing number.
- **Alternative (Math):** The sum of numbers from `0` to `n` is `n*(n+1)/2`. The missing number is this expected sum minus the actual sum of the input array.

### 3. Find the Repeating and Missing Number
`[HARD]` `[TRICK]`
- **Problem:** In an array of `n` integers from `1` to `n`, one number `A` repeats twice, and one number `B` is missing. Find `A` and `B`.
- **Overview (Advanced XOR):**
    1.  First, XOR all array elements and all numbers from `1` to `n`. The result is `A ^ B`.
    2.  Find the rightmost set bit in `A ^ B`. This bit must be different between `A` and `B`.
    3.  Partition all numbers (from the array AND the range `1..n`) into two groups based on whether they have this bit set.
    4.  XORing all numbers in the first group gives you one of the results (either `A` or `B`), and XORing the second group gives you the other.
    5.  A final pass is needed to identify which is which.
- **Alternative (Math):** Set up two equations using sum and sum-of-squares (`S - Sn = A - B` and `S2 - S2n = A^2 - B^2`) and solve for `A` and `B`. This can be prone to integer overflow.
