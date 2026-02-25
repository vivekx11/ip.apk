
---
# INSTANT PICK
## Final Year Project Black Book
### Department of Computer Science and Engineering
---

**Project Title:**  
INSTANT PICK - A Location-Based Smart Shop Discovery & Ordering System Using Flutter and Node.js

**Submitted in partial fulfillment of the requirements for the award of the degree of**  
**BACHELOR OF TECHNOLOGY**  
**in**  
**COMPUTER SCIENCE AND ENGINEERING**

---

**Submitted By:**

| Name | Roll Number | Email |
|------|-------------|-------|
| [Student Name 1] | [Roll No. 1] | [email1@example.com] |
| [Student Name 2] | [Roll No. 2] | [email2@example.com] |
| [Student Name 3] | [Roll No. 3] | [email3@example.com] |

---

**Under the Guidance of:**  
[Supervisor Name]  
[Designation]  
Department of Computer Science and Engineering

**Institution:**  
[University/Institution Name]  
[City, State, PIN Code]

**Academic Year:** 2024-2025

---

**Project Duration:** [Start Date] to [End Date]

**GitHub Repository:** [Repository URL]  
**Live Demo:** [Demo URL if available]

---
 
CERTIFICATE

This is to certify that the project report entitled "Design and Development of Instant Pick: A Location-Based Smart Shop Discovery and Ordering System Using Flutter and Node.js" submitted by the following students is a bonafide record of the work carried out by them under my supervision and guidance during the academic year 2024-2025, in partial fulfillment of the requirements for the award of the degree of Bachelor of Technology in Computer Science and Engineering from [University/Institution Name].

The project has not been submitted to any other university or institution for the award of any degree or diploma.

Students	Roll Numbers
[Student 1 Name]	[Roll No. 1]
[Student 2 Name]	[Roll No. 2]
[Student 3 Name]	[Roll No. 3]

Project Guide:

[Supervisor Name]
[Designation]
Department of Computer Science and Engineering
[University/Institution Name]

Head of Department:

[HOD Name]
Department of Computer Science and Engineering
[University/Institution Name]
 
Acknowledgment
We express our sincere and heartfelt gratitude to all those who have contributed to the successful completion of this project titled "Design and Development of Instant Pick: A Location-Based Smart Shop Discovery and Ordering System Using Flutter and Node.js." Without their support, guidance, and encouragement, this endeavour would not have been possible.
First and foremost, we would like to extend our deepest gratitude to our project supervisor, [Supervisor Name], [Designation], Department of Computer Science and Engineering, [University/Institution Name], for the invaluable guidance, constant motivation, constructive feedback, and unwavering support provided throughout every stage of this project. The insightful suggestions and technical expertise of our supervisor were instrumental in shaping the direction and quality of this work.
We would like to express our sincere thanks to [HOD Name], Head of the Department of Computer Science and Engineering, for providing us with the necessary infrastructure, computational resources, and a conducive academic environment to carry out this project effectively.
We are deeply grateful to the faculty members of the Department of Computer Science and Engineering for their encouragement and academic support. The knowledge imparted during our coursework has formed the foundation upon which this project was built.
We extend our appreciation to the library staff and the laboratory technicians who provided timely access to resources, literature, and computing facilities. Their assistance has greatly aided our research and implementation efforts.
We would also like to acknowledge the open-source community for developing and maintaining the frameworks and tools such as Flutter, Dart, Node.js, Express.js, and MongoDB, which served as the backbone of our application. The extensive documentation and community forums provided by these platforms have been indispensable to our learning and development process.
Our sincere thanks go to our fellow students and peers who participated in the user testing and evaluation phase of this project. Their feedback helped us identify areas for improvement and refine the user experience of the application.
Finally, we would like to express our profound gratitude to our families for their unconditional love, moral support, and constant encouragement throughout our academic journey. Their belief in our abilities has been a source of strength and motivation.
This project has been an enriching learning experience, and we are thankful to everyone who has been a part of it in any capacity.

[Student Names]
Department of Computer Science and Engineering
[University/Institution Name]
 
Abstract
The rapid proliferation of smartphones and the ubiquity of mobile internet connectivity have fundamentally transformed the manner in which consumers engage with commercial entities. In the contemporary digital landscape, customers increasingly demand instant, location-aware, and personalized services that bridge the gap between physical retail establishments and the digital economy. However, a significant void exists in the market for a unified platform that enables users to discover nearby shops, browse product catalogues, and place orders from local vendors in real time. Traditional e-commerce platforms are predominantly designed for large-scale retailers and fail to cater to the needs of small and medium-scale local shop owners who constitute a substantial portion of the retail economy.
Instant Pick is a full-stack mobile application developed to address this critical gap. The system is designed to serve as a comprehensive ecosystem that connects three distinct stakeholder groups: customers seeking nearby shops and products, shop owners managing their business operations digitally, and administrators overseeing the overall platform functionality. The application leverages cutting-edge technologies to deliver a seamless, efficient, and scalable user experience.
The frontend of the application is developed using Flutter, Google's open-source UI framework built on the Dart programming language. Flutter enables the development of natively compiled applications for mobile platforms from a single codebase, ensuring consistent user experience across Android and iOS devices. The backend is powered by Node.js with the Express.js framework, providing a fast, event-driven, non-blocking server architecture capable of handling concurrent requests efficiently. MongoDB, a document-oriented NoSQL database, serves as the primary data persistence layer, offering flexibility in schema design and scalability for evolving data requirements.
The core functionality of Instant Pick revolves around geolocation-based shop discovery. Users are able to view shops within a defined radius of their current location using device GPS. The system computes proximity using geographical coordinates stored in the database and presents shops in order of distance from the user. Each shop profile contains detailed information including name, category, operating hours, and contact details, along with a catalogue of available products with images, descriptions, and pricing.
The application implements a robust, role-based authentication and authorization mechanism using JSON Web Tokens (JWT). Three distinct roles are defined within the system: User, Shop Owner, and Admin. Each role is granted specific permissions aligned with its functional scope. User accounts enable browsing, order placement, and order tracking. Shop Owner accounts provide access to a dedicated management dashboard for product listing, inventory management, and order fulfillment. Admin accounts offer full platform oversight including user management, shop verification, and analytics.
Security is a paramount consideration in the design of Instant Pick. Passwords are hashed using the bcrypt algorithm before storage in the database, ensuring that plaintext credentials are never persisted. API endpoints are protected through JWT-based middleware, verifying token validity and role authorization on every protected request. Input validation and sanitization are implemented to prevent common vulnerabilities such as injection attacks.
The database architecture employs a carefully designed schema comprising collections for Users, Shops, Products, and Orders. Relationships between entities are maintained through document references, and indexing is applied on geospatial fields to enable efficient proximity queries using MongoDB's geospatial query operators. The schema design prioritizes both performance and data integrity.
Testing of the application was conducted across multiple dimensions, including unit testing of individual functions and modules, integration testing of API endpoints using Postman, and system-level testing of end-to-end user workflows. The testing phase identified and resolved several edge cases related to geolocation accuracy, session handling, and data validation.
The project demonstrates the feasibility and practical utility of a location-based commerce platform tailored for local retail environments. It contributes to the academic body of knowledge in mobile computing, distributed systems, and RESTful API design. Future enhancements envisioned for the platform include the integration of real-time payment gateways, live order tracking using WebSocket communication, an AI-driven product recommendation engine, and a comprehensive rating and review system to enhance trust and transparency within the platform ecosystem.
In conclusion, Instant Pick represents a well-engineered solution to a real-world problem, delivering practical value to consumers and local businesses alike while adhering to modern software engineering principles and best practices in full-stack mobile application development.
 
Table of Contents


 
List of Figures
Figure No.	Figure Title	Page No.
Figure 5.1	High-Level System Architecture of Instant Pick	XX
Figure 5.2	Frontend Module Architecture (Flutter)	XX
Figure 5.3	Backend Architecture (Node.js / Express.js)	XX
Figure 5.4	Database Architecture (MongoDB Collections)	XX
Figure 7.1	User Module Workflow Diagram	XX
Figure 7.2	Shop Owner Module Workflow Diagram	XX
Figure 7.3	Admin Module Workflow Diagram	XX
Figure 8.1	Entity-Relationship Diagram of Instant Pick	XX
Figure 9.1	RESTful API Endpoint Structure	XX
Figure 9.2	JWT Authentication Flow Diagram	XX
Figure 10.1	API Testing Results using Postman	XX
 
List of Tables
Table No.	Table Title	Page No.
Table 2.1	Comparison of Existing Location-Based and E-Commerce Systems	XX
Table 6.1	Technology Stack Summary for Instant Pick	XX
Table 8.1	User Collection Schema	XX
Table 8.2	Shop Collection Schema	XX
Table 8.3	Product Collection Schema	XX
Table 8.4	Order Collection Schema	XX
Table 9.1	API Endpoint Reference Table	XX
Table 10.1	Unit Test Cases and Results	XX
Table 10.2	API Integration Test Cases	XX
Table 11.1	Security Mechanisms Applied in Instant Pick	XX
 
