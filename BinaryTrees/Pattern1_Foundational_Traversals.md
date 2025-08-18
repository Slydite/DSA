# Pattern 1: Foundational Traversals

This pattern covers the essential traversal algorithms for binary trees, which form the basis for solving a wide range of tree problems. It includes recursive and iterative approaches for Depth-First (Pre-order, In-order, Post-order) and Breadth-First (Level-order) traversals.

---

### 1. Binary Tree Traversals in Binary Tree
`[EASY]` `#traversal`

#### Problem Statement
This is a foundational concept that covers the three primary ways to traverse a tree using Depth First Search (DFS):
- **In-order Traversal:** Visit the left subtree, then the current node, and finally the right subtree. (Mnemonic: **L**eft, **R**oot, **R**ight)
- **Pre-order Traversal:** Visit the current node, then the left subtree, and finally the right subtree. (Mnemonic: **R**oot, **L**eft, **R**ight)
- **Post-order Traversal:** Visit the left subtree, then the right subtree, and finally the current node. (Mnemonic: **L**eft, **R**ight, **R**oot)

Given the root of a binary tree, the task is to write recursive functions for all three traversal types.

**Example:**
For the tree:
```
      1
     / \
    2   3
   / \
  4   5
```
- **In-order:** `4, 2, 5, 1, 3`
- **Pre-order:** `1, 2, 4, 5, 3`
- **Post-order:** `4, 5, 2, 3, 1`

#### Implementation Overview
The implementation for all three traversals is elegantly handled with recursion. A helper function is defined for each traversal, which takes the current node as an argument.

1.  **Base Case:** If the current node is `null` (or `None`), simply return. This stops the recursion when we reach a leaf's child.
2.  **Recursive Step:** Based on the traversal type, perform the three key actions in the correct order:
    - `inorder(node.left)`: Recursively call on the left child.
    - `inorder(node.right)`: Recursively call on the right child.
    - `print(node.val)` or add to a list: Process the current node's value.

The order of these three actions is the only thing that changes between the three traversal types.

#### Python Code Snippet
```python
class TreeNode:
    def __init__(self, val=0, left=None, right=None):
        self.val = val
        self.left = left
        self.right = right

def inorder_traversal(root):
    res = []
    def helper(node):
        if not node:
            return
        helper(node.left)
        res.append(node.val)
        helper(node.right)
    helper(root)
    return res

def preorder_traversal(root):
    res = []
    def helper(node):
        if not node:
            return
        res.append(node.val)
        helper(node.left)
        helper(node.right)
    helper(root)
    return res

def postorder_traversal(root):
    res = []
    def helper(node):
        if not node:
            return
        helper(node.left)
        helper(node.right)
        res.append(node.val)
    helper(root)
    return res
```

#### Tricks/Gotchas
- The core logic is simple, but it's crucial to remember the exact order for each traversal. The mnemonics (LNR, NLR, LRN) are very helpful.
- In-order traversal of a Binary Search Tree (BST) results in a sorted list of its node values. This is a very important property.
- Post-order traversal is often used when you need to process child nodes before the parent (e.g., deleting nodes in a tree, calculating the height of subtrees).

#### Related Problems
- All iterative traversal problems in this pattern file.
- `[Pattern 3]` Height of a Binary Tree (uses a post-order traversal pattern).
- `[Pattern 5]` Construct Binary Tree from inorder and preorder (relies on understanding how these traversals represent the tree structure).

---

### 2. Preorder Traversal of Binary Tree
`[EASY]` `#traversal` `#preorder`

#### Problem Statement
Given the root of a binary tree, return the preorder traversal of its nodes' values. The traversal should follow the order: **Root, Left, Right**.

**Example:**
Input: `root = [1,null,2,3]`
```
   1
    \
     2
    /
   3
```
Output: `[1, 2, 3]`

#### Implementation Overview
The recursive solution is the most straightforward. We define a helper function that takes the current node and a list to store the result.

