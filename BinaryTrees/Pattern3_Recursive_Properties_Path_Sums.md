# Pattern 3: Recursive Properties & Path Sums

This pattern focuses on a common recursive strategy for solving binary tree problems. The core idea is to perform a post-order traversal (or a variation) where each node's recursive call returns a value (or set of values) to its parent. The parent then uses these values from its left and right children to compute a property for its own subtree. This "pass-up" information flow is key.

---

### 1. Height of a Binary Tree
`[MEDIUM]` `#recursion` `#height-balanced`

#### Problem Statement
Given the root of a binary tree, find its maximum depth (or height). The maximum depth is the number of nodes along the longest path from the root node down to the farthest leaf node.

**Example:**
Input: `root = [3,9,20,null,null,15,7]`
Output: `3`

#### Implementation Overview
This is a classic recursion problem that perfectly demonstrates the post-order traversal pattern. The height of a tree is defined by the height of its subtrees.

1.  **Base Case:** If the current node is `null`, its height is `0`. This is the termination condition for the recursion.
2.  **Recursive Step:**
    a. Recursively calculate the height of the left subtree: `left_height = height(node.left)`.
    b. Recursively calculate the height of the right subtree: `right_height = height(node.right)`.
3.  **Combine Results:** The height of the tree rooted at the current node is `1 + max(left_height, right_height)`. The `+1` accounts for the current node itself.

This "calculate for children, then combine for parent" logic is the essence of post-order thinking.

#### Python Code Snippet
```python
# Definition for a binary tree node.
# class TreeNode:
#     def __init__(self, val=0, left=None, right=None):
#         self.val = val
#         self.left = left
#         self.right = right
from typing import Optional

class Solution:
    def maxDepth(self, root: Optional[TreeNode]) -> int:
        # Base case: an empty tree has a depth of 0
        if not root:
            return 0

        # Recursively find the depth of the left and right subtrees
        left_depth = self.maxDepth(root.left)
        right_depth = self.maxDepth(root.right)

        # The depth of the tree is 1 (for the current node) + the max of the subtrees
        return 1 + max(left_depth, right_depth)
```

#### Tricks/Gotchas
- Be clear about the definition of height/depth. Some definitions use the number of edges, which would mean returning `max(left, right)` at the root. LeetCode and most competitive programming platforms define it as the number of nodes, hence the `1 + ...`.
- The time complexity is O(N) because we visit every node once.
- The space complexity is O(H) due to the recursion stack, where H is the height of the tree. In the worst case (a skewed tree), this can be O(N).

#### Related Problems
- `[Pattern 3]` Check if the Binary tree is height-balanced or not (builds directly on this).
- `[Pattern 3]` Diameter of Binary Tree (uses a modified height calculation).
- Minimum Depth of Binary Tree.

---

### 2. Check if the Binary tree is height-balanced or not
`[MEDIUM]` `#recursion` `#height-balanced`

#### Problem Statement
Given a binary tree, determine if it is height-balanced. A height-balanced binary tree is a binary tree in which the depth of the two subtrees of every node never differs by more than one.

**Example:**
Input: `root = [3,9,20,null,null,15,7]` (Balanced)
Output: `true`

Input: `root = [1,2,2,3,3,null,null,4,4]` (Not Balanced)
Output: `false`

#### Implementation Overview
The key insight is to modify the standard height-finding function. Instead of just returning the height, we can make it return a special value (like `-1`) to signal that an imbalance has been detected somewhere in its subtree.

1.  Create a recursive helper function `check_height(node)`.
2.  **Base Case:** If `node` is null, it's balanced and has a height of `0`. Return `0`.
3.  **Recursive Step:**
    a. Recursively call on the left child: `left_height = check_height(node.left)`.
    b. **Check for Imbalance:** If `left_height` is `-1`, it means the left subtree is already unbalanced. Propagate this information up by immediately returning `-1`.
    c. Recursively call on the right child: `right_height = check_height(node.right)`.
    d. **Check for Imbalance:** If `right_height` is `-1`, return `-1`.
4.  **Check Current Node:** After getting valid heights from both children, check if the current node is balanced: `if abs(left_height - right_height) > 1`, return `-1`.
5.  **Return Height:** If the current node is balanced, return its height as usual: `1 + max(left_height, right_height)`.

The main function calls this helper and returns `True` if the result is not `-1`. This avoids re-computing heights and achieves an O(N) solution.

