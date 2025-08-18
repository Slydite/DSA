# Capacity Planning And Estimation： How Much Data Does Youtube Store Daily？ (1080P24) - Part 1

### Estimation Questions in System Design

![Screenshot at 00:00:00](notes_screenshots/refined_Capacity_Planning_and_Estimation：_How_much_data_does_YouTube_store_daily？-(1080p24)_screenshots/frame_00-00-00.jpg)

Estimation questions are a fundamental part of system design interviews and are broadly applicable in general problem-solving. They evaluate your ability to:
*   **Deconstruct Complex Problems**: Break down a large, seemingly daunting problem into smaller, manageable components.
*   **Make Reasonable Assumptions**: Formulate sensible assumptions when exact data is unavailable. This is critical for moving forward with calculations.
*   **Perform Back-of-the-Envelope Calculations**: Quickly compute approximate values to gauge the scale of a system or resource requirement.
*   **Demonstrate Logical Thinking**: Show a clear, step-by-step thought process rather than just providing a number.

The primary goal is not to arrive at a perfectly accurate numerical answer, but to illustrate your analytical approach and understanding of the influencing factors.

### Case Study: Estimating YouTube's Daily Video Storage Requirements

![Screenshot at 00:00:12](notes_screenshots/refined_Capacity_Planning_and_Estimation：_How_much_data_does_YouTube_store_daily？-(1080p24)_screenshots/frame_00-00-12.jpg)

Let's apply these principles to a common estimation problem: **How much storage does YouTube need per day for newly uploaded video content?**

To tackle this, we'll build our estimate by making a series of informed assumptions and performing calculations. It's essential to articulate each assumption, as they directly influence the final outcome.

#### Step 1: Initial Assumptions & Raw Footage Calculation

![Screenshot at 00:00:36](notes_screenshots/refined_Capacity_Planning_and_Estimation：_How_much_data_does_YouTube_store_daily？-(1080p24)_screenshots/frame_00-00-36.jpg)

1.  **Total YouTube User Base**: Assume YouTube has approximately **1 billion (10^9) active users**.
2.  **Daily Uploader Ratio**: Not every user uploads videos. Let's conservatively estimate that **1 in every 1,000 users uploads a video per day**.
    *   Calculated daily uploaders: 1,000,000,000 users / 1,000 = **1,000,000 uploaders**.
3.  **Average Video Length**: Assume the average length of an uploaded video is **10 minutes**.
    *   Total video minutes uploaded daily: 1,000,000 uploaders * 10 minutes/video = **10,000,000 minutes (10^7 minutes)**.
4.  **Video Size per Minute (Compressed)**:
    *   A typical high-quality 2-hour movie might be around 4 GB. However, YouTube heavily compresses videos for streaming efficiency, especially since the raw, original quality isn't typically offered for download or sale.
    *   Let's assume a 2-hour video, after YouTube's standard compression, occupies about **0.4 GB (400 MB)**.
    *   Converting this to MB per minute:
        *   400 MB / 2 hours = 200 MB per hour.
        *   200 MB / 60 minutes/hour ≈ **3.33 MB per minute**. For simplicity, we'll round this to **3 MB per minute**.

Now, we can calculate the raw storage needed for a single copy of all daily uploads:

*   Total Raw Storage = Total Daily Upload Minutes × Storage per Minute
*   Total Raw Storage = 10^7 minutes × 3 MB/minute = 3 × 10^7 MB = 30,000,000 MB
*   Since 1 TB = 1,000,000 MB, this equates to **30 TB (Terabytes)**.

This 30 TB represents the baseline storage for one version of all new videos uploaded to YouTube in a single day, assuming a compressed quality.

```mermaid
graph TD
    A[Start Estimation] --> B{Assumptions};
    B --> C[Total Users: 1 Billion];
    B --> D[Uploaders Ratio: 1 in 1000];
    B --> E[Avg Video Length: 10 minutes];
    B --> F[Video Size (Compressed): 3 MB/min];

    C & D --> G[Daily Uploaders: 1 Million];
    G & E --> H[Total Daily Upload Minutes: 10 Million];
    H & F --> I[Raw Storage (Single Copy): 30 TB];

    style A fill:#f9f,stroke:#333,stroke-width:1px
    style I fill:#ccf,stroke:#333,stroke-width:1px
```

