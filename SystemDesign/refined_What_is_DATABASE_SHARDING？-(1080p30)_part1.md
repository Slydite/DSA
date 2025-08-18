# What Is Database Sharding？ (1080P30) - Part 1

### Querying and Scaling Databases

![Screenshot at 00:00:02](notes_screenshots/refined_What_is_DATABASE_SHARDING？-(1080p30)_screenshots/frame_00-00-02.jpg)

When dealing with large volumes of data in a database, traditional query optimization techniques like using an **SQL optimizer** or creating **indexes** on tables become less effective on their own. While essential, they are often insufficient for truly massive datasets. This leads to the need for more advanced scaling strategies.

#### The Need for Sharding

To handle immense data loads and high request volumes, a technique called **sharding** is employed. Sharding is a method of distributing a single dataset across multiple databases or servers, allowing them to operate as a single logical database.

Imagine you have an enormous pizza that's too big for one person to eat alone. What do you do? You cut it into slices and invite friends over. Each friend gets a slice and is responsible for eating only their portion.

![Screenshot at 00:01:48](notes_screenshots/refined_What_is_DATABASE_SHARDING？-(1080p30)_screenshots/frame_00-01-48.jpg)
![Screenshot at 00:01:59](notes_screenshots/refined_What_is_DATABASE_SHARDING？-(1080p30)_screenshots/frame_00-01-59.jpg)
![Screenshot at 00:02:20](notes_screenshots/refined_What_is_DATABASE_SHARDING？-(1080p30)_screenshots/frame_00-02-20.jpg)

Similarly, in a database system:
- The **entire pizza** represents your complete database or all incoming server requests.
- Each **slice of pizza** represents a **shard** or a partition of your data.
- Each **friend** represents a **database server** responsible for handling requests related to their assigned data slice.

For example, if you have user IDs ranging from 0 to 799, you might assign:
- User IDs 0-99 to Server 1 (Slice 0)
- User IDs 100-199 to Server 2 (Slice 1)
- ...and so on.

This effectively distributes the workload and storage requirements across multiple machines.

```mermaid
graph LR
    BigDatabase[Large Database / All Requests] --> Split[Split into Chunks]
    Split --> ShardA[Shard A (Data Range 0-99)]
    Split --> ShardB[Shard B (Data Range 100-199)]
    Split --> ShardC[Shard C (Data Range 200-299)]
    Split --> ...

    ShardA --> DBServA[Database Server A]
    ShardB --> DBServB[Database Server B]
    ShardC --> DBServC[Database Server C]

    DBServA -- "Handles requests for Data Range 0-99" --> ClientReqA[Client Requests]
    DBServB -- "Handles requests for Data Range 100-199" --> ClientReqB[Client Requests]
    DBServC -- "Handles requests for Data Range 200-299" --> ClientReqC[Client Requests]

    style BigDatabase fill:#f9f,stroke:#333,stroke-width:1px
    style Split fill:#bbf,stroke:#333,stroke-width:1px
    style ShardA fill:#efe,stroke:#333,stroke-width:1px
    style ShardB fill:#efe,stroke:#333,stroke-width:1px
    style ShardC fill:#efe,stroke:#333,stroke-width:1px
    style DBServA fill:#ccf,stroke:#333,stroke-width:1px
    style DBServB fill:#ccf,stroke:#333,stroke-width:1px
    style DBServC fill:#ccf,stroke:#333,stroke-width:1px
    style ClientReqA fill:#f9f,stroke:#333,stroke-width:1px
    style ClientReqB fill:#f9f,stroke:#333,stroke-width:1px
    style ClientReqC fill:#f9f,stroke:#333,stroke-width:1px
```

#### Types of Database Partitioning

Sharding is a specific implementation of **horizontal partitioning**.

1.  **Horizontal Partitioning (Sharding):**
    *   **Concept:** Divides a table's rows (records) into multiple, smaller tables, each stored on a separate server.
    *   **Key:** This partitioning is based on a specific **partitioning key** (also known as a shard key or distribution key), which is an attribute within the data itself (e.g., `UserID`, `ProductID`, `Timestamp`).
    *   **Analogy:** Slicing a pizza into individual pieces, where each piece is a complete unit (a row of data).
    *   **Benefit:** Improves scalability, performance, and fault tolerance by distributing the data and workload.

2.  **Vertical Partitioning:**
    *   **Concept:** Divides a table's columns (attributes) into multiple, smaller tables. For example, frequently accessed columns might be stored separately from rarely accessed ones, or sensitive data columns might be isolated.
    *   **Key:** Not based on a data attribute, but on the logical grouping or access patterns of columns.
    *   **Analogy:** Separating the pizza crust from the toppings, or the cheese from the sauce, and storing them separately. You still need to combine them to get a full "pizza" (record).
    *   **Benefit:** Can improve performance for certain queries by reducing disk I/O, and enhance security by isolating sensitive columns.

