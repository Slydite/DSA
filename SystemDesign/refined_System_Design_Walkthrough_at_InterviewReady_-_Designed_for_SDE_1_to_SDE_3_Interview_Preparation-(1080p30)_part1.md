# System Design Walkthrough At Interviewready Designed For Sde 1 To Sde 3 Interview Preparation (1080P30) - Part 1

### System Design Course Walkthrough: InterviewReady

This section provides a detailed walkthrough of the System Design course offered by InterviewReady, outlining its structure, key features, and recommended learning approach.

#### Accessing the Course
To begin your learning journey, you will need to log in to the InterviewReady platform.
-   **Login Flexibility:** You can log in directly using your credentials or conveniently sign up/in via your Google or GitHub accounts.
-   **Zip Code (Optional):** For users outside India, the zip code field during registration is not mandatory.

![Screenshot at 00:00:00](notes_screenshots/refined_System_Design_Walkthrough_at_InterviewReady_-_Designed_for_SDE_1_to_SDE_3_Interview_Preparation-(1080p30)_screenshots/frame_00-00-00.jpg)

Upon successful login, you'll be presented with an option for a **free preview** of the course. This is highly recommended to get a feel for the content and teaching style. If you possess a coupon code, it can be applied during this stage.

![Screenshot at 00:00:25](notes_screenshots/refined_System_Design_Walkthrough_at_InterviewReady_-_Designed_for_SDE_1_to_SDE_3_Interview_Preparation-(1080p30)_screenshots/frame_00-00-25.jpg)

#### Course Structure Overview
The System Design course is meticulously organized into four primary sections, each designed to build upon the previous one, ensuring a comprehensive understanding of system design principles and practices:

1.  **Fundamentals:** Lays the groundwork with core system design concepts.
2.  **High-Level Design (HLD):** Focuses on the architectural blueprint of large-scale systems.
3.  **Low-Level Design (LLD):** Dives into the detailed internal implementation of system components.
4.  **Additional Free Resources:** Offers supplementary materials and advanced topics.

```mermaid
graph TD
    A[InterviewReady System Design Course] --> B[1. Fundamentals]
    B --> C[2. High-Level Design (HLD)]
    C --> D[3. Low-Level Design (LLD)]
    A --> E[4. Additional Free Resources]
    D -- "Recommended Progression" --> F[Interview Preparation]
```

#### Detailed Section Breakdown

##### 1. Fundamentals
This section is essential for anyone new to system design or those looking to solidify their foundational knowledge. All video lessons within the Fundamentals section are **freely accessible**.

Each video lesson is designed for an interactive learning experience, featuring:
-   **About Section:** Provides a concise summary and relevant context for the video's topic.
-   **Resources Section:** Offers curated links to external articles or videos for deeper exploration of concepts.
-   **Notes Section:** A dedicated space within the platform where you can jot down personal notes, key takeaways, or insights useful for interviews or general upskilling.
-   **Discussion Section:** A collaborative forum to ask questions, clarify doubts, and engage in discussions with other learners and instructors.

##### 2. High-Level Design (HLD)
High-Level Design involves conceptualizing and structuring large-scale distributed systems, such as designing a system like Gmail. It focuses on:
-   **System Components:** Identifying the main building blocks (services, databases, queues, etc.) of the entire system.
-   **Interactions and Flow:** Defining how these components communicate and interact to fulfill the system's overall functionality and requirements.
-   **Example: Gmail System:** An HLD for Gmail would involve components like a **Gateway** (to handle incoming client requests and route them) and an **Authentication Service** (to manage user logins and verification).

![Screenshot at 00:02:59](notes_screenshots/refined_System_Design_Walkthrough_at_InterviewReady_-_Designed_for_SDE_1_to_SDE_3_Interview_Preparation-(1080p30)_screenshots/frame_00-02-59.jpg)
The provided architecture diagram visually represents a high-level design, illustrating the interconnectedness of various services in a distributed system:

```mermaid
graph LR
    Client["Client (e.g., Browser, App)"] -- "HTTP Requests" --> Gateway[Gateway]
    Gateway -- "Updates Cache" --> ServiceRegistry[Service Registry]
    Gateway -- "Auth Code" --> AuthService[Auth-Service]
    AuthService -- "Registers Service" --> ServiceRegistry
    ServiceRegistry -- "Endpoint Lookup" --> ProfileService[ProfileService]
    ServiceRegistry -- "Endpoint Lookup" --> AuthService
    ServiceRegistry -- "Endpoint Lookup" --> EmailService[EmailService]

    AuthService -- "Sends Verification" --> SMS_Service[SMS Service]
    SMS_Service -- "Delivers Message" --> UserMobile[User's Mobile]

    subgraph Key Service Endpoints
        direction LR
        EP_createProfile["createProfile"] -- "Maps to" --> S_ProfileService[ProfileService]
        EP_verify["verify"] -- "Maps to" --> S_AuthService[Auth-Service]
        EP_authenticate["authenticate"] -- "Maps to" --> S_AuthService
    end

    subgraph Service IP Address Examples
        direction LR
        IP_ProfileService["ProfileService IPs"] -- "e.g., 10.20.30.1, 10.20.30.2"
        IP_AuthService["AuthService IPs"] -- "e.g., 10.21.31.1, 10.21.31.2"
        IP_EmailService["EmailService IPs"] -- "e.g., 10.22.33.1, 10.22.33.2"
    end

    style Gateway fill:#ADD8E6,stroke:#333,stroke-width:1px
    style ServiceRegistry fill:#ADD8E6,stroke:#333,stroke-width:1px
    style AuthService fill:#ADD8E6,stroke:#333,stroke-width:1px
    style SMS_Service fill:#ADD8E6,stroke:#333,stroke-width:1px
    style ProfileService fill:#ADD8E6,stroke:#333,stroke-width:1px
    style EmailService fill:#ADD8E6,stroke:#333,stroke-width:1px
```

##### 3. Low-Level Design (LLD)
In contrast to HLD's broad scope, Low-Level Design focuses on the intricate details of a *specific component* within a larger distributed system.
-   **Component Granularity:** It involves taking a single piece of the system, such as a particular service or module (e.g., the core logic of a Splitwise-like application).
-   **Object-Oriented Focus:** The primary goal is to define the exact objects, classes, their attributes, methods, and relationships required to build that component. This includes designing data structures and algorithms.
-   **Code Readiness:** LLD produces a detailed blueprint that is very close to actual code implementation, facilitating the creation of unit and integration test cases.
-   **Example: Splitwise Application:** For Splitwise, LLD would involve designing classes like `User`, `Expense`, `Group`, and `Transaction`, defining their properties (e.g., `amount`, `payer`, `participants`) and behaviors (e.g., `addExpense()`, `settleDebt()`).

##### 4. Additional Free Resources
This section provides supplemental free content that is highly beneficial for various purposes:
-   **SD1 Interview Preparation:** The resources provided here are specifically curated to help candidates successfully clear a Software Developer 1 (SD1) level system design interview.
-   **Concept Brush-up:** It serves as an excellent resource for quickly reviewing fundamental system design concepts.

![Screenshot at 00:00:51](notes_screenshots/refined_System_Design_Walkthrough_at_InterviewReady_-_Designed_for_SDE_1_to_SDE_3_Interview_Preparation-(1080p30)_screenshots/frame_00-00-51.jpg)
This section covers foundational topics such as Distributed Rate Limiting, Horizontal vs. Vertical Scaling, Monoliths vs. Microservices, Load Balancing, Single Point of Failure, Service Discovery and Heartbeats, and API Design.

#### High-Level Design (HLD) vs. Low-Level Design (LLD) Comparison

| Feature           | High-Level Design (HLD)                                   | Low-Level Design (LLD)                                      |
| :---------------- | :-------------------------------------------------------- | :---------------------------------------------------------- |
| **Scope**         | Entire system or its major subsystems                     | A specific component or module within the system            |
| **Focus**         | Overall architecture, major components, and their interactions | Internal logic, classes, objects, data structures, and algorithms |
| **Abstraction**   | High; defines "what" the system does at a macro level     | Low; defines "how" a specific component achieves its function |
| **Deliverable**   | Architectural diagrams, component interaction flows, service contracts | Class diagrams, sequence diagrams, pseudo-code, database schemas |
| **Example**       | Designing the services (e.g., Gateway, Auth) for Gmail    | Designing the `User` and `Expense` classes for Splitwise    |
| **Proximity to Code** | More abstract; conceptual                              | Very close to actual code implementation; actionable        |

