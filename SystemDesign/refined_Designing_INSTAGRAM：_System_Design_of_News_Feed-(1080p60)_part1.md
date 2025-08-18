# Designing Instagram： System Design Of News Feed (1080P60) - Part 1

# Designing Instagram: Core Features and Considerations

![Screenshot at 00:00:00](notes_screenshots/refined_Designing_INSTAGRAM：_System_Design_of_News_Feed-(1080p60)_screenshots/frame_00-00-00.jpg)

When approaching a system design interview for a platform like Instagram, it's crucial to first clarify the scope with the interviewer. While you might be familiar with all of Instagram's features, time constraints typically limit the discussion to a few core functionalities. Always ask what specific features the interviewer expects you to design.

Based on common interview scenarios, the following four fundamental features are often expected:

![Screenshot at 00:00:45](notes_screenshots/refined_Designing_INSTAGRAM：_System_Design_of_News_Feed-(1080p60)_screenshots/frame_00-00-45.jpg)
[SCREENSHOT-02-16]
[SCREENSHOT-02-27]

1.  **Storing and Retrieving Images:** This is the most obvious and foundational requirement for any photo-sharing application.
2.  **Liking and Commenting:** Providing interaction capabilities for posts (images).
3.  **Following Users:** Enabling users to subscribe to content from other users.
4.  **Publishing a News Feed:** Aggregating content from followed users for display.

Let's delve into the initial two features.

## 1. Storing and Retrieving Images

This feature is fundamental, and its design principles are broadly applicable to many media-heavy systems. The primary goals are:

*   **Cost-Effectiveness:** Images can consume significant storage space. Opting for a **file system** (like a distributed file system or object storage such as Amazon S3, Google Cloud Storage) is typically more cost-efficient than a traditional database for large binary data.
*   **Fast Retrieval:** Users expect images to load quickly. This is achieved through a **Content Delivery Network (CDN)**.

    *   **Analogy: CDN as a Global Warehouse Network**
        Imagine your images are products in a central warehouse (your main storage server). A CDN is like setting up smaller, local warehouses (CDN edge servers) closer to your customers around the world. When a user requests an image, it's delivered from the nearest local warehouse, significantly reducing delivery time. This caching mechanism ensures that frequently accessed images are served rapidly from locations geographically closer to the users.

*(For a deeper dive into image storage and CDN implementation, refer to resources on designing systems like Tinder, which share similar media handling challenges.)*

## 2. Liking and Commenting on Posts

The concept of "posts" is central here, with images being a type of post. Designing the liking and commenting functionality involves addressing specific interaction rules:

### Commenting Hierarchy and Complexity

A key question to clarify is the **depth of comments**:

*   **Can you comment on a comment (recursive commenting)?**
    *   **Instagram's Real-World Behavior:** Instagram allows a single layer of replies (you can reply *to* a comment, but not reply *to a reply*). This keeps conversations simpler and prevents excessively deep threads.
    *   **Interview Simplification:** For system design interviews, it's often best to simplify. Unless explicitly stated by the interviewer, assume a **flat commenting structure** where comments are direct responses to the original post, and there are no replies to comments. This reduces design complexity significantly.

### Liking Comments

*   **Can you like a comment?**
    *   **Yes**, Instagram allows users to 'like' individual comments. This adds another dimension to user interaction beyond just liking the main post.

### Data Model for Likes

To store information about likes, a dedicated `Likes` table (or collection in a NoSQL database) is typically used. This table captures who liked what and when.

| Column Name | Data Type | Description                                        |
| :---------- | :-------- | :------------------------------------------------- |
| `like_id`   | UUID/BigInt | Unique identifier for each like.                   |
| `post_id`   | UUID/BigInt | Foreign key referencing the `Post` that was liked. |
| `user_id`   | UUID/BigInt | Foreign key referencing the `User` who liked it.   |
| `timestamp` | Timestamp | The exact time the like was recorded.              |
| `is_active` | Boolean   | (Optional) Indicates if the like is still active.  |
| `comment_id`| UUID/BigInt | (Optional) Foreign key referencing the `Comment` if the like is on a comment. (Only if comments can be liked) |

*   **Note on `is_active`:** Instead of an `is_active` flag, it's often simpler and more efficient to just **delete the row** from the `Likes` table when a user "unlikes" a post or comment. This keeps the table cleaner and avoids unnecessary complexity.
*   **Note on `comment_id`:** If comments can be liked, the `Likes` table might need a `comment_id` column, which would be `NULL` if the like is on a post, and populated if it's on a comment. Alternatively, separate `PostLikes` and `CommentLikes` tables could be used for clarity. For this interview, we'll assume the simpler case where a `comment_id` may be present.

---

### Refining the `Likes` Data Model

![Screenshot at 00:03:36](notes_screenshots/refined_Designing_INSTAGRAM：_System_Design_of_News_Feed-(1080p60)_screenshots/frame_00-03-36.jpg)

Previously, we discussed a basic `Likes` table. A critical consideration for Instagram-like systems is that likes can apply not just to **posts** but also to **comments**. To accommodate this flexibility, we need to design our `Likes` table to be able to reference different types of "parent" entities.

![Screenshot at 00:05:00](notes_screenshots/refined_Designing_INSTAGRAM：_System_Design_of_News_Feed-(1080p60)_screenshots/frame_00-05-00.jpg)

Instead of having separate `post_id` and `comment_id` columns, a more robust and flexible design uses a **polymorphic association**. This involves:

1.  **`parent_id`**: A generic ID column that can hold the ID of either a `Post` or a `Comment`.
2.  **`parent_type`**: A column that specifies *what kind* of entity the `parent_id` refers to (e.g., 'POST' or 'COMMENT').

This allows a single `Likes` table to efficiently track likes across different content types. Each entry in the `Likes` table also needs its own unique `like_id`.

Here's the refined `Likes` table schema:

| Column Name   | Data Type   | Description                                                               |
| :------------ | :---------- | :------------------------------------------------------------------------ |
| `like_id`     | UUID/BigInt | **Primary Key:** Unique identifier for each specific 'like' action.       |
| `parent_id`   | UUID/BigInt | **Foreign Key:** The ID of the item being liked (e.g., a Post ID or a Comment ID). |
| `parent_type` | VARCHAR(10) | Defines what `parent_id` refers to: 'POST' or 'COMMENT'.                  |
| `user_id`     | UUID/BigInt | **Foreign Key:** The ID of the user who performed the like.               |
| `timestamp`   | Timestamp   | The exact time the like was recorded.                                     |

*   **Note on `is_active`:** The `is_active` boolean column (mentioned previously) is generally unnecessary. If a user "unlikes" something, the corresponding row in the `Likes` table can simply be **deleted**. This simplifies queries and keeps the table cleaner.

### Efficiently Counting Likes

![Screenshot at 00:05:57](notes_screenshots/refined_Designing_INSTAGRAM：_System_Design_of_News_Feed-(1080p60)_screenshots/frame_00-05-57.jpg)

A common requirement is to display the total number of likes for a post or comment. Let's analyze different approaches:

1.  **Direct `SELECT COUNT(*)` Query (Inefficient for Scale)**
    *   **Method:** To get the number of likes for a specific post (e.g., `post_id = 123`), you could run a query like:
        ```sql
        SELECT COUNT(*)
        FROM Likes
        WHERE parent_id = 123 AND parent_type = 'POST';
        ```
    *   **Problem:** While correct, this approach is **highly inefficient** for high-traffic applications like Instagram. Imagine a user's news feed displaying 50 posts. Each post would require a separate `COUNT(*)` query, leading to significant database load and slow response times for the user. This is akin to asking a librarian to count every book in a specific section each time someone asks how many books are there, rather than having a pre-counted tally.

2.  **Denormalization: Storing `likes_count` in `Post`/`Comment` Tables (Generally Discouraged)**
    *   **Method:** Add a `likes_count` column directly to the `Post` table and `Comment` table. Whenever a like is added or removed, update this count.
    *   **Pros:** Extremely fast reads, as the count is readily available with the post/comment data.
    *   **Cons:**
        *   **Data Redundancy:** The `likes_count` is derived information, duplicating data that logically belongs in the `Likes` table.
        *   **Consistency Challenges:** Ensuring this count remains accurate (incrementing on like, decrementing on unlike) can be complex, especially with concurrent operations. Race conditions can lead to incorrect counts if not handled carefully with atomic operations or strong transaction isolation.
        *   **Violation of Normalization:** It mixes aggregated data with core entity data, which is generally poor relational database design.

3.  **Dedicated Aggregation Table (`Activity` / `Counters` Table) (Recommended)**

![Screenshot at 00:06:53](notes_screenshots/refined_Designing_INSTAGRAM：_System_Design_of_News_Feed-(1080p60)_screenshots/frame_00-06-53.jpg)

The most robust and scalable solution is to introduce a separate table specifically for storing aggregated counts. This table acts as a cache for frequently requested metrics.

*   **Concept:** Create an `Activity` (or `Counters`) table that stores the `parent_id`, `parent_type`, and the pre-calculated `likes_count`.

    *   **`Activity` Table Schema:**
        | Column Name    | Data Type   | Description                                                     |
        | :------------- | :---------- | :-------------------------------------------------------------- |
        | `activity_id`  | UUID/BigInt | **Primary Key:** Unique identifier for this aggregation record. |
        | `parent_id`    | UUID/BigInt | The ID of the entity (Post or Comment) whose likes are counted. |
        | `parent_type`  | VARCHAR(10) | Type of entity: 'POST' or 'COMMENT'.                            |
        | `likes_count`  | INT         | The current total number of likes for this `parent_id`.         |
        | `last_updated` | Timestamp   | Timestamp of the last time this count was updated.              |

*   **How it Works:**
    *   When a user likes a post/comment:
        1.  A new entry is added to the `Likes` table.
        2.  Concurrently, an update operation increments the `likes_count` for the corresponding `parent_id` in the `Activity` table. This update can be handled by a database trigger, an application-level event, or an asynchronous worker.
    *   When a user unlikes:
        1.  The entry is deleted from the `Likes` table.
        2.  The `likes_count` in the `Activity` table is decremented.

*   **Advantages:**
    *   **Fast Reads:** Retrieving the `likes_count` is a simple lookup in the `Activity` table, which can be highly optimized (e.g., indexed, cached in memory).
    *   **Separation of Concerns:** Keeps the `Likes` table purely transactional and the `Activity` table purely for aggregated metrics.
    *   **Scalability:** The `Activity` table can be heavily cached (e.g., in Redis or Memcached) or even stored in a high-performance key-value store, enabling extremely fast retrieval of counts without hitting the main transactional database.

### Designing the `Comment` Data Model

![Screenshot at 00:08:04](notes_screenshots/refined_Designing_INSTAGRAM：_System_Design_of_News_Feed-(1080p60)_screenshots/frame_00-08-04.jpg)

