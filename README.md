# Phero: Location-Based Community Reporting Tool
*Phero* is a mobile-first application designed to empower citizens to report local infrastructure issues such as potholes, broken streetlights, or vandalism directly to a centralized community feed. By leveraging device hardware and cloud infrastructure, the app allows users to snap a photo of an issue, automatically tag it with geographic coordinates, and track the resolution status in real-time.

## Key Features / Program Structure
* **Program Structure:** The project will utilize an MVC pattern, keeping hardware API calls isolated in controller files away from the visual map and camera views.
* **Hardware Integration:** Seamless capture of photos and precise GPS coordinates.
Interactive Map Feed: A localized map view displaying pins for all reported issues in the surrounding area.
* **Status Tracking Lifecycle:** Robust CRUD operations allowing users to track the progression of their submitted reports.
* **Suggested:** Emergency contact hotline (local authorities)

## Members and Designated Roles
**Frontend & Geospatial Developer** - *Angel May Janiola* <br>
&nbsp; &nbsp; Responsible for building the Flutter reporting screens and integrating the interactive Google Maps interface.

**Backend & Data Architect** - *Matthew Simpas* <br>
&nbsp; &nbsp; Responsible for structuring the NoSQL database to efficiently query geospatial data and managing the storage of high-resolution photo reports.

**Hardware & State Lead** - *Chakinzo Sombito* <br>
&nbsp; &nbsp; Responsible for integrating the device's camera and GPS APIs, handling location permissions, and managing the state flow of submitting a new report to the backend. - chak

**Release & Version Control Manager** - *Sophe Mae Dela Cruz* <br>
&nbsp; &nbsp; Responsible for maintaining the Git workflow across the team, orchestrating app testing across different simulated devices, and ensuring stable versioning during the development lifecycle.