#### Step 2: Accounting for Redundancy and Multiple Resolutions

The initial 30 TB is a significant underestimate because real-world systems like YouTube must account for data durability and diverse user experiences.

1.  **Data Redundancy (Fault Tolerance and Performance)**:
    *   **Fault Tolerance**: To protect against data loss from hardware failures, natural disasters, or accidental deletion, multiple copies of data are stored. These copies are often replicated across different data centers or geographical regions.
    *   **Performance Enhancement**: Having data copies closer to users (e.g., a copy in Asia and another in North America) reduces latency, leading to faster loading and smoother streaming.
    *   **Assumption**: We'll assume YouTube maintains **3 copies** of each video for redundancy.
    *   Storage with redundancy = 30 TB × 3 = **90 TB**.

2.  **Multiple Video Resolutions**:
    *   When a user uploads a video (e.g., in 720p), YouTube transcodes it into various lower resolutions (e.g., 480p, 360p, 240p, 144p). This allows users with slower internet connections or smaller screens to stream videos efficiently without buffering issues.
    *   While lower resolutions are individually smaller, storing all these versions significantly increases the total storage footprint.
    *   **Relative Size Principle**: If the highest stored resolution (`X`) takes a certain amount of space, lower resolutions might take fractions of that space:
        | Resolution Type | Relative Size (Approx.) |
        | :-------------- | :---------------------- |
        | Original/720p   | `X`                     |
        | 480p            | `X/2`                   |
        | 360p            | `X/4`                   |
        | 240p            | `X/8`                   |
        | 144p            | `X/16`                  |
    *   When summing these fractions (`X + X/2 + X/4 + X/8 + X/16 + ...`), the total approaches `2X`.
    *   **Assumption**: Storing all necessary resolutions effectively **doubles** the storage required compared to just keeping one version.
    *   Storage with multiple resolutions = 90 TB × 2 = **180 TB**.

![Screenshot at 00:02:36](notes_screenshots/refined_Capacity_Planning_and_Estimation：_How_much_data_does_YouTube_store_daily？-(1080p24)_screenshots/frame_00-02-36.jpg)

Therefore, based on our assumptions, YouTube would need approximately **180 TB** (or **0.18 Petabytes**) of storage per day for newly uploaded video content.

```mermaid
graph TD
    I["Raw Storage (Single Copy): 30 TB"] --> J[Redundancy Factor: x3];
    J --> K[Storage with Redundancy: 90 TB];
    K --> L[Multiple Resolutions Factor: x2];
    L --> M[Total Daily Storage: 180 TB (0.18 PB)];

    style I fill:#ccf,stroke:#333,stroke-width:1px
    style M fill:#9cf,stroke:#333,stroke-width:1px
```

#### The Critical Role of Assumptions

The final estimate is highly dependent on the initial assumptions made. It is paramount to:

*   **Explicitly State Assumptions**: Always communicate your assumptions to the interviewer. This transparency demonstrates your thought process and allows for collaborative refinement.
*   **Be Adaptable**: Be ready to modify your assumptions if the interviewer provides different parameters (e.g., a different ratio of uploaders, or a longer average video length).
*   **Understand Impact**: Recognize how changes in assumptions propagate through the calculation. For example, if the initial video size assumption (0.4 GB for 2 hours) was instead 4 GB (the original uncompressed size), the final daily storage would jump to 1.8 PB (an order of magnitude higher).

The true value of an estimation question lies not in the exact numerical answer, but in the logical, structured approach taken to break down the problem and the ability to articulate the factors influencing the outcome.

---

### Acceptable Error Margins in Estimation

When performing estimation questions, the goal is to demonstrate a sound thought process and reasonable assumptions, not perfect numerical accuracy. It's generally acceptable to be off by a factor of 10, or even 100 in some cases, provided your methodology is logical. However, being off by a factor of 1,000 or 10,000 (i.e., multiple orders of magnitude) indicates a fundamental flaw in the calculations or assumptions.

The more accurate your initial assumptions are, the closer your estimate will be to the real-world figure. Interviewers are often looking for your ability to identify key variables and their impact.

#### Refining Assumptions: The Impact of Granularity

Let's revisit the assumption about video size and explore how a different approach, even if more granular, can lead to vastly different results if underlying assumptions are flawed.

