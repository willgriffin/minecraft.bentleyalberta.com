# **Product Requirements Document (PRD): Minecraft GitOps Realm**

## **1\. Project Overview**

The goal is to create a fully automated, reproducible, and scalable Minecraft server infrastructure at **minecraft.bentleyalberta.com**. This project utilizes **GitOps (FluxCD)**, **Kubernetes**, and **Nix** to manage a multi-server network that bridges Java and Bedrock (Switch/Console) players, featuring a high-extensibility JavaScript/TypeScript logic layer.

## **2\. Target Audience**

* DevOps Engineers who want an enterprise-grade, Git-driven gaming infrastructure.  
* Players across all platforms (**Java PC, Mobile, and Console/Switch**) who desire a unified experience.

## **3\. Technical Stack**

* **Infrastructure:** Kubernetes (K8s) with NGINX Ingress.  
* **Proxy Layer:** **Velocity** (Java-based) \+ **Geyser** \+ **Floodgate**.  
* **Server Software:** **Fabric** (latest stable) with **GraalJS**.  
* **Automation:** FluxCD (Deployment) and Nix (OCI Image Building).  
* **CI/CD:** GitHub Actions with **Nix-installer** and **Attic** (Nix Binary Cache).  
* **Identity:** **Dummy Account Strategy** for Console/Switch joining.

## **4\. Functional Requirements**

### **4.1 Networking & Routing ("The Bentley Protocol")**

* **Primary Domain:** minecraft.bentleyalberta.com  
* **Proxy Entry Point:**  
  * **Java (TCP 25565):** Standard routing via Velocity.  
  * **Bedrock (UDP 19132):** Translation via Geyser.  
* **Console Access:** Support for "Friend-based" joining via a dedicated Microsoft Dummy Account.

### **4.2 The JavaScript "Crazy" Layer**

* **Requirement:** Support for hot-reloading JS/TS logic (LLMs, Economy, Custom Events).  
* **Implementation:** GraalJS engine integrated into Fabric. Scripts are synchronized from the /scripts Git directory to a dedicated volume mount.

### **4.3 Multi-Server Sync**

* **Data Persistence:** Shared PostgreSQL instance for Floodgate linking, Global Inventories, and NPC memory.

## **5\. Security & Image Architecture (Nix Minimalist Spec)**

### **5.1 Distroless Nix Images**

* **Requirement:** Reduce attack surface by removing all non-essential binaries (sh, bash, coreutils).  
* **Implementation:** \* Use pkgs.dockerTools.buildLayeredImage.  
  * **Contents:** Only the OpenJDK JRE, specific CA certificates, and the Minecraft JARs.  
  * **User:** Image must default to a non-root user (UID 1000).  
  * **Filesystem:** Read-only root filesystem enforced via Kubernetes SecurityContext.

### **5.2 RCON & Admin Security**

* **Access:** RCON is restricted to ClusterIP. Admin panels (RCON Web / Script Console) are protected by OAuth2-Proxy via GitHub SSO.

## **6\. CI/CD Pipeline (Zero-Manual Maintenance)**

### **6.1 Automated Image Updates**

* **Trigger:** Push to main or a scheduled "Update Check" workflow.  
* **Action:**  
  1. GitHub Action initializes Nix with **Magic Nix Cache**.  
  2. Nix builds the OCI image (recalculating hashes for Fabric, Velocity, and all .jar mods).  
  3. Image is pushed to GitHub Container Registry (GHCR).  
  4. FluxCD detects the new image tag and performs a rolling update.

### **6.2 Plugin/Mod Version Tracking**

* **Implementation:** Use a lock.json or Nix Flake lockfile for all plugins.  
* **Automation:** A weekly GitHub Action checks for new versions of Fabric, Geyser, and pinned mods. If updates are found, it opens a Pull Request with updated hashes.

### **6.3 Resource Pack Pipeline**

* **Automation:**  
  1. GHA detects changes in the /resourcepack directory.  
  2. Action zips the pack and uploads it to an S3 bucket (or GH Pages).  
  3. Action calculates the **SHA-1 hash** of the new zip and updates the HelmRelease YAML via a commit.  
  4. Flux applies the new hash, triggering Minecraft to force-update the pack for all players (including Switch).

## **7\. Project Structure**

.  
├── .github/workflows/  
│   ├── build-images.yaml      \# Nix OCI build & push  
│   └── update-mods.yaml       \# Weekly dependency update check  
├── clusters/  
│   └── production/            \# Flux CD manifests  
├── scripts/                   \# Hot-reloadable JS/TS logic  
└── images/  
    └── server/  
        ├── flake.nix          \# Minimal distroless image definition  
        └── mods.nix           \# Pinned mod hashes

## **8\. Success Criteria**

1. **Zero Manual SSH:** All updates (Mods, Java, Logic) are triggered by Git commits.  
2. **Minimal Image:** The production server image contains zero shell binaries.  
3. **Automated Cache Busting:** Resource pack changes are immediately recognized by clients.  
4. **Resilience:** The proxy handles Bedrock translation and Java routing seamlessly under a single domain.