1.  **Base Case:** If the current node is `None`, we do nothing and return.
2.  **Visit Root:** Add the current node's value to our result list.
3.  **Recurse Left:** Call the helper function on the left child.
4.  **Recurse Right:** Call the helper function on the right child.

This order of operations ensures the "Root, Left, Right" sequence.

#### Python Code Snippet
```python
# Definition for a binary tree node.
# class TreeNode:
#     def __init__(self, val=0, left=None, right=None):
#         self.val = val
#         self.left = left
#         self.right = right
from typing import List, Optional

class Solution:
    def preorderTraversal(self, root: Optional[TreeNode]) -> List[int]:
        res = []

        def traverse(node):
            if not node:
                return

            res.append(node.val)
            traverse(node.left)
            traverse(node.right)

        traverse(root)
        return res
```

#### Tricks/Gotchas
- Preorder traversal is useful for tasks where you need to process a node before its descendants.
- A classic application is creating a copy of a tree (serializing), as you can create the root, then recursively build the left and right subtrees.
- Be careful to distinguish it from other traversals; the order of visiting the node vs. making recursive calls is the only difference.

#### Related Problems
- `[This File]` Iterative Preorder Traversal of Binary Tree
- `[Pattern 5]` Serialize and deserialize Binary Tree
- N-ary Tree Preorder Traversal (a generalization of this problem).

---

### 3. Inorder Traversal of Binary Tree
`[EASY]` `#traversal` `#inorder`

#### Problem Statement
Given the root of a binary tree, return the inorder traversal of its nodes' values. The traversal should follow the order: **Left, Root, Right**.

**Example:**
Input: `root = [1,null,2,3]`
```
   1
    \
     2
    /
   3
```
Output: `[1, 3, 2]`

#### Implementation Overview
The recursive solution is elegant and directly follows the traversal's definition. We use a helper function that takes the current node and a results list.

1.  **Base Case:** If the current node is `None`, return.
2.  **Recurse Left:** Call the helper function on the left child.
3.  **Visit Root:** Once the left recursion is complete, add the current node's value to our result list.
4.  **Recurse Right:** Call the helper function on the right child.

This "Left, Root, Right" order is what defines the inorder traversal.

#### Python Code Snippet
```python
# Definition for a binary tree node.
# class TreeNode:
#     def __init__(self, val=0, left=None, right=None):
#         self.val = val
#         self.left = left
#         self.right = right
from typing import List, Optional

class Solution:
    def inorderTraversal(self, root: Optional[TreeNode]) -> List[int]:
        res = []

        def traverse(node):
            if not node:
                return

            traverse(node.left)
            res.append(node.val)
            traverse(node.right)

        traverse(root)
        return res
```

#### Tricks/Gotchas
- The most critical property of inorder traversal is that for a **Binary Search Tree (BST)**, it visits the nodes in non-decreasing order. This is frequently used to validate if a tree is a BST or to find the k-th smallest element.
- Because you must traverse the entire left subtree before visiting the root, it's less intuitive to implement iteratively compared to preorder.

#### Related Problems
- `[This File]` Iterative Inorder Traversal of Binary Tree
- `[Pattern 5]` Construct Binary Tree from inorder and preorder/postorder (Inorder is essential for construction).
- Validate Binary Search Tree
- Kth Smallest Element in a BST

---

### 4. Post-order Traversal of Binary Tree
`[EASY]` `#traversal` `#postorder`

#### Problem Statement
Given the root of a binary tree, return the postorder traversal of its nodes' values. The traversal should follow the order: **Left, Right, Root**.

**Example:**
Input: `root = [1,null,2,3]`
```
   1
    \
     2
    /
   3
```
Output: `[3, 2, 1]`

#### Implementation Overview
The recursive solution naturally mirrors the "Left, Right, Root" definition. A helper function is used to manage the recursion.

1.  **Base Case:** If the current node is `None`, return.
2.  **Recurse Left:** Call the helper function on the left child.
3.  **Recurse Right:** Call the helper function on the right child.
4.  **Visit Root:** After the recursive calls for both left and right children have completed, add the current node's value to the result list.