#### Python Code Snippet
```python
# Definition for a binary tree node.
# class TreeNode:
#     def __init__(self, val=0, left=None, right=None):
#         self.val = val
#         self.left = left
#         self.right = right
from typing import Optional

class Solution:
    def isBalanced(self, root: Optional[TreeNode]) -> bool:

        def check_height(node):
            if not node:
                return 0

            left_height = check_height(node.left)
            if left_height == -1:
                return -1

            right_height = check_height(node.right)
            if right_height == -1:
                return -1

            if abs(left_height - right_height) > 1:
                return -1

            return 1 + max(left_height, right_height)

        return check_height(root) != -1
```

#### Tricks/Gotchas
- The naive solution of calculating the height at every node separately would be O(N^2). The trick here is to combine the height calculation and the balance check into a single post-order traversal.
- Using a sentinel value like `-1` to signal an error or a specific condition is a common and powerful pattern in recursive functions.

#### Related Problems
- `[Pattern 3]` Height of a Binary Tree (the foundational problem).

---

### 3. Diameter of Binary Tree
`[MEDIUM]` `#recursion` `#diameter`

#### Problem Statement
Given the root of a binary tree, return the length of the diameter of the tree. The diameter of a binary tree is the length of the longest path between any two nodes in a tree. This path may or may not pass through the root. The length of a path is the number of edges between its endpoints.

**Example:**
Input: `root = [1,2,3,4,5]`
```
      1
     / \
    2   3
   / \
  4   5
```
Output: `3` (The path is `4 -> 2 -> 1 -> 3` or `5 -> 2 -> 1 -> 3`, which has 3 edges).

#### Implementation Overview
The key challenge is that the longest path might not pass through the root of the tree; it could be entirely contained within the left or right subtree.

The solution is to use a recursive function that does two things:
1.  It returns the height (or max depth) of the subtree it's called on.
2.  It updates a global or passed-by-reference variable that tracks the maximum diameter found *so far*.

**Algorithm:**
1.  Initialize a variable `max_diameter = 0`. This can be a member variable or a list/dictionary passed by reference to get around Python's scoping rules for primitive types.
2.  Create a recursive helper `height(node)`.
3.  **Base Case:** If `node` is null, return `0`.
4.  **Recursive Step:**
    a. `left_height = height(node.left)`
    b. `right_height = height(node.right)`
5.  **Update Diameter:** For the current node, the longest path passing through it as the highest point has a length of `left_height + right_height`. We compare this with our global `max_diameter` and update it if this path is longer: `max_diameter = max(max_diameter, left_height + right_height)`.
6.  **Return Height:** The function must still return the height of the current subtree to its parent, which is `1 + max(left_height, right_height)`.

The main function initializes the diameter tracker, calls the helper on the root, and then returns the final `max_diameter`.

#### Python Code Snippet
```python
# Definition for a binary tree node.
# class TreeNode:
#     def __init__(self, val=0, left=None, right=None):
#         self.val = val
#         self.left = left
#         self.right = right
from typing import Optional

class Solution:
    def diameterOfBinaryTree(self, root: Optional[TreeNode]) -> int:
        self.max_diameter = 0

        def height(node):
            if not node:
                return 0

            left_height = height(node.left)
            right_height = height(node.right)

            # Update the max diameter found so far
            # The diameter at this node is the sum of heights of its subtrees
            self.max_diameter = max(self.max_diameter, left_height + right_height)

            # Return the height of the tree rooted at this node
            return 1 + max(left_height, right_height)

        height(root)
        return self.max_diameter
```

#### Tricks/Gotchas
- The most common confusion is thinking the function should return the diameter. It should return the *height*, while updating the diameter as a side effect. This is a crucial distinction.
- The problem asks for the number of edges, which for a path is `number_of_nodes - 1`. Our calculation `left_height + right_height` correctly gives the number of edges.

#### Related Problems
- `[Pattern 3]` Height of a Binary Tree (the foundational function).
- `[Pattern 3]` Maximum path sum (a more complex version of this "update a global, return a path" idea).

---

### 4. Maximum path sum
`[HARD]` `#recursion` `#path-sum`

#### Problem Statement
A path in a binary tree is a sequence of nodes where each pair of adjacent nodes in the sequence has an edge connecting them. A node can only appear in the sequence at most once. Note that the path does not need to pass through the root.

The path sum of a path is the sum of the node's values in the path. Given the root of a binary tree, return the maximum path sum of any non-empty path.

