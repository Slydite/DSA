# How Netflix Onboards New Content： Video Processing At Scale 🎥 (1080P25) - Part 1

## Onboarding New Content to Netflix: Engineering Challenges

When a new TV series or movie is added to Netflix, beyond the legal agreements, there are significant **engineering challenges** involved in preparing the content for delivery to millions of diverse users. The core problem is ensuring that a single piece of content can be seamlessly viewed across a vast array of devices and internet connection speeds.

### Key Technical Challenges in Video Processing

![Screenshot at 00:01:36](notes_screenshots/refined_How_NETFLIX_onboards_new_content：_Video_Processing_at_scale_🎥-(1080p25)_screenshots/frame_00-01-36.jpg)
![Screenshot at 00:01:03](notes_screenshots/refined_How_NETFLIX_onboards_new_content：_Video_Processing_at_scale_🎥-(1080p25)_screenshots/frame_00-01-03.jpg)

To cater to every user's unique viewing environment, Netflix must process each video into multiple variations, addressing two primary factors:

1.  **Video Formats (Codecs)**
    *   **Purpose:** Different formats exist to optimize for varying internet connection speeds and desired video quality. A user with a fast connection might prefer a high-quality, detailed format, while someone on a slower connection needs a more compressed, lower-quality version to avoid buffering.
    *   **Codec Defined:** A **codec** (short for **co**mpressor-**dec**ompressor) is a technology used to encode or decode digital data streams, particularly video and audio. Its primary function is to compress video data to reduce file size, making it more efficient for storage and transmission.
    *   **Compression Types:**
        *   **Lossy Compression:** This is the most common type for video (e.g., MP4). It reduces file size by permanently discarding some data that is often imperceptible to the human eye. While some original detail is lost, the file size reduction is significant, making it ideal for streaming.
        *   **Lossless Compression:** (Mentioned for contrast) This method compresses data without losing any information. While it results in larger file sizes compared to lossy compression, it's used when perfect fidelity to the original source is critical, though less common for final streaming delivery.
    *   **Analogy:** Think of a codec like a specific recipe for packing a suitcase. A "high-quality" codec might pack everything meticulously, resulting in a larger suitcase (file) but perfectly preserved items. A "lower-quality" (lossy) codec might fold things more tightly, perhaps crushing a few items (losing some data) but resulting in a much smaller suitcase that's easier to carry (transmit).

2.  **Video Resolutions**
    *   **Purpose:** The required screen resolution varies drastically depending on the viewing device. A mobile phone screen needs significantly less resolution than a large 4K television or even a laptop display. Providing the appropriate resolution ensures optimal viewing experience without wasting bandwidth.
    *   **Examples:**
        *   **Mobile Phone:** Might use 360p or 480p.
        *   **Laptop/Tablet:** Often uses 720p or 1080p.
        *   **Large TV:** May require 1080p, 4K (2160p), or even higher resolutions.

### The Combinatorial Explosion: Formats x Resolutions

For a single original video, Netflix must generate multiple versions, each a unique combination of a specific **format (codec)** and a **resolution**. These combinations are often referred to as "tuples" or pairs.

The total number of video files that need to be processed from a single original video can be calculated as:

`Total Processed Videos = Number of Formats (F) * Number of Resolutions (R)`

**Example:** If Netflix supports 5 different video formats and 10 different resolutions, then each original video must be processed into `5 * 10 = 50` unique versions.

| Format (Codec) | Resolution | Example Output File (Conceptual) |
| :------------- | :--------- | :------------------------------- |
| MP4 (H.264)    | 1080p      | `MovieTitle_H264_1080p.mp4`      |
| WebM (VP9)     | 720p       | `MovieTitle_VP9_720p.webm`       |
| AV1            | 480p       | `MovieTitle_AV1_480p.mp4`        |
| MP4 (HEVC)     | 4K (2160p) | `MovieTitle_HEVC_2160p.mp4`      |

