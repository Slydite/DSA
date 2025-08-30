# Pattern 6: Greedy Approach

Sometimes, a problem that appears complex can be solved efficiently by making a series of locally optimal choices. This is the **Greedy** approach. While many problems that can be solved with DP can also be approached greedily, it's crucial to ensure the greedy choice property holds: that a locally optimal choice leads to a globally optimal solution. The problems here are classic examples where a greedy strategy is both correct and more efficient than a complex DP solution.

---

### 1. Assign Cookies
`[EASY]` `#greedy` `#sorting`

#### Problem Statement
Each child `i` has a greed factor `g[i]`, and each cookie `j` has a size `s[j]`. A cookie `j` can be assigned to child `i` if `s[j] >= g[i]`. Maximize the number of content children.

#### Greedy Strategy
The core intuition is to be as efficient as possible with our resources (the cookies). To satisfy the most children, we should use our "least valuable" cookies (the smallest ones) to satisfy the "easiest to please" children (the least greedy ones). This leaves larger cookies available for greedier children who need them.

1.  **Sort** both the greed factor array `g` and the cookie size array `s`.
2.  Use two pointers. Iterate through the children. For the current child, find the smallest available cookie that can satisfy them.
3.  If we find such a cookie, we make the assignment (a "match") and move to the next child.
4.  Whether we make a match or not, we always move on to the next cookie.

#### Python Code Snippet
```python
def find_content_children(g: list[int], s: list[int]) -> int:
    # Sort both arrays to enable the greedy approach
    g.sort()
    s.sort()

    child_idx = 0  # Pointer for the greed factor array g
    cookie_idx = 0 # Pointer for the cookie size array s

    # Iterate while there are still children to satisfy and cookies to give
    while child_idx < len(g) and cookie_idx < len(s):
        # If the current cookie can satisfy the current child
        if s[cookie_idx] >= g[child_idx]:
            # Give the cookie and move to the next child
            child_idx += 1

        # Always move to the next cookie to see if it can satisfy the
        # current child (if they weren't satisfied) or the next child.
        cookie_idx += 1

    # The number of satisfied children is the number of times we incremented child_idx
    return child_idx
```
- **Time Complexity:** O(N log N + M log M), dominated by the two sorting operations.
- **Space Complexity:** O(1) if sorting is done in-place (or O(N+M) depending on sort implementation).

---

### 2. Jump Game
`[MEDIUM]` `#greedy` `#array`

#### Problem Statement
You are given an integer array `nums`. You are initially positioned at the first index, and each element in the array represents your maximum jump length at that position. Return `true` if you can reach the last index, or `false` otherwise.

*Example:* `nums = [2,3,1,1,4]`. **Output:** `true`.
*Example:* `nums = [3,2,1,0,4]`. **Output:** `false`.

#### Greedy Strategy
Instead of thinking about which jump to take from the start (which can lead to a complex DP/backtracking solution), we can work backwards or, more simply, think greedily from the start. The greedy idea is to always find the **farthest reachable index**.

1.  Initialize a variable `max_reach` to 0. This will track the farthest index we can possibly get to from the start.
2.  Iterate through the array with an index `i` and value `num`.
3.  **Constraint Check:** If at any point our current index `i` is greater than `max_reach`, it means we've fallen into a gap of zeros and can never reach the current index. Return `false`.
4.  **Greedy Choice:** Update the farthest we can reach: `max_reach = max(max_reach, i + num)`.
5.  If we successfully iterate through the entire array, it means every position was reachable. Return `true`.

#### Python Code Snippet
```python
def can_jump(nums: list[int]) -> bool:
    max_reach = 0
    n = len(nums)

    for i, num in enumerate(nums):
        # If the current index is not reachable, we can't proceed
        if i > max_reach:
            return False

        # Greedily update the farthest point we can reach
        max_reach = max(max_reach, i + num)

        # Optimization: if we can already reach the end, no need to check further
        if max_reach >= n - 1:
            return True

    return True
```
- **Time Complexity:** O(n), because we iterate through the array once.
- **Space Complexity:** O(1).
