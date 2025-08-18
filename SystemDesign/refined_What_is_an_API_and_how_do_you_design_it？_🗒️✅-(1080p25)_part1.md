# What Is An Api And How Do You Design It？ 🗒️✅ (1080P25) - Part 1

![Screenshot at 00:00:00](notes_screenshots/refined_What_is_an_API_and_how_do_you_design_it？_🗒️✅-(1080p25)_screenshots/frame_00-00-00.jpg)

### API Design Fundamentals

This section will cover the essential aspects of designing effective Application Programming Interfaces (APIs). By the end, you should have a solid understanding of what an API is, what constitutes a good API, and practical strategies for designing them, enabling you to become a more proficient software engineer in this domain.

### What is an API?

An **API (Application Programming Interface)** is a **documented way** in which external consumers can understand how to interact with your code. It's a precise set of rules and specifications that allows different software components to communicate and exchange information.

Think of an API as a **contract** between your code and external users. It tells them:
*   **What** specific actions your code can perform (e.g., "get user data," "process payment").
*   **How** to request those actions (e.g., what parameters to provide).
*   **What** kind of response to expect (e.g., data format, possible errors).

Crucially, an API focuses on the **"what"** (the functionality it provides) and the **"how to use it"**, not the **"how it works internally"**. The internal implementation details are hidden from the consumer, allowing for flexibility and preventing dependency on your internal logic.

#### Example: Finding WhatsApp Group Admins

![Screenshot at 00:02:03](notes_screenshots/refined_What_is_an_API_and_how_do_you_design_it？_🗒️✅-(1080p25)_screenshots/frame_00-02-03.jpg)
![Screenshot at 00:02:34](notes_screenshots/refined_What_is_an_API_and_how_do_you_design_it？_🗒️✅-(1080p25)_screenshots/frame_00-02-34.jpg)

Let's illustrate with an example: imagine you need to find all the administrators of a specific WhatsApp group. WhatsApp would expose an API for this. Conceptually, this API would behave like a function call:

```mermaid
graph LR
    A[External Consumer/Application] --> B{Call getAdmins API}
    B --> C[WhatsApp Group Service]

    subgraph API Contract: getAdmins
        C -- "Input: string groupID" --> D[getAdmins Function]
        D -- "Possible Errors" --> E{Error Check}
        E -- "Group ID does not exist" --> F[Error: groupDoesNotExist]
        E -- "Group has been deleted" --> G[Error: groupIsDeleted]
        D -- "Success" --> H[Response: List<Admin> admins]
        H --> I[Admin Object Structure]
        I --> J[name: string]
        I --> K[userID: string]
        I --> L[...other details (e.g., JSON)]
    end

    H --> M[Result Delivered to Consumer]
    F --> M
    G --> M

    style A fill:#f9f,stroke:#333,stroke-width:1px
    style M fill:#ccf,stroke:#333,stroke-width:1px
    style C fill:#cff,stroke:#333,stroke-width:1px
```

**Breakdown of the `getAdmins` API:**

*   **Function Name:** `getAdmins`
*   **Parameters:** It requires a single parameter: `groupID` (of type `string`). This tells the API which specific group to query.
*   **Return Type (on success):** A `List` containing `Admin` objects. Each `Admin` object would be a structured data type (e.g., a JSON object) holding details like the admin's `name` and `userID`.
*   **Possible Errors:**
    *   `groupDoesNotExist`: The provided `groupID` does not correspond to any known group.
    *   `groupIsDeleted`: The group associated with the `groupID` existed but has since been removed. (Whether this is an error depends on the specific business logic).

This example demonstrates how an API defines a clear interface, much like a function signature in programming languages, specifying its name, inputs, potential outputs, and error conditions without revealing the underlying implementation.

### Designing Good APIs: A Checklist for Software Engineers

When designing an API, asking a series of critical questions can help ensure it is clear, intuitive, and robust.

#### 1. Where Should This API Reside? (Placement/Belonging)

![Screenshot at 00:00:30](notes_screenshots/refined_What_is_an_API_and_how_do_you_design_it？_🗒️✅-(1080p25)_screenshots/frame_00-00-30.jpg)

The first question to ask is: **"Where does this API logically belong within your system architecture?"**