Chapter 1: Introduction
1.1 Background of the Project
The global retail industry has witnessed a dramatic shift over the past two decades, driven by the exponential growth of digital technologies, mobile computing, and internet infrastructure. Electronic commerce, which once seemed futuristic, has now become an integral component of daily consumer behaviour. Platforms such as Amazon, Flipkart, Swiggy, and Zomato have demonstrated the immense commercial potential of digital ordering systems and have fundamentally altered consumer expectations regarding convenience, speed, and service quality.
However, a critical dimension of retail commerce that has remained largely underserved in the digital transformation is the domain of local, neighbourhood-level commerce. Small and medium-scale retailers, grocery shops, pharmacies, hardware stores, and specialty stores form the backbone of the local economy in cities across India and the world. Despite their economic significance, these establishments have been largely excluded from the digital marketplace due to high barriers to entry, lack of technical expertise, and the absence of platforms specifically tailored to their operational scale.
The advancement of GPS technology and Location-Based Services (LBS) in smartphones has opened new possibilities for hyperlocal commerce. Mobile applications can now accurately determine a user's geographic location and use this information to present contextually relevant information, including nearby businesses and services. This capability, combined with the growing penetration of affordable smartphones and data services, presents an unprecedented opportunity to digitize local commerce at scale.
Instant Pick is conceptualized and developed as a response to this opportunity. It is a full-stack mobile application that uses geolocation technology to connect users with nearby shops, enabling product discovery and order placement in a seamless digital environment. The project seeks to democratize access to digital commerce tools by providing shop owners with an easy-to-use platform for managing their products and orders, while simultaneously delivering a convenient and efficient shopping experience to consumers.
1.2 Need for the System
Despite the rapid growth of digital commerce, a significant segment of the retail market remains disconnected from the digital economy. Local shop owners lack the resources and technical knowledge to build and maintain their own digital presence. Consumers, on the other hand, are often unaware of the range of products and services available at nearby shops and must physically visit multiple locations to find what they need.
The COVID-19 pandemic further underscored the need for digital interfaces that allow consumers to browse and order from local establishments without the need for physical presence. Social distancing norms and mobility restrictions highlighted the vulnerability of businesses that relied solely on walk-in customers. A digital platform that enables remote product browsing and order placement could significantly enhance the resilience and sustainability of local businesses.
Furthermore, existing e-commerce platforms are not optimized for hyperlocal commerce. They impose high commission rates, require extensive onboarding processes, and are designed for large-scale logistics operations rather than the immediate, neighbourhood-level fulfilment that local shops are capable of providing. There is a clear and pressing need for a purpose-built platform that addresses the unique requirements of local retail.
Instant Pick addresses all of these needs by providing a lightweight, mobile-first platform that requires minimal onboarding effort, offers location-aware shop discovery, and supports the full order management lifecycle from browsing to fulfillment.
1.3 Objectives of the Project
The primary objectives of the Instant Pick project are as follows:
•	To design and develop a cross-platform mobile application using Flutter that enables users to discover nearby shops based on their real-time geographic location.
•	To implement a robust backend server using Node.js and Express.js that handles API requests, business logic, authentication, and data management efficiently.
•	To design a flexible and scalable database schema using MongoDB that supports the storage and retrieval of user, shop, product, and order data.
•	To develop a role-based access control system with three distinct user roles: Customer, Shop Owner, and Admin, each with specific permissions and capabilities.
•	To implement secure user authentication and session management using JSON Web Tokens (JWT) and bcrypt password hashing.
•	To provide shop owners with a comprehensive management dashboard for product listing, inventory management, and order processing.
•	To enable customers to browse product catalogues, add items to a cart, and place orders from nearby shops.
•	To develop an admin panel for monitoring user activities, managing shop registrations, and overseeing platform operations.
•	To conduct thorough testing of all modules to ensure functional correctness, security, and performance.
•	To document the design, development, and testing process in accordance with academic and professional standards.
1.4 Scope of the Project
The scope of the Instant Pick project encompasses the design, development, deployment, and testing of a mobile application and its associated backend infrastructure. The following elements fall within the defined scope of this project:
The mobile application is developed for Android and iOS platforms using Flutter, targeting smartphones with GPS capabilities. The application includes screens for user registration and login, location-based shop discovery, product browsing, cart management, order placement, and order history.
The backend system includes RESTful API endpoints for all major operations, including user authentication, shop management, product management, and order processing. The backend is hosted as a Node.js application and communicates with a MongoDB database.
The admin module provides a web-accessible dashboard or mobile interface for platform administrators to monitor user registrations, approve or reject shop listings, and review order data.
The project does not include within its current scope the integration of online payment gateways, real-time GPS-based delivery tracking, in-app chat communication, or machine-learning-based recommendation systems. These features are identified as future enhancements and are discussed in Chapter 12 of this report.
The application has been tested on Android devices and simulators. Full iOS testing is dependent on access to Apple developer accounts and hardware, and is noted as a limitation of the current implementation.
 
Chapter 2: Literature Review
2.1 Introduction to Location-Based Commerce
Location-Based Services (LBS) have evolved significantly since the early days of GPS-enabled mobile devices. The integration of LBS with e-commerce has given rise to a new paradigm known as hyperlocal commerce, where geographic proximity plays a central role in connecting buyers and sellers. Academic research in this domain has explored various dimensions of LBS-enabled commerce, including user behaviour, technology architecture, and business model innovation.
Hazas, Scott, and Krumm (2004) in their foundational work on location-aware computing established the theoretical underpinnings of using geographic context to enhance the utility of software applications. Subsequent research by Barkhuus and Dey (2003) explored the privacy implications and user acceptance of location-sharing in mobile applications, findings that remain relevant to the design of systems such as Instant Pick.
More recent work by Chen, Xu, and Whinston (2011) examined the economic impact of LBS on local retail businesses and found statistically significant evidence that digital proximity-based discovery increases foot traffic and sales at local establishments. These findings provide strong empirical justification for the development of platforms like Instant Pick.
2.2 Study of Existing Systems
2.2.1 Amazon
Amazon is the world's largest e-commerce platform, founded by Jeff Bezos in 1994. The platform operates on a marketplace model, hosting millions of third-party sellers alongside its own retail operations. Amazon's key technological features include a sophisticated recommendation engine powered by collaborative filtering algorithms, one-click ordering, same-day and next-day delivery in select markets, and an extensive fulfillment network.
Amazon's mobile application, available on both Android and iOS, uses location data primarily for delivery address management and logistics optimization rather than for proximity-based shop discovery. The platform is optimized for large-scale, national, and international commerce and does not provide features tailored to local, neighbourhood-level retail. The onboarding process for sellers is complex and time-consuming, presenting a significant barrier for small local retailers.
2.2.2 Flipkart
Flipkart, founded in India in 2007 and subsequently acquired by Walmart, is one of India's leading e-commerce platforms. Similar to Amazon, Flipkart operates a marketplace model and offers a wide range of product categories including electronics, fashion, home goods, and groceries.
Flipkart's mobile application incorporates some location-aware features, particularly in its grocery delivery segment (Flipkart Quick), where same-day delivery from local dark stores is offered in select cities. However, the platform does not provide a general-purpose mechanism for discovering and ordering from arbitrary local shops. The platform's commission structure and operational requirements remain a deterrent for small local retailers.
2.2.3 Swiggy
Swiggy is an Indian online food ordering and delivery platform founded in 2014. It operates in the hyperlocal commerce space, specifically within the food and grocery sector. Swiggy's application uses the user's location to display restaurants and stores within a deliverable radius, making it a directly relevant case study for Instant Pick.
Swiggy's technological architecture is notable for its real-time order tracking feature, which uses GPS data from delivery partners to provide users with live updates on their order status. The platform also features a robust logistics management system for coordinating delivery operations across large geographic areas. Swiggy's success demonstrates the commercial viability of location-based food ordering and has been a significant influence on the design philosophy of Instant Pick.
However, Swiggy is primarily limited to the food and grocery domain and does not extend to other categories of local retail such as hardware, pharmaceuticals, or specialty goods. Additionally, Swiggy's model involves Swiggy managing the delivery logistics, which may not be appropriate for all types of local businesses.
2.2.4 Zomato
Zomato, founded in 2008, began as a restaurant discovery and review platform before expanding into online food ordering and delivery. Similar to Swiggy, Zomato uses location data to present nearby restaurants and facilitates order placement and delivery.
Zomato's application offers several relevant features, including distance-based restaurant sorting, real-time order tracking, in-app customer support, and a rating and review system. The platform has also integrated its Hyperpure supply chain service to provide restaurant ingredients, demonstrating a vertically integrated approach to local commerce.
From a technical standpoint, Zomato's early adoption of microservices architecture and its subsequent transition to more scalable cloud-based infrastructure offer important lessons in system design for high-traffic, location-based applications. Zomato's success in building a trusted local commerce ecosystem has been informative in the conceptualization of Instant Pick.
2.3 Comparative Analysis of Existing Systems
The following table presents a structured comparison of the key features and characteristics of the existing systems studied in this review, evaluated against the functional requirements of Instant Pick.
Feature	Amazon	Flipkart	Swiggy	Zomato	Instant Pick
Location-Based Discovery	Partial	Partial	Yes	Yes	Yes
Local Shop Support	No	No	Yes (Food)	Yes (Food)	Yes (All)
Multi-Category	Yes	Yes	Limited	Limited	Yes
Small Vendor Onboarding	Complex	Complex	Moderate	Moderate	Simple
Role-Based Access	Partial	Partial	Yes	Yes	Yes
Admin Panel	Yes	Yes	Yes	Yes	Yes
Open Source Stack	No	No	No	No	Yes
Flutter / Node.js	No	No	No	No	Yes
2.4 Limitations of Existing Systems
Despite the significant achievements of the platforms studied above, several important limitations have been identified that Instant Pick seeks to address:
First, existing large-scale platforms such as Amazon and Flipkart are not designed with local, neighbourhood-level retail in mind. Their seller onboarding processes, commission structures, and operational requirements are optimized for established businesses with the capacity to handle large order volumes and comply with complex logistical and regulatory requirements.
Second, while Swiggy and Zomato successfully implement hyperlocal commerce, they are domain-specific platforms focused exclusively on the food and grocery sector. There is no comparable platform that extends the hyperlocal model to general retail categories, including pharmaceuticals, hardware, clothing, electronics, stationery, and other commonly sought goods at the local level.
Third, the existing platforms do not prioritize transparency and control for small shop owners. Merchants on these platforms are often subject to algorithm-driven visibility, meaning that shops with higher ratings or advertising budgets are preferentially displayed, disadvantaging smaller operators.
Fourth, the technology stacks employed by these commercial platforms are proprietary and closed-source, limiting the ability of researchers and developers to study, replicate, or build upon their architectures. Instant Pick, by contrast, is built on an entirely open-source technology stack, making it more accessible for academic study and future development.
 