**Previous Assumption**: 2 hours of compressed video ≈ 0.4 GB (leading to ~3 MB/minute).

**Alternative (More Granular) Approach**: Treating a video as a sequence of images (frames).
1.  **Video Length**: 1 minute = 60 seconds.
2.  **Frame Rate**: Assume 24 frames per second (FPS). For simpler calculation, let's use 25 FPS.
3.  **Frames per Minute**: 25 frames/second * 60 seconds/minute = 1,500 frames/minute.
4.  **Image (Frame) Size**: Let's make a *hypothetical* assumption that a single high-quality image frame is **1 MB**.
5.  **Calculated Video Size**: 1,500 frames/minute * 1 MB/frame = 1,500 MB/minute = **1.5 GB/minute**.

Comparing this to our previous estimate of 3 MB/minute, 1.5 GB/minute is orders of magnitude larger! This highlights a crucial point: **more detailed assumptions don't necessarily lead to a better estimate if the foundational numbers (like 1 MB per frame) are wildly inaccurate for the context (compressed video).** In reality, video compression is highly efficient, and individual frames are not stored as standalone 1MB images. This extreme example demonstrates how a single incorrect core assumption can derail an entire estimation.

### Caching Strategy: Metadata for User Experience

Beyond storing the raw video footage, YouTube also needs to efficiently serve metadata associated with videos, such as thumbnails and titles. This metadata is crucial for the user interface, enabling features like recommendations, trending lists, and search results to load quickly. Caching this information in fast memory (RAM) is essential for performance.

#### Caching Calculation for Thumbnails

![Screenshot at 00:04:14](notes_screenshots/refined_Capacity_Planning_and_Estimation：_How_much_data_does_YouTube_store_daily？-(1080p24)_screenshots/frame_00-04-14.jpg)

When a user sees a list of videos, they are presented with a **thumbnail** and a **title**.
*   **Thumbnail**: This is an image. It's typically the heavier component compared to the text-based title.
    *   An original, high-resolution thumbnail might be up to 1 MB.
    *   However, for display in a list or recommendation feed, thumbnails are significantly downscaled. If an image is scaled down by a factor of 10 in both width and height, its size is reduced by a factor of 10 * 10 = 100.
    *   **Assumed Cached Thumbnail Size**: 1 MB / 100 = **10 KB**.
*   **Title**: Text-based, usually very small (a few tens to hundreds of bytes at most). We can often ignore this for initial storage estimation compared to thumbnails.

![Screenshot at 00:04:38](notes_screenshots/refined_Capacity_Planning_and_Estimation：_How_much_data_does_YouTube_store_daily？-(1080p24)_screenshots/frame_00-04-38.jpg)

To estimate the total cache size for thumbnails, we need to consider which videos are likely to be accessed frequently and thus should be cached.

1.  **Videos to Cache**: It's not practical or necessary to cache thumbnails for *all* videos ever uploaded. Instead, we cache "popular" videos.
2.  **Definition of "Popular" Videos**: A reasonable approximation for popular videos includes:
    *   Videos uploaded in the last **3 months (90 days)**. These are often trending or recently active.
    *   **Evergreen videos**: Videos that remain popular over long periods (e.g., classic music videos, tutorials). For simplicity in this estimation, we can assume the last 90 days capture a significant portion of what needs to be cached, and evergreen videos might implicitly be covered if they were uploaded recently or fall under a Least Recently Used (LRU) caching strategy.
3.  **Total Daily Uploads**: From our previous calculation, approximately **1 million** videos are uploaded daily.
4.  **Total Popular Videos to Cache**:
    *   90 days * 1,000,000 videos/day = **90,000,000 videos**.
5.  **Total Cache Size for Thumbnails**:
    *   90,000,000 videos * 10 KB/video = 900,000,000 KB
    *   Since 1 TB = 1,000,000,000 KB, this is approximately **0.9 TB** or **900 GB**. We can round this up to **1 TB**.

This 1 TB represents the estimated RAM requirement for caching popular video thumbnails.

#### Hardware Implications for Caching (RAM)

![Screenshot at 00:07:20](notes_screenshots/refined_Capacity_Planning_and_Estimation：_How_much_data_does_YouTube_store_daily？-(1080p24)_screenshots/frame_00-07-20.jpg)

