# Pattern 6: Greedy Approach

Sometimes, a problem that appears in a Dynamic Programming list can be solved more efficiently using a different technique. The following problem is a classic example of a case where a **Greedy Algorithm** provides the optimal solution. It's included here for completeness. The greedy approach involves making the locally optimal choice at each step with the hope of finding a global optimum.

---

### 1. Assign Cookies
`[EASY]` `#greedy` `#sorting`

#### Problem Statement
Assume you are an awesome parent and want to give your children some cookies. But, you should give each child at most one cookie.

Each child `i` has a greed factor `g[i]`, which is the minimum size of a cookie that the child will be content with; and each cookie `j` has a size `s[j]`. If `s[j] >= g[i]`, we can assign the cookie `j` to the child `i`, and the child `i` will be content.

Your goal is to maximize the number of your content children and output the maximum number.

*Example:* `g = [1,2]`, `s = [1,2,3]`. **Output:** `2` (Child 1 gets cookie 1, child 2 gets cookie 2).

#### Implementation Overview
This problem can be solved optimally with a greedy strategy. The core intuition is that to maximize the number of content children, we should try to satisfy the least greedy children with the smallest possible cookies that can satisfy them. This leaves larger cookies available for greedier children.

-   **Algorithm:**
    1.  Sort the greed factor array `g` in ascending order.
    2.  Sort the cookie size array `s` in ascending order.
    3.  Initialize two pointers, one for the greed array (`child_idx`) and one for the cookie array (`cookie_idx`).
    4.  Iterate while both pointers are within their array bounds:
        -   If the current cookie `s[cookie_idx]` can satisfy the current child `g[child_idx]`, then we have a successful assignment. Increment the count of content children, and move on to the next child and the next cookie.
        -   If the current cookie cannot satisfy the current child, it's too small. We must discard this cookie and try the next larger one for the *same* child. Increment only the cookie pointer.
-   **Final Answer:** The final count of content children, which will be equal to the `child_idx` pointer.

This approach is O(N log N + M log M) dominated by the sorting steps.

#### Python Code Snippet
```python
def find_content_children(g: list[int], s: list[int]) -> int:
    # Sort both the greed factors and the cookie sizes
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

        # Always move to the next cookie, whether it was given away or not
        cookie_idx += 1

    # The number of satisfied children is the number of times we incremented child_idx
    return child_idx
```