Chapter 3: Existing System
3.1 Overview of Current Working Models
The existing systems for product discovery and ordering can be broadly classified into three categories: centralized e-commerce marketplaces, food delivery platforms, and business directory services. Each of these models has been analyzed in detail to understand their operational mechanisms and identify their shortcomings in the context of local retail commerce.
Centralized e-commerce marketplaces such as Amazon and Flipkart operate by aggregating products from multiple sellers into a unified catalogue. Customers search for products using keyword-based queries, and results are ranked by a combination of relevance scores, seller ratings, and sponsored placement. Geographical proximity between the buyer and seller is considered primarily in the context of delivery time estimation rather than as a primary discovery mechanism.
Food delivery platforms such as Swiggy and Zomato operate on a hyperlocal model where geographical proximity is the primary discovery criterion. Restaurants and stores within a predefined delivery radius are displayed to the user, and orders are fulfilled through a proprietary delivery network. This model is effective for time-sensitive, perishable goods such as food, but is not well-suited for general retail categories that do not require immediate delivery.
Business directory services such as Google Maps, JustDial, and Sulekha provide listings of local businesses and enable users to view contact information, operating hours, and reviews. However, these platforms do not support direct ordering or transaction functionality, requiring users to contact businesses through separate channels to make purchases.
3.2 Problems in Traditional Systems
The traditional systems described above suffer from several significant problems when considered in the context of local retail commerce:
Lack of Discovery Mechanism for Local Shops: Traditional e-commerce platforms do not provide a systematic, location-aware mechanism for discovering local shops. Consumers who wish to find shops near them must resort to general-purpose search engines or business directories, which do not support product browsing or order placement.
High Barriers to Entry for Small Retailers: The seller onboarding processes for major e-commerce platforms are designed for businesses with established supply chains, warehousing capabilities, and technical staff. Small local retailers lack the resources to navigate these requirements, effectively excluding them from the digital marketplace.
Domain Restrictions: Hyperlocal platforms such as Swiggy and Zomato are restricted to the food and grocery domain and cannot be used for ordering from other categories of local retail. This creates a fragmented user experience where consumers must use multiple applications for different types of purchases.
Absence of Integrated Order Management for Local Shops: Local shop owners currently manage orders through manual processes, telephone calls, or informal messaging applications. There is no purpose-built tool that enables local retailers to receive, process, and manage orders digitally and in an organized manner.
Data Silos and Lack of Insights: Because local transactions are managed informally, shop owners lack access to data and analytics that could help them understand sales trends, popular products, and customer preferences. This informational disadvantage limits their ability to make data-driven business decisions.
Insufficient Security in Informal Ordering: Informal ordering mechanisms through messaging applications lack formal authentication, authorization, and data protection mechanisms. This exposes both customers and shop owners to risks related to privacy, fraud, and data loss.
 
Chapter 4: Proposed System
4.1 Overview of Instant Pick
Instant Pick is a comprehensive full-stack mobile application designed to bridge the gap between local retail shops and digital consumers. The system provides a unified platform that serves the distinct needs of three stakeholder groups: customers, shop owners, and administrators. By leveraging location-based services, modern mobile development frameworks, and scalable backend technologies, Instant Pick delivers a seamless and efficient digital commerce experience tailored specifically to the local retail context.
At its core, the application enables registered users to access their device's GPS to determine their current location. The application then queries the backend server to retrieve a list of shops located within a configurable radius of the user's position. Shops are displayed on the interface sorted by proximity, giving users immediate access to the nearest available options. Each shop listing provides comprehensive information including the shop category, contact details, and the full product catalogue.
Shop owners registered on the platform have access to a dedicated management interface that enables them to create and manage their shop profile, add and update product listings, and process incoming orders. The management interface is designed with simplicity in mind, requiring minimal technical knowledge to operate effectively.
The administrator role provides a high-level oversight interface for monitoring platform activity, managing user registrations, verifying and approving shop listings, and reviewing operational data.
4.2 Advantages of the Proposed System
The Instant Pick system offers the following significant advantages over existing solutions:
•	Hyperlocal Discovery: The application provides precise, GPS-based shop discovery, enabling users to find shops within their immediate vicinity without the need for manual searching or navigation.
•	Multi-Category Support: Unlike domain-specific platforms restricted to food or grocery, Instant Pick supports all categories of local retail, providing a unified platform for diverse shopping needs.
•	Simplified Onboarding for Shop Owners: The registration and shop setup process is designed to be completed in minimal time, requiring only basic business information and product details. No technical expertise is required from shop owners.
•	Integrated Order Management: Shop owners receive and manage all orders through a single interface, eliminating the inefficiencies of manual order management through informal channels.
•	Secure Authentication: The use of JWT and bcrypt ensures that user credentials and session data are protected to industry-standard security levels.
•	Cross-Platform Compatibility: The Flutter-based frontend ensures that the application delivers a native-quality user experience on both Android and iOS platforms from a single codebase.
•	Scalable Architecture: The use of Node.js with an event-driven, non-blocking I/O model and MongoDB's flexible document model ensures that the system can scale effectively as the user base and data volume grow.
•	Open-Source Technology Stack: The entire technology stack is open-source, ensuring that the application can be maintained, extended, and audited without proprietary licensing constraints.
4.3 Innovative Features
In addition to its core functionality, Instant Pick incorporates several innovative features that distinguish it from existing solutions:
Geospatial Proximity Querying: The application uses MongoDB's native geospatial indexing and query operators to perform efficient proximity calculations on the server side. This approach is more accurate and computationally efficient than client-side distance calculation, particularly when dealing with large numbers of shop locations.
Role-Based Interface Adaptation: The application's user interface dynamically adapts based on the authenticated user's role. Customers, shop owners, and administrators each see an interface optimized for their specific workflow, reducing cognitive load and improving task efficiency.
Real-Time Order Status Updates: The system implements order status management with distinct states (Pending, Accepted, Processing, Ready, Completed, Cancelled), providing both customers and shop owners with a clear and up-to-date view of the order lifecycle.
Stateless Backend Architecture: The Node.js backend is designed as a stateless REST API, meaning that each request contains all the information necessary for the server to process it. This design choice enhances scalability and simplifies deployment in distributed environments.
 