**Example:**
Input: `root = [-10,9,20,null,null,15,7]`
Output: `42` (The path is `15 -> 20 -> 7`, sum = 15 + 20 + 7 = 42).

#### Implementation Overview
This problem follows the same pattern as Diameter of a Binary Tree: we need a recursive function that returns one value while updating a global maximum as a side effect.

The recursive function `max_path_down(node)` will compute the maximum path sum starting at `node` and going downwards into one of its subtrees (it cannot branch).

1.  Initialize a global `max_sum` to a very small number (e.g., `float('-inf')`).
2.  **Base Case:** If `node` is null, the max path down is `0`.
3.  **Recursive Step:**
    a. `left_path = max(0, max_path_down(node.left))`. We take `max(0, ...)` because we don't want to include paths with negative sums.
    b. `right_path = max(0, max_path_down(node.right))`.
4.  **Update Global Maximum:** The maximum path sum that "turns" at the current node (i.e., includes the node and paths down both its left and right sides) is `node.val + left_path + right_path`. We update our global `max_sum` with this value if it's greater.
5.  **Return Value:** The function must return the maximum path sum that starts at the current node and goes *straight down*. It cannot branch. This value is `node.val + max(left_path, right_path)`. This is the value the parent node will use.

The main function initializes `max_sum`, calls the helper on the root, and returns `max_sum`.

#### Python Code Snippet
```python
# Definition for a binary tree node.
# class TreeNode:
#     def __init__(self, val=0, left=None, right=None):
#         self.val = val
#         self.left = left
#         self.right = right
from typing import Optional

class Solution:
    def maxPathSum(self, root: Optional[TreeNode]) -> int:
        self.max_sum = float('-inf')

        def max_path_down(node):
            if not node:
                return 0

            # Get max path sum from left/right, ignore negative paths
            left_path = max(0, max_path_down(node.left))
            right_path = max(0, max_path_down(node.right))

            # Update the global max_sum with the path that "turns" at the current node
            # This is the sum of the node itself plus the max paths from its children
            self.max_sum = max(self.max_sum, node.val + left_path + right_path)

            # Return the max path sum going "straight down" from this node
            return node.val + max(left_path, right_path)

        max_path_down(root)
        return self.max_sum
```

#### Tricks/Gotchas
- The distinction between what the function *updates* and what it *returns* is the most critical part of this problem.
- Using `max(0, ...)` is a crucial trick to handle nodes with negative values. If a subtree's max path sum is negative, we are better off not including it in our path from the parent.
- The initial value of `max_sum` must be negative infinity to correctly handle trees with all negative node values.

#### Related Problems
- `[Pattern 3]` Diameter of Binary Tree (shares the same core pattern).

---

### 5. Check if two trees are identical or not
`[MEDIUM]` `#recursion` `#tree-comparison`

#### Problem Statement
Given the roots of two binary trees, `p` and `q`, write a function to check if they are the same or not. Two binary trees are considered the same if they are structurally identical, and the nodes have the same value.

**Example:**
Input: `p = [1,2,3], q = [1,2,3]`
Output: `true`

Input: `p = [1,2], q = [1,null,2]`
Output: `false`

#### Implementation Overview
This problem is solved with a straightforward parallel recursion. We traverse both trees simultaneously and compare them at each step.

1.  **Base Cases:**
    a. If both nodes `p` and `q` are `null`, they are identical at this position. Return `True`.
    b. If one of `p` or `q` is `null` but the other is not, they are not structurally identical. Return `False`.
    c. If the values of the current nodes `p.val` and `q.val` are different, the trees are not identical. Return `False`.
2.  **Recursive Step:** If the base cases all pass, it means the current nodes are identical. Now, we must check if their subtrees are also identical. The overall result is `True` only if **both** the left subtrees and the right subtrees are identical.
    - Return `isSameTree(p.left, q.left) AND isSameTree(p.right, q.right)`.

This recursive structure elegantly checks all conditions.

#### Python Code Snippet
```python
# Definition for a binary tree node.
# class TreeNode:
#     def __init__(self, val=0, left=None, right=None):
#         self.val = val
#         self.left = left
#         self.right = right
from typing import Optional

class Solution:
    def isSameTree(self, p: Optional[TreeNode], q: Optional[TreeNode]) -> bool:
        # If both nodes are None, they are identical
        if not p and not q:
            return True
        # If one is None but the other isn't, or their values differ, they are not identical
        if not p or not q or p.val != q.val:
            return False

        # Recursively check if both left and right subtrees are identical
        return self.isSameTree(p.left, q.left) and self.isSameTree(p.right, q.right)
```