#### Recommended Learning Path
For a structured and effective learning experience, the recommended progression through the course is as follows:
1.  **Start with Fundamentals:** Establish a solid understanding of core concepts.
2.  **Proceed to High-Level Design:** Learn how to architect entire systems.
3.  **Conclude with Low-Level Design:** Master the detailed implementation of components.

This sequential approach ensures a natural progression from broad system understanding to intricate coding considerations.

#### Course Features and Benefits
The InterviewReady System Design course is equipped with several features designed to optimize your learning and interview preparation:
-   **Course Progress Tracking:** The platform actively monitors your completion rate, providing a clear overview of your progress and encouraging full course engagement.
    -   **Completion Incentive:** A **certificate** is awarded upon 100% course completion, serving as a tangible recognition of your effort.
-   **Video Rating System:** You can rate each video (from 1 to 5 stars) to provide feedback on its quality and usefulness, helping the course continually improve.
-   **Architecture Diagrams:** Most video lessons are complemented by detailed architecture diagrams (as seen in ![Screenshot at 00:02:59](notes_screenshots/refined_System_Design_Walkthrough_at_InterviewReady_-_Designed_for_SDE_1_to_SDE_3_Interview_Preparation-(1080p30)_screenshots/frame_00-02-59.jpg)), which are invaluable for visualizing and comprehending complex system designs.
-   **Quiz Sections:** Integrated quizzes help you test your understanding and assess your grasp of concepts at a deeper level.
    -   ![Screenshot at 00:02:33](notes_screenshots/refined_System_Design_Walkthrough_at_InterviewReady_-_Designed_for_SDE_1_to_SDE_3_Interview_Preparation-(1080p30)_screenshots/frame_00-02-33.jpg) illustrates a multiple-choice quiz question, for example, pertaining to "Request collapsing."
-   **FAQs (Frequently Asked Questions):** Addresses common queries related to specific chapters, providing quick clarifications.
-   **API Contracts:** For relevant chapters, detailed API specifications are provided, crucial for understanding service interactions.
-   **Capacity Estimation:** Certain chapters include exercises and explanations on how to estimate the resource requirements (e.g., storage, bandwidth, QPS) for system components.

#### Target Audience and Purchase Information
This course is primarily designed for individuals aiming for **SD2 (Software Developer 2) to SD3 (Software Developer 3) level system design interviews**. Senior engineering professionals will also find significant value in its comprehensive content.

-   **Purchase Options:** The course offers flexible payment options, allowing purchases in Indian Rupees (INR) for Indian residents or US Dollars (USD) for international payments.

---

#### Course Suitability for Non-Engineering Roles
While the course is primarily geared towards software development engineers (SD2 to SD3 levels), individuals in **Product Management** or **Program Management** roles may also find it beneficial. For these roles, the course might serve more as a valuable **revision material** rather than introducing entirely new concepts, helping to solidify their understanding of system architecture and technical considerations.

![Screenshot at 00:04:03](notes_screenshots/refined_System_Design_Walkthrough_at_InterviewReady_-_Designed_for_SDE_1_to_SDE_3_Interview_Preparation-(1080p30)_screenshots/frame_00-04-03.jpg)
The variety of case studies covered, such as "Design an Emailing service like Gmail," "Chess Design," "Calling App Design like WhatsApp," and "Live Video Streaming System like ESPN" within the High-Level Design section, and "Payment Tracking App like Splitwise" in Low-Level Design, provides a broad exposure that can be useful for understanding the scope and complexity of different systems.

#### Support and Contact Information
Should you have any questions or encounter issues, InterviewReady provides multiple channels for support:

-   **Chatbot:**
    -   The primary support method is an automated chatbot, designed to quickly address common queries and save time.
    -   For more complex questions or specific concerns that the chatbot cannot resolve, a human support team will respond within **24 hours**.

-   **Email Support:**
    -   If you prefer to communicate via email, you can reach out directly at `contact@interviewready.io`.

-   **Contact Us Form:**
    -   A dedicated "Contact Us" form is available on the website for easy submission of messages.
    -   **Important for Bug Reporting:** When reporting a bug or technical issue, including a **screenshot** is highly recommended. This visual context significantly aids the support team in understanding and resolving the problem efficiently.

---