Chapter 5: System Architecture
5.1 High-Level Architecture
The architecture of Instant Pick follows a three-tier model comprising the Presentation Tier (mobile application), the Logic Tier (backend server), and the Data Tier (database). This classical architectural pattern provides a clear separation of concerns, enabling independent development, testing, and scaling of each tier.
Figure 5.1 depicts the high-level architecture of the Instant Pick system. At the top tier, the Flutter mobile application serves as the primary user interface for all three user roles. The application communicates exclusively with the backend server through a well-defined RESTful API over HTTPS. The backend server, implemented in Node.js with Express.js, receives API requests, executes the relevant business logic, interacts with the MongoDB database, and returns structured JSON responses to the client.
[Figure 5.1: High-Level System Architecture of Instant Pick]
The architecture incorporates several cross-cutting concerns that operate across all tiers. Authentication and authorization are enforced at the API Gateway level using JWT middleware. Input validation is applied on incoming requests before business logic execution. Error handling middleware captures and formats all runtime exceptions for consistent API responses.
Communication between the mobile client and the backend is secured using HTTPS/TLS encryption, ensuring that all data transmitted over the network is protected against interception and man-in-the-middle attacks. The backend server is designed to be stateless, meaning that server instances do not maintain session state between requests, with all session information encoded within the JWT.
5.2 Frontend Architecture (Flutter)
The Flutter frontend is organized according to the Model-View-Controller (MVC) architectural pattern adapted for Flutter's reactive programming model. The codebase is structured into distinct layers corresponding to presentation logic, business logic, and data access.
The Presentation Layer contains all widget trees and UI components. Flutter's widget-based architecture allows UI components to be composed hierarchically, with parent widgets managing the layout and lifecycle of child widgets. Screen-level widgets are separated from reusable component widgets, promoting code reuse and maintainability.
The Business Logic Layer contains the application state management logic. Flutter's state management is implemented using the Provider pattern, which enables reactive data flow between the model and the view. State changes triggered by user actions or incoming API responses are propagated through the widget tree via change notifiers.
The Data Access Layer contains the API service classes responsible for constructing HTTP requests, parsing JSON responses, and handling network errors. The Dart HTTP package is used for executing asynchronous network calls, with error handling implemented through try-catch blocks and custom exception classes.
[Figure 5.2: Frontend Module Architecture (Flutter)]
The Flutter project is organized into the following directory structure: lib/screens for screen-level widgets, lib/widgets for reusable components, lib/models for data model classes, lib/services for API communication classes, lib/providers for state management classes, and lib/utils for utility functions and constants.
5.3 Backend Architecture (Node.js / Express.js)
The backend architecture follows the RESTful API design principles with a layered structure comprising route handlers, middleware, controller functions, and data access objects. This separation ensures that each layer has a single, well-defined responsibility.
The Route Layer defines the URL patterns for all API endpoints and maps them to the corresponding controller functions. Routes are organized by resource type, with separate route files for authentication, users, shops, products, and orders.
The Middleware Layer contains reusable functions that are executed in the request processing pipeline before or after controller functions. Key middleware components include JWT authentication middleware, request logging middleware, input validation middleware, and error handling middleware.
The Controller Layer contains the business logic for each API endpoint. Controllers receive requests from the route layer, validate and process the input, interact with the database through Mongoose models, and return structured JSON responses.
The Model Layer contains the Mongoose schema definitions and model classes for each data entity. Mongoose provides an object-document mapper (ODM) interface that abstracts the MongoDB driver and enables schema-based data validation and type coercion.
[Figure 5.3: Backend Architecture (Node.js / Express.js)]
5.4 Database Architecture (MongoDB)
The database tier is implemented using MongoDB, a document-oriented NoSQL database. MongoDB's flexible schema model is well-suited for the heterogeneous data structures required by Instant Pick, particularly the varying product attributes across different shop categories.
The database is organized into four primary collections: Users, Shops, Products, and Orders. Each collection stores documents in BSON (Binary JSON) format, with each document representing a single entity instance. Documents within a collection may have varying structures, enabling the storage of product-specific attributes without requiring schema migration.
Geospatial indexing is applied on the location fields of the Shops collection using a 2dsphere index, which enables efficient proximity-based queries using MongoDB's $near and $geoWithin operators. This index is critical for the performance of the shop discovery feature, particularly as the number of registered shops grows.
[Figure 5.4: Database Architecture (MongoDB Collections)]
 
Chapter 6: Technologies Used
6.1 Flutter
Flutter is an open-source UI software development kit created by Google. It was first released in May 2017 and reached its stable version 1.0 in December 2018. Flutter enables developers to build natively compiled applications for mobile, web, and desktop platforms from a single Dart codebase. In the context of Instant Pick, Flutter is used exclusively for mobile application development targeting Android and iOS platforms.
Flutter's architecture is built around the concept of widgets, which are the fundamental building blocks of a Flutter application's user interface. Everything in Flutter is a widget, including layout structures, interactive controls, animations, and state management components. Widgets are composed into a widget tree that represents the full UI hierarchy of the application at any given point in time.
Flutter uses the Skia graphics engine (and its successor Impeller on newer platforms) to render UI components directly to the canvas, bypassing the platform's native UI components entirely. This approach ensures visual consistency across platforms and enables Flutter applications to achieve consistently high frame rates. Instant Pick's interface is designed to render at 60 fps on all supported devices.
Key Flutter packages used in Instant Pick include geolocator for accessing device GPS, http for network communication, provider for state management, shared_preferences for local storage of authentication tokens, and flutter_map for displaying map views.
6.2 Dart Programming Language
Dart is an object-oriented, class-based programming language developed by Google. It was first announced in 2011 and has since matured into a powerful language for both client and server-side development. Dart is the primary programming language for Flutter development, and all Flutter application code is written in Dart.
Dart features a strong, statically-typed type system with optional type inference, making code both safe and concise. It supports asynchronous programming through the async/await syntax and the Future and Stream APIs, which are extensively used in Instant Pick for managing asynchronous network requests and event streams.
Dart compiles to native machine code for mobile and desktop targets using the Dart Native compiler, ensuring high performance. For web targets, Dart compiles to JavaScript. The Dart VM is used during development for hot-reload capabilities, which significantly accelerate the development cycle.
6.3 Node.js
Node.js is an open-source, cross-platform, server-side JavaScript runtime environment built on Google Chrome's V8 JavaScript engine. It was created by Ryan Dahl and first released in 2009. Node.js uses an event-driven, non-blocking I/O model, making it particularly well-suited for building scalable network applications that handle a large number of concurrent connections.
The non-blocking architecture of Node.js is particularly advantageous for API servers like the Instant Pick backend, where the majority of operations involve I/O-bound tasks such as database queries and file operations rather than computationally intensive processing. In a traditional synchronous server model, each concurrent request would require a separate thread, leading to high memory consumption and thread management overhead. Node.js handles concurrent requests through an event loop without creating additional threads, enabling efficient resource utilization.
Node.js has a vast ecosystem of open-source packages available through the npm (Node Package Manager) registry. Key npm packages used in the Instant Pick backend include express for HTTP routing and middleware, mongoose for MongoDB object modelling, jsonwebtoken for JWT generation and verification, bcryptjs for password hashing, dotenv for environment variable management, and cors for Cross-Origin Resource Sharing configuration.
6.4 Express.js
Express.js is a minimal and flexible Node.js web application framework that provides a robust set of features for building web and mobile application backends. It is one of the most widely used Node.js frameworks and is a core component of the MERN (MongoDB, Express, React, Node) and MEAN (MongoDB, Express, Angular, Node) stacks.
Express.js simplifies the process of building REST APIs by providing a concise routing API, middleware support, and request and response abstraction utilities. The middleware architecture of Express.js enables developers to compose request processing pipelines from discrete, reusable functions, promoting modularity and separation of concerns.
In Instant Pick, Express.js is used to define all API routes, configure middleware, handle HTTP request parsing, and manage the application lifecycle. The modular routing feature of Express.js allows routes to be organized into separate files by resource type, improving codebase organization and maintainability.
6.5 MongoDB
MongoDB is a source-available, cross-platform document-oriented database management system. It was developed by MongoDB Inc. and first released in 2009. MongoDB classifies itself as a NoSQL database because it does not use the traditional relational table-based data model. Instead, data is stored in flexible, JSON-like documents called BSON (Binary JSON), which can have varying fields and structures.
MongoDB's document model is advantageous for Instant Pick because different shop categories may have different product attribute structures. For example, a pharmacy might store products with dosage and prescription requirement attributes, while a grocery shop might store products with weight and expiry date attributes. MongoDB's flexible schema accommodates these variations without requiring complex schema migrations or multiple tables.
Mongoose is the Object-Document Mapper (ODM) library used to interact with MongoDB from the Node.js backend. Mongoose provides schema validation, type coercion, query building, and middleware hooks, offering a structured approach to MongoDB operations while retaining the flexibility of the underlying document model.
MongoDB's geospatial capabilities are a critical enabler of Instant Pick's shop discovery feature. The 2dsphere index and associated query operators ($near, $geoWithin, $geoIntersects) enable efficient server-side computation of distances between geographic coordinates and filtering of shops based on proximity. These capabilities are available out-of-the-box without requiring external geospatial processing libraries.
6.6 JWT Authentication
JSON Web Token (JWT) is an open standard (RFC 7519) that defines a compact and self-contained way for securely transmitting information between parties as a JSON object. JWTs can be digitally signed using a secret or a public/private key pair, enabling the receiving party to verify the authenticity and integrity of the claims.
In Instant Pick, JWTs are used for stateless authentication and session management. Upon successful login, the backend generates a JWT containing the user's ID, role, and an expiration timestamp. This token is signed with a server-side secret key and returned to the client. For all subsequent authenticated requests, the client includes the JWT in the HTTP Authorization header using the Bearer token scheme.
The authentication middleware on the backend verifies the JWT signature and expiration on every protected request before allowing the request to proceed to the controller. If the token is invalid, expired, or absent, the middleware returns a 401 Unauthorized response. This stateless approach eliminates the need for server-side session storage, enhancing scalability.
The technology stack summary for Instant Pick is presented in the following table:
Component	Technology	Version	Purpose
Frontend	Flutter / Dart	3.x / 3.x	Cross-platform mobile UI
Backend	Node.js	18.x LTS	Server-side runtime
API Framework	Express.js	4.x	HTTP routing & middleware
Database	MongoDB	6.x	Data persistence
ODM	Mongoose	7.x	Object-document mapping
Authentication	JSON Web Token (JWT)	9.x	Stateless auth
Password Hashing	bcryptjs	2.x	Credential security
State Management	Provider (Flutter)	6.x	Reactive state
HTTP Client (Flutter)	http package	1.x	API communication
Geolocation	geolocator (Flutter)	10.x	GPS access
 
