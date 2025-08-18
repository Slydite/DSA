# Pattern 4: Pathfinding & Ancestors

This pattern deals with problems that require finding a path between nodes, identifying common ancestors (like the Lowest Common Ancestor), or finding nodes based on their relationship or distance to another node. These solutions often involve a traversal to find the target node(s) and then another mechanism (like backtracking or a parent-pointer map) to solve the actual problem.

---

### 1. Root to Node Path in Binary Tree
`[MEDIUM]` `#recursion` `#pathfinding` `#backtracking`

#### Problem Statement
*(Explanation of how to find the path from the root to a given node, typically using a recursive traversal that builds a path and backtracks.)*

---

### 2. LCA in Binary Tree
`[MEDIUM]` `#recursion` `#lca`

#### Problem Statement
*(Explanation of the classic and efficient recursive solution for finding the Lowest Common Ancestor of two nodes in a binary tree.)*

---

### 3. Print all the Nodes at a distance of K in a Binary Tree
`[MEDIUM]` `#traversal` `#pathfinding` `#distance-k`

#### Problem Statement
*(Explanation of the multi-step process: find the target node, then search downwards for nodes at distance K, and also search upwards (using the root-to-node path) to find nodes in other subtrees that are at distance K.)*

---

### 4. Minimum time taken to BURN the Binary Tree from a Node
`[HARD]` `#traversal` `#bfs` `#burn-tree`

#### Problem Statement
*(Explanation of how to solve this problem by treating the tree as a graph. This involves creating parent pointers (or a map) and then performing a BFS starting from the target node to find the maximum time taken to reach any node.)*