This ensures that a node is processed only after its entire left and right subtrees have been processed.

#### Python Code Snippet
```python
# Definition for a binary tree node.
# class TreeNode:
#     def __init__(self, val=0, left=None, right=None):
#         self.val = val
#         self.left = left
#         self.right = right
from typing import List, Optional

class Solution:
    def postorderTraversal(self, root: Optional[TreeNode]) -> List[int]:
        res = []

        def traverse(node):
            if not node:
                return

            traverse(node.left)
            traverse(node.right)
            res.append(node.val)

        traverse(root)
        return res
```

#### Tricks/Gotchas
- Post-order traversal is essential when you need to compute a value for a node based on the values of its children. This is why it's used in problems like finding the height of a tree or checking for a children sum property.
- It's also used for deletion in a binary tree. You must delete the children before you can delete the parent.
- The iterative implementation of post-order is the trickiest of the three DFS traversals.

#### Related Problems
- `[This File]` Iterative Post-order Traversal (using 1 or 2 stacks).
- `[Pattern 3]` Height of a Binary Tree
- `[Pattern 3]` Check for Children Sum Property

---

### 5. Level order Traversal
`[EASY]` `#traversal` `#level-order` `#bfs`

#### Problem Statement
Given the root of a binary tree, return the level order traversal of its nodes' values. (i.e., from left to right, level by level).

**Example:**
Input: `root = [3,9,20,null,null,15,7]`
```
    3
   / \
  9  20
    /  \
   15   7
```
Output: `[[3],[9,20],[15,7]]`

#### Implementation Overview
Level order traversal is implemented using a queue, which is a hallmark of Breadth-First Search (BFS).

1.  Initialize an empty list `result` to store the levels and a queue (e.g., `collections.deque` in Python) with the root node.
2.  Loop while the queue is not empty.
3.  Inside the loop, first get the number of nodes currently in the queue (`level_size`). This is crucial because it tells you how many nodes are on the current level.
4.  Initialize a new list `current_level` to store the values for this level.
5.  Loop `level_size` times:
    a. Dequeue a node from the front of the queue.
    b. Add its value to the `current_level` list.
    c. If the node has a left child, enqueue it.
    d. If the node has a right child, enqueue it.
6.  After the inner loop finishes, add the `current_level` list to the `result` list.
7.  Once the outer loop finishes, return the `result`.

#### Python Code Snippet
```python
# Definition for a binary tree node.
# class TreeNode:
#     def __init__(self, val=0, left=None, right=None):
#         self.val = val
#         self.left = left
#         self.right = right
from typing import List, Optional
import collections

class Solution:
    def levelOrder(self, root: Optional[TreeNode]) -> List[List[int]]:
        if not root:
            return []

        result = []
        queue = collections.deque([root])

        while queue:
            level_size = len(queue)
            current_level = []

            for _ in range(level_size):
                node = queue.popleft()
                current_level.append(node.val)

                if node.left:
                    queue.append(node.left)
                if node.right:
                    queue.append(node.right)

            result.append(current_level)

        return result
```

#### Tricks/Gotchas
- The key trick is processing the tree one level at a time. The `level_size` variable is essential for this; without it, you would just traverse all nodes in a flat list, not grouped by level.
- Using `collections.deque` is more efficient for queue operations (popleft) than a standard Python list.
- This algorithm forms the basis for many other "view" problems.

#### Related Problems
- `[Pattern 2]` Zig Zag Traversal of Binary Tree
- `[Pattern 2]` Right/Left View of Binary Tree
- `[Pattern 3]` Maximum width of a Binary Tree

---

### 6. Iterative Preorder Traversal of Binary Tree
`[EASY]` `#traversal` `#preorder` `#iterative` `#stack`

#### Problem Statement
Given the root of a binary tree, return the preorder traversal of its nodes' values using an iterative approach. The traversal should follow the order: **Root, Left, Right**.

#### Implementation Overview
The iterative preorder traversal is a direct translation of the recursive idea using a stack. A stack naturally mimics the "last-in, first-out" behavior of recursive function calls.