Chapter 7: Module Description
7.1 User Module
The User Module encompasses all functionality available to registered customers of the Instant Pick platform. This module represents the primary consumer-facing interface of the application and is designed to provide an intuitive, efficient, and satisfying shopping experience.
7.1.1 User Registration and Authentication
New users can register on the platform by providing their full name, email address, mobile number, and password. The registration form implements client-side validation to ensure all required fields are populated and that the email address and mobile number conform to valid formats. The password must meet minimum complexity requirements, enforced on both the client and server sides.
Upon form submission, the registration request is transmitted to the backend API. The server validates the input, checks for duplicate email or mobile number entries, hashes the password using bcrypt, and persists the new user record to the MongoDB database. A JWT is generated and returned to the client upon successful registration, logging the user in immediately.
Returning users can log in using their registered email address and password. The login endpoint verifies the credentials against the stored bcrypt hash and, upon success, returns a new JWT. The token is stored securely on the device using Flutter's secure storage utilities and is included in the Authorization header of all subsequent authenticated requests.
7.1.2 Location Access and Shop Discovery
The core value proposition of the User Module is the ability to discover nearby shops based on the user's current geographic location. Upon accessing the shop discovery screen, the application requests permission to access the device's location services. Once permission is granted, the geolocator package retrieves the user's current GPS coordinates (latitude and longitude).
These coordinates are transmitted to the backend along with a configurable search radius parameter. The backend executes a MongoDB geospatial query against the Shops collection to retrieve all active shops within the specified radius. The results are returned as a JSON array sorted by proximity and rendered as a list on the discovery screen.
Each shop entry in the list displays the shop name, category, distance from the user's current location, and a brief description. Users can tap on any shop entry to navigate to the full shop profile page, which displays detailed information and the complete product catalogue.
[Figure 7.1: User Module Workflow Diagram]
7.1.3 Product Browsing and Cart Management
The shop profile page presents the shop's complete product catalogue, organized into categories for ease of browsing. Each product listing displays the product name, description, price, and an image. Users can view a full product detail page by tapping on any product entry.
Users can add products to their shopping cart directly from the product listing or detail pages. The cart state is managed locally using the Provider state management pattern, ensuring immediate responsiveness without network round trips. The cart page displays all selected items with their quantities and prices, along with a running total. Users can modify quantities or remove items from the cart before proceeding to checkout.
7.1.4 Order Placement and History
The checkout process involves a review of the order contents, confirmation of the delivery address, and submission of the order to the backend. The backend creates an order record in the database with the status set to Pending and returns the order confirmation details to the client.
Users can access their complete order history from the profile section of the application. Each order entry displays the order date, items ordered, total amount, and current order status. Tapping on an order entry provides a detailed view of the order, including item breakdowns and the shop's contact information.
7.2 Shop Owner Module
The Shop Owner Module provides registered shop owners with a comprehensive set of tools for managing their digital presence on the Instant Pick platform. This module is accessed through the same mobile application as the User Module but presents a distinct interface tailored to the operational needs of shop owners.
7.2.1 Shop Registration and Profile Management
New shop owners register on the platform by providing personal account information followed by detailed shop information, including the shop name, category, address, operating hours, contact details, and geographic coordinates. The geographic coordinates are automatically populated using the device's GPS, ensuring accurate location data. Alternatively, shop owners can manually adjust the location using a map picker interface.
Once submitted, the shop registration is reviewed by a platform administrator before becoming publicly visible on the platform. Upon approval, the shop owner receives a notification and their shop begins appearing in user search results. Shop owners can update their profile information at any time through the profile management screen.
[Figure 7.2: Shop Owner Module Workflow Diagram]
7.2.2 Product Management
The product management interface enables shop owners to create, update, and delete product listings. Adding a new product requires the shop owner to provide the product name, description, price, category, available quantity, and an optional product image.
Product images are uploaded to the server as multipart form data and stored in the server's file system or a cloud storage bucket. The database stores the image URL, which is used by the client application to display the product image. Shop owners can update product details and toggle the availability status of products to indicate whether they are currently in stock.
7.2.3 Order Management
The order management interface presents shop owners with a real-time list of incoming orders for their shop, sorted by creation time. Each order entry displays the customer's name, ordered items, total amount, and current status. Shop owners can update the order status through the defined status progression: Pending to Accepted to Processing to Ready.
The order detail view provides a complete breakdown of the order, including individual item quantities, unit prices, and any special instructions provided by the customer. Shop owners can also contact the customer through the provided contact information if clarification is required.
7.3 Admin Module
The Admin Module provides platform administrators with comprehensive oversight and management capabilities for the entire Instant Pick ecosystem. The admin interface is accessible through the same mobile application, presenting a distinct dashboard upon authentication with admin credentials.
7.3.1 User Management
The user management section provides administrators with a searchable, filterable list of all registered users on the platform. For each user, the admin can view the registration date, account type (User or Shop Owner), and account status (Active or Suspended).
Administrators have the authority to suspend or reactivate user accounts in cases of policy violations or fraudulent activity. Suspended accounts are prevented from authenticating on the platform through a check in the authentication middleware.
[Figure 7.3: Admin Module Workflow Diagram]
7.3.2 Shop Management
The shop management section presents a list of all shop registrations on the platform, including both pending and approved shops. Administrators can review pending shop registrations and either approve or reject them. Approved shops are made publicly visible on the platform, while rejected shops receive a notification with the reason for rejection.
Administrators can also deactivate previously approved shops in cases where the shop owner violates platform policies. Deactivated shops are removed from user search results without deleting the underlying data, enabling potential reactivation in the future.
7.3.3 Analytics and Monitoring
The analytics section provides administrators with aggregate statistics about platform activity, including total registered users, total active shops, total orders placed, and recent activity metrics. These metrics are computed from the database in real time and presented through a summary dashboard.
 
