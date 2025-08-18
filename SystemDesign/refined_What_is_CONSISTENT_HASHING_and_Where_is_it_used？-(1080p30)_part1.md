# What Is Consistent Hashing And Where Is It Used？ (1080P30) - Part 1

### The Challenge of Dynamic Server Environments

The primary challenge in distributed systems is not merely **load balancing** requests across servers. A more significant issue arises when servers are **added or removed** from the system. In traditional hashing schemes (like `hash(request_ID) % N`, where `N` is the number of servers), changing `N` (adding or removing a server) necessitates re-mapping almost all requests, leading to:
*   **Data redistribution:** Local data cached or stored on specific servers becomes invalid or misaligned.
*   **High overhead:** Significant re-calculation and data movement.
*   **Service disruption:** Potential performance degradation or temporary unavailability.

To mitigate this, a more robust approach called **Consistent Hashing** is introduced.

### Introducing Consistent Hashing: The Hash Ring Concept

![Screenshot at 00:02:42](notes_screenshots/refined_What_is_CONSISTENT_HASHING_and_Where_is_it_used？-(1080p30)_screenshots/frame_00-02-42.jpg)

Consistent Hashing solves the re-mapping problem by introducing a **"Hash Ring"** (or **Consistent Hash Ring**). Imagine this as a circular number line representing the entire range of possible hash values, typically from `0` up to `M-1` (where `M` is a very large number, representing the maximum output of the hash function).

1.  **Hashing Requests onto the Ring:**
    *   Every incoming **request** is assigned a unique `request ID`.
    *   This `request ID` is hashed using a standard hash function `h()`, and the result is mapped onto a specific point on the hash ring.
    *   Example: `h(request_ID) % M` places the request at a particular position on the ring.
    *   Visually, requests appear as distinct points on the circle.

2.  **Hashing Servers onto the Ring:**
    *   Crucially, **servers** themselves are also assigned unique `server IDs`.
    *   These `server IDs` are then hashed using the *same* (or a compatible) hash function `h()`, and their results are also mapped onto points on the *same* hash ring.
    *   Example: `h(server_ID) % M` places each server at a specific position.
    *   If we have servers S1, S2, S3, S4, they will each occupy a unique spot on the ring.
    *   For instance, if `h(0)` (for server 0) results in 49, and `M` is 30, then `49 % 30 = 19`. So, server 0 (S0) is placed at position 19 on the ring.

    ![Screenshot at 00:02:29](notes_screenshots/refined_What_is_CONSISTENT_HASHING_and_Where_is_it_used？-(1080p30)_screenshots/frame_00-02-29.jpg)

### Request-to-Server Mapping Algorithm

Once both requests and servers are mapped to points on the hash ring, the assignment process is simple:

1.  For any given request on the ring, traverse the ring **clockwise**.
2.  The **first server** encountered in the clockwise direction is the server responsible for handling that request.

**Example Scenario:**

Consider servers S1, S2, S3, S4 placed on the ring (after hashing their IDs).
Let's say requests R1, R2, R3, R4, R5 are also mapped to points on the ring.

```mermaid
graph LR
    subgraph Hash Ring
        direction LR
        S1_pos[S1]
        S2_pos[S2]
        S3_pos[S3]
        S4_pos[S4]
        R1_pos[R1]
        R2_pos[R2]
        R3_pos[R3]
        R4_pos[R4]
        R5_pos[R5]

        % Connections to illustrate clockwise assignment
        R1_pos -- "Clockwise" --> S2_pos
        R2_pos -- "Clockwise" --> S3_pos
        R3_pos -- "Clockwise" --> S4_pos
        R4_pos -- "Clockwise" --> S1_pos
        R5_pos -- "Clockwise" --> S1_pos
    end

    S1_pos -- "Handles" --> R4_pos
    S1_pos -- "Handles" --> R5_pos
    S2_pos -- "Handles" --> R1_pos
    S3_pos -- "Handles" --> R2_pos
    S4_pos -- "Handles" --> R3_pos

    style S1_pos fill:#ccf,stroke:#333,stroke-width:1px
    style S2_pos fill:#ccf,stroke:#333,stroke-width:1px
    style S3_pos fill:#ccf,stroke:#333,stroke-width:1px
    style S4_pos fill:#ccf,stroke:#333,stroke-width:1px
    style R1_pos fill:#f9f,stroke:#333,stroke-width:1px
    style R2_pos fill:#f9f,stroke:#333,stroke-width:1px
    style R3_pos fill:#f9f,stroke:#333,stroke-width:1px
    style R4_pos fill:#f9f,stroke:#333,stroke-width:1px
    style R5_pos fill:#f9f,stroke:#333,stroke-width:1px
```

In this example:
*   R1 is served by S2.
*   R2 is served by S3.
*   R3 is served by S4.
*   R4 is served by S1.
*   R5 is served by S1.

Here, S1 handles two requests, while S2, S3, and S4 handle one each.

### Advantages of Consistent Hashing

