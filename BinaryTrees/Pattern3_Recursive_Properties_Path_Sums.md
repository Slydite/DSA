# Pattern 3: Recursive Properties & Path Sums

This pattern focuses on a common recursive strategy for solving binary tree problems. The core idea is to perform a post-order traversal (or a variation) where each node's recursive call returns a value (or set of values) to its parent. The parent then uses these values from its left and right children to compute a property for its own subtree. This "pass-up" information flow is key.

---

### 1. Height of a Binary Tree
`[MEDIUM]` `#recursion` `#height-balanced`

#### Problem Statement
*(Explanation of how to find the height of a binary tree using a simple recursive approach: 1 + max(left_height, right_height).)*

---

### 2. Check if the Binary tree is height-balanced or not
`[MEDIUM]` `#recursion` `#height-balanced`

#### Problem Statement
*(Explanation of how to check for a height-balanced tree by modifying the height function to return -1 if an imbalance is found.)*

---

### 3. Diameter of Binary Tree
`[MEDIUM]` `#recursion` `#diameter`

#### Problem Statement
*(Explanation of how to find the diameter by having the recursive height function also update a global or passed-by-reference variable for the maximum diameter found so far.)*

---

### 4. Maximum path sum
`[HARD]` `#recursion` `#path-sum`

#### Problem Statement
*(Explanation of the classic maximum path sum problem, where the recursive function returns the max path sum "going up" while updating a global variable for the max path sum that can "turn" at a node.)*

---

### 5. Check if two trees are identical or not
`[MEDIUM]` `#recursion` `#tree-comparison`

#### Problem Statement
*(Explanation of how to compare two trees for identity using a simple parallel recursion.)*

---

### 6. Symmetric Binary Tree
`[MEDIUM]` `#recursion` `#tree-comparison` `#symmetry`

#### Problem Statement
*(Explanation of how to check for symmetry by creating a recursive helper function that compares a node's left subtree with its right subtree in a mirrored fashion.)*

---

### 7. Maximum width of a Binary Tree
`[MEDIUM]` `#recursion` `#level-order` `#width`

#### Problem Statement
*(Explanation of how to find the maximum width, typically using a level-order traversal with node indexing to calculate the width at each level.)*

---

### 8. Check for Children Sum Property
`[HARD]` `#recursion` `#children-sum`

#### Problem Statement
*(Explanation of how to check if every node's value is equal to the sum of its immediate children's values.)*