Chapter 8: Database Design
8.1 Entity-Relationship Diagram Explanation
The Entity-Relationship (ER) diagram for the Instant Pick database models the relationships between the four primary entities: User, Shop, Product, and Order. Understanding these relationships is essential for appreciating the data model design and the rationale for the chosen schema structure.
The User entity represents all registered accounts on the platform, encompassing customers, shop owners, and administrators. Each User has a unique identifier, personal information, and a role attribute that determines their access level. The role attribute creates a logical one-to-many relationship between the role concept and users, with multiple users potentially sharing the same role.
The Shop entity represents a registered business on the platform. Each Shop is associated with exactly one User (the shop owner) through a foreign key reference. A User in the Shop Owner role may own multiple shops, creating a one-to-many relationship between User (as owner) and Shop. The Shop entity also stores the geographic location as a GeoJSON point, which is indexed for efficient proximity queries.
The Product entity represents individual items offered for sale by a shop. Each Product belongs to exactly one Shop, creating a one-to-many relationship between Shop and Product. A shop may have many products, but each product belongs to exactly one shop.
The Order entity represents a purchase transaction initiated by a customer. Each Order is associated with one User (the customer) and one Shop (the fulfilling shop). The order contains a list of order items, each referencing a Product and specifying the quantity ordered. This creates a many-to-many relationship between Orders and Products, implemented through the embedded order items array.
[Figure 8.1: Entity-Relationship Diagram of Instant Pick]
8.2 Collections and Schema Explanation
8.2.1 User Collection
The User collection stores all registered accounts on the platform, regardless of role. The schema is designed to be minimal yet comprehensive, capturing all essential user information while avoiding redundancy.
Field	Type	Required	Description
_id	ObjectId	Yes	Auto-generated unique identifier
fullName	String	Yes	Full name of the user
email	String	Yes (Unique)	Email address used for login
mobileNumber	String	Yes (Unique)	Mobile phone number
passwordHash	String	Yes	bcrypt-hashed password
role	String (Enum)	Yes	user | shopOwner | admin
isActive	Boolean	Yes	Account active status
createdAt	Date	Auto	Account creation timestamp
updatedAt	Date	Auto	Last update timestamp
8.2.2 Shop Collection
The Shop collection stores all registered shop profiles. The location field is stored as a GeoJSON Point object to enable MongoDB's geospatial indexing and querying capabilities.
Field	Type	Required	Description
_id	ObjectId	Yes	Auto-generated unique identifier
owner	ObjectId (ref: User)	Yes	Reference to the shop owner's User document
shopName	String	Yes	Name of the shop
category	String	Yes	Shop category (e.g., Grocery, Pharmacy)
description	String	No	Brief shop description
address	String	Yes	Physical address of the shop
location	GeoJSON Point	Yes	{ type: 'Point', coordinates: [lng, lat] }
contactNumber	String	Yes	Shop contact phone number
operatingHours	Object	No	Opening and closing times per day
isApproved	Boolean	Yes	Admin approval status
isActive	Boolean	Yes	Shop visibility status
createdAt	Date	Auto	Registration timestamp
8.2.3 Product Collection
The Product collection stores all product listings associated with registered shops. The flexible schema accommodates product-specific attributes through an optional additionalDetails field stored as a mixed type.
Field	Type	Required	Description
_id	ObjectId	Yes	Auto-generated unique identifier
shop	ObjectId (ref: Shop)	Yes	Reference to the parent Shop document
productName	String	Yes	Name of the product
description	String	No	Detailed product description
price	Number	Yes	Unit price in Indian Rupees
category	String	Yes	Product category within the shop
imageUrl	String	No	URL to the product image
stockQuantity	Number	Yes	Available stock quantity
isAvailable	Boolean	Yes	Product availability status
unit	String	No	Unit of measure (e.g., kg, piece, litre)
createdAt	Date	Auto	Product listing timestamp
8.2.4 Order Collection
The Order collection records all purchase transactions on the platform. The order items are stored as an embedded array of subdocuments, avoiding the need for a separate join collection and enabling efficient retrieval of complete order details.
Field	Type	Required	Description
_id	ObjectId	Yes	Auto-generated unique identifier
customer	ObjectId (ref: User)	Yes	Reference to the ordering User document
shop	ObjectId (ref: Shop)	Yes	Reference to the fulfilling Shop document
items	Array of Objects	Yes	Array of { product, quantity, unitPrice }
totalAmount	Number	Yes	Computed total order amount
status	String (Enum)	Yes	Pending | Accepted | Processing | Ready | Completed | Cancelled
deliveryAddress	String	Yes	Delivery address for the order
notes	String	No	Special instructions from the customer
createdAt	Date	Auto	Order placement timestamp
updatedAt	Date	Auto	Last status update timestamp
 
Chapter 9: Implementation
9.1 Development Process
The development of Instant Pick followed an iterative, agile-inspired methodology. The project was divided into four main development sprints, each focused on a distinct set of functional requirements. This approach enabled progressive delivery of working features and facilitated regular review and feedback cycles.
Sprint 1 focused on project setup and infrastructure. This included initializing the Flutter project with the required dependencies, setting up the Node.js and Express.js backend project structure, configuring the MongoDB Atlas cloud database instance, and establishing the development environment with version control through Git.
Sprint 2 focused on user authentication and the core data model. The user registration and login API endpoints were implemented, along with the JWT authentication middleware. The Mongoose schema definitions for all four primary collections were finalized during this sprint.
Sprint 3 focused on the core business logic, including the shop discovery API with geospatial querying, the product management CRUD endpoints, and the order creation and management endpoints. The Flutter frontend screens for shop discovery, product browsing, and order placement were developed in parallel.
Sprint 4 focused on the admin module, comprehensive testing, security hardening, and final documentation. This sprint also included performance optimization of frequently executed database queries through index analysis and UI refinements based on internal usability testing.
9.2 API Structure
The Instant Pick backend exposes a RESTful API organized into logical resource groups. All endpoints return responses in JSON format. HTTP status codes are used consistently to communicate the outcome of requests: 200 for successful GET requests, 201 for successful POST requests that create resources, 400 for invalid input, 401 for unauthorized access, 403 for forbidden operations, 404 for resource not found, and 500 for server errors.
[Figure 9.1: RESTful API Endpoint Structure]
Method	Endpoint	Auth Required	Description
POST	/api/auth/register	No	Register a new user account
POST	/api/auth/login	No	Authenticate and receive JWT
GET	/api/users/profile	User	Retrieve authenticated user profile
PUT	/api/users/profile	User	Update authenticated user profile
GET	/api/shops/nearby	User	Get shops near coordinates
GET	/api/shops/:id	User	Get specific shop details
POST	/api/shops	ShopOwner	Register a new shop
PUT	/api/shops/:id	ShopOwner	Update shop details
GET	/api/products/shop/:shopId	User	Get all products for a shop
POST	/api/products	ShopOwner	Create a new product
PUT	/api/products/:id	ShopOwner	Update product details
DELETE	/api/products/:id	ShopOwner	Delete a product
POST	/api/orders	User	Place a new order
GET	/api/orders/my	User	Get orders for the authenticated customer
GET	/api/orders/shop	ShopOwner	Get orders for the authenticated shop owner
PUT	/api/orders/:id/status	ShopOwner	Update order status
GET	/api/admin/users	Admin	Get all registered users
PUT	/api/admin/shops/:id/approve	Admin	Approve or reject a shop
9.3 Authentication Flow
The authentication flow in Instant Pick follows the standard JWT Bearer Token pattern. The sequence of operations for a typical authenticated session is described below.
Step 1 - User Login: The user submits their email and password via the login screen. The Flutter application transmits a POST request to the /api/auth/login endpoint with the credentials in the request body.
Step 2 - Credential Verification: The backend controller retrieves the user document matching the provided email. It then uses the bcryptjs compare function to verify the submitted password against the stored hash. If the credentials are invalid, a 401 response is returned.
Step 3 - JWT Generation: Upon successful verification, the backend generates a JWT using the jsonwebtoken library. The token payload includes the user's ID and role. The token is signed with the server's secret key and is configured with an expiration period of 24 hours.
Step 4 - Token Storage: The JWT is returned in the login response body. The Flutter application stores the token using the flutter_secure_storage package, which uses platform-specific secure storage mechanisms (Android Keystore / iOS Keychain) to protect the token from unauthorized access.
Step 5 - Authenticated Requests: For all subsequent requests to protected endpoints, the Flutter application retrieves the stored JWT and attaches it to the HTTP Authorization header in the format: Bearer [token].
Step 6 - Token Verification: The authentication middleware on the backend extracts the Bearer token from the Authorization header, verifies its signature using the server's secret key, checks the expiration time, and extracts the payload. The user's ID and role from the payload are attached to the request object for use by downstream controller functions.
[Figure 9.2: JWT Authentication Flow Diagram]
 