*   **Principle:** An API should be exposed by the service or module that is the primary owner and manager of the data or functionality it provides. This adheres to the **Principle of Least Astonishment** and promotes modularity.
*   **Example:** If your system uses a **microservice architecture** and you have a dedicated `Group Service` responsible for all operations related to groups (creating, deleting, managing members, etc.), then an API like `getAdmins` (which deals with group-specific data) should be part of that `Group Service`. It wouldn't make sense for a `User Service` or a `Payment Service` to expose group-related APIs.

#### 2. What Does This API Do? (Naming Conventions)

The name of your API is its primary identifier and should clearly communicate its purpose.

*   **Principle:** An API's name must accurately and concisely describe its primary function and expected return value. If an API is named `getAdmins`, it should *only* return administrators.
*   **Common Naming Mistakes & Solutions:**

    | Problematic Name | What it Returns/Does | Recommended Change | Explanation |
    | :--------------- | :------------------- | :----------------- | :---------- |
    | `getAdmins`      | Admins + Groups they belong to | `getAdminsWithGroups` or `getAdminDetailsIncludingGroups` | The original name is misleading because it returns more than just admins. The new name clearly states the additional information. |
    | `processData`    | Performs multiple, unrelated operations | `processUserData` and `processOrderData` | Vague names make it hard to understand the API's scope. Split into more specific APIs, each with a single responsibility. |

*   **Analogy:** If you label a button "Start," it's vague. Does it start a car, a game, or a timer? A good label, like "Start Engine," is specific and immediately understandable.

#### 3. What Information Does This API Need? (Parameters)

The parameters an API accepts define its inputs and directly influence its functionality.

*   **Principle:** Parameters should be minimal, essential, and directly support the API's stated purpose. Avoid adding parameters that drastically change the API's core function.
*   **Example Scenario:** For `getAdmins`, the `groupID` is clearly essential. But what if a caller *also* has a list of user IDs and wants to verify if *those specific users* are admins in the given group?
    *   **Initial thought:** Add an optional `listOfUsers` parameter to `getAdmins`.
    *   **Problem:** This changes the API's fundamental purpose. It's no longer just "get all admins for a group"; it becomes "check if *these specific users* are admins in this group." This violates the **Single Responsibility Principle**.
    *   **Best Practice:** In such cases, it's often better to create a **new, dedicated API** for the distinct use case. For example: `checkAdminsForGroupAndUsers(groupID, listOfUsers)`. This keeps each API focused on a single, clear responsibility.
*   **Impact on Naming:** If you find yourself adding parameters that make you want to significantly alter the API's name (e.g., from `getAdmins` to `checkAdminsForGroupAndUsers`), it's a strong indicator that you should consider splitting it into separate APIs.

By diligently applying these principles, you can design APIs that are not only functional but also intuitive, easy to use, and maintainable, contributing to more robust and scalable software systems.

---

![Screenshot at 00:05:02](notes_screenshots/refined_What_is_an_API_and_how_do_you_design_it？_🗒️✅-(1080p25)_screenshots/frame_00-05-02.jpg)

### Designing Good APIs: Further Considerations

Continuing our discussion on API design, we'll delve into the nuances of parameter usage, response structures, effective error handling, and how these concepts translate to HTTP API endpoints.

#### 3. Parameters: When to Deviate from Simplicity?

While the general rule is to keep parameters minimal and focused on the API's core function, there are specific scenarios where adding extra parameters might be justified.

*   **Action Defines Parameters:** The primary purpose of an API should dictate its parameters. If an API is meant to `getAdmins`, its essential parameter is the `groupID`.
*   **Optimization as an Exception:**
    *   In a **microservice architecture**, services often need to communicate with each other (e.g., `Group Service` calling `User Service` to get user details). These inter-service calls (IO operations) can be expensive and slow.
    *   If a particular API is under **heavy load** or requires **extreme speed**, you might consider adding an "extra" parameter that allows the calling service to provide information that the API would otherwise have to fetch from another microservice.
    *   **Example:** If `getAdmins` frequently needs user authentication details from a `User Service`, and the calling client *already possesses* those details, passing them as an additional parameter to `getAdmins` could avoid an expensive internal `User Service` call.
    *   **Caveat:** Even in such cases, it's often preferable to rename the API to reflect its expanded scope (e.g., `getAdminsOptimizedWithAuth`). However, this might not always be feasible if the API is already widely used.
    *   **Principle:** Optimization-driven parameter additions should be a **last resort**, carefully weighed against the cost of increased complexity and potential confusion.