#### Tricks/Gotchas
- The order of the base cases is important for correctness and to avoid `NoneType` errors. Checking for null nodes first is standard practice.
- The use of `and` in the recursive step is key. The entire structure must match, so both recursive calls must be true.

#### Related Problems
- `[Pattern 3]` Symmetric Binary Tree (a variation of this problem where you compare a tree with itself in a mirrored way).
- Subtree of Another Tree.

---

### 6. Symmetric Binary Tree
`[MEDIUM]` `#recursion` `#tree-comparison` `#symmetry`

#### Problem Statement
Given the root of a binary tree, check whether it is a mirror of itself (i.e., symmetric around its center).

**Example:**
Input: `root = [1,2,2,3,4,4,3]` (Symmetric)
```
    1
   / \
  2   2
 / \ / \
3  4 4  3
```
Output: `true`

Input: `root = [1,2,2,null,3,null,3]` (Not symmetric)
Output: `false`

#### Implementation Overview
This problem can be solved by modifying the "Same Tree" logic. Instead of comparing two different trees, we compare two subtrees of the *same* tree.

The key insight is that a tree is symmetric if:
1. The root's left subtree is a mirror image of the root's right subtree.

So, we can write a recursive helper function `isMirror(node1, node2)` that checks if two trees are mirrors of each other.

1.  **Base Cases for `isMirror`:**
    a. If both `node1` and `node2` are `null`, they are mirrors. Return `True`.
    b. If one is `null` but the other isn't, or if their values differ, they are not mirrors. Return `False`.
2.  **Recursive Step for `isMirror`:** The crucial step. To be mirrors, `node1`'s left subtree must be a mirror of `node2`'s **right** subtree, AND `node1`'s right subtree must be a mirror of `node2`'s **left** subtree.
    - Return `isMirror(node1.left, node2.right) AND isMirror(node1.right, node2.left)`.

The main function simply calls `isMirror(root.left, root.right)` if the root exists.

#### Python Code Snippet
```python
# Definition for a binary tree node.
# class TreeNode:
#     def __init__(self, val=0, left=None, right=None):
#         self.val = val
#         self.left = left
#         self.right = right
from typing import Optional

class Solution:
    def isSymmetric(self, root: Optional[TreeNode]) -> bool:
        if not root:
            return True

        def isMirror(node1, node2):
            if not node1 and not node2:
                return True
            if not node1 or not node2 or node1.val != node2.val:
                return False

            # Check outer children and inner children
            return isMirror(node1.left, node2.right) and isMirror(node1.right, node2.left)

        return isMirror(root.left, root.right)
```

#### Tricks/Gotchas
- The core trick is realizing that symmetry means comparing `left` with `right` and `right` with `left` in the recursive calls. This is the "mirror" part of the logic.
- It's a common mistake to just check `isMirror(left, left)` and `isMirror(right, right)`, which doesn't work.

#### Related Problems
- `[Pattern 3]` Check if two trees are identical or not (the basis for this problem).

---

### 7. Maximum width of a Binary Tree
`[MEDIUM]` `#recursion` `#level-order` `#width`

#### Problem Statement
Given the root of a binary tree, return the maximum width of the given tree. The maximum width of a tree is the maximum width among all levels.

The width of one level is defined as the length between the end-nodes (the leftmost and rightmost non-null nodes), where the null nodes between the end-nodes that would be present in a complete binary tree extending down to that level are also counted.

**Example:**
Input: `root = [1,3,2,5,null,null,9]` (indices are different from values)
```
      1 (idx 0)
     / \
    3   2 (idx 1)
   /     \
  5       9 (idx 6)
(idx 1)
```
Output: `4` (The width of the third level is `6 - 3 + 1 = 4`. The nodes are 5 (index 1) and 9 (index 6)). Note: this example is slightly different from LeetCode's to better illustrate the concept.

#### Implementation Overview
The key to this problem is to assign an index to every node as if it were in a complete binary tree (like a heap).
- If a node has index `i`, its left child will have index `2*i` and its right child will have index `2*i + 1`. (Using 0-based indexing from the start).

We can then use a level-order traversal (BFS) to find the width of each level.