### The Solution: Distributed Processing and Chunking

Processing a single, large video file into potentially dozens of different versions is an incredibly time-consuming and computationally intensive task. Relying on a single powerful computer for this would be impractical due to:

*   **Time:** It would take an extremely long time for one machine to complete all the encodings.
*   **Reliability:** If that single computer crashes or experiences a failure, the entire process would stop, and potentially all work would be lost.

Netflix employs a highly intelligent and robust solution: **distributed processing through video chunking.**

1.  **Breaking into Chunks:** The original, large video file is first broken down into smaller, independent segments called **chunks**.
2.  **Parallel Processing:** Each of these smaller chunks can then be processed (encoded into various formats and resolutions) independently and simultaneously by different computers or processing units across a large cluster.

This approach offers several critical advantages:

*   **Speed:** By distributing the workload, the total time required to encode a video into all its versions is drastically reduced. It's like having an assembly line where many workers process small parts concurrently, rather than one worker building the whole product.
*   **Fault Tolerance:** If one processing unit fails while working on a chunk, only that specific chunk needs to be re-processed, not the entire video. This greatly improves the system's resilience.
*   **Scalability:** New processing power can be easily added to handle increased content ingestion, as the tasks are granular and distributable.
*   **Efficient Resource Utilization:** Smaller, independent tasks are easier to manage, schedule, and distribute across a large pool of computing resources.

Essentially, each **(Chunk, Format, Resolution)** combination becomes a distinct, manageable task. For example, "Chunk A encoded in MP4 at 1080p" is one task, and "Chunk A encoded in AVI at 480p" is another.

```mermaid
graph LR
    OriginalVideo[Original Video File] --> ChunkingModule[Chunking Module]

    subgraph Chunks Created
        ChunkingModule --> ChunkA[Chunk A]
        ChunkingModule --> ChunkB[Chunk B]
        ChunkingModule --> ChunkC[Chunk C]
        ChunkingModule --> ...
    end

    subgraph Distributed Processing Farm
        ChunkA --> Processor1[Processor 1]
        ChunkB --> Processor2[Processor 2]
        ChunkC --> Processor3[Processor 3]
        Processor1 -- "Encode (Format, Resolution)" --> OutputA1[Chunk A (MP4, 1080p)]
        Processor1 -- "Encode (Format, Resolution)" --> OutputA2[Chunk A (AVI, 480p)]
        Processor2 -- "Encode (Format, Resolution)" --> OutputB1[Chunk B (MP4, 1080p)]
        Processor3 -- "Encode (Format, Resolution)" --> OutputC1[Chunk C (MP4, 1080p)]
    end

    OutputA1 & OutputA2 & OutputB1 & OutputC1 -- "Combined later" --> FinalVideoVersions[All Formats/Resolutions for Original Video]

    style OriginalVideo fill:#f9f,stroke:#333,stroke-width:1px
    style FinalVideoVersions fill:#ccf,stroke:#333,stroke-width:1px
    style ChunkingModule fill:#bbf,stroke:#333,stroke-width:1px
    style Processor1 fill:#cfc,stroke:#333,stroke-width:1px
    style Processor2 fill:#cfc,stroke:#333,stroke-width:1px
    style Processor3 fill:#cfc,stroke:#333,stroke-width:1px
```

### Evolution of Chunking Strategy: Fixed-Size Chunks (Initial Approach)

Initially, Netflix's approach to chunking involved dividing the video into equal-sized segments, for instance, three minutes each.

*   **Rationale:** This seemed logical because it ensured that each processing unit was assigned an "equal" amount of work in terms of duration. It provided a simple, quantifiable way to distribute tasks.

However, this fixed-size approach, while seemingly fair, presented its own set of challenges, particularly when considering the varying complexity of video content within those three-minute segments.

---

### The Problem with Fixed-Size Chunks