A 1 TB RAM requirement for caching is substantial.
*   **Cost**: RAM is significantly more expensive per GB than disk storage.
*   **Distribution**: A single server typically cannot hold 1 TB of RAM. This implies that the cache must be distributed across **multiple machines**. For instance, if each server has 16 GB of RAM, you would need:
    *   1 TB = 1024 GB
    *   1024 GB / 16 GB/server ≈ **64 servers** dedicated to caching this metadata.

This highlights that even seemingly small data elements like thumbnails, when multiplied by the scale of a platform like YouTube, can lead to significant infrastructure requirements.

---

#### Cache System Node Count and Redundancy

![Screenshot at 00:07:45](notes_screenshots/refined_Capacity_Planning_and_Estimation：_How_much_data_does_YouTube_store_daily？-(1080p24)_screenshots/frame_00-07-45.jpg)
![Screenshot at 00:08:23](notes_screenshots/refined_Capacity_Planning_and_Estimation：_How_much_data_does_YouTube_store_daily？-(1080p24)_screenshots/frame_00-08-23.jpg)

Based on our previous calculation, we need approximately 1 TB of RAM for the thumbnail cache. If we decide to use servers with 16 GB of RAM each:

*   **Number of Cache Nodes (Initial)** = Total Cache Size / RAM per Node
*   Number of Cache Nodes = 1000 GB / 16 GB/node = **62.5 nodes**.
*   We'll round this up to **64 nodes** for practical purposes (e.g., powers of 2 for distributed systems).

However, these 64 nodes represent the *minimum* required capacity. For a robust, production-grade system like YouTube, additional considerations are vital:

1.  **Redundancy**: If a cache node crashes, its cached data becomes unavailable, potentially leading to cascading failures or degraded user experience as requests fall back to slower storage. To prevent this, data is replicated across multiple nodes.
    *   **Goal**: Ensure continuous service even if some nodes fail.
    *   **Benefit**: Improves fault tolerance and global performance (by having data closer to users).
2.  **Peak Capacity and Buffer**: Running a system at 100% capacity leaves no room for spikes in demand or node failures. If one node fails, the load on remaining nodes increases, potentially overwhelming them.
    *   **Strategy**: Operate at a lower capacity (e.g., 50%) to handle failures and traffic surges gracefully. This means you need double the number of nodes than the minimum required.

**Revised Node Count for Cache System**:
*   To account for redundancy and operating at 50% capacity (meaning you need twice the nodes to handle the load if half fail or to simply have buffer capacity), we would double the initial count.
*   Revised Node Count = 64 nodes * 2 (for 50% capacity/redundancy) = **128 nodes**.
*   The speaker approximates this to **500 nodes** for a rough estimate that includes more overhead or a higher redundancy factor (e.g., 3x or more for critical systems, or accounting for geographical distribution). The key is the thought process, not the exact number.

This large number of nodes (e.g., 500 servers each with 16GB RAM) forms the distributed caching system for YouTube's metadata.

```mermaid
graph TD
    A[Total Cache RAM Needed: 1 TB] --> B[RAM per Cache Node: 16 GB];
    B --> C[Initial Nodes (Min): 1000 GB / 16 GB/node = 62.5 ~ 64 Nodes];
    C --> D{Considerations};
    D -- "Redundancy / Fault Tolerance" --> E[Avoid Cascading Failures];
    D -- "Buffer for Peak Load" --> F[Operate at ~50% Capacity];
    E & F --> G[Final Nodes (Approx): 64 * 2 = 128 (or ~500 for more robust estimate)];

    style A fill:#f9f,stroke:#333,stroke-width:1px
    style G fill:#ccf,stroke:#333,stroke-width:1px
```

### Video Processing Requirements: Transcoding and Delivery

Beyond storage, YouTube needs to process and deliver video content. This involves transcoding (converting videos to different resolutions) and ensuring they can be streamed efficiently worldwide.

#### Step 3: Estimating Daily Video Processing Throughput

![Screenshot at 00:11:12](notes_screenshots/refined_Capacity_Planning_and_Estimation：_How_much_data_does_YouTube_store_daily？-(1080p24)_screenshots/frame_00-11-12.jpg)
![Screenshot at 00:11:37](notes_screenshots/refined_Capacity_Planning_and_Estimation：_How_much_data_does_YouTube_store_daily？-(1080p24)_screenshots/frame_00-11-37.jpg)