1.  Initialize `max_width = 0` and a queue for BFS.
2.  The queue will store pairs of `(node, index)`. Add `(root, 0)` to the queue.
3.  Loop while the queue is not empty (i.e., for each level):
    a. Get the `level_size`.
    b. Get the index of the first node in the level (`level_start_index`). This is the index of the element at the front of the queue.
    c. Loop `level_size` times:
        i. Dequeue a `(node, index)` pair.
        ii. The index of the last node in the level will be this `index`.
        iii. To prevent huge index numbers, we can use a relative index: `rel_index = index - level_start_index`.
        iv. Enqueue the children with their calculated indices: `(node.left, 2*rel_index)` and `(node.right, 2*rel_index + 1)`.
    d. The width of the current level is `last_node_index - level_start_index + 1`.
    e. Update `max_width = max(max_width, current_level_width)`.
4.  Return `max_width`.

#### Python Code Snippet
```python
# Definition for a binary tree node.
# class TreeNode:
#     def __init__(self, val=0, left=None, right=None):
#         self.val = val
#         self.left = left
#         self.right = right
from typing import Optional
import collections

class Solution:
    def widthOfBinaryTree(self, root: Optional[TreeNode]) -> int:
        if not root:
            return 0

        max_width = 0
        queue = collections.deque([(root, 0)]) # (node, index)

        while queue:
            level_size = len(queue)
            # Get the index of the first node at this level
            level_start_index = queue[0][1]

            for i in range(level_size):
                node, index = queue.popleft()

                # The width is the distance between the first and last node's index
                current_width = index - level_start_index + 1
                max_width = max(max_width, current_width)

                # Use relative indexing to prevent overflow
                rel_index = index - level_start_index
                if node.left:
                    queue.append((node.left, 2 * rel_index))
                if node.right:
                    queue.append((node.right, 2 * rel_index + 1))

        return max_width
```

#### Tricks/Gotchas
- The indices can become very large for deep trees. This can lead to integer overflow in languages with fixed-size integers. Python's arbitrary-precision integers handle this, but rebasing the index at each level (`rel_index = index - level_start_index`) is a robust optimization that prevents numbers from growing too large.
- The problem definition is subtle. It's not just the number of nodes on a level, but the "span" they cover.

#### Related Problems
- `[Pattern 1]` Level Order Traversal.

---

### 8. Check for Children Sum Property
`[HARD]` `#recursion` `#children-sum`

#### Problem Statement
Given the root of a binary tree, check if for every node, its value is equal to the sum of its left and right children's values. If a child is `null`, its value is treated as `0`.

**Example:**
Input:
```
      10
     /  \
    8    2
   / \  /
  3  5 2
```
Output: `true` (8=3+5, 2=2+0, 10=8+2)

Input:
```
      5
     / \
    3   1
```
Output: `false` (5 != 3+1)

#### Implementation Overview
This can be solved with a simple recursive traversal (pre-order, in-order, or post-order all work). We visit every node and check if the property holds.

1.  Create a recursive function `check(node)`.
2.  **Base Case:** If `node` is `null` or is a leaf node, it trivially satisfies the property. Return `True`.
3.  **Calculate Children Sum:**
    a. Initialize `children_sum = 0`.
    b. If `node.left` exists, add `node.left.val` to `children_sum`.
    c. If `node.right` exists, add `node.right.val` to `children_sum`.
4.  **Check Property:**
    a. Check if `node.val` is equal to `children_sum`.
    b. Recursively call `check(node.left)` and `check(node.right)`.
5.  The property must hold for the current node AND for its entire left subtree AND for its entire right subtree. So, the return value should be `(node.val == children_sum) AND check(node.left) AND check(node.right)`.

#### Python Code Snippet
```python
# Definition for a binary tree node.
# class TreeNode:
#     def __init__(self, val=0, left=None, right=None):
#         self.val = val
#         self.left = left
#         self.right = right
from typing import Optional

class Solution:
    def checkTree(self, root: Optional[TreeNode]) -> bool:
        if not root or (not root.left and not root.right):
            return True # Base case: empty or leaf node

        children_sum = 0
        if root.left:
            children_sum += root.left.val
        if root.right:
            children_sum += root.right.val

        # Check current node's property and recurse on children
        return (root.val == children_sum) and \
               self.checkTree(root.left) and \
               self.checkTree(root.right)
```

#### Tricks/Gotchas
- Make sure to handle `null` children correctly by treating their value as `0`.
- The recursive calls must be combined with an `AND`. If the property fails at any node in the tree, the entire result must be `false`.

#### Related Problems
- This is a straightforward tree traversal problem. It's related to other recursive property checks but is generally simpler.
