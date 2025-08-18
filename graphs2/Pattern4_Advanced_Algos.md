# Pattern 4: Advanced Graph Algorithms

This pattern covers advanced algorithms for analyzing the connectivity and structure of graphs. These algorithms, often based on nuanced applications of Depth-First Search (DFS), are used to find critical edges (bridges), critical vertices (articulation points), and strongly connected subgraphs.

---

### 1. Bridges in a Graph
`[HARD]` `#dfs` `#bridges`

#### Problem Statement
Given a connected, undirected graph, a **bridge** is an edge that, if removed, would increase the number of connected components in the graph. The task is to find all bridges in the graph.

#### Implementation Overview
This problem can be solved in a single DFS traversal. The algorithm, often attributed to Tarjan, relies on tracking the "discovery time" and the "low-link" value for each vertex.
1.  **Discovery Time (`disc[u]`):** The time (or step number) at which a vertex `u` is first visited during the DFS.
2.  **Low-Link Value (`low[u]`):** The lowest discovery time reachable from `u` (including itself through its DFS tree), possibly using one "back-edge" to an ancestor.

**Algorithm:**
1.  Initialize `disc` and `low` arrays to -1, a `time` variable to 0, and a parent variable for the DFS.
2.  Start a DFS from a source vertex.
3.  `dfs(u, parent)`:
    - Set `disc[u] = low[u] = time`, and increment `time`.
    - For each neighbor `v` of `u`:
        - If `v` is the `parent`, ignore it.
        - If `v` is visited: it's a back-edge. Update `low[u] = min(low[u], disc[v])`.
        - If `v` is not visited:
            - Recursively call `dfs(v, u)`.
            - After the call returns, update `low[u] = min(low[u], low[v])`.
            - **Bridge Condition**: If `low[v] > disc[u]`, the earliest reachable node from `v` is within its own subtree. It cannot reach `u` or its ancestors via a back-edge. Therefore, the edge `(u, v)` is a bridge.

---

### 2. Articulation Points in a Graph
`[HARD]` `#dfs` `#articulation-points`

#### Problem Statement
An **articulation point** (or cut vertex) is a vertex that, if removed (along with its edges), would increase the number of connected components. Find all articulation points in a given connected, undirected graph.

#### Implementation Overview
The algorithm is very similar to finding bridges, using the same `disc` and `low` value concepts.
1.  Perform a DFS traversal, calculating `disc` and `low` for each vertex.
2.  `dfs(u, parent)`:
    - Set `disc[u] = low[u] = time`, etc.
    - Keep track of the number of children in the DFS tree for `u`.
    - For each neighbor `v` of `u`:
        - ... (same logic as finding bridges for updating `low[u]`) ...
        - **Articulation Point Conditions**:
            1.  **For the root of the DFS tree**: The root `u` is an articulation point if it has **more than one child** in the DFS tree.
            2.  **For any other node**: A non-root node `u` is an articulation point if it has a child `v` such that `low[v] >= disc[u]`. This means the subtree at `v` has no back-edge to an ancestor of `u`. Removing `u` would disconnect `v`'s subtree.

---

### 3. Kosaraju's Algorithm for Strongly Connected Components (SCCs)
`[HARD]` `#dfs` `#kosaraju` `#scc`

#### Problem Statement
In a **directed graph**, a **Strongly Connected Component (SCC)** is a subgraph where for every pair of vertices `u, v` in the subgraph, there is a path from `u` to `v` and a path from `v` to `u`. Find all SCCs.

#### Implementation Overview
Kosaraju's algorithm finds all SCCs using two DFS traversals.
1.  **Step 1: First DFS (Order by Finish Time)**
    - Perform a DFS on the original graph `G`.
    - The purpose is to get vertices in decreasing order of their "finish times". Push each vertex onto a stack after all its neighbors have been fully explored (same logic as DFS-based topological sort).

2.  **Step 2: Transpose the Graph**
    - Create the transpose graph `G_T` by reversing the direction of every edge in `G`.

3.  **Step 3: Second DFS (Find Components)**
    - Pop vertices one by one from the stack created in Step 1.
    - For each popped vertex `u`, if it has not yet been visited (in this second pass):
        - Start a DFS on the **transpose graph `G_T`** from `u`.
        - All vertices reachable from `u` in `G_T` form a single Strongly Connected Component. Collect them and mark them as visited.
    - Repeat until the stack is empty.

By processing nodes in the order of decreasing finish times from the first pass, the second DFS on the transposed graph is guaranteed to only explore nodes within a single SCC.