#### 4. Response Object Design

Just as with parameters, the response object returned by an API should be concise and relevant.

*   **Principle:** The API's response should **only contain the data directly related to its stated purpose**. Do not "stuff" the response with additional information in the hope that future consumers might find it useful.
*   **Common Mistake:** Returning a large, complex object containing many fields, even if the API's name suggests it should only return a subset (e.g., `getAdmins` returning admins, their groups, their contact info, and their last login details).
*   **Consequences:**
    *   **Confusion:** Consumers become unsure what the core purpose of the API is.
    *   **Over-fetching:** Unnecessary data is transferred, increasing network load and processing time for both the server and client.
    *   **Poor Extensibility:** Making the response object overly generic or comprehensive from the start makes it harder to evolve specific parts of the data model independently in the future.
*   **Analogy:** If you order a coffee, you expect a coffee. You don't want the barista to give you a coffee, a sandwich, and a newspaper "just in case you need them later." It's inefficient and confusing.

#### 5. Error Handling: Finding the Right Balance

Defining how your API communicates errors is crucial for its usability and robustness. There are two extremes to avoid:

*   **Extreme 1: Over-defining Errors (Too Granular)**
    *   **Problem:** Creating unique error codes or messages for every conceivable minor issue, even those that should be handled by basic input validation or are implicit failures.
    *   **Example:**
        *   "Group ID is not an integer" (if the API parameter type is already `integer`).
        *   "Group ID is too long" (if the API expects a string of a certain length, this should cause a general input validation error, not a specific API error).
    *   **Guidance:** Let underlying mechanisms (like data type validation in your programming language or framework) handle basic input errors. If the input format is wrong, a generic "Bad Request" (e.g., HTTP 400) is often sufficient, implying the caller sent invalid data. The caller should be responsible for sending correctly formatted data.

*   **Extreme 2: Under-defining Errors (Too Generic)**
    *   **Problem:** Returning a single, generic error (e.g., "Something went wrong" or a generic HTTP 404 "Not Found") for all failure conditions.
    *   **Example:** Returning a generic 404 when a `groupID` does not exist, or when a group has been deleted.
    *   **Guidance:** For **expected and meaningful business-logic errors**, provide specific error messages or codes. These are errors that are part of the API's domain and help the caller understand *why* their request failed.
    *   **Examples of Expected Errors:**
        *   `GROUP_NOT_FOUND`: The `groupID` does not correspond to an existing group.
        *   `GROUP_DELETED`: The group existed but has been deleted.
        *   `PERMISSION_DENIED`: The caller lacks the necessary rights to perform the action.
    *   **Principle:** Design errors based on **common expectations** of the API's consumers and the **responsibilities** of your service. Provide enough detail for the caller to take appropriate action, but avoid overwhelming them with irrelevant specifics.

#### 6. HTTP API Endpoint Design

When exposing your API over HTTP, you need to consider how the API's logical structure maps to web addresses (URLs) and HTTP methods.

![Screenshot at 00:07:02](notes_screenshots/refined_What_is_an_API_and_how_do_you_design_it？_🗒️✅-(1080p25)_screenshots/frame_00-07-02.jpg)

*   **URL Structure (Where):** The URL acts as the address for your API. A common pattern includes:
    *   **Base URL:** Your site's domain.
    *   **Domain/Service Identifier:** A segment indicating the specific service or domain.
    *   **Resource/Function Name:** The primary resource or action.
    *   **Version:** An optional but highly recommended segment for API versioning.

    ```
    https://<your_site_address>/<service_domain>/<resource_or_function_name>/<version>
    ```

    **Example:** For our `getAdmins` API within a `Group Service` in a `chat-messaging` domain:
    `https://gkcs.tech/chat-messaging/getAdmins/v1`

    *   `gkcs.tech`: The base domain.
    *   `chat-messaging`: Represents a broader domain or a specific service (e.g., the `Group Service` might be part of a larger `chat-messaging` suite).
    *   `getAdmins`: The specific API function.
    *   `v1`: Indicates **Version 1** of this API. This is crucial for backward compatibility. If you make breaking changes later, you can introduce `v2` without affecting clients using `v1`.