This architecture is chosen because:
*   **Uniform Distribution:** If the hash function generates uniformly random outputs, both server positions and request positions will be evenly distributed around the ring.
*   **Expected Load Balance:** Due to uniform distribution, the "distance" between servers on the ring (and thus the segment of requests they cover) is expected to be roughly equal. This leads to an average expected load factor of **1/N** per server, where N is the total number of servers. This means each server handles approximately an equal share of requests.
*   **Minimal Disruption (Key Benefit for dynamic environments):** When a server is added or removed, only a small fraction of requests needs to be re-mapped. This significantly reduces the overhead compared to traditional modulo hashing.

---

### Dynamic Server Management with Consistent Hashing

![Screenshot at 00:04:18](notes_screenshots/refined_What_is_CONSISTENT_HASHING_and_Where_is_it_used？-(1080p30)_screenshots/frame_00-04-18.jpg)

One of the core strengths of Consistent Hashing lies in its graceful handling of dynamic server environments—specifically, adding or removing servers without drastic reconfigurations.

#### Adding a Server

When a new server (e.g., S5) is added to the system, it is also hashed and placed at a new point on the hash ring.

*   **Impact:** Only a small segment of the ring is affected. The requests that were previously handled by the next clockwise server (S4 in the example, if S5 is placed between S3 and S4) will now be handled by the newly added server S5.
*   **Benefit:** Only the requests falling into the segment *just before* the new server's position, which were previously assigned to the next server clockwise, need to be re-routed. The vast majority of requests and their server assignments remain unchanged. This minimizes data migration and service disruption.

Consider the example where S5 is added between S3 and S4. Requests `R_A` and `R_B` that were previously assigned to S3 (because S3 was the next clockwise server) might now be assigned to S5 if S5 is the next clockwise server after their hash points. S1, S2, and S4's assignments remain largely untouched.

#### Removing a Server

Similarly, if a server (e.g., S1) goes offline or is intentionally removed:

*   **Impact:** The requests that were previously assigned to the removed server (S1) will now be re-assigned to the *next available server clockwise* on the ring (e.g., S4).
*   **Benefit:** Again, only the requests handled by the removed server are affected. These requests simply "fall through" to the next server on the ring, requiring minimal re-mapping and data movement.

This localized impact is a significant improvement over traditional modulo hashing, where adding or removing a server could invalidate nearly all existing assignments.

### The Challenge of Skewed Load Distribution

While theoretically, consistent hashing provides an average load of `1/N` per server (where `N` is the number of servers), practical scenarios with a small number of servers can still lead to **skewed load distribution**.

*   **Problem:** With only a few servers, the segments of the ring assigned to each server might not be perfectly equal. Some servers might end up with larger segments, thus handling a disproportionately higher number of requests compared to others.
*   **Analogy:** Imagine a small pizza (the hash ring) divided among only 4 friends (servers). Even if you try to cut it evenly, one friend might accidentally get a much larger slice than others due to the small number of cuts. If you had 100 friends, the slices would naturally become much more uniform.
*   **Consequence:** An overloaded server can become a bottleneck, leading to slower response times or even crashes, while other servers remain underutilized.

### Solution: Virtual Servers (Replicas / Multiple Hash Points)

![Screenshot at 00:06:36](notes_screenshots/refined_What_is_CONSISTENT_HASHING_and_Where_is_it_used？-(1080p30)_screenshots/frame_00-06-36.jpg)
![Screenshot at 00:07:31](notes_screenshots/refined_What_is_CONSISTENT_HASHING_and_Where_is_it_used？-(1080p30)_screenshots/frame_00-07-31.jpg)

To combat skewed load distribution and ensure better load balancing, especially with a limited number of physical servers, the concept of **Virtual Servers** (also known as **Replicas** or **Multiple Hash Points**) is employed.

The term "virtual server" here does **not** mean purchasing more physical machines or setting up virtual machines (like VirtualBox). Instead, it refers to mapping each physical server to **multiple distinct points** on the hash ring.

1.  **How it Works:**
    *   Instead of hashing a server ID just once, each physical server `S_i` is hashed `k` times. This can be achieved by:
        *   Using `k` different hash functions (`h1(S_i)`, `h2(S_i)`, ..., `hk(S_i)`).
        *   Appending a unique identifier to the server ID before hashing (e.g., `h(S_i + "-1")`, `h(S_i + "-2")`, ..., `h(S_i + "-k")`).
    *   This results in each physical server having `k` "virtual" positions on the hash ring. For example, if `k=3` and we have server S3, it might appear at three different points: S3a, S3b, S3c.

2.  **Benefits:**
    *   **Improved Load Distribution:** By scattering multiple points for each server across the ring, the "gaps" between server points become smaller and more numerous. This makes it far more likely that requests will be evenly distributed, as each server effectively "claims" multiple smaller segments of the ring.
    *   **Reduced Skew:** With a larger number of virtual points (e.g., `N * k` total points instead of `N`), the probability of a single server accumulating a disproportionately large share of requests significantly decreases. The ring becomes more granularly divided.
    *   **Enhanced Resilience:** When a physical server fails, its `k` virtual points are removed. The load previously handled by these `k` points is then distributed among the *remaining* `N-1` servers' `(N-1)*k` virtual points, spreading the impact more broadly and minimizing the sudden load surge on any single remaining server.