1.  Initialize an empty list `result` and a stack. If the `root` is not null, push it onto the stack.
2.  Loop while the stack is not empty.
3.  Pop a node from the top of the stack.
4.  Add the popped node's value to the `result` list.
5.  **Crucially, push the right child onto the stack first, then the left child.** Since a stack is LIFO (Last-In, First-Out), pushing the left child last ensures it will be processed first, maintaining the "Root, Left, Right" order.
6.  After the loop, return the `result`.

#### Python Code Snippet
```python
# Definition for a binary tree node.
# class TreeNode:
#     def __init__(self, val=0, left=None, right=None):
#         self.val = val
#         self.left = left
#         self.right = right
from typing import List, Optional

class Solution:
    def preorderTraversal(self, root: Optional[TreeNode]) -> List[int]:
        if not root:
            return []

        result = []
        stack = [root]

        while stack:
            node = stack.pop()
            result.append(node.val)

            # Push right child first, then left child
            if node.right:
                stack.append(node.right)
            if node.left:
                stack.append(node.left)

        return result
```

#### Tricks/Gotchas
- The most common mistake is pushing children onto the stack in the wrong order. Remember: `push right, then push left` to process `left, then right`.
- This approach is a fundamental building block for more complex iterative tree algorithms. It's a very direct simulation of recursion.

#### Related Problems
- `[This File]` Recursive Preorder Traversal (the conceptual basis).
- `[This File]` Iterative Inorder Traversal (a slightly more complex iterative problem).
- Binary Tree Zigzag Level Order Traversal (combines ideas from level-order and stack-based processing).

---

### 7. Iterative Inorder Traversal of Binary Tree
`[EASY]` `#traversal` `#inorder` `#iterative` `#stack`

#### Problem Statement
Given the root of a binary tree, return the inorder traversal of its nodes' values using an iterative approach. The traversal should follow the order: **Left, Root, Right**.

#### Implementation Overview
Unlike preorder, we can't simply visit a node when we pop it from the stack. We must wait until its entire left subtree has been visited. This requires a more nuanced approach.