We need to determine the amount of video data that needs to be *processed* per second.

1.  **Total Daily Video Data (Input)**:
    *   From our initial storage calculation, 10^7 minutes of video are uploaded daily.
    *   Assuming the compressed size of 0.4 GB for 2 hours (or 3 MB/minute), this is 30 TB per day.
    *   Converting 30 TB to GB: 30 * 1024 GB = 30,720 GB (approx 3 * 10^4 GB).
    *   This is the total raw data volume that needs to be ingested and processed *per day*.

2.  **Daily Processing Throughput (MB/second)**:
    *   To find the required throughput, divide the total daily data by the number of seconds in a day.
    *   Seconds in a day = 24 hours * 60 minutes/hour * 60 seconds/minute = 86,400 seconds (approx 8.64 * 10^4 seconds).
    *   Raw processing throughput = (3 * 10^4 GB/day) / (8.64 * 10^4 seconds/day)
    *   Raw processing throughput ≈ 0.347 GB/second ≈ **347 MB/second**.
    *   The speaker rounds this to **40 MB/second** in the transcript, which seems to be a significant difference from 347 MB/s. Let's re-evaluate the speaker's calculation path to align.
        *   Speaker's path: 10^4 / 3 GB of video to be processed in a day. (This `10^4/3 GB` likely comes from `10^7 minutes * (0.4 GB / 120 minutes) = 10^7 * 0.0033 GB = 3.3 * 10^4 GB`. So the `10^4/3 GB` is an approximation of `3.3 * 10^4 GB`.)
        *   Then, `(10^4 / 3 GB) / (24 * 60 * 60 seconds)` = `(10^4 / 3 GB) / 86400 seconds`.
        *   `10000 / (3 * 86400)` GB/sec = `10000 / 259200` GB/sec = `0.0385` GB/sec.
        *   Converting to MB/sec: `0.0385 * 1024` MB/sec ≈ **39.4 MB/sec**.
        *   So, **40 MB/second** is a reasonable approximation for the raw incoming data processing rate.

3.  **Accounting for Multiple Formats & Replications**:
    *   The 40 MB/second is just for the *incoming* raw footage.
    *   However, YouTube transcodes each video into multiple resolutions (which effectively doubles the data, as discussed earlier).
    *   Additionally, these processed videos are replicated across multiple data centers (e.g., 3 data centers for redundancy and global distribution).
    *   Therefore, the actual data processed and moved is much higher.
    *   **Assumption**: Multiply the raw processing by a factor of ~10 (2x for resolutions, ~5x for replication/internal processing overhead).
    *   Global processing throughput = 40 MB/second * 10 = **400 MB/second**.
    *   This 400 MB/second represents the total volume of data that needs to be read, processed (transcoded), and written across YouTube's infrastructure globally, continuously.

#### Step 4: Estimating Processing Time per MB and Total Servers Needed

Processing a video involves several steps:
1.  **Read**: Reading the video data from disk into memory.
2.  **Process**: Performing computations like transcoding, compression, and other video manipulations.
3.  **Write**: Writing the processed video data back to storage (disks or other nodes).

Let's estimate the time taken for each step per MB of data:

1.  **Read Time**: Assume **10 milliseconds (ms)** to read 1 MB of data from disk. (Disk I/O is relatively slow).
2.  **Write Time**: Assume writing is twice as slow as reading, or generally slower than reads.
    *   **Assumed Write Time**: **20 milliseconds (ms)** per MB.
3.  **Processing Time**: This is highly variable and depends on the complexity of the video operations (e.g., transcoding algorithms, CPU power).
    *   **Assumed Processing Time**: **20 milliseconds (ms)** per MB. (This is a simplified assumption for the interview context).

**Total Time to Process 1 MB of Video Data**:
*   Total Time = Read Time + Processing Time + Write Time
*   Total Time = 10 ms + 20 ms + 20 ms = **50 milliseconds (ms) per MB**.

Now, we can calculate the total "workload" in terms of seconds of processing needed per second of real time:

*   Total Workload = (Data to Process per Second) * (Time to Process 1 MB)
*   Total Workload = 400 MB/second * 50 ms/MB
*   Total Workload = 400 * 50 * 10^-3 seconds/second (since 1 ms = 10^-3 seconds)
*   Total Workload = 20,000 * 10^-3 seconds/second = **20 seconds of work per second**.