3.  **Choosing `k` (Number of Virtual Points):**
    *   The optimal value for `k` depends on the total number of servers and the desired level of load balancing.
    *   A common heuristic is to choose `k` such that `N * k` is sufficiently large (e.g., in the hundreds or thousands).
    *   The lecturer suggests `log N` or `log M` (where `M` is the hash space size) as a potential value for `k` to almost entirely remove the chance of skewed load.

By leveraging virtual servers, system designers can achieve highly efficient and resilient load balancing, making consistent hashing a cornerstone of distributed system architectures.

---

### Graceful Handling of Dynamic Environments with Virtual Nodes

![Screenshot at 00:08:42](notes_screenshots/refined_What_is_CONSISTENT_HASHING_and_Where_is_it_used？-(1080p30)_screenshots/frame_00-08-42.jpg)

The power of **virtual servers** (or multiple hash points per physical server) becomes even more evident when servers are dynamically added or removed.

*   **Server Removal with K Virtual Nodes:**
    *   If a physical server `S_i` is removed (e.g., due to a crash or maintenance), all `k` of its virtual points are simultaneously removed from the hash ring.
    *   The requests previously mapped to these `k` points will now be re-assigned to the next clockwise active server's virtual point.
    *   **Benefit:** Instead of a single large segment of load shifting to one adjacent server (as in the simple consistent hashing case), the load is now distributed across multiple adjacent servers on the ring. This results in a more **uniform increase** in load across various remaining servers, preventing any single server from becoming a new bottleneck. The "pie slices" re-distribute more smoothly.

*   **Server Addition with K Virtual Nodes:**
    *   When a new physical server `S_new` is added, `k` new virtual points corresponding to `S_new` are added to the hash ring.
    *   These new points "claim" requests from the segments just before them (clockwise), effectively taking load from the servers previously responsible for those segments.
    *   **Benefit:** Similar to removal, the new server alleviates load from **multiple existing servers** across different parts of the ring, ensuring a more balanced and minimal change in load for each existing server. This leads to a smoother and more efficient scaling process.

This mechanism ensures that the expected minimum change in the number of requests served by any given server is maintained, even with dynamic scaling.

### Overall Benefits and Efficiency

Consistent Hashing, especially with the implementation of virtual nodes, offers significant advantages for distributed systems:

*   **Flexibility:** Easily accommodates changes in server topology (adding/removing servers).
*   **Efficient Load Balancing:** Distributes requests evenly across available servers, minimizing hot spots and maximizing resource utilization.
*   **Minimal Disruption:** Changes to the server pool result in localized re-assignments, preventing a system-wide data or request re-shuffle.
*   **Scalability:** Allows systems to scale horizontally by simply adding more servers, without complex reconfigurations.

### Real-World Applications of Consistent Hashing

Consistent Hashing is a fundamental concept widely used in various distributed systems for its efficiency and flexibility in managing dynamic resources and data:

*   **Web Caches (e.g., Akamai CDN, Squid):** Used to distribute cached content across multiple caching servers. When a new cache server is added, only a small portion of the cached data needs to be migrated, ensuring high cache hit rates and low latency.
*   **Distributed Databases (e.g., Apache Cassandra, DynamoDB, Riak):** Essential for sharding data across database nodes. It allows for horizontal scaling and fault tolerance, as data can be efficiently rebalanced when nodes are added or removed.
*   **Distributed Key-Value Stores:** Enables efficient mapping of keys to specific nodes in a cluster, allowing for fast lookups and resilient data storage.
*   **Service Discovery/Load Balancers:** Can be used to map client requests to specific service instances or to balance traffic across a pool of application servers.

### Why Consistent Hashing is Crucial: Avoiding Request Dependencies

![Screenshot at 00:10:44](notes_screenshots/refined_What_is_CONSISTENT_HASHING_and_Where_is_it_used？-(1080p30)_screenshots/frame_00-10-44.jpg)

The need for efficient load balancing, especially with minimal disruption during server changes, is paramount because of **request dependencies**.

*   **The Problem:** In many complex applications, a single user request might involve multiple interactions with different backend services or data servers. If the system experiences a significant re-mapping (as with traditional modulo hashing) when a server is added or removed, it can lead to:
    *   **Broken Dependencies:** A subsequent part of a multi-step request might suddenly be routed to a different server that doesn't have the necessary context or data from the previous step, leading to errors or incomplete operations.
    *   **Performance Degradation:** Excessive data migration or cache invalidation can temporarily cripple system performance.
    *   **User Impact:** Users might experience errors, timeouts, or inconsistent application behavior.

Consistent Hashing minimizes these issues by ensuring that the vast majority of requests continue to be served by the same server, even as the underlying server infrastructure changes. This stability is critical for maintaining data locality, session persistence, and overall system reliability in a dynamic distributed environment.

---