1.  Initialize an empty list `result`, an empty `stack`, and a `current` pointer to the `root`.
2.  Use a `while` loop that continues as long as the `current` pointer is not null OR the `stack` is not empty. This condition is key.
3.  **Go Left:** While `current` is not null, push it onto the `stack` and move `current` to its left child (`current = current.left`). This loop ensures we go as far left as possible, adding all nodes on the path to the stack.
4.  **Visit Node:** Once `current` becomes null (meaning we've hit the bottom of a left path), we pop a node from the stack. This node is the next one to be visited in the inorder sequence. Add its value to the `result`.
5.  **Go Right:** After visiting the node, we must explore its right subtree. Set `current = popped_node.right` and let the main loop continue. The next iteration will either start pushing the left children of this new `current` node or, if it's null, pop the next node from the stack (which would be the parent of the node we just processed).

#### Python Code Snippet
```python
# Definition for a binary tree node.
# class TreeNode:
#     def __init__(self, val=0, left=None, right=None):
#         self.val = val
#         self.left = left
#         self.right = right
from typing import List, Optional

class Solution:
    def inorderTraversal(self, root: Optional[TreeNode]) -> List[int]:
        result = []
        stack = []
        current = root

        while current or stack:
            # Go as far left as possible
            while current:
                stack.append(current)
                current = current.left

            # current is now None, so we pop from the stack
            current = stack.pop()
            result.append(current.val)

            # Now, explore the right subtree
            current = current.right

        return result
```

#### Tricks/Gotchas
- The `while current or stack:` condition is crucial. The loop must continue even if `current` is null, as long as there are nodes in the stack waiting to be processed.
- This pattern of "push all left children, then pop and visit, then go right" is the core of iterative inorder traversal and is a very common interview pattern.

#### Related Problems
- `[This File]` Recursive Inorder Traversal (the conceptual basis).
- `[Pattern 6]` Morris Inorder Traversal (a space-optimized version that avoids a stack).
- Validate Binary Search Tree (can be done iteratively with this traversal).
- Kth Smallest Element in a BST (can be solved by stopping this traversal after k elements).

---

### 8. Post-order Traversal of Binary Tree using 2 stacks
`[EASY]` `#traversal` `#postorder` `#iterative` `#stack`

#### Problem Statement
Given the root of a binary tree, return the postorder traversal of its nodes' values using an iterative approach with two stacks. The traversal should follow the order: **Left, Right, Root**.

#### Implementation Overview
This method is a clever modification of the iterative preorder traversal. Recall that preorder is `Root, Left, Right`. If we were to do a modified preorder traversal of `Root, Right, Left`, the resulting sequence would be `[1, 3, 2]` for the standard example tree. If you reverse this sequence, you get `[2, 3, 1]`, which is exactly the postorder traversal!

The algorithm uses two stacks:
1.  Initialize an empty `stack1` and an empty `stack2`. Push the `root` to `stack1`.
2.  Loop while `stack1` is not empty.
3.  Pop a node from `stack1`.
4.  Push this popped node onto `stack2`.
5.  Push the left child of the popped node to `stack1`, then push the right child. This is the `Root, Left, Right` order of pushing.
6.  After the loop, `stack2` contains the nodes in the order `Root, Right, Left`.
7.  Pop all elements from `stack2` and add their values to the `result` list. This will reverse the order, giving the correct `Left, Right, Root` postorder sequence.

#### Python Code Snippet
```python
# Definition for a binary tree node.
# class TreeNode:
#     def __init__(self, val=0, left=None, right=None):
#         self.val = val
#         self.left = left
#         self.right = right
from typing import List, Optional

class Solution:
    def postorderTraversal(self, root: Optional[TreeNode]) -> List[int]:
        if not root:
            return []

        stack1 = [root]
        stack2 = []
        result = []

        while stack1:
            node = stack1.pop()
            stack2.append(node)

            if node.left:
                stack1.append(node.left)
            if node.right:
                stack1.append(node.right)

        while stack2:
            result.append(stack2.pop().val)

        return result
```

#### Tricks/Gotchas
- This method is easier to remember and implement than the one-stack version.
- The key insight is realizing that `Postorder` is the reverse of a modified `Preorder` (`Root, Right, Left`).
- The space complexity is O(N) due to the two stacks, which can be a drawback in memory-constrained scenarios.

#### Related Problems
- `[This File]` Iterative Post-order Traversal using 1 stack (the more space-efficient version).
- `[This File]` Iterative Preorder Traversal (the basis for this trick).

---

### 9. Post-order Traversal of Binary Tree using 1 stack
`[EASY]` `#traversal` `#postorder` `#iterative` `#stack`

#### Problem Statement
Given the root of a binary tree, return the postorder traversal of its nodes' values using an iterative approach with only one stack. The traversal should follow the order: **Left, Right, Root**.

#### Implementation Overview
This method is more complex because we need to know when a node's right child has been visited before we can visit the node itself. We can track the previously visited node to make this decision.

1.  Initialize an empty `result` list, an empty `stack`, and a `current` pointer to `root`.
2.  Loop while `current` is not null or the `stack` is not empty.
3.  **Go Left:** While `current` is not null, push it onto the stack and move `current = current.left`.
4.  **Check Right Subtree:** After the inner loop, `current` is null. Peek at the top of the stack.
    - If the node at the top of the stack has a right child, and that right child has **not** been visited yet (i.e., `peek_node.right` is not the `last_visited_node`), then we must visit the right subtree. Set `current = peek_node.right` and continue the main loop.
    - **Visit Node:** Otherwise, it means we have already processed the left and right subtrees (or they don't exist). So, we can now visit this node. Pop it from the stack, add its value to `result`, set it as the `last_visited_node`, and set `current` to `None` to ensure we continue popping from the stack in the next iteration.

#### Python Code Snippet
```python
# Definition for a binary tree node.
# class TreeNode:
#     def __init__(self, val=0, left=None, right=None):
#         self.val = val
#         self.left = left
#         self.right = right
from typing import List, Optional

class Solution:
    def postorderTraversal(self, root: Optional[TreeNode]) -> List[int]:
        if not root:
            return []

        result = []
        stack = []
        current = root
        last_visited = None

        while current or stack:
            while current:
                stack.append(current)
                current = current.left

            peek_node = stack[-1] # Peek at the top

            # If the right child exists and has not been visited yet
            if peek_node.right and peek_node.right != last_visited:
                current = peek_node.right
            else:
                # Visit the node
                last_visited = stack.pop()
                result.append(last_visited.val)

        return result
```

#### Tricks/Gotchas
- The use of `last_visited` is the key to this algorithm. It prevents the code from going down the right subtree infinitely.
- This approach is harder to reason about than the two-stack method but is more space-efficient (O(H) space, where H is the height of the tree).
- Setting `current = None` after visiting a node is an important detail that is sometimes missed. It forces the loop to continue by popping from the stack rather than trying to traverse left again.

#### Related Problems
- `[This File]` Iterative Post-order Traversal using 2 stacks (the simpler, less space-efficient version).

---

### 10. Preorder, Inorder, and Postorder Traversal in one Traversal
`[MEDIUM]` `#traversal` `#iterative` `#stack`

#### Problem Statement
Given the root of a binary tree, write a single iterative function that returns all three DFS traversals (Preorder, Inorder, and Postorder) in one pass.

#### Implementation Overview
This advanced technique uses a single stack but stores pairs of `(node, num)` instead of just nodes. The `num` acts as a state machine for each node:
- `num = 1`: This is the first time we've encountered the node. We process it for **preorder** and then try to go left.
- `num = 2`: We've returned from the left subtree. We process the node for **inorder** and then try to go right.
- `num = 3`: We've returned from the right subtree. We process the node for **postorder** and are finished with it.

The algorithm works as follows:
1.  Initialize three empty lists: `pre`, `in`, `post`.
2.  Initialize a stack and push the pair `(root, 1)` if the root exists.
3.  Loop while the stack is not empty.
4.  Pop the `(node, num)` pair.
5.  If `num == 1`:
    - Add `node.val` to `pre`.
    - Push `(node, 2)` back onto the stack.
    - If `node.left` exists, push `(node.left, 1)` onto the stack.
6.  If `num == 2`:
    - Add `node.val` to `in`.
    - Push `(node, 3)` back onto the stack.
    - If `node.right` exists, push `(node.right, 1)` onto the stack.
7.  If `num == 3`:
    - Add `node.val` to `post`.
    - We are done with this node, so we don't push it back.

#### Python Code Snippet
```python
# Definition for a binary tree node.
# class TreeNode:
#     def __init__(self, val=0, left=None, right=None):
#         self.val = val
#         self.left = left
#         self.right = right
from typing import List, Tuple, Optional

def all_traversals_in_one(root: Optional[TreeNode]) -> Tuple[List[int], List[int], List[int]]:
    if not root:
        return [], [], []

    pre_order = []
    in_order = []
    post_order = []
    stack = [(root, 1)]

    while stack:
        node, num = stack.pop()

        if num == 1:
            # Preorder processing
            pre_order.append(node.val)
            stack.append((node, 2))
            if node.left:
                stack.append((node.left, 1))
        elif num == 2:
            # Inorder processing
            in_order.append(node.val)
            stack.append((node, 3))
            if node.right:
                stack.append((node.right, 1))
        else: # num == 3
            # Postorder processing
            post_order.append(node.val)

    return pre_order, in_order, post_order
```

#### Tricks/Gotchas
- This is a state-machine approach. The `num` variable is the state for each node.
- The order of operations is critical. When a node is popped, its state is incremented, and it's pushed back onto the stack *before* its children are pushed. This ensures we return to the node later.
- While clever, this is often less practical than just writing three separate, clear traversal functions. It's more of a test of deep understanding of iterative traversals.

#### Related Problems
- This problem is a culmination of all the other iterative DFS traversals in this file.
