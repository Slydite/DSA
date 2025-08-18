# Pattern 4: Topological Sort

A Topological Sort of a Directed Acyclic Graph (DAG) is a linear ordering of its vertices such that for every directed edge from vertex `u` to vertex `v`, `u` comes before `v` in the ordering. If the graph has a cycle, it does not have a topological sort. This pattern is fundamental for problems involving dependencies, scheduling, or prerequisites.

There are two main algorithms to perform a topological sort: a DFS-based approach and a BFS-based approach (Kahn's Algorithm).

---

### 1. Topological Sort (DFS-based)
`[MEDIUM]` `#dfs` `#topological-sort`

#### Problem Statement
Given a Directed Acyclic Graph (DAG), return a linear ordering of its vertices that represents a valid topological sort.

#### Implementation Overview
This approach uses Depth-First Search and a stack to record the "finish time" of each node.
1.  Initialize an empty `stack` which will store the sorted vertices.
2.  Initialize a `visited` array.
3.  Iterate through all vertices. For each unvisited vertex, call a recursive DFS helper.
4.  **`dfs(node)` function**:
    - Mark `node` as visited.
    - For each `neighbor` of `node`, if it's not visited, recursively call `dfs(neighbor)`.
    - After the recursive calls for all neighbors are complete, push the `node` onto the `stack`.
5.  The `stack` now contains the vertices in topologically sorted order. Popping from it gives the result.

#### Python Code Snippet
```python
def topo_sort_dfs(V, adj):
    visited = [False] * V
    stack = []

    def dfs(node):
        visited[node] = True
        for neighbor in adj.get(node, []):
            if not visited[neighbor]:
                dfs(neighbor)
        stack.append(node)

    for i in range(V):
        if not visited[i]:
            dfs(i)

    return stack[::-1] # Reverse to get correct order
```

---

### 2. Kahn's Algorithm (BFS-based Topological Sort)
`[MEDIUM]` `#bfs` `#topological-sort`

#### Problem Statement
Given a Directed Acyclic Graph (DAG), return a valid topological sort. This approach also naturally detects cycles.

#### Implementation Overview
Kahn's algorithm uses Breadth-First Search and **in-degrees** (the number of incoming edges).
1.  **Compute In-degrees**: Calculate the in-degree for every vertex.
2.  **Initialize Queue**: Create a queue and add all vertices with an in-degree of `0`.
3.  **Process Queue**:
    - Initialize an empty list `topo_order`.
    - While the queue is not empty:
        - Dequeue `u`, add it to `topo_order`.
        - For each `neighbor` `v` of `u`:
            - Decrement the in-degree of `v`.
            - If `v`'s in-degree becomes `0`, enqueue `v`.
4.  **Cycle Detection**: If `len(topo_order) == V`, the sort is valid. Otherwise, a cycle exists. This directly solves **Cycle Detection in Directed Graph (BFS)**.

---

### 3. Course Schedule - I
`[MEDIUM]` `#topological-sort` `#cycle-detection`

#### Problem Statement
Given `numCourses` and a list of `prerequisites` `[ai, bi]` (to take `ai`, you must first take `bi`), return `true` if you can finish all courses.

#### Implementation Overview
This is a cycle detection problem. If there is a cycle (e.g., A depends on B, B depends on A), it's impossible.
- **Graph Model**: Each course is a vertex. A prerequisite `[a, b]` is a directed edge `b -> a`.
- **Solution**: Use Kahn's algorithm. If the algorithm produces a topological sort of length `numCourses`, it means there was no cycle. Return `true`. Otherwise, return `false`.

---

### 4. Course Schedule - II
`[MEDIUM]` `#topological-sort`

#### Problem Statement
Same as Course Schedule I, but return the ordering of courses to take. If impossible, return an empty array.

#### Implementation Overview
This is a direct application of topological sort.
- **Solution**: Perform a topological sort (Kahn's is natural here).
  - If the sort is successful and produces an ordering of all `numCourses`, return that ordering.
  - If the sort fails (due to a cycle), return an empty array.

---

### 5. Find Eventual Safe States
`[MEDIUM]` `#topological-sort` `#dfs`

#### Problem Statement
In a directed graph, a node is "safe" if every path starting from it leads to a "terminal" node (a node with no outgoing edges). Return all safe nodes.

#### Implementation Overview
A node is *unsafe* if it's part of a cycle or can reach a cycle.
- **Graph Reversal**: Reverse all edges. The problem becomes: find all nodes that can reach a terminal node in the original graph. In the reversed graph, terminal nodes become source nodes (in-degree 0).
- **Solution**: Perform a topological sort (Kahn's) on the **reversed graph**. The resulting topological order is the set of all nodes reachable from the original terminal nodes. These are the safe nodes. Sort and return.

---

### 6. Alien Dictionary
`[HARD]` `#topological-sort`

#### Problem Statement
Given a list of `words` sorted lexicographically by an alien language's rules, derive the order of letters.

#### Implementation Overview
This is a dependency-inference problem.
1.  **Build Graph**: Letters are vertices. Find dependencies by comparing adjacent words.
    - Compare `words[i]` and `words[i+1]`.
    - Find the first character where they differ. If `words[i] = "wrt"` and `words[i+1] = "wrf"`, then `t` must come before `f`. Add a directed edge `t -> f`.
2.  **Topological Sort**: Once the graph of letter dependencies is built, perform a topological sort. The result is the alien alphabet. If the sort fails (cycle detected), the order is inconsistent.