*   **HTTP Method (What Action):** HTTP methods (like `GET`, `POST`, `PUT`, `DELETE`) define the *type of operation* being performed on the resource.

    *   For `getAdmins`, one might typically use `GET` to retrieve data. However, if the `groupID` or other filtering criteria are complex or sensitive, a `POST` request might be used, sending the parameters in the **request body** (as a JSON object).

    **Example HTTP Request (using POST):**

    ```mermaid
    graph LR
        Client[Client Application] -- "HTTP POST Request" --> APIEndpoint[https://gkcs.tech/chat-messaging/getAdmins/v1]
        APIEndpoint -- "Request Body (JSON)" --> RequestBody[{"groupID": "group-123", "filter_by_name": "Alice"}]
        RequestBody --> APIProcessing[API Processes Request]
        APIProcessing -- "HTTP 200 OK Response" --> SuccessResponse[{"admins": [{"name": "Alice", "userID": "u001"}, {"name": "Bob", "userID": "u002"}]}]
        SuccessResponse --> Client
        APIProcessing -- "HTTP 404 Not Found" --> ErrorResponse[{"errorCode": "GROUP_NOT_FOUND", "message": "The specified group does not exist."}]
        ErrorResponse --> Client

        style Client fill:#f9f,stroke:#333,stroke-width:1px
        style APIEndpoint fill:#ccf,stroke:#333,stroke-width:1px
        style SuccessResponse fill:#cfc,stroke:#333,stroke-width:1px
        style ErrorResponse fill:#fcc,stroke:#333,stroke-width:1px
    ```

    In this example:
    *   The **HTTP Request Object** (the `POST` request body) is a JSON payload containing the `groupID` and any other relevant filtering parameters.
    *   The API processes this request and returns a **HTTP Response Object**, which is typically also a JSON payload containing the list of admin objects.

By carefully considering where your API belongs, what it does, what it needs, how it responds, and how it handles errors, you can design robust, user-friendly, and maintainable APIs.

---

### HTTP API Endpoint Design (Continued)

The response from our `getAdmins` API, when called via HTTP, would typically be a **JSON (JavaScript Object Notation) array** of admin objects.

**Example HTTP Response Body (JSON):**

```json
{
  "admins": [
    {
      "id": "admin_id_123",
      "name": "Alice Wonderland"
    },
    {
      "id": "admin_id_456",
      "name": "Bob The Builder"
    }
  ]
}
```

This structure allows external applications to easily parse and utilize the returned data.

#### GET vs. POST for Data Retrieval

![Screenshot at 00:07:30](notes_screenshots/refined_What_is_an_API_and_how_do_you_design_it？_🗒️✅-(1080p25)_screenshots/frame_00-07-30.jpg)
![Screenshot at 00:07:42](notes_screenshots/refined_What_is_an_API_and_how_do_you_design_it？_🗒️✅-(1080p25)_screenshots/frame_00-07-42.jpg)

While we used a `POST` request in the previous example for `getAdmins`, it's important to understand the common practices for HTTP methods:

*   **`GET` Method:**
    *   **Purpose:** Primarily used for **retrieving** data. It should be **idempotent** (multiple identical requests have the same effect as a single one) and **safe** (doesn't change server state).
    *   **Parameters:** Typically passed in the URL as **query parameters** (e.g., `/admins?groupID=123`).
    *   **Advantage:** Simpler, no request body needed, parameters are visible in the URL (good for caching and bookmarking).
    *   **Disadvantage:** Limited by URL length, not suitable for sensitive data or very complex/large query payloads.

*   **`POST` Method:**
    *   **Purpose:** Primarily used for **creating** new resources or submitting data that causes a **side effect** on the server.
    *   **Parameters:** Passed in the **request body** (e.g., JSON payload).
    *   **Advantage:** Can send large and complex data, suitable for sensitive information (not visible in URL), can be used for complex queries that don't fit in a URL.
    *   **Disadvantage:** Less straightforward for simple retrieval, not cacheable by default.

For `getAdmins`, if the `groupID` is simple, a `GET` request like `/chat-messaging/admins/v1?groupID=123` would be more idiomatic and efficient, avoiding the overhead of a request payload. A `POST` might be chosen if the filtering criteria were much more complex, requiring a structured JSON body.

#### Avoiding Ambiguity: Routing vs. Action

![Screenshot at 00:07:54](notes_screenshots/refined_What_is_an_API_and_how_do_you_design_it？_🗒️✅-(1080p25)_screenshots/frame_00-07-54.jpg)
![Screenshot at 00:08:05](notes_screenshots/refined_What_is_an_API_and_how_do_you_design_it？_🗒️✅-(1080p25)_screenshots/frame_00-08-05.jpg)

A common mistake in API design is to mix the **routing information** (where the API is located) with the **action it performs**.

*   **Anti-pattern:** Using a generic endpoint like `/chat-messaging/group` and then expecting the request body or some other implicit logic to determine whether to fetch admins, members, or group details.
    *   **Problem:** This leads to **ambiguous APIs**. The endpoint itself doesn't clearly state its purpose, making it hard for consumers to understand or for the backend to route requests efficiently.
*   **Best Practice:**
    *   The **URL (routing)** should identify the **resource** you are interacting with.
    *   The **HTTP Method (action)** should define *what* you want to do with that resource.
    *   **Example:**
        *   Instead of `POST /chat-messaging/getAdmins/v1` (where `getAdmins` is redundant with the `GET` method), consider `GET /chat-messaging/admins/v1`.
        *   Here, `/admins` clearly identifies the resource (administrators), and the `GET` method indicates the action (retrieve). The `groupID` can be passed as a query parameter (`/chat-messaging/admins/v1?groupID=123`).

This approach aligns with **RESTful principles**, where URLs represent resources and HTTP methods represent actions on those resources.

### Major Issues in API Design: Side Effects and Atomicity

Beyond the basics of naming and parameters, two critical concerns can significantly impact an API's quality: **side effects** and **atomicity**.

#### 1. Side Effects: The "Hidden" Operations

A **side effect** occurs when an API performs actions beyond its explicitly stated purpose. While sometimes intended, unacknowledged side effects lead to confusing, unpredictable, and difficult-to-maintain APIs.

*   **Principle:** An API should have **no unexpected side effects**. Its name and contract should fully describe everything it does. If an API does multiple things, it should be explicitly named to reflect all those actions, or ideally, broken into multiple, more focused APIs.
*   **Example: `setAdmins` API**
    Imagine an API named `setAdmins(groupID, listOfAdmins)` intended to assign a list of users as administrators for a specific group.
    *   **Problematic Side Effects:**
        *   **Implicit Member Addition:** If a user in `listOfAdmins` is *not already a member* of `groupID`, the API might silently add them as a member *and then* make them an admin.
        *   **Implicit Group Creation:** If `groupID` does not exist, the API might silently *create the group* and then assign the users as admins.
    *   **Why this is bad:**
        1.  **Confusion:** The caller expects only "setting admins," not "adding members" or "creating groups." This violates the **Principle of Least Astonishment**.
        2.  **Unpredictability:** Different outcomes based on pre-existing state (e.g., group existence, user membership) make the API hard to reason about and test.
        3.  **Lack of Control:** The caller might not *want* these implicit actions to happen. They might prefer to explicitly call `addMember` or `createGroup` first.
        4.  **Poor Naming:** The API's name no longer accurately describes its behavior. It's not just `setAdmins`; it's `setAdminsAndAddMembersMaybeAndCreateGroupMaybe`.

*   **"Config Object" Anti-pattern:**
    *   Avoid APIs that take a large, generic "config object" as a parameter, where different flags or fields within the object dictate drastically different behaviors.
    *   **Problem:** This turns a single API into a multi-purpose function, making its behavior highly dependent on the "config," leading to complex logic, difficult testing, and poor discoverability of its capabilities.
    *   **Solution:** Break such APIs into multiple, smaller, and more specific APIs, each with a clear, single responsibility.

#### 2. Atomicity: All or Nothing

**Atomicity** refers to the property of a transaction or operation where it is treated as a single, indivisible unit. Either all of its operations complete successfully, or none of them do. If any part fails, the entire operation is rolled back, leaving the system in its original state.

*   **Relevance to Side Effects:** When an API performs multiple internal operations (i.e., has side effects), atomicity becomes critical.
*   **Example: `setAdmins` (with implicit group creation)**
    If `setAdmins` attempts to:
    1.  Create the group (if it doesn't exist).
    2.  Add members to the group (if they aren't already members).
    3.  Set them as admins.

    What if step 1 (creating the group) succeeds, but step 2 (adding members) fails?
    *   The group might be created, but the intended admins aren't associated with it. This leaves the system in an **inconsistent state**.
    *   Another client might then try to set admins, leading to unexpected behavior or conflicts.

*   **Mitigation:**
    *   **Transaction Management:** For database operations, use database transactions to ensure atomicity.
    *   **Compensating Actions:** For distributed systems where true atomicity is hard, design compensating actions to revert changes if a later step fails.
    *   **API Splitting:** The best solution is often to **split the API** into smaller, atomic operations.
        *   `createGroup(groupID)`
        *   `addMembersToGroup(groupID, listOfMembers)`
        *   `setAdminsForGroup(groupID, listOfAdmins)`
        This allows clients to orchestrate the process and handle failures at each step, preventing inconsistent states.

*   **Conclusion on Atomicity and Naming:** While atomicity might sometimes necessitate bundling operations for consistency, it is **never an excuse for poor API naming**. An API's name must always accurately reflect *all* the atomic operations it performs.

---

### Best Practices for API Design (Continued)

#### Decomposition for Atomicity and Clarity

![Screenshot at 00:11:13](notes_screenshots/refined_What_is_an_API_and_how_do_you_design_it？_🗒️✅-(1080p25)_screenshots/frame_00-11-13.jpg)
![Screenshot at 00:11:22](notes_screenshots/refined_What_is_an_API_and_how_do_you_design_it？_🗒️✅-(1080p25)_screenshots/frame_00-11-22.jpg)

We previously discussed the importance of an API having **no side effects**—meaning it should only perform the actions explicitly stated by its name. This principle is closely tied to the concept of **atomicity**.

*   **The Problem of Implicit Side Effects:**
    *   Consider our `setAdmins(List<Admin> admins, string groupID)` API. If this API implicitly handles cases like:
        *   "What if these admins are not members of this group?" (i.e., it adds them as members first).
        *   "What if the group doesn't exist?" (i.e., it creates the group first).
    *   This creates a multi-purpose API that is confusing and unpredictable. The caller doesn't know *exactly* what actions will be taken, or in what order.

*   **The Atomicity Challenge:**
    *   When an API performs multiple internal operations (like creating a group, adding members, then setting admins), these operations need to be treated as an **atomic unit**. This means either *all* of them succeed, or *none* of them do, rolling back any partial changes.
    *   If `setAdmins` attempts to `createGroup` and then `addMembers`, but `addMembers` fails, you could be left with a created group but no members, leading to an **inconsistent state**.
    *   Ensuring atomicity for complex, multi-step operations within a single API call can be challenging, especially in distributed systems.

*   **The Solution: Explicit API Calls and Decomposition**
    The best practice is to break down complex, multi-step operations into **multiple, single-purpose APIs**. This shifts the responsibility of orchestration to the client, making the API contract clearer and easier to manage.

    **Instead of:**
    `setAdmins(groupID, listOfAdmins)` that might implicitly create a group or add members.

    **Consider a sequence of explicit, atomic API calls:**
    1.  **Check for Group Existence:** Client calls `getGroup(groupID)`.
        *   If group doesn't exist, the API returns an error (e.g., HTTP 404 "Group Not Found").
        *   Client then decides: Should I create the group?
    2.  **Create Group (if needed):** Client calls `createGroup(groupID, initialMembers)`.
        *   This API's sole responsibility is creating the group.
    3.  **Add Members (if needed):** Client calls `addMembersToGroup(groupID, newMembers)`.
        *   This API's sole responsibility is adding members.
    4.  **Set Admins:** Client calls `setAdmins(groupID, listOfAdmins)`.
        *   This API's sole responsibility is to make existing members into admins. If a user in `listOfAdmins` is not a member, this API should return an error (e.g., "User is not a member").

    **Benefits of Decomposition:**
    *   **Clarity:** Each API's purpose is unambiguous.
    *   **Predictability:** The client knows exactly what will happen with each call.
    *   **Control:** The client orchestrates the flow and handles errors at each distinct step.
    *   **Testability:** Individual API functions are easier to test.
    *   **Maintainability:** Changes to group creation logic don't impact admin setting logic.

    While atomicity is crucial for certain critical actions (like financial transactions where partial completion is unacceptable), it's generally better to achieve it through explicit, well-defined, and smaller API operations rather than through a single, overloaded API with hidden side effects. Poor naming is never justified, even for atomicity.

#### Handling Large API Responses

When an API needs to return a potentially large amount of data (e.g., hundreds or thousands of members in a group), sending it all in a single response can be inefficient and slow. There are two primary strategies to manage large responses:

1.  **Pagination (Client-Controlled)**

    ![Screenshot at 00:11:42](notes_screenshots/refined_What_is_an_API_and_how_do_you_design_it？_🗒️✅-(1080p25)_screenshots/frame_00-11-42.jpg)

    *   **Concept:** Instead of returning all data at once, the API returns data in smaller, manageable chunks (pages). The client requests specific pages.
    *   **Mechanism:** The API typically accepts parameters like `offset` (or `pageNumber`) and `limit` (or `pageSize`).
        *   `offset`: The starting point in the dataset.
        *   `limit`: The maximum number of items to return in a single response.
    *   **Example:** For `getMembers` of a group with 200 members:
        *   `GET /group/members?groupID=G123&offset=0&limit=10` (returns members 1-10)
        *   `GET /group/members?groupID=G123&offset=10&limit=10` (returns members 11-20)
        *   ... and so on.
    *   **Benefits:**
        *   **Reduced Load:** Less data transferred over the network per request.
        *   **Faster Initial Response:** The first page loads quickly.
        *   **Client Control:** The client decides how much data to fetch at a time, improving user experience (e.g., "load more" functionality).
    *   **Use Case:** Common for user-facing applications (web/mobile) where displaying all data at once is impractical or unnecessary.

2.  **Response Fragmentation / Chunking (Internal Protocol / Server-to-Server)**

    ![Screenshot at 00:12:02](notes_screenshots/refined_What_is_an_API_and_how_do_you_design_it？_🗒️✅-(1080p25)_screenshots/frame_00-12-02.jpg)

    *   **Concept:** This strategy is less about the public API contract and more about how large responses are handled internally between microservices, especially when an internal service-to-service call might exceed internal message size limits (e.g., 1KB or 10KB).
    *   **Mechanism:** If an internal response is too large, the sending service breaks it into multiple smaller "fragments" or "chunks." Each fragment is sent sequentially, often with a unique identifier (like a sequence number) and a flag indicating if it's the last chunk.
    *   **Example:** A `User Service` requesting detailed profiles for 200 members from a `Profile Service`. If the total data exceeds the internal message buffer, the `Profile Service` might send:
        *   Chunk 1 (members 1-50, sequence 1, `hasMore: true`)
        *   Chunk 2 (members 51-100, sequence 2, `hasMore: true`)
        *   ...
        *   Chunk N (members 151-200, sequence N, `hasMore: false`)
    *   **Benefits:**
        *   Allows transfer of very large internal data sets without hitting hard limits.
        *   Ensures reliable delivery of large payloads within a controlled environment.
    *   **Use Case:** Primarily for backend, inter-service communication where direct TCP/IP fragmentation might not be sufficient or where application-level acknowledgment of chunks is desired.

#### Data Consistency in API Responses

When an API reads data, a crucial question arises: **How consistent does that data need to be?**

*   **The Consistency Challenge:**
    *   Imagine `getAdmins` is called. The API starts reading from the database.
    *   While it's reading, another transaction adds a new admin.
    *   The `getAdmins` API might return a list of 2 admins, even though there are now 3. This is an **inconsistent view** of the data.

*   **Types of Consistency:**
    *   **Strong (Immediate) Consistency:** Guarantees that any read operation will always return the most recently committed write. This often involves locking mechanisms, which can reduce concurrency and slow down operations.
    *   **Eventual Consistency:** Guarantees that if no new updates are made to a given data item, eventually all accesses to that item will return the last updated value. This model prioritizes availability and performance over immediate consistency. Reads might return slightly stale data for a brief period.

*   **The Trade-off: Consistency vs. Performance/Cost:**
    *   Achieving perfect, strong consistency for every API call, especially in distributed systems, is **expensive** in terms of:
        *   **Performance:** Requires synchronization, locking, or multi-phase commits, which add latency.
        *   **Resources:** More complex infrastructure and coordination.
    *   **Question to Ask:** "Do you *really* care about perfect consistency for *this specific API* at *this exact moment*?"
        *   **Example: `getAdmins`:** If a new admin is added, and your `getAdmins` call returns a list that's a few seconds old, is that generally acceptable? For most social applications, a slight delay in seeing a new admin might be fine.
        *   **Example: Bank Account Balance:** For a `getBalance` API, strong consistency is paramount. You absolutely need the most up-to-date balance.
    *   **Principle:** Design your API's consistency model based on the **business requirements** and the **tolerance for stale data**. Don't pay the performance and complexity cost of strong consistency if eventual consistency is sufficient for the use case.

By consciously making these decisions about atomicity, response handling, and data consistency, you can design APIs that are not only functional but also efficient, scalable, and appropriate for their specific domain.

---

### Data Consistency in API Responses (Continued)

![Screenshot at 00:14:23](notes_screenshots/refined_What_is_an_API_and_how_do_you_design_it？_🗒️✅-(1080p25)_screenshots/frame_00-14-23.jpg)

We discussed the trade-off between strong (immediate) consistency and eventual consistency. A common way to leverage eventual consistency for performance gains is through **caching**.

#### Caching and Data Staleness

*   **Concept:** Caching involves storing copies of frequently accessed data in a faster, temporary storage location (a cache) closer to the consumer. When an API request comes in, the system first checks the cache. If the data is found and is considered "fresh enough," it's served from the cache instead of the primary data source (e.g., database).
*   **Impact on Consistency:** When data is served from a cache, there's an inherent possibility that it might be slightly **stale** (not perfectly up-to-date) compared to the absolute latest state in the database.
*   **The Question:** For a given API, "Do you care if the response is slightly older, served from a cache?"
    *   **Example 1: `getAdmins`:** If you request a list of admins and the cached response is 5 seconds old, showing 2 admins when a 3rd was just added, does it matter significantly for your application's user experience? Often, for such scenarios, a small degree of staleness is acceptable in exchange for faster response times and reduced database load.
    *   **Example 2: `getCommentsForPost`:** For displaying comments on a blog post, a user typically doesn't need to see comments posted in the last 3 seconds. A cached view that's a minute or two old is perfectly adequate.
*   **Decision Point:** If your database is under heavy load, serving more requests from the cache can significantly improve overall system performance and responsiveness. This is a design decision that balances data freshness with system efficiency.

### Service Degradation: Maintaining Responsiveness Under Load

![Screenshot at 00:14:30](notes_screenshots/refined_What_is_an_API_and_how_do_you_design_it？_🗒️✅-(1080p25)_screenshots/frame_00-14-30.jpg)

**Service Degradation** (also known as graceful degradation or brownout) is a strategic approach in API design and system architecture to maintain some level of functionality and responsiveness when the system is under extreme load or experiencing partial failures, rather than completely crashing.

*   **Concept:** Instead of failing outright, the API or service intentionally reduces the quality or completeness of its response to ensure it can still deliver core functionality.
*   **How it relates to API Design:**
    *   **Reduced Response Size:** If an API (`getProfile` for example) normally returns a comprehensive user profile with many fields (name, email, profile picture URL, bio, last activity, etc.), during degradation, it might be configured to return only the **essential fields** (e.g., just the `name` and `userID`).
    *   **Omitting Non-Essential Data:** Information like profile pictures, detailed activity logs, or secondary data that is expensive to fetch might be temporarily excluded from the response.
    *   **Example:** Instead of returning a full user profile, an API might return just the user's `name` to ensure a quick response and prevent the service from crashing due to database strain.
*   **Benefit:** This allows the system to remain partially operational and responsive, providing a degraded but functional experience, instead of becoming completely unavailable. It's a trade-off between full functionality and system stability during peak load or incidents.

In essence, good API design involves a continuous evaluation of trade-offs: clarity vs. optimization, comprehensive vs. concise responses, strong vs. eventual consistency, and full functionality vs. graceful degradation. Making informed decisions on these points leads to robust, scalable, and user-friendly APIs.

---