The `Comment` table stores the actual comments made by users. Given our decision to keep commenting simple (no replies to replies), the schema is straightforward:

| Column Name  | Data Type   | Description                                       |
| :----------- | :---------- | :------------------------------------------------ |
| `comment_id` | UUID/BigInt | **Primary Key:** Unique identifier for each comment. |
| `post_id`    | UUID/BigInt | **Foreign Key:** The ID of the Post this comment belongs to. |
| `user_id`    | UUID/BigInt | **Foreign Key:** The ID of the User who made the comment. |
| `text_content` | TEXT        | The actual text content of the comment.          |
| `timestamp`  | Timestamp   | The exact time the comment was posted.           |
| `image_url`  | VARCHAR(255)| (Optional) URL to an image if comments could include media. For this design, we assume comments are text-only. |

*   **No Recursive Comments:** As discussed, for simplicity in this system design, we are assuming comments are directly linked to a `post_id` and do not form nested reply chains.
*   **Text-Only Comments:** For this design, comments are assumed to be purely textual. Adding images or other media to comments would require an `image_url` or similar field.

---

### The `Post` Data Model

To complete the picture for likes and comments, we also need a `Post` table. This table stores the core information about each image post.

![Screenshot at 00:08:04](notes_screenshots/refined_Designing_INSTAGRAM：_System_Design_of_News_Feed-(1080p60)_screenshots/frame_00-08-04.jpg)

| Column Name | Data Type   | Description                                           |
| :---------- | :---------- | :---------------------------------------------------- |
| `post_id`   | UUID/BigInt | **Primary Key:** Unique identifier for each post.     |
| `user_id`   | UUID/BigInt | **Foreign Key:** The ID of the user who created the post. |
| `image_url` | VARCHAR(255)| URL where the image is stored (e.g., in a CDN).       |
| `caption`   | TEXT        | The textual caption accompanying the image.           |
| `timestamp` | Timestamp   | The exact time the post was created.                  |

*   **Flexibility in ER Diagrams:** Designing an Entity-Relationship (ER) diagram is an iterative process. It often involves refining schemas as you consider different query patterns and future requirements. The goal is to create a flexible, efficient, and well-structured database that can handle current needs and adapt to future changes. It's important to balance simplicity with foresight, avoiding over-engineering for unknown future requirements while ensuring the current design is robust.

## 3. Following Users

The "follow" feature is fundamental to social media platforms, enabling users to curate their content feed by subscribing to updates from others. This relationship is typically many-to-many (one user can follow many, and be followed by many).

![Screenshot at 00:10:03](notes_screenshots/refined_Designing_INSTAGRAM：_System_Design_of_News_Feed-(1080p60)_screenshots/frame_00-10-03.jpg)

To model this, a single `Follows` (or `UserFollows`) table can efficiently answer both key questions:

1.  **"Who follows user X?"** (i.e., finding user X's followers)
2.  **"Which users does user X follow?"** (i.e., finding user X's followings)

### The `Follows` Data Model

| Column Name     | Data Type   | Description                                                               |
| :-------------- | :---------- | :------------------------------------------------------------------------ |
| `follow_id`     | UUID/BigInt | **Primary Key:** Unique identifier for each follow relationship.          |
| `follower_user_id` | UUID/BigInt | **Foreign Key:** The ID of the user who initiated the follow (the "follower"). |
| `followed_user_id` | UUID/BigInt | **Foreign Key:** The ID of the user who is being followed (the "followee"). |
| `timestamp`     | Timestamp   | The exact time the follow relationship was established.                   |

*   **Example Usage:**
    *   **To find who follows Stephen Hawking (e.g., `followed_user_id = 'Hawking_ID'`):**
        ```sql
        SELECT follower_user_id
        FROM Follows
        WHERE followed_user_id = 'Hawking_ID';
        ```
        This query efficiently retrieves all users who follow Stephen Hawking.
    *   **To find who Gaurav follows (e.g., `follower_user_id = 'Gaurav_ID'`):**
        ```sql
        SELECT followed_user_id
        FROM Follows
        WHERE follower_user_id = 'Gaurav_ID';
        ```
        This query efficiently retrieves all users that Gaurav is following.

*   **Indexing:** For optimal performance on these queries, it's crucial to add indexes on both `follower_user_id` and `followed_user_id` columns. This allows the database to quickly look up records based on either user ID.

This simple table design effectively captures the bidirectional "follow" relationships and allows for efficient querying of followers and followings.

### Interview Strategy: Speed vs. Detail

In a system design interview, if you know the answer to a question, it's often beneficial to provide a concise and direct answer rather than slowly building up to it.

*   **Efficiency:** This saves time for both you and the interviewer.
*   **Demonstrates Preparation:** A quick, accurate answer shows strong preparation and understanding.
*   **Pivots to Advanced Topics:** Interviewers often have more complex follow-up questions or want to delve into advanced topics. By quickly resolving simpler questions, you create an opportunity to discuss more challenging and interesting aspects of the design. This video series adopts a similar approach, moving quickly through basics to explore more advanced system design concepts.

## 4. Publishing a News Feed (Preview)

![Screenshot at 00:11:15](notes_screenshots/refined_Designing_INSTAGRAM：_System_Design_of_News_Feed-(1080p60)_screenshots/frame_00-11-15.jpg)
![Screenshot at 00:11:39](notes_screenshots/refined_Designing_INSTAGRAM：_System_Design_of_News_Feed-(1080p60)_screenshots/frame_00-11-39.jpg)

The news feed is arguably the most complex part of a social media system. It involves aggregating posts from all the users a person follows and presenting them in a chronological or personalized order.

A high-level overview of the news feed generation process often involves:

*   **User Request:** A user's device sends an HTTP request (e.g., `getUserFeed`) to a **Gateway**.
*   **Authentication/Authorization:** The Gateway typically routes the request to an **Auth Service** to verify the user's identity and permissions.
*   **Feed Service:** After authentication, the request is forwarded to a **User Feed Service**. This service is responsible for compiling the personalized feed.

The detailed design of the news feed generation, including fan-out strategies (push vs. pull), caching, and ranking algorithms, will be explored in subsequent sections using diagrams and animations for clarity.

---

### 4. Publishing a News Feed: System Architecture

![Screenshot at 00:11:51](notes_screenshots/refined_Designing_INSTAGRAM：_System_Design_of_News_Feed-(1080p60)_screenshots/frame_00-11-51.jpg)
![Screenshot at 00:12:12](notes_screenshots/refined_Designing_INSTAGRAM：_System_Design_of_News_Feed-(1080p60)_screenshots/frame_00-12-12.jpg)

Building a news feed for a large-scale application like Instagram requires a robust system architecture. Let's break down the key components involved when a user requests their feed.

#### The Gateway (Reverse Proxy)

The **Gateway** acts as the primary entry point for all client requests into our system. It's often implemented as a **reverse proxy**.

*   **Role:**
    *   **External to Internal Protocol Conversion:** Clients (like a mobile app) communicate using standard public protocols (e.g., **HTTP**, or **WebSockets** for real-time updates, potentially over XMPP). The Gateway translates these into an internal, proprietary protocol understood by our backend services. This adds a layer of security by obfuscating the internal communication mechanism.
    *   **Security Encapsulation:** Handles initial security checks, such as **authentication** (verifying user tokens) and authorization.
    *   **Request Routing:** Decides which internal service should handle an incoming request. This is crucial for microservices architectures where different functionalities are handled by separate services.

```mermaid
graph LR
    Client[Mobile App] -- HTTP/WebSocket --> Gateway[Gateway (Reverse Proxy)]
    Gateway -- Internal Protocol --> InternalService[Internal Service]
    style Client fill:#f9f,stroke:#333,stroke-width:1px
    style Gateway fill:#ccf,stroke:#333,stroke-width:1px
    style InternalService fill:#cfc,stroke:#333,stroke-width:1px
```

#### The User Feed Service

![Screenshot at 00:12:54](notes_screenshots/refined_Designing_INSTAGRAM：_System_Design_of_News_Feed-(1080p60)_screenshots/frame_00-12-54.jpg)

When a user requests their feed (e.g., `getUserFeed` with a `user_id`), the Gateway routes this request to the **User Feed Service**.

*   **Purpose:** This service is responsible for compiling the personalized news feed for a given user, typically fetching the top N (e.g., 20) most recent or relevant posts from the users they follow.
*   **Scalability and Resilience:** To handle a large number of users and ensure high availability, the `User Feed Service` is **replicated across multiple servers**. If one server fails, others can take over.

#### Load Balancing and Routing

With multiple instances of services (like `User Feed Service`), we need a mechanism to distribute incoming requests efficiently across them. This is where **Load Balancers** come in.

*   **Challenge:** Directly asking a central load balancer for every request would be a performance bottleneck.
*   **Solution: Snapshot-Based Routing:**
    1.  **Central Load Balancer:** Maintains a "snapshot" of the entire system's state. This snapshot includes:
        *   Which services are running.
        *   Which server boxes they are on.
        *   How to connect to them.
        *   Their current health and load.
    2.  **Snapshot Distribution:** This load balancer periodically pushes this system snapshot to all **Gateways** (e.g., every 10 seconds).
    3.  **Gateway-Level Routing:** When a Gateway receives a `getUserFeed` request:
        *   It consults its local, up-to-date snapshot to determine which specific `User Feed Service` instance (server box) should handle the request.
        *   **Consistent Hashing:** To ensure requests for the *same user* consistently go to the *same server* (which is beneficial for caching and state management), **Consistent Hashing** is often employed. The Gateway hashes the `user_id` to determine the target `User Feed Service` instance. This minimizes data movement and improves cache hit rates.

```mermaid
graph LR
    Client[Mobile App] -- HTTP: getUserFeed(userID) --> Gateway
    Gateway -- "Auth Token" --> AuthSvc[Authentication Service]
    AuthSvc -- "Valid User" --> Gateway
    subgraph Internal System
        Gateway -- "Internal Protocol + Hashed UserID" --> UserFeedSvc[User Feed Service (Multiple Instances)]
        LoadBalancer[Load Balancer] -- "Periodically pushes Snapshot" --> Gateway
    end
    style Client fill:#f9f,stroke:#333,stroke-width:1px
    style Gateway fill:#ccf,stroke:#333,stroke-width:1px
    style AuthSvc fill:#fcf,stroke:#333,stroke-width:1px
    style UserFeedSvc fill:#cfc,stroke:#333,stroke-width:1px
    style LoadBalancer fill:#f9f,stroke:#333,stroke-width:1px
```

#### Core Dependent Services for News Feed

The `User Feed Service` relies on other dedicated microservices to gather the necessary data to construct a feed.

![Screenshot at 00:15:11](notes_screenshots/refined_Designing_INSTAGRAM：_System_Design_of_News_Feed-(1080p60)_screenshots/frame_00-15-11.jpg)

1.  **Post Service:**
    *   **Role:** Manages and stores all post-related information.
    *   **APIs:** Exposes APIs to:
        *   Retrieve posts by `user_id` (e.g., "get all posts made by User X").
        *   Retrieve specific posts by `post_id`.
        *   Possibly filter posts by date range, etc.
    *   **Underlying Data:** Interacts with the `Post` table we defined earlier.

2.  **Follow Service:**
    *   **Role:** Manages and stores all user-following relationships.
    *   **APIs:** Exposes APIs to answer questions like:
        *   "Who does User X follow?" (Returns a list of `followed_user_id`s).
        *   "Who follows User X?" (Returns a list of `follower_user_id`s).
    *   **Underlying Data:** Interacts with the `Follows` table we defined earlier.

#### Other Essential Services (Briefly Mentioned)

While not detailed in this section, a complete Instagram system would also include:

*   **Image Service:** Handles image uploads, processing, and retrieval (often interacting with CDNs and object storage).
*   **Activity Service:** Manages aggregated data like like counts, comment counts, etc. (as discussed with the `Activity` table).
*   **Comment Service:** Manages all comment-related operations (creation, retrieval, deletion).
*   **User Service:** Manages user profiles, authentication, and general user data.

These services represent a typical microservices architecture, where each service is responsible for a specific domain, promoting modularity, scalability, and independent deployment.

---

### Other Services in a Complete Instagram System

![Screenshot at 00:15:24](notes_screenshots/refined_Designing_INSTAGRAM：_System_Design_of_News_Feed-(1080p60)_screenshots/frame_00-15-24.jpg)

Beyond the core services discussed, a full-fledged Instagram system would involve several other specialized services:

*   **Chat Module:** This is often an entire suite of services dedicated to real-time messaging, including message storage, delivery, presence, and notifications.
*   **Profile Service:** Manages user profile information (e.g., profile picture, bio, public/private status), session management, and potentially user authentication details.
*   **Notification Service:** Handles sending push notifications, in-app alerts, and other communications to users (e.g., new follower, comment on your post).
*   **Search Service:** Powers the ability to search for users, hashtags, and locations.
*   **Analytics Service:** Collects and processes user behavior data for insights and feature improvements.

For the scope of a system design interview, it's common to focus on a few core features and acknowledge the existence of other services without diving into their deep design.

### News Feed Generation: Initial Approach (Pull Model)

Let's revisit the `User Feed Service` and explore how it generates a user's feed.

![Screenshot at 00:16:35](notes_screenshots/refined_Designing_INSTAGRAM：_System_Design_of_News_Feed-(1080p60)_screenshots/frame_00-16-35.jpg)

A straightforward, but often inefficient, approach is the **Pull Model**:

1.  **Get Followed Users:** When a user (e.g., User A) requests their feed, the `User Feed Service` first queries the **Follow Service** to get a list of all users that User A follows.
    *   API call: `FollowService.getUsersFollowedBy(UserA_ID)`
    *   Response: `Set<User_IDs_UserA_Follows>`

2.  **Fetch Posts from Followed Users:** For each user in the returned set, the `User Feed Service` then queries the **Post Service** to get their recent posts.
    *   API call (initial, inefficient): `PostService.getPostsByUser(FollowedUser1_ID)`, `PostService.getPostsByUser(FollowedUser2_ID)`, etc.
    *   This means if User A follows 100 people, the `User Feed Service` makes 100 separate requests to the `Post Service`.

3.  **Consolidate and Return:** The `User Feed Service` collects all these individual sets of posts, merges them, sorts them (e.g., chronologically), and returns the top N posts to the client via the Gateway.

#### Optimizations for the Pull Model

While the basic pull model is inefficient, some immediate optimizations can be applied:

*   **Bulk Post Retrieval:** Instead of making individual requests, the `User Feed Service` can expose an API that accepts a *list* of user IDs and returns all their recent posts in a single call.
    *   Optimized API call: `PostService.getPostsByUsers(Set<User_IDs_UserA_Follows>)`
    *   This significantly reduces network overhead and database query load.
*   **Limit Post Fetching:** Limit the number of posts retrieved per followed user (e.g., only the latest 5 posts). This reduces the amount of data fetched and processed.
    *   Example: `PostService.getPostsByUsers(Set<User_IDs_UserA_Follows>, limit=5_per_user)`
    *   This lessens the load on the `Post Service` and its underlying database, as well as the network load when sending data back to the client.

#### Scalability Challenge of the Pull Model

Even with optimizations, the pull model faces a significant scalability issue:

*   **On-Demand Computation:** For every single feed request, the system has to perform a series of lookups and aggregations.
*   **High Load on Post Service:** The `Post Service` (and its database) would be constantly bombarded with complex queries from the `User Feed Service`, especially if users follow many people or frequently refresh their feed. This can lead to performance bottlenecks and slow user experiences.

**Analogy:** Imagine a restaurant where every time a customer orders, the chef has to go to *each* ingredient supplier, get the ingredients, then cook the meal. This is slow. A better approach is to have some pre-prepared meals or ingredients ready.

### News Feed Generation: Pre-computation (Push Model / Fan-out on Write)

![Screenshot at 00:17:58](notes_screenshots/refined_Designing_INSTAGRAM：_System_Design_of_News_Feed-(1080p60)_screenshots/frame_00-17-58.jpg)
![Screenshot at 00:18:45](notes_screenshots/refined_Designing_INSTAGRAM：_System_Design_of_News_Feed-(1080p60)_screenshots/frame_00-18-45.jpg)

The solution for scalable news feed generation in high-read systems like Instagram is **pre-computation**, also known as the **Push Model** or **Fan-out on Write**.

*   **Core Idea:** Instead of computing the feed when a user *requests* it (read-time), we compute and store the feed whenever a new post is *created* (write-time).

*   **How it Works (Fan-out on Write):**
    1.  **User Posts:** A user creates a new post, which is sent to the `Post Service`.
    2.  **Persist Post:** The `Post Service` saves the new post to its database.
    3.  **Notify (Fan-out):** Crucially, after persisting the post, the `Post Service` sends a **notification** (an event or message) to the `User Feed Service`. This notification contains details about the new post (e.g., `post_id`, `user_id` of the poster).
    4.  **Find Followers:** The `User Feed Service` receives this notification. It then queries the **Follow Service** to get a list of *all users who follow the person who just posted*.
        *   API call: `FollowService.getFollowersOf(Poster_User_ID)`
        *   Response: `Set<Follower_User_IDs>`
    5.  **Update Feeds:** For each `follower_user_id` in the returned set, the `User Feed Service` adds the newly created `post_id` to that follower's pre-computed news feed.

*   **Storage of Pre-computed Feeds:**
    *   Each user's feed can be stored as a sorted list (e.g., a Redis List or a dedicated feed table in a NoSQL database like Cassandra) containing `post_id`s.
    *   When a user requests their feed, the `User Feed Service` simply retrieves this pre-computed list (e.g., the top 20 `post_id`s) and then fetches the full post details from the `Post Service` (potentially in bulk).

*   **Advantages of Pre-computation:**
    *   **Extremely Fast Reads:** When a user requests their feed, it's a simple lookup and retrieval of an already assembled list. This makes reading feeds incredibly fast, which is critical for user experience in a read-heavy application.
    *   **Distributed Workload:** The heavy computation (finding followers, updating feeds) is distributed over time as posts are created, rather than concentrated at read-time.
    *   **Scalability:** The `Post Service` is not directly bombarded with feed-generation queries. The `User Feed Service` handles the fan-out, which can be scaled independently.

*   **Challenge:** The main challenge is managing updates for users with a very large number of followers (e.g., celebrities). If a celebrity with millions of followers posts, the `User Feed Service` needs to update millions of individual feeds. This is known as the **"hot follower" problem** or **"celebrity problem"** and often requires hybrid approaches (combining push for most users and pull for celebrities).

```mermaid
graph LR
    Client[Mobile App] -- HTTP: Post(UserID, Image) --> Gateway
    Gateway -- Internal Protocol --> PostSvc[Post Service]
    PostSvc -- "Persist Post" --> PostDB[(Post Database)]
    PostSvc -- "NOTIFY: New Post (PostID, UserID)" --> UserFeedSvc[User Feed Service]
    UserFeedSvc -- "Get Followers Of (PosterUserID)" --> FollowSvc[Follow Service]
    FollowSvc -- "Returns Set<FollowerIDs>" --> UserFeedSvc
    UserFeedSvc -- "Add PostID to each Follower's Feed" --> UserFeedsDB[User Feeds Database (Pre-computed)]

    Client_Req[Mobile App] -- HTTP: GetUserFeed(UserID) --> Gateway
    Gateway -- Internal Protocol --> UserFeedSvc
    UserFeedSvc -- "Get Pre-computed Feed (PostIDs)" --> UserFeedsDB
    UserFeedSvc -- "Bulk Get Posts (PostIDs)" --> PostSvc
    PostSvc -- "Return Post Details" --> UserFeedSvc
    UserFeedSvc -- "Return Full Feed" --> Gateway
    Gateway -- "Return Full Feed" --> Client_Req

    style Client fill:#f9f,stroke:#333,stroke-width:1px
    style Client_Req fill:#f9f,stroke:#333,stroke-width:1px
    style Gateway fill:#ccf,stroke:#333,stroke-width:1px
    style PostSvc fill:#cfc,stroke:#333,stroke-width:1px
    style PostDB fill:#eee,stroke:#333,stroke-width:1px
    style UserFeedSvc fill:#cfc,stroke:#333,stroke-width:1px
    style FollowSvc fill:#cfc,stroke:#333,stroke-width:1px
    style UserFeedsDB fill:#eee,stroke:#333,stroke-width:1px
```

---

### Storage of Pre-computed User Feeds

![Screenshot at 00:18:57](notes_screenshots/refined_Designing_INSTAGRAM：_System_Design_of_News_Feed-(1080p60)_screenshots/frame_00-18-57.jpg)

Now that we've decided to pre-compute user feeds using the **push model (fan-out on write)**, the next question is where to store these pre-computed feeds.

*   **Database vs. Cache:**
    *   **Database:** While possible, storing pre-computed feeds in a traditional database might be overkill for data that is primarily read-heavy and can be re-generated if lost.
    *   **Cache (e.g., Redis, Memcached):** This is the preferred approach.
        *   **Reasoning:** Caches are optimized for fast read operations and are designed for transient data.
        *   **Stateless Service:** The `User Feed Service` itself can remain stateless. If the cache data is lost or a service instance crashes, the feed can be **re-computed** using the "pull model" logic (fetch followed users, then their posts) as a fallback mechanism. This means the cache acts as a fast-read layer, not the single source of truth.
        *   **Memory Management (LRU):** Caches typically use algorithms like **Least Recently Used (LRU)**. This means feeds for frequently active users will reside in the cache for quick retrieval. For inactive users, their feeds might be evicted from the cache to free up memory. When an inactive user logs in, their feed will be re-computed on demand and then cached. This optimizes memory usage by only caching feeds for active users.

*   **Benefit:** Storing feeds in a cache ensures extremely fast retrieval for users, as the data is readily available in memory.

### Real-time Notifications for New Posts

![Screenshot at 00:19:21](notes_screenshots/refined_Designing_INSTAGRAM：_System_Design_of_News_Feed-(1080p60)_screenshots/frame_00-19-21.jpg)

Beyond just updating the pre-computed feed, the `User Feed Service` can also be responsible for sending **real-time notifications** to users when someone they follow posts.

*   **Mechanism:**
    *   When the `User Feed Service` adds a new post to a follower's pre-computed feed, it can simultaneously trigger a notification to that follower's device.
    *   This requires a mechanism for the server to push updates to clients.

*   **Push Notification Technologies:**
    *   **WebSockets:** A persistent, bidirectional communication channel between client and server. This is often preferred for real-time updates due to its efficiency and low latency.
    *   **Long Polling:** The client holds an HTTP request open until the server has new data, or a timeout occurs. Less efficient than WebSockets but simpler to implement for some scenarios.
    *   **Server-Sent Events (SSE):** A unidirectional channel from server to client over HTTP. Good for real-time updates where the client doesn't need to send data back often.

*   **Routing Notifications to Clients:**
    *   The challenge is how to efficiently route a single server-side notification to potentially many client devices (e.g., all 50-60 followers of a user).
    *   This often involves a dedicated **Notification Service** or a **Chat Service** (which handles real-time communication) that maintains connections to active user devices and can fan out messages efficiently. (This topic is often explored in detail when discussing chat system design).

### Handling the "Celebrity Problem" (Fan-out on Write Challenge)

![Screenshot at 00:22:10](notes_screenshots/refined_Designing_INSTAGRAM：_System_Design_of_News_Feed-(1080p60)_screenshots/frame_00-22-10.jpg)
![Screenshot at 00:22:34](notes_screenshots/refined_Designing_INSTAGRAM：_System_Design_of_News_Feed-(1080p60)_screenshots/frame_00-22-34.jpg)

The push model (fan-out on write) works well for most users. However, it faces a significant challenge with **celebrity accounts** (users with millions of followers). If a celebrity posts, the `User Feed Service` would attempt to update millions of individual feeds simultaneously, potentially leading to system crashes or severe performance degradation. This is known as the **"celebrity problem"** or **"hot follower problem."**

There are two primary approaches to mitigate this:

1.  **Batch Processing / Rate Limiting (Hybrid Push):**
    *   **Concept:** Instead of immediately pushing the post to all followers, the updates are processed in batches.
    *   **Mechanism:** When a celebrity posts, the `User Feed Service` identifies their followers but adds the new post to their feeds gradually, perhaps in batches of 1,000 users every few seconds.
    *   **Benefit:** Prevents system overload by rate-limiting the fan-out operations.
    *   **Drawback:** Introduces a slight delay for some followers in seeing the celebrity's posts.

2.  **Hybrid Model: Pull for Celebrities, Push for Regular Users:**
    *   **Concept:** This is the most common and robust solution.
    *   **Push Model (Fan-out on Write):** Used for **regular users** who have a manageable number of followers (e.g., up to tens of thousands). Their feeds are pre-computed and pushed.
    *   **Pull Model (Fan-out on Read):** Used for **celebrity accounts** (users with millions of followers).
        *   When a regular user requests their feed, they get the pre-computed feed.
        *   When a user who follows a celebrity requests their feed, the `User Feed Service` performs a *real-time query* to the `Post Service` to fetch the celebrity's latest posts, and then merges them with the user's pre-computed feed from other regular users.
        *   **Benefit:** Avoids the massive write amplification problem of pushing to millions of followers. The load is shifted to read-time, but it's distributed across all followers who choose to pull.
        *   **Drawback:** Celebrity posts might appear slightly less instantaneously for their followers compared to posts from regular users (unless heavy caching is used for celebrity posts). However, for many users, this slight delay is acceptable for celebrity content.

*   **Comparison of Push vs. Pull for "Hot Followers":**

    | Feature        | Push Model (Fan-out on Write)                                  | Pull Model (Fan-out on Read)                                   |
    | :------------- | :------------------------------------------------------------- | :------------------------------------------------------------- |
    | **When Computed** | At write time (when post is created)                           | At read time (when user requests feed)                         |
    | **Write Load** | High, especially for celebrities (many writes to user feeds)   | Low (only write to Post table)                                 |
    | **Read Load**  | Very Low (direct lookup of pre-computed feed)                  | High (querying multiple user posts on demand)                  |
    | **Celebrity Problem** | Major challenge (millions of updates per post)             | Solved (load distributed across many readers over time)        |
    | **Latency**    | Low read latency (feed is ready)                               | Higher read latency (feed computed on demand)                  |
    | **Data Staleness** | Potentially higher if update process is slow/batched         | Low (always fetches latest data)                               |
    | **Best For**   | Most users, lower number of followers, high read volume        | Celebrities, high number of followers, dynamic content         |

By combining these models, a hybrid approach provides the best of both worlds, ensuring fast feed retrieval for most users while gracefully handling the massive scale of celebrity accounts.

---

### Hybrid Model: The Best of Both Worlds for News Feed

![Screenshot at 00:23:00](notes_screenshots/refined_Designing_INSTAGRAM：_System_Design_of_News_Feed-(1080p60)_screenshots/frame_00-23-00.jpg)

The debate between the **Push Model (Fan-out on Write)** and the **Pull Model (Fan-out on Read)** for news feed generation is resolved by adopting a **hybrid approach**. This combines the strengths of both models to optimize for different user scales:

*   **For Normal Users (Push Model):**
    *   **Strategy:** Implement a **push model** where a user's feed is pre-computed and updated whenever someone they follow posts.
    *   **Benefit:** Provides a **seamless and real-time** experience for the user. When they open their app, their feed is already ready, leading to very low read latency.
    *   **Justification:** The number of followers for regular users is manageable, so the "fan-out" writes are not overwhelming.

*   **For Celebrity Users (Pull Model):**
    *   **Strategy:** Implement a **pull model** for users who follow celebrities. When a follower of a celebrity requests their feed, the system dynamically fetches the celebrity's latest posts and merges them with the user's pre-computed feed from non-celebrity followings.
    *   **Benefit:** Avoids the **"celebrity problem"** of massive fan-out writes that would otherwise crash the system. The read load is distributed across the many followers who *choose* to pull the content.
    *   **Justification:** The cost of calculating the feed on demand for a few high-read items is less than the cost of pushing to millions of feeds on every celebrity post.

This hybrid architecture is a common and highly effective strategy for news feed systems in large-scale social applications like Facebook, Twitter, Quora, and Instagram.

![Screenshot at 00:23:52](notes_screenshots/refined_Designing_INSTAGRAM：_System_Design_of_News_Feed-(1080p60)_screenshots/frame_00-23-52.jpg)

### Overall Architecture for News Feed

```mermaid
graph TD
    subgraph Client Interaction
        Client[Mobile App] -- HTTP: getUserFeed(UserID) --> Gateway
    end

    subgraph Core Services
        Gateway -- Internal Protocol --> UserFeedSvc[User Feed Service]
        UserFeedSvc -- "1. Get Followed Users" --> FollowSvc[Follow Service]
        FollowSvc -- "Returns FollowedUserIDs" --> UserFeedSvc
        UserFeedSvc -- "2. Get Posts (from FollowedUserIDs)" --> PostSvc[Post Service]
        PostSvc -- "Returns Posts" --> UserFeedSvc
        UserFeedSvc -- "3. Compile & Cache Feed" --> UserFeedsCache[User Feeds Cache (e.g., Redis)]

        PostCreator[User Posts] -- HTTP: CreatePost --> Gateway
        Gateway -- Internal Protocol --> PostSvc
        PostSvc -- "Persist Post" --> PostDB[(Post Database)]
        PostSvc -- "NOTIFY: New Post (PostID, PosterUserID)" --> UserFeedSvc
    end

    subgraph Hybrid Logic for UserFeedSvc
        UserFeedSvc -- "IF Poster is NORMAL User" --> PushLogic[Push Logic]
        PushLogic -- "Add Post to Followers' Caches" --> UserFeedsCache

        UserFeedSvc -- "IF Poster is CELEBRITY User" --> PullLogic[Pull Logic]
        PullLogic -- "Posts fetched on Read-Time" --> PostSvc
    end

    subgraph Notification Flow
        UserFeedSvc -- "Send Real-time Notification (via WebSockets/Long Polling)" --> NotificationSvc[Notification Service]
        NotificationSvc -- "Push to Client" --> Client
    end

    style Client fill:#f9f,stroke:#333,stroke-width:1px
    style Gateway fill:#ccf,stroke:#333,stroke-width:1px
    style UserFeedSvc fill:#cfc,stroke:#333,stroke-width:1px
    style FollowSvc fill:#cfc,stroke:#333,stroke-width:1px
    style PostSvc fill:#cfc,stroke:#333,stroke-width:1px
    style PostDB fill:#eee,stroke:#333,stroke-width:1px
    style UserFeedsCache fill:#f9f,stroke:#333,stroke-width:1px
    style NotificationSvc fill:#fcf,stroke:#333,stroke-width:1px
    style PostCreator fill:#f9f,stroke:#333,stroke-width:1px
```

### Conclusion and Interview Takeaways

This detailed exploration covers the design of Instagram's core features: image storage, liking/commenting, following, and the news feed.

*   **Key Design Principles Demonstrated:**
    *   **Microservices Architecture:** Breaking down the system into specialized, independently deployable services (e.g., Post Service, Follow Service, User Feed Service).
    *   **Data Modeling:** Designing efficient database schemas (e.g., polymorphic `Likes` table, simple `Follows` table).
    *   **Read vs. Write Optimization:** Understanding when to choose a push model (write-heavy, read-optimized) versus a pull model (read-heavy, write-optimized), and how to combine them for a hybrid solution.
    *   **Caching:** Leveraging caches (like Redis) for fast data retrieval and reducing database load.
    *   **Load Balancing & Routing:** Techniques like consistent hashing and snapshot-based routing for efficient request distribution.
    *   **Scalability Challenges:** Identifying and proposing solutions for common issues like the "celebrity problem."

In a system design interview, being able to articulate these concepts, justify your design choices, and discuss trade-offs (e.g., consistency vs. availability, read latency vs. write throughput) demonstrates a strong understanding of distributed systems. While an interviewer might dive into other modules like the Profile Service, Chat Service, or specific protocol choices (HTTP vs. WebSockets), the ability to build a solid foundation for the core features is paramount.

---