| Feature            | Horizontal Partitioning (Sharding)                               | Vertical Partitioning                                          |
| :----------------- | :--------------------------------------------------------------- | :------------------------------------------------------------- |
| **Split By**       | Rows (records)                                                   | Columns (attributes)                                           |
| **Primary Goal**   | Scalability (handling more data/requests), Load Distribution     | Performance (reducing I/O), Security, Manageability            |
| **Data Unit**      | Complete records (rows)                                          | Partial records (subsets of columns)                           |
| **Key Dependency** | Relies on a **partitioning key** (data attribute)                | Relies on logical grouping of columns, access patterns         |
| **Analogy**        | Slicing a pizza into individual portions                         | Separating different ingredients of a pizza (crust, cheese, etc.) |

#### Database Servers vs. Application Servers

It's crucial to distinguish between the types of "servers" discussed in the context of sharding:

| Feature           | Application Servers                                     | Database Servers                                         |
| :---------------- | :------------------------------------------------------ | :------------------------------------------------------- |
| **Role**          | Handle business logic, process requests, serve APIs     | Store, manage, and retrieve the actual data              |
| **Statefulness**  | Typically designed to be **stateless**                  | Inherently **stateful** (they hold the data's current state) |
| **Data Handling** | Deal with data through interactions with database servers | Deal with the "meat of the data" directly                |
| **Primary Goal**  | Decoupling components, scalability of application logic | Data persistence, integrity, and **consistency**          |
| **Risk**          | Less critical for data integrity if one fails           | Critical for data integrity; errors can lead to data loss |

For database servers, **consistency** is a paramount attribute. Any "goof-ups" (errors or inconsistencies) in data storage can lead to severe issues, making reliability and data integrity top priorities.

---

### Key Attributes of Database Systems

![Screenshot at 00:03:24](notes_screenshots/refined_What_is_DATABASE_SHARDING？-(1080p30)_screenshots/frame_00-03-24.jpg)

Database systems are designed with several critical attributes in mind, especially when dealing with distributed systems like sharded databases. Two fundamental attributes are **Consistency** and **Availability**.

1.  **Consistency:**
    *   **Definition:** Consistency ensures that any data written to the database will be seen by subsequent reads. If a change is made, all users accessing that data will immediately see the most updated version. It implies that the database state is always valid according to predefined rules.
    *   **Analogy:** If you update your profile picture on a social media site, consistency means that anyone viewing your profile right after your update will see the new picture, not the old one.
    *   **Importance:** Crucial for data integrity and reliability, especially in financial transactions or systems where data accuracy is paramount.

2.  **Availability:**
    *   **Definition:** Availability means that the database system remains operational and accessible to users even in the face of failures (e.g., server crashes, network issues). Users can always read from and write to the database.
    *   **Analogy:** A website is available if it's always up and reachable, even if there are occasional glitches or slow responses.
    *   **Importance:** Essential for user experience and continuous service delivery.

**Consistency vs. Availability (CAP Theorem Context):**
In distributed systems, it's often impossible to guarantee both strong consistency and high availability simultaneously along with partition tolerance (the ability to continue operating despite network partitions). This is known as the **CAP Theorem**. In most traditional database systems, **consistency often trumps availability** when data integrity is the highest priority. This means if there's a conflict or a partition, the system might prioritize ensuring all data is consistent, even if it means temporarily reducing availability for some operations.

### Choosing a Shard Key

The choice of the **partitioning key (shard key)** is crucial for effective sharding. This key determines how data is distributed across different shards.

*   **Example 1: User ID**
    *   As discussed, `UserID` is a common choice. Users 0-99 go to Server A, 100-199 to Server B, and so on. This works well for queries primarily involving a single user.
*   **Example 2: Location (e.g., City ID for Tinder)**
    *   For applications like Tinder, where users often search for others based on location, sharding by `Location` (e.g., `CityID`) makes sense.
    *   If a user queries "find all users in New York City," all relevant data for New York would ideally reside on a single shard. This allows the query to be fulfilled by one database server (e.g., "database server number seven"), leading to:
        *   **Smaller shard size:** Each shard holds only data for a specific location.
        *   **Easier maintenance:** Operations on a specific location affect only one shard.
        *   **Faster performance:** Queries are localized to a single server, avoiding expensive cross-shard operations.

### Challenges of Sharding

While sharding offers significant benefits for scalability, it introduces new complexities:

![Screenshot at 00:04:35](notes_screenshots/refined_What_is_DATABASE_SHARDING？-(1080p30)_screenshots/frame_00-04-35.jpg)
![Screenshot at 00:04:58](notes_screenshots/refined_What_is_DATABASE_SHARDING？-(1080p30)_screenshots/frame_00-04-58.jpg)

1.  **Joins Across Shards:**
    *   **Problem:** If a query requires joining data that resides on two different shards (e.g., joining user data from Shard A with order data from Shard B), the query becomes extremely expensive.
    *   **Process:** The query engine must:
        1.  Send requests to multiple shards.
        2.  Pull data from each shard.
        3.  Transfer this data across the network.
        4.  Perform the join operation on the combined data.
    *   **Impact:** This dramatically increases latency and resource consumption, negating some of the performance benefits of sharding.
    *   **Mitigation:** Design your data model and shard key carefully to minimize cross-shard joins, or consider denormalization for frequently joined data.

2.  **Inflexibility of Fixed Shards:**
    *   **Problem:** With a static sharding scheme (like our 8-slice pizza), the number of shards is fixed. If your data grows unevenly, or if you need to add/remove servers, redistributing data among fixed shards is complex and often requires downtime.
    *   **Analogy:** Once the pizza is cut into 8 slices, you can't easily add a 9th slice or change the size of existing slices without re-cutting the entire pizza.
    *   **Need for Dynamic Scalability:** Modern applications require the ability to dynamically add or remove database servers and automatically rebalance data without interrupting service.

#### Solutions to Sharding Challenges

1.  **Consistent Hashing (Addressing Inflexibility):**
    *   **Concept:** Consistent hashing is an algorithm that minimizes data movement when nodes (servers) are added or removed from a distributed system. Instead of directly mapping data to a fixed number of servers, it maps both data and servers to a circular hash space.
    *   **Benefit:** When a server is added or removed, only a small portion of the data needs to be remapped and moved, rather than a complete re-shuffling.
    *   **Example Application:** While not a database itself, **Memcached** (a distributed caching system) uses principles similar to consistent hashing in its client-side libraries to distribute keys across cache servers. This allows adding/removing cache nodes with minimal disruption.
    *   **Note:** The speaker mentions Memcached doesn't *implement* consistent hashing internally for its storage, but rather client libraries use it to interact with Memcached instances.

2.  **Hierarchical Sharding (Addressing Inflexibility and Dynamic Growth):**
    *   **Concept:** This technique addresses the inflexibility of fixed shards by allowing individual shards to be further subdivided (sub-sharded) dynamically.
    *   **Analogy:** If one pizza slice becomes too large, you can cut *that specific slice* into smaller "mini-slices" without affecting the other main slices.
    *   **Process:**
        1.  An initial sharding distributes data into primary shards (e.g., by `UserID` range).
        2.  If a primary shard (a "pizza slice") becomes too large or receives too much load, it can be dynamically split into smaller, secondary shards (the "mini-slices").
        3.  A **shard manager** (or routing layer) is responsible for knowing which primary shard and then which secondary shard a particular request should go to.
    *   **Benefit:** Provides greater flexibility and allows for dynamic scaling, as individual hot shards can be split without re-sharding the entire database.

3.  **Indexing within Shards (Optimizing Complex Queries):**
    *   **Concept:** Even with sharding, you can create secondary indexes *within each shard* on attributes different from the shard key.
    *   **Example:** If data is sharded by `CityID`, you can still create an index on `Age` within each city's shard.
    *   **Query Example:** "Find all people in New York City who are older than 50."
        1.  The request goes to the shard responsible for "New York City" (determined by the `CityID` shard key).
        2.  Within that specific shard, the query uses the `Age` index to quickly find all users matching the age criteria.
    *   **Benefit:** Allows for efficient queries on non-shard key attributes, as long as the query can first be routed to a single shard. This ensures that queries remain fast even with complex criteria.

---

### Benefits of Sharding

The primary advantage of sharding is a significant improvement in both **read performance** and **write performance**. This is because:
*   **Localized Queries:** Queries are directed to a specific shard based on the partitioning key, meaning the entire query can often be handled by a single database server.
*   **Reduced Load:** Each server handles a smaller, more manageable subset of the total data and requests, reducing contention and processing time per query.

### Ensuring High Availability: Master-Slave Architecture

While sharding distributes data for performance, it introduces a new vulnerability: what happens if a single shard (i.e., a database server hosting a shard) fails due to, for example, a power outage? To address this **single point of failure** and ensure continuous operation, a common solution is to implement a **Master-Slave architecture** for each shard.

![Screenshot at 00:07:09](notes_screenshots/refined_What_is_DATABASE_SHARDING？-(1080p30)_screenshots/frame_00-07-09.jpg)
![Screenshot at 00:08:21](notes_screenshots/refined_What_is_DATABASE_SHARDING？-(1080p30)_screenshots/frame_00-08-21.jpg)

**Master-Slave Replication Explained:**

1.  **Master Database Server:**
    *   This is the **primary** server for a given shard.
    *   All **write requests** (inserts, updates, deletes) are exclusively directed to the Master.
    *   The Master maintains the most up-to-date and authoritative copy of the data.

2.  **Slave Database Servers:**
    *   These are **replica** servers that continuously copy data from the Master.
    *   They typically **poll** the Master (regularly check for updates) and apply any changes to their own copies.
    *   **Read requests** can be distributed across multiple Slave servers, offloading the read burden from the Master and improving read scalability.

**How it handles failure (Failover):**
*   If the **Master server fails**, the Slave servers detect this.
*   Through an election process (often managed by a coordination service like ZooKeeper or Consul), one of the surviving Slaves is promoted to become the new Master.
*   The other Slaves then begin replicating from this new Master.
*   This mechanism ensures **high availability** by providing redundancy and allowing the system to recover automatically from a Master failure with minimal downtime.

```mermaid
graph LR
    subgraph Client Interaction
        ClientApp[Client Application]
    end

    subgraph Shard 1 (Data Range X-Y)
        MasterDB[Master Database Server]
        SlaveDB1[Slave Database Server 1]
        SlaveDB2[Slave Database Server 2]
    end

    ClientApp -- "Write Request" --> MasterDB
    MasterDB -- "Replicates Data" --> SlaveDB1
    MasterDB -- "Replicates Data" --> SlaveDB2
    ClientApp -- "Read Request (Distributed)" --> SlaveDB1
    ClientApp -- "Read Request (Distributed)" --> SlaveDB2

    subgraph Failover Process
        MasterDB -- "Master Fails" --x MasterDB
        SlaveDB1 -- "Elects New Master" --> SlaveDB3[SlaveDB2 (New Master)]
        SlaveDB2 -- "Becomes New Slave" --> SlaveDB4[SlaveDB1 (New Slave)]
        SlaveDB3 -- "Continues Replication" --> SlaveDB4
    end

    style MasterDB fill:#f9f,stroke:#333,stroke-width:2px
    style SlaveDB1 fill:#ccf,stroke:#333,stroke-width:1px
    style SlaveDB2 fill:#ccf,stroke:#333,stroke-width:1px
    style ClientApp fill:#afa,stroke:#333,stroke-width:1px
    style SlaveDB3 fill:#f9f,stroke:#333,stroke-width:2px
    style SlaveDB4 fill:#ccf,stroke:#333,stroke-width:1px
```

| Role   | Key Functionality                               | Writes Handled | Reads Handled (Typical) | Data State               |
| :----- | :---------------------------------------------- | :------------- | :---------------------- | :----------------------- |
| **Master** | Processes all write operations; replicates data | Yes (Primary)  | Yes (Can, but often avoided for load) | Most up-to-date, authoritative |
| **Slave**  | Receives replicated data; serves read requests  | No (Directly)  | Yes (Load-balanced)     | Eventually consistent with Master |

### The Complexity of Sharding

While sharding is powerful for scaling, it's a complex undertaking, especially when trying to maintain strict **consistency** across distributed data.

*   **Maintaining Consistency:** Ensuring that all copies of data across shards and replicas are always consistent, especially during writes and failures, is notoriously difficult. This is a core challenge in distributed database design.
*   **Operational Overhead:** Implementing and managing a sharded database, along with master-slave replication, adds significant operational complexity in terms of deployment, monitoring, backup, and recovery.

**Recommendation for New Systems:**

For systems that are just starting out or do not yet face massive scaling challenges, it's often more practical to explore simpler scaling mechanisms before diving into custom sharding implementations:

1.  **Indexing:** Optimize database queries with appropriate indexes.
2.  **NoSQL Databases:** Many NoSQL databases (e.g., MongoDB, Cassandra) are designed from the ground up to handle distributed data and often incorporate sharding-like concepts (like partitioning or distribution keys) internally, abstracting much of the complexity from the developer.
3.  **Well-Known Solutions:** Leverage existing, mature solutions and database features (like built-in replication or partitioning features in relational databases) before attempting to build a custom sharding layer.

Sharding is a powerful tool for extreme scale, but it introduces substantial architectural and operational challenges. It should be considered when other, simpler scaling methods are no longer sufficient.

---