This "20 seconds of work per second" metric is critical. It means that to handle the continuous influx of 400 MB/second of video data, a single processing unit (if it could achieve 50 ms/MB) would need to perform 20 seconds of processing every real-time second. This is impossible for a single unit.

Therefore, this implies that we need **20 parallel processing units** (or servers/cores) to handle the daily video upload and processing load in real-time. Each of these units would ideally contribute 1 second of processing per second to meet the demand.

This calculation provides a rough estimate of the sheer scale of processing power YouTube requires just for ingesting and preparing new video content.

---

#### Step 5: Determining the Number of Processing Units

![Screenshot at 00:11:50](notes_screenshots/refined_Capacity_Planning_and_Estimation：_How_much_data_does_YouTube_store_daily？-(1080p24)_screenshots/frame_00-11-50.jpg)
![Screenshot at 00:12:10](notes_screenshots/refined_Capacity_Planning_and_Estimation：_How_much_data_does_YouTube_store_daily？-(1080p24)_screenshots/frame_00-12-10.jpg)

Our calculation showed that YouTube needs to perform **20 seconds of work per second** to handle the daily video ingestion and processing load. This is a critical insight:

*   **Meaning**: A single processing unit, working at our assumed `50 ms/MB` rate, cannot keep up with the `400 MB/second` incoming data stream. It would fall 19 seconds behind every second.
*   **Solution: Parallelism**: To meet this continuous demand in real-time, the workload must be distributed across multiple processing units working in parallel.
*   **Number of Processors**: To achieve 20 seconds of work *within* one second of real time, we need at least **20 dedicated processing units** (e.g., servers, or powerful multi-core CPUs) operating concurrently. Each unit would contribute roughly 1 second of processing per real-time second.

While 20 processors might seem like a relatively small number for a global service like YouTube, this calculation is based on many simplifying assumptions. In a real-world scenario, factors like peak load variations, different video complexities, failures, software overhead, and more granular resource allocation (e.g., individual CPU cores rather than entire "processors") would significantly increase this number. The key is the method of arriving at the estimate.

### Key Takeaways from the Estimation Process

This exercise in estimating YouTube's storage and processing needs illustrates a robust approach to tackling large-scale system design problems.

1.  **Decomposition is Key**:
    *   Break down an overwhelming problem (e.g., "YouTube's total storage") into smaller, manageable components (e.g., daily uploads, video size per minute, redundancy, resolutions, processing steps).
    *   This transforms an abstract challenge into a series of calculable sub-problems.

2.  **Strategic Assumption-Making**:
    *   **Necessity**: When exact data is unavailable (which is common in interviews and real-world design), making reasonable assumptions is not just allowed, but required.
    *   **Transparency**: Always state your assumptions clearly to the interviewer. This demonstrates your thought process and allows for discussion and refinement.
    *   **Sensibility**: Assumptions should be grounded in common sense and general knowledge. For instance, assuming a video frame is 1 MB is highly unrealistic for a compressed video, leading to vastly inflated numbers.
    *   **Impact**: Understand how each assumption influences the final result. Being off by a factor of 10 or even 100 might be acceptable, but orders of magnitude (1,000x or 10,000x) indicate a fundamental error in an assumption or calculation.

3.  **Conversion to Familiar Units**:
    *   Translate abstract concepts (like "total storage" or "video processing") into units that relate directly to computer hardware capabilities.
    *   For example, converting total daily video minutes into `MB/second` allows direct comparison with a computer's `read/write/process` speeds (typically measured in milliseconds or seconds). This bridges the gap between high-level requirements and low-level system performance.

4.  **Knowing Fundamental Latencies**:
    *   Familiarity with common hardware performance metrics (e.g., typical disk read/write times, network latencies, CPU operations) is invaluable. These "back-of-the-envelope" numbers help validate assumptions and guide calculations.
    *   For example, knowing that disk reads are in milliseconds (not microseconds or nanoseconds) prevents gross miscalculations.

The ultimate goal of an estimation question is to assess your structured thinking, problem-solving methodology, and ability to reason about system scale, rather than providing a perfectly precise numerical answer.

---