Chapter 10: Testing
10.1 Testing Strategy
The testing strategy for Instant Pick was designed to validate the system at multiple levels of granularity, from individual function units to complete end-to-end user workflows. The testing approach comprised three primary levels: unit testing, API integration testing, and system-level testing.
The primary objective of the testing phase was to identify and resolve defects, verify that all functional requirements have been correctly implemented, and ensure that the system behaves correctly under both normal and edge-case conditions. Testing was conducted iteratively throughout the development process rather than as a single phase at the end, enabling early detection and resolution of issues.
10.2 Unit Testing
Unit testing in Instant Pick focused on testing individual utility functions, data validation logic, and Mongoose model operations in isolation. The Jest testing framework was used for the Node.js backend, providing a rich set of assertion utilities and mocking capabilities.
Key areas covered by unit tests include password hashing and comparison functions, JWT generation and verification utilities, input validation middleware, and geospatial distance calculation utilities. Each unit test verifies the output of a function for a specific set of inputs, including both valid and invalid input scenarios.
Test ID	Component	Test Case	Expected Result	Status
UT-001	Password Hashing	Hash a plaintext password	Returns a 60-char bcrypt hash	Pass
UT-002	Password Verification	Verify correct password against hash	Returns true	Pass
UT-003	Password Verification	Verify incorrect password against hash	Returns false	Pass
UT-004	JWT Generation	Generate token with valid payload	Returns signed JWT string	Pass
UT-005	JWT Verification	Verify valid token	Returns decoded payload	Pass
UT-006	JWT Verification	Verify expired token	Throws TokenExpiredError	Pass
UT-007	Input Validation	Submit email without @ character	Returns validation error	Pass
UT-008	Input Validation	Submit empty required field	Returns required field error	Pass
UT-009	Geolocation	Calculate distance between two coordinates	Returns distance in km	Pass
UT-010	User Model	Create user with duplicate email	Throws MongoServerError (11000)	Pass
10.3 API Testing
API testing was conducted using Postman, a widely used API development and testing platform. A comprehensive collection of API test cases was developed, covering all defined API endpoints with multiple test scenarios per endpoint. The Postman collection was configured with environment variables for the base URL, authentication tokens, and commonly referenced resource IDs, enabling efficient test execution.
API tests verified the correct HTTP status codes, response body structures, and data content for each endpoint. Error scenarios, including missing authentication headers, invalid input data, and unauthorized access attempts, were tested to verify that the API responds with appropriate error messages and status codes.
Test ID	Endpoint	Scenario	Expected Status	Status
AT-001	POST /api/auth/register	Valid registration data	201 Created	Pass
AT-002	POST /api/auth/register	Duplicate email address	409 Conflict	Pass
AT-003	POST /api/auth/login	Valid credentials	200 OK with JWT	Pass
AT-004	POST /api/auth/login	Invalid password	401 Unauthorized	Pass
AT-005	GET /api/shops/nearby	Valid coordinates and radius	200 OK with shop array	Pass
AT-006	GET /api/shops/nearby	No Authorization header	401 Unauthorized	Pass
AT-007	POST /api/shops	Valid shop data as ShopOwner	201 Created	Pass
AT-008	POST /api/shops	User role attempting shop creation	403 Forbidden	Pass
AT-009	POST /api/orders	Valid order with available products	201 Created	Pass
AT-010	PUT /api/orders/:id/status	Status update by order's shop owner	200 OK	Pass
[Figure 10.1: API Testing Results using Postman]
10.4 Integration Testing
Integration testing verified the correct interaction between the various components of the system, including the Flutter frontend, the Node.js backend, and the MongoDB database. End-to-end integration tests simulated complete user workflows from initial registration to order placement and fulfillment.
Key integration test scenarios included the complete user registration and login flow, the shop registration and admin approval workflow, the shop discovery and product browsing workflow, and the complete order placement and status update cycle. Each scenario was executed on an Android device connected to the development backend server, with the database state verified before and after each test to confirm data persistence.
Integration testing identified several issues that were not caught during unit or API testing, including state synchronization problems in the Flutter Provider when navigating between screens, edge cases in the geolocation permission request flow on Android, and race conditions in the order status update when multiple concurrent requests were made.
 
Chapter 11: Security Features
11.1 Overview of Security Design
Security was treated as a first-class concern throughout the design and development of Instant Pick. The system implements multiple layers of security controls spanning authentication, authorization, data protection, and input handling. This defence-in-depth approach ensures that no single vulnerability can compromise the integrity or confidentiality of the entire system.
The security architecture of Instant Pick is guided by several foundational principles: the principle of least privilege, which ensures that each user role has access only to the resources and operations necessary for its function; the principle of defence in depth, which implements multiple security controls at different layers; and the principle of fail-secure, which ensures that the system defaults to a secure state in the event of unexpected errors or conditions.
11.2 Password Encryption with bcrypt
User passwords are protected using the bcrypt cryptographic hashing function. bcrypt is specifically designed for password hashing and incorporates several features that make it particularly resistant to brute-force attacks, including a configurable work factor (cost parameter) that determines the computational cost of the hashing operation.
In Instant Pick, the bcryptjs library is used with a work factor of 12, which is considered appropriately secure for contemporary hardware. At this work factor, a single hash computation takes approximately 250-400 milliseconds on a typical server, making brute-force dictionary attacks computationally infeasible at scale.
bcrypt automatically generates and embeds a random salt value into each hash, ensuring that identical passwords produce different hash values. This property defeats precomputed rainbow table attacks, as the attacker would need to compute a separate rainbow table for each unique salt value.
Password comparison during login is performed using bcryptjs's compare function, which extracts the embedded salt from the stored hash and applies it to the submitted plaintext password before comparing the resulting hash. This ensures that the comparison is performed without exposing the plaintext password in memory beyond the minimum necessary duration.
11.3 JWT Token Security
JSON Web Tokens (JWT) are used for stateless authentication and session management. The security of the JWT implementation in Instant Pick relies on several protective measures.
The JWT secret key is stored as an environment variable (JWT_SECRET) and loaded into the application using the dotenv package. It is never hardcoded in the source code or committed to version control. The secret key is a randomly generated, high-entropy string of at least 256 bits, making it computationally infeasible to guess or brute-force.
Tokens are signed using the HS256 algorithm (HMAC-SHA256), providing a cryptographic guarantee of integrity. Any modification to the token payload after issuance will invalidate the signature, and the verification middleware will reject the tampered token.
All tokens are issued with an expiration time of 24 hours (configurable via the TOKEN_EXPIRY environment variable). Expired tokens are rejected by the verification middleware, limiting the window of opportunity for stolen token exploitation. Token rotation on sensitive operations such as password changes is recommended as a future enhancement.
Tokens are transmitted exclusively over HTTPS, encrypted in transit. On the client side, tokens are stored using platform-level secure storage mechanisms that restrict access to the application's own process.
11.4 Role-Based Access Control
Role-Based Access Control (RBAC) is implemented through a combination of JWT payload claims and server-side authorization middleware. The user's role is embedded in the JWT payload upon login and is verified on every protected request.
Three roles are defined in the system: user, shopOwner, and admin. Role-checking middleware is applied to specific route groups to enforce access control. For example, the route for updating order status is protected by middleware that verifies that the authenticated user has the shopOwner role. Attempting to access this endpoint with a user or admin JWT returns a 403 Forbidden response.
Security Feature	Technology/Method	Purpose
Password Storage	bcrypt (work factor 12)	Prevent credential exposure
Authentication Tokens	JWT (HS256, 24h expiry)	Stateless session management
Transport Security	HTTPS/TLS	Protect data in transit
Secret Management	Environment variables (dotenv)	Prevent credential leakage
Input Validation	express-validator	Prevent injection attacks
Role Authorization	JWT role claims + middleware	Enforce access control
Token Storage (Client)	flutter_secure_storage	Protect tokens on device
Error Handling	Generic error messages	Prevent information disclosure
11.5 Input Validation and Sanitization
All user-supplied input is validated and sanitized on the server side before processing or storage. The express-validator library provides a declarative API for defining validation rules for request body parameters, query parameters, and route parameters.
Validation rules are defined as chains of validator methods applied to each input field. Common validation checks include type verification, format validation (email, phone number), length constraints, and enumeration membership. If any validation check fails, the request is rejected before the controller function is executed, and a detailed validation error response is returned to the client.
Input sanitization, including HTML entity encoding and whitespace trimming, is applied to string inputs to prevent the injection of malicious HTML or script content. MongoDB's Mongoose ODM provides an additional layer of protection through schema-level type coercion, which ensures that values stored in the database conform to the expected data types.
 