![Screenshot at 00:03:35](notes_screenshots/refined_How_NETFLIX_onboards_new_content：_Video_Processing_at_scale_🎥-(1080p25)_screenshots/frame_00-03-35.jpg)

While breaking videos into fixed-size chunks (e.g., 3-minute segments) simplifies processing distribution, it introduces a significant issue for **user experience (UX)**.

*   **Scenario:** Imagine an action movie where a critical moment, like a car chase, spans across the boundary of two fixed-size chunks. For instance, the climax of the chase might be at the 2:50 mark of "Chunk 1" and continue into the beginning of "Chunk 2" at the 3:00 mark.
*   **User Impact:** If a user is streaming this video and an API call is made to fetch the next chunk precisely at the 3-minute mark, there could be a noticeable **lag** or stutter as the system transitions from one chunk to the next. This disrupts the seamless viewing experience, especially during fast-paced or critical scenes. The user wants to see the action unfold continuously, not with an arbitrary pause.

### Adaptive Chunking: Introducing "Shots" and "Scenes"

To overcome the limitations of fixed-size chunking, Netflix evolved its strategy to be more content-aware. Instead of arbitrary time-based divisions, they now chunk videos based on **visual content changes**, introducing concepts like "shots" and "scenes."

*   **Shot:** A "shot" is the smallest unit of video, typically a few seconds long (e.g., 4 seconds). It represents a continuous, uninterrupted recording from a single camera angle.
*   **Scene:** A "scene" is a collection of related shots that together form a cohesive narrative segment. For example, an entire car chase, a dialogue exchange, or a quiet moment might constitute a single scene, regardless of its exact duration.
*   **Benefits:**
    *   **Improved User Experience:** When a user seeks or streams to a particular point in the video, the video-serving algorithm can identify the entire scene containing that point and fetch all its corresponding chunks at once. This ensures that the user gets a complete, uninterrupted segment of action or dialogue, preventing jarring breaks.
    *   **Content-Awareness:** This method aligns chunk boundaries with natural breaks in the video content, making the streaming process more intelligent and user-centric.

### Intelligent Content Delivery: Sparse vs. Dense Movies

![Screenshot at 00:06:02](notes_screenshots/refined_How_NETFLIX_onboards_new_content：_Video_Processing_at_scale_🎥-(1080p25)_screenshots/frame_00-06-02.jpg)

Netflix further optimizes content delivery by analyzing user viewing patterns for different types of movies, categorizing them as "sparse" or "dense." This allows the system to predict future viewing behavior and pre-fetch data accordingly, balancing bandwidth usage with user experience.

1.  **Sparse Movies (Exploratory Viewing)**
    *   **Definition:** These are movies where users tend to jump around, skipping sections or watching only specific scenes. This pattern indicates that the user is not watching linearly from start to finish.
    *   **Prediction:** Netflix's prediction algorithms identify such movies as "sparsely seen."
    *   **Delivery Strategy:** For sparse movies, the system avoids aggressive pre-fetching. Instead, it primarily sends only the data that the user has explicitly requested (e.g., by clicking on a specific point in the timeline). This prevents unnecessary data transfer and saves bandwidth, as the user is unlikely to watch the intervening content.
    *   **Analogy:** Imagine a textbook where you only read specific chapters or sections. A smart system wouldn't download the entire book; it would only fetch the pages you specifically open.

2.  **Dense Movies (Continuous Viewing)**
    *   **Definition:** These are highly engaging movies where users typically watch continuously and linearly, from beginning to end, with minimal skipping.
    *   **Prediction:** Netflix identifies these as "dense movies" based on consistent viewing patterns.
    *   **Delivery Strategy:** For dense movies, the system proactively pre-fetches future chunks of the video. As you watch, the next few minutes or scenes are already being downloaded to your device's buffer, ensuring a seamless, uninterrupted playback experience even if your internet connection has momentary dips.
    *   **Analogy:** This is like a chef preparing the next course of a meal while you're still enjoying the current one, ensuring there's no delay between courses.

