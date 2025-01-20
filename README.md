MikroTik Networking Automation Script for Centipid

Overview
This script is designed to simplify and automate the configuration of a MikroTik router. It creates an efficient setup for managing both Hotspot and PPPoE services while ensuring flexibility and scalability for network administrators.

Features
- Bridge Creation: Automatically creates a bridge for seamless network integration.
- Interface Renaming: Renames `ether1` to "Internet Source" for easier identification.
- Hotspot Profile: Configures a custom hotspot profile with RADIUS support.
- IP Pools: Defines IP pools for Hotspot and PPPoE users.
- User Management: Prepares the router for user authentication via Hotspot and PPPoE protocols.

 Script Breakdown
1. Bridge Creation:
   - A new bridge named "Centipid Main Bridge" is created for managing traffic.
2. Interface Configuration:
   - Renames the primary interface (`ether1`) for clarity.
3. Hotspot Setup:
   - Creates a hotspot profile with customizable options, including login methods and RADIUS interim updates.
4. IP Pool Definition:
   - Configures IP address ranges for Hotspot and PPPoE clients.
5. Scalability:
   - Easily adaptable to various network environments.

 How to Use
1. Download the script (`new.rsc`).
2. Upload the script to your MikroTik router using WinBox or WebFig.
3. Open the MikroTik terminal and execute the script using: import new.rsc
