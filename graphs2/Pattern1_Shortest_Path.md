# Pattern 1: Shortest Path Algorithms

Finding the shortest path between nodes is one of the most common problems in graph theory. The right algorithm depends on the properties of the graph, such as whether its edges are weighted, whether weights can be negative, and whether the graph is a Directed Acyclic Graph (DAG).

---

### 1. Shortest Path in Unweighted Graph
`[EASY]` `#bfs` `#shortest-path`

#### Implementation Overview
For an unweighted graph (or a graph with uniform edge weights), the shortest path is the path with the fewest edges. **Breadth-First Search (BFS)** is guaranteed to find this.
- Start a BFS from the source node, keeping track of distances.
- The distance to a node is simply its level in the BFS tree.

---

### 2. Shortest Path in a Directed Acyclic Graph (DAG)
`[MEDIUM]` `#dag` `#topological-sort` `#shortest-path`

#### Implementation Overview
For a DAG, we can find the shortest path from a source `s` in O(V+E) time, which is more efficient than Dijkstra's. This works even with negative edge weights.
1.  **Topologically sort** the vertices of the DAG.
2.  Initialize a `distance` array to infinity, with `distance[source] = 0`.
3.  Process the vertices in their topological order. For each vertex `u`:
    - For each neighbor `v` of `u`, **relax the edge**: `distance[v] = min(distance[v], distance[u] + weight(u, v))`.
Because we process in topological order, we ensure that `distance[u]` is finalized before we use it to update its neighbors.

---

### 3. Dijkstra's Algorithm
`[HARD]` `#dijkstra` `#shortest-path` `#priority-queue`

#### Problem Statement
Given a weighted graph with **non-negative edge weights** and a source vertex, find the shortest paths from the source to all other vertices.

#### Implementation Overview
Dijkstra's is a greedy algorithm.
1.  Initialize a `distance` array `dist` to infinity, with `dist[source] = 0`.
2.  Use a **priority queue** to store pairs of `(distance, vertex)`, prioritized by the smallest distance. Initially, it contains `(0, source)`.
3.  While the priority queue is not empty:
    - Extract the vertex `u` with the minimum distance.
    - For each neighbor `v` of `u`:
        - If `dist[u] + weight(u, v) < dist[v]`, we found a shorter path. Update `dist[v]` and push `(dist[v], v)` to the priority queue.

#### Why is a Priority Queue used?
A naive implementation would repeatedly scan all vertices to find the unvisited one with the minimum distance (O(V^2)). A priority queue optimizes this "find minimum" step to O(log V), making the overall complexity O(E log V), which is much faster for sparse graphs.

---

### 4. Variations and Applications of Dijkstra's

- **Shortest Path in a Binary Maze**: The grid is the graph, cells are nodes. Movement represents edges. The "weight" of an edge is the value in the target cell. Use Dijkstra to find the path with the minimum total weight.
- **Path with Minimum Effort**: The "effort" is the maximum absolute difference in height between any two consecutive cells on a path. This is a Dijkstra variation where we minimize the *maximum edge weight* on the path, not the sum. The priority queue stores `(max_effort_so_far, row, col)`.
- **Network Delay Time**: Direct application of Dijkstra. Find the time for a signal from a source `k` to reach all nodes. This is the maximum shortest path distance from `k`.
- **Number of Ways to Arrive at Destination**: Modified Dijkstra. Maintain a `ways` array. When you find a shorter path to `v`, update `ways[v] = ways[u]`. If you find another path of the *same* shortest length, `ways[v] += ways[u]`.
- **Minimum Steps... (Multiplication/Mod)**: Shortest path on an implicit graph. Nodes are numbers `(0 to mod-1)`, edges are the transformations. Use Dijkstra to find the minimum steps.

---

### 5. Bellman-Ford Algorithm
`[HARD]` `#bellman-ford` `#shortest-path` `#negative-weights`

#### Problem Statement
Find the shortest paths from a source to all other vertices in a weighted graph that may contain **negative edge weights**.

#### Implementation Overview
Bellman-Ford relaxes all edges repeatedly.
1.  Initialize `dist` array to infinity, `dist[source] = 0`.
2.  **Repeat V-1 times**: For every edge `(u, v)` with weight `w`, relax it: `dist[v] = min(dist[v], dist[u] + w)`.
3.  **Negative Cycle Detection**: Repeat the relaxation one more time (the V-th time). If any `dist` value is updated, a negative-weight cycle exists.
- **Cheapest Flights Within K Stops**: This is a Bellman-Ford style problem. We need the shortest path with at most `K+1` edges. We run the relaxation loop exactly `K+1` times.

---

### 6. Floyd-Warshall Algorithm
`[HARD]` `#floyd-warshall` `#all-pairs-shortest-path`

#### Problem Statement
Find the shortest distances between **every pair** of vertices in a given weighted directed graph.

#### Implementation Overview
A dynamic programming algorithm.
1.  Initialize a 2D `dist` matrix. `dist[i][j]` is the direct edge weight, `dist[i][i] = 0`.
2.  Use a triply nested loop with an intermediate vertex `k`:
    `for k in 0..V-1`, `for i in 0..V-1`, `for j in 0..V-1`:
        `dist[i][j] = min(dist[i][j], dist[i][k] + dist[k][j])`
3.  This checks if the path from `i` to `j` via `k` is shorter. Complexity is O(V^3).
- **Find the City...**: A direct application. Run Floyd-Warshall to get all-pairs shortest paths. Then, for each city, count neighbors within the `distanceThreshold`. Find the city with the minimum count.