### Data Storage: Amazon S3

![Screenshot at 00:05:28](notes_screenshots/refined_How_NETFLIX_onboards_new_content：_Video_Processing_at_scale_🎥-(1080p25)_screenshots/frame_00-05-28.jpg)

All the original video files, along with their myriad processed formats and resolutions (chunks), need to be stored reliably and cost-effectively. Netflix uses **Amazon S3 (Simple Storage Service)** for this purpose.

*   **What is Amazon S3?** It is a cloud-based object storage service provided by Amazon Web Services (AWS). It's designed for storing and retrieving any amount of data from anywhere on the web.
*   **Key Characteristics:**
    *   **Static Data Storage:** S3 is primarily used for **static data**, meaning data that does not change frequently once stored. Video files, once encoded, are largely static.
    *   **Cost-Effective:** It is significantly cheaper than traditional databases for storing large volumes of data, especially when frequent updates or complex transactional guarantees are not required.
    *   **Scalability & Reliability:** S3 offers massive scalability and high durability, making it ideal for storing Netflix's enormous content library.
*   **Comparison with Databases:** While databases provide features like updates, complex queries, and transactional guarantees (e.g., ACID properties), they are generally more expensive and less optimized for storing vast amounts of static binary large objects (BLOBs) like video files. S3 excels in simple storage and retrieval of such data.

### Beyond Storage: The Role of Internet Service Providers (ISPs)

![Screenshot at 00:06:48](notes_screenshots/refined_How_NETFLIX_onboards_new_content：_Video_Processing_at_scale_🎥-(1080p25)_screenshots/frame_00-06-48.jpg)

Before a Netflix video even reaches a user's device, it travels through the internet infrastructure, involving **Internet Service Providers (ISPs)**. Netflix's innovative approach to content delivery extends to how it interacts with ISPs.

*   **Traditional Internet Request Flow (e.g., Facebook.com):**
    1.  **User Input:** You type `Facebook.com` into your browser.
    2.  **ISP Interaction:** Your request goes to your ISP.
    3.  **DNS Resolution:** Your ISP (or its DNS server) has a "phone book" or **address register** (DNS table) that maps human-readable domain names (like `Facebook.com`) to numerical **IP addresses** (e.g., `157.240.24.35`).
    4.  **Connection to Server:** Your computer then uses this IP address to connect directly to the Facebook server, which is a physical computer located somewhere on the internet.
    5.  **Data Exchange:** You are "talking" directly to the Facebook server to retrieve content.

*   **Netflix's Innovation (Introduction to Open Connect):**
    Netflix recognized that the traditional model of every user connecting directly to a central server for video streaming would overwhelm its infrastructure and lead to poor user experience, especially during peak hours. Their solution was to bring the content much closer to the users, which we will explore further. This innovative approach transformed how large-scale content delivery is handled over the internet.

---

### The Challenge of Geographic Distance

![Screenshot at 00:07:12](notes_screenshots/refined_How_NETFLIX_onboards_new_content：_Video_Processing_at_scale_🎥-(1080p25)_screenshots/frame_00-07-12.jpg)
![Screenshot at 00:07:23](notes_screenshots/refined_How_NETFLIX_onboards_new_content：_Video_Processing_at_scale_🎥-(1080p25)_screenshots/frame_00-07-23.jpg)

Even with optimized video formats and resolutions, a significant challenge arises from the **geographic distance** between users and Netflix's primary servers. Historically, Netflix's main servers were concentrated in locations like the United States.

*   **Problem:** For users in distant regions (e.g., India), every request to stream a Netflix video would have to travel across continents to the US servers and back. This long travel time for data (known as **latency**) would lead to:
    *   **Slow Load Times:** Videos taking longer to start.
    *   **Frequent Buffering:** Interruptions during playback as the system waits for more data.
    *   **Poor User Experience:** Frustration due to delays and stuttering.
    *   **High Bandwidth Costs:** Significant traffic over long-haul internet links.