Chapter 12: Future Scope
12.1 Overview
The current implementation of Instant Pick represents a solid foundation for a comprehensive hyperlocal commerce platform. While the core functionality of location-based shop discovery, product browsing, and order management has been successfully implemented and tested, several significant enhancements have been identified that would substantially increase the platform's value proposition and commercial viability. These enhancements are documented in this chapter as a roadmap for future development.
12.2 Online Payment Integration
The current version of Instant Pick supports order placement but does not include in-app payment processing, requiring cash-on-delivery or external payment methods. Integrating a digital payment gateway would significantly enhance the user experience by enabling seamless, cashless transactions directly within the application.
The integration of payment gateways such as Razorpay, Stripe, or PayU would involve implementing secure payment flows that comply with PCI DSS (Payment Card Industry Data Security Standard) requirements. The backend would need to generate payment order identifiers, handle payment status webhooks from the payment gateway, and update the order status upon successful payment confirmation.
Wallet functionality, enabling users to maintain a balance within the application for rapid checkout, could also be implemented as an extension of the payment integration. UPI (Unified Payments Interface) integration, which is widely adopted in India, would be particularly valuable for the target market.
12.3 Live Order Tracking
Real-time order tracking, a feature popularized by food delivery platforms, would greatly enhance the post-order experience for customers. Implementing live tracking would involve integrating GPS data from delivery personnel or shop owners and transmitting location updates to the customer's application in real time.
WebSocket-based communication, using technologies such as Socket.io for Node.js, would enable bidirectional, low-latency data transmission between the backend and client applications. The customer's application would display the delivery person's current location on a map and provide an estimated time of arrival based on route computation.
This feature would require the development of a dedicated delivery personnel interface, logistics management capabilities on the backend, and significant enhancements to the database schema to support real-time location tracking data. The implementation would also need to address battery consumption considerations on mobile devices used by delivery personnel.
12.4 Rating and Review System
A comprehensive rating and review system would enhance trust and transparency within the Instant Pick ecosystem. Users who have completed an order would be prompted to provide a rating (on a 1-5 star scale) and an optional written review for the shop and specific products ordered.
The rating system would display aggregated ratings on shop profile pages, enabling prospective customers to make more informed decisions. A robust review moderation system, including automated flagging of potentially inappropriate content and admin review capabilities, would be essential for maintaining the quality and reliability of the review data.
The implementation would involve adding rating and review collections to the database, implementing a post-order rating prompt in the Flutter application, and developing review display components for shop and product pages. Statistical analysis of review sentiment using natural language processing could be implemented as a more advanced enhancement.
12.5 AI-Powered Recommendations
Integrating an artificial intelligence-based recommendation engine would enable Instant Pick to deliver personalized product and shop suggestions tailored to each user's preferences and behaviour. Recommendation algorithms could be implemented using collaborative filtering, content-based filtering, or hybrid approaches.
Collaborative filtering algorithms identify patterns in user behaviour data (such as order history and browsing patterns) to identify users with similar preferences and recommend items or shops that similar users have engaged with. Content-based filtering recommends items with similar attributes to those the user has previously purchased or viewed.
The implementation of a recommendation engine would require collecting and processing user behaviour data (with appropriate privacy disclosures and consent mechanisms), training machine learning models using frameworks such as TensorFlow or scikit-learn, and exposing recommendation APIs that can be called by the Flutter application. Model training would be performed offline using batch data, with the trained model deployed on the backend for real-time inference.
12.6 Advanced Analytics Dashboard
Enhancing the admin module with a comprehensive analytics dashboard would provide valuable insights into platform performance and user behaviour. Advanced analytics could include revenue trend analysis, user acquisition and retention metrics, geographic heat maps showing shop density and order volume by location, product popularity rankings, and performance benchmarking for individual shops.
Data visualization libraries such as Chart.js or D3.js could be used for building an interactive web-based dashboard accessible to administrators. Alternatively, the Flutter application could be extended with charting widgets using packages such as fl_chart.
12.7 Multi-Language and Localization Support
Expanding the application to support multiple Indian regional languages would significantly broaden its accessibility and appeal across diverse linguistic communities. Flutter's built-in internationalization (i18n) support through the intl package enables the localization of all user-facing text, date formats, currency representations, and directional layouts.
Supporting languages such as Hindi, Marathi, Tamil, Telugu, Kannada, and Bengali, in addition to English, would enable the platform to serve a far larger population of potential users and shop owners who are more comfortable with their native languages.
 
Chapter 13: Conclusion
13.1 Summary of Achievements
This project has successfully designed and developed Instant Pick, a full-stack mobile application for location-based smart shop discovery and ordering. The project has demonstrated the feasibility and practical utility of combining modern mobile development technologies, server-side JavaScript frameworks, and document-oriented database systems to address a real-world problem in the local retail commerce domain.
The core objectives of the project have been achieved. A cross-platform mobile application has been developed using Flutter, delivering a consistent and responsive user experience on Android devices from a single Dart codebase. A scalable and secure RESTful API backend has been implemented using Node.js and Express.js, efficiently handling concurrent requests and providing well-structured endpoints for all system operations.
The MongoDB database, configured with geospatial indexing on the Shops collection, enables efficient proximity-based shop discovery within configurable radius parameters. This capability is the central differentiating feature of Instant Pick and has been implemented using MongoDB's native geospatial operators, avoiding the need for external geospatial processing libraries.
A robust security architecture has been implemented, incorporating bcrypt password hashing, JWT-based stateless authentication, role-based access control, input validation, and transport-layer encryption. These security measures collectively ensure the confidentiality, integrity, and availability of user data and system operations.
Three distinct user roles have been implemented with purpose-built interfaces: the Customer role for product discovery and ordering, the Shop Owner role for business management and order fulfilment, and the Admin role for platform oversight and governance. Each role's interface has been designed to align with its specific operational needs and permissions.
13.2 Technical Contributions
From a technical standpoint, this project makes several contributions to the understanding and practice of full-stack mobile application development. The integration of Flutter's reactive widget architecture with a RESTful Node.js backend demonstrates effective patterns for client-server communication in mobile applications. The use of the Provider state management pattern for managing complex, multi-level application state in Flutter has been thoroughly demonstrated across the application's various modules.
The design of the MongoDB schema, particularly the use of embedded subdocuments for order items and the GeoJSON-based location representation for shops, illustrates effective schema design patterns for document databases in commerce applications. The implementation of geospatial indexing and query optimization provides a practical example of leveraging MongoDB's advanced indexing capabilities for performance-critical operations.
The layered backend architecture, with clear separation between routing, middleware, controller, and model layers, demonstrates the application of software engineering principles such as separation of concerns, single responsibility, and dependency inversion to Node.js API development.
13.3 Challenges Encountered and Lessons Learned
The development of Instant Pick presented several technical challenges that were resolved through research, experimentation, and iterative refinement. Managing asynchronous state in Flutter, particularly when multiple concurrent API requests were in flight, required careful consideration of state management patterns and the use of FutureBuilder and StreamBuilder widgets to handle loading, success, and error states gracefully.
Implementing accurate geospatial proximity queries required a thorough understanding of MongoDB's 2dsphere indexing requirements, including the correct specification of the GeoJSON coordinate format (longitude followed by latitude, which differs from the conventional latitude/longitude notation) and the units used for distance parameters in the $near operator.
Cross-Origin Resource Sharing (CORS) configuration on the Express.js backend required careful attention during the development phase when the Flutter application was tested against a locally running server. Understanding and correctly configuring CORS policies was an important practical lesson in web API development.
13.4 Final Remarks
Instant Pick represents a significant and meaningful contribution to the ongoing effort to digitize local retail commerce in India and beyond. By providing a platform that is accessible to small and medium-scale shop owners while delivering genuine value to consumers through location-aware product discovery, the application addresses a real and underserved need in the market.
The project has provided its developers with invaluable hands-on experience in full-stack mobile development, encompassing the full spectrum of activities from requirements analysis and system design through implementation, testing, and documentation. The knowledge and skills acquired through this project provide a strong foundation for professional software engineering practice.
It is the sincere hope of the project team that Instant Pick, in its current form and through future enhancements, will contribute to the economic empowerment of local businesses and the convenience of consumers, fostering a more connected, efficient, and inclusive local economy.
 
References
[1] Hazas, M., Scott, J., and Krumm, J. (2004). Location-Aware Computing Comes of Age. IEEE Computer, 37(2), 95-97.
[2] Barkhuus, L., and Dey, A. (2003). Location-Based Services for Mobile Telephony: A Study of User's Privacy Concerns. IFIP TC13 International Conference on Human-Computer Interaction (INTERACT).
[3] Chen, Y., Xu, H., and Whinston, A. (2011). Hyperlocal Commerce and the Digital Transformation of Small Retailers. Journal of Electronic Commerce Research, 12(4), 251-268.
[4] Fowler, M. (2002). Patterns of Enterprise Application Architecture. Addison-Wesley Professional.
[5] Newman, S. (2015). Building Microservices: Designing Fine-Grained Systems. O'Reilly Media.
[6] Flutter Documentation. Google LLC. (2024). Retrieved from https://flutter.dev/docs
[7] Node.js Documentation. OpenJS Foundation. (2024). Retrieved from https://nodejs.org/en/docs
[8] MongoDB Documentation. MongoDB Inc. (2024). Retrieved from https://docs.mongodb.com
[9] Express.js Documentation. OpenJS Foundation. (2024). Retrieved from https://expressjs.com
[10] Jones, M., Bradley, J., and Sakimura, N. (2015). JSON Web Token (JWT). RFC 7519. Internet Engineering Task Force (IETF).
[11] Provos, N., and Mazieres, D. (1999). A Future-Adaptable Password Scheme. USENIX Annual Technical Conference. Freenix Track.
[12] Fielding, R. T. (2000). Architectural Styles and the Design of Network-based Software Architectures. Doctoral Dissertation. University of California, Irvine.
[13] Leler, W. (2017). Why Flutter uses Dart. Hackernoon. Retrieved from https://hackernoon.com
[14] Tilkov, S., and Vinoski, S. (2010). Node.js: Using JavaScript to Build High-Performance Network Programs. IEEE Internet Computing, 14(6), 80-83.
[15] Chodorow, K. (2013). MongoDB: The Definitive Guide (2nd Edition). O'Reilly Media.
