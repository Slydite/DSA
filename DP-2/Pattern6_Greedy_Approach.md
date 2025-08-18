# Pattern 6: Greedy Approach

Sometimes, a problem that appears in a Dynamic Programming list can be solved more efficiently using a different technique. The following problem is a classic example of a case where a **Greedy Algorithm** provides the optimal solution. It's included here for completeness as requested. The greedy approach involves making the locally optimal choice at each step with the hope of finding a global optimum.

---

### 1. Assign Cookies
`[EASY]` `#greedy` `#sorting`

#### Problem Statement
Assume you are an awesome parent and want to give your children some cookies. But, you should give each child at most one cookie.

Each child `i` has a greed factor `g[i]`, which is the minimum size of a cookie that the child will be content with; and each cookie `j` has a size `s[j]`. If `s[j] >= g[i]`, we can assign the cookie `j` to the child `i`, and the child `i` will be content.

Your goal is to maximize the number of your content children and output the maximum number.

#### Implementation Overview
This problem can be solved optimally with a greedy strategy. The core intuition is that to maximize the number of content children, we should try to satisfy the least greedy children with the smallest possible cookies that can satisfy them. This leaves larger cookies available for greedier children.

-   **Algorithm:**
    1.  Sort the greed factor array `g` in ascending order.
    2.  Sort the cookie size array `s` in ascending order.
    3.  Initialize two pointers, one for the greed array (`i`) and one for the cookie array (`j`).
    4.  Iterate while both pointers are within their array bounds:
        -   If the current cookie `s[j]` can satisfy the current child `g[i]` (i.e., `s[j] >= g[i]`), then we have a successful assignment. Increment the count of content children, and move on to the next child and the next cookie (`i++`, `j++`).
        -   If the current cookie `s[j]` cannot satisfy the current child `g[i]`, it's too small. We must discard this cookie and try the next larger one for the *same* child. Increment the cookie pointer (`j++`).
-   **Final Answer:** The final count of content children.

This approach is O(N log N) dominated by the sorting step, where N is the larger of the two array sizes. The two-pointer scan is O(N).