### The Solution: Caching and Netflix Open Connect

To overcome geographic latency and improve user experience on a global scale, Netflix implemented a brilliant strategy based on **caching** and a distributed content delivery network called **Open Connect**.

#### Caching Principle

*   **Concept:** Caching is a fundamental engineering principle where frequently accessed data is stored closer to the user to reduce retrieval time. Instead of re-computing or re-fetching data from its original, distant source every time, a cached copy is served, leading to faster responses.
*   **Analogy:** Imagine a popular book in a library. Instead of everyone requesting it from the central archive across the country, copies are placed in local branches. When you want the book, you get it from your local branch, which is much faster.

#### Netflix Open Connect: Bringing Content Closer

![Screenshot at 00:09:12](notes_screenshots/refined_How_NETFLIX_onboards_new_content：_Video_Processing_at_scale_🎥-(1080p25)_screenshots/frame_00-09-12.jpg)
![Screenshot at 00:09:45](notes_screenshots/refined_How_NETFLIX_onboards_new_content：_Video_Processing_at_scale_🎥-(1080p25)_screenshots/frame_00-09-45.jpg)

Netflix extended the caching concept by partnering directly with **Internet Service Providers (ISPs)** worldwide. They provide ISPs with specialized servers, known as **Open Connect Appliances (OCAs)** or "Open Connect boxes," which are installed directly within the ISP's network infrastructure.

*   **How it Works:**
    1.  **Local Storage:** Each Open Connect box stores a vast library of Netflix content (movies, TV shows) that is popular in that specific region.
    2.  **Local Request Handling:** When a user requests a Netflix movie (e.g., a Bollywood movie in India):
        *   The ISP's network first checks its local Open Connect box.
        *   If the movie (or the relevant chunk) is found there, it is immediately served to the user from the local box.
        *   The request *does not* need to travel all the way to Netflix's central servers in the US.
    3.  **Fallback to Central Servers:** Only if the content is *not* available in the local Open Connect box (e.g., a very niche or brand-new title) will the request be forwarded to Netflix's main data centers.

*   **Benefits of Open Connect:**

    *   **Massively Improved User Experience:** Users experience significantly faster load times and virtually no buffering, as content is delivered from a server literally within their ISP's network, just a few milliseconds away.
    *   **Reduced Bandwidth Costs:** ISPs save enormous amounts of bandwidth because popular Netflix traffic no longer needs to traverse expensive long-distance internet links. This is a win-win, as ISPs benefit from reduced operational costs, making them eager to host these boxes.
    *   **Localized Content:** Open Connect boxes can be pre-loaded with content specifically popular in that region (e.g., local language films), further optimizing content delivery and user relevance.
    *   **Reduced Load on Netflix's Core Infrastructure:** By offloading approximately **90% of all Netflix traffic** to these Open Connect boxes, Netflix's central servers are freed up to handle other critical operations, such as user authentication, personalized recommendations, and managing the content ingestion pipeline.
    *   **Industry Impact:** This model has been so successful that other major content providers, like YouTube (with its "YouTube Red boxes" or Google Global Cache), have adopted similar strategies to improve their own content delivery networks.

#### Content Updates for Open Connect Boxes

*   **Challenge:** While Open Connect boxes store static content, new movies and series are constantly being added to Netflix. These new titles need to be pushed to the distributed boxes.
*   **Solution:** Netflix intelligently manages content updates to these boxes:
    *   **Scheduled Updates:** Updates typically occur during off-peak hours, such as 4 AM local time, when network load and user activity are minimal.
    *   **Push Mechanism:** Netflix's central system determines which new or popular content needs to be added to specific Open Connect boxes and initiates "write operations" to transfer these processed video chunks.
    *   **Fresh Content for Users:** This ensures that local boxes always have the latest and most relevant content, maintaining a seamless experience for users accessing new releases.

**Summary of Netflix's System Design Innovation:**

Netflix's ability to operate at massive scale, serving millions of users globally with high-quality, seamless video, is a testament to its innovative system design. This involves:

*   **Advanced Video Processing:** Using codecs and adaptive resolutions, combined with intelligent chunking (shots and scenes), to prepare content for diverse devices and networks.
*   **Distributed Storage:** Leveraging cost-effective cloud storage like Amazon S3 for the vast content library.
*   **Revolutionary Content Delivery Network:** The **Open Connect program** strategically places content at the edge of the network, directly within ISPs, to drastically reduce latency, improve user experience, and optimize bandwidth for both Netflix and its partners.

This multi-faceted approach, particularly the Open Connect initiative, represents a significant leap in real-world system design for large-scale content delivery.

---

### Conclusion: The Power of System Design at Netflix

![Screenshot at 00:10:40](notes_screenshots/refined_How_NETFLIX_onboards_new_content：_Video_Processing_at_scale_🎥-(1080p25)_screenshots/frame_00-10-40.jpg)

This discussion has highlighted how Netflix leverages innovative system design to deliver a seamless streaming experience globally. The core principle revolves around **bringing content closer to the user** and optimizing every step of the delivery pipeline.

The entire content delivery architecture can be summarized as follows:

```mermaid
graph TD
    subgraph User Interaction
        UserDevice1[Mobile Phone]
        UserDevice2[Computer]
    end

    UserDevice1 --> ISP[Internet Service Provider]
    UserDevice2 --> ISP

    ISP -- "DNS Query" --> AddressRegister[Address Register / DNS]
    AddressRegister -- "Maps to IP" --> FacebookServer[Facebook.com]
    AddressRegister -- "Maps to IP" --> NetflixCentral[Netflix Central Servers]

    subgraph Netflix Content Delivery
        ISP -- "10% of Netflix Traffic (or new content)" --> NetflixCentral
        NetflixCentral -- "Content Updates (e.g., at 4 AM)" --> OpenConnect[Open Connect Appliance (OCA)]
        ISP -- "90% of Netflix Traffic" --> OpenConnect
        OpenConnect -- "Serves Content" --> UserDevice1
        OpenConnect -- "Serves Content" --> UserDevice2
    end

    style NetflixCentral fill:#f9f,stroke:#333,stroke-width:1px
    style OpenConnect fill:#ccf,stroke:#333,stroke-width:1px
    style ISP fill:#bfb,stroke:#333,stroke-width:1px
    style AddressRegister fill:#fcf,stroke:#333,stroke-width:1px
```

**Key Takeaways from Netflix's Approach:**

*   **Content Processing:** Videos are meticulously processed into multiple formats and resolutions, then intelligently chunked (into 'shots' and 'scenes') to optimize for diverse devices and network conditions.
*   **Distributed Storage (Amazon S3):** A vast, cost-effective cloud storage solution ensures all video assets are readily available.
*   **Geographic Optimization (Open Connect):** By deploying Open Connect Appliances directly within ISP networks, Netflix drastically reduces the physical distance data needs to travel. This strategy accounts for approximately **90% of all Netflix traffic**, leading to:
    *   **Superior User Experience:** Faster load times and minimal buffering due to localized content delivery.
    *   **Mutual Benefit:** ISPs save significant bandwidth and costs, making them willing partners in hosting these appliances.
    *   **Localized Content:** Ability to store region-specific popular content closer to the relevant audience.
*   **Intelligent Caching and Updates:** Content is proactively pushed to Open Connect boxes during off-peak hours (e.g., 4 AM) to ensure users always have access to the latest and most popular titles from their local cache.

This comprehensive approach, from content ingestion and processing to highly optimized global delivery, exemplifies how robust system design can solve complex engineering challenges and drive immense scale and user satisfaction in the real world.

---

