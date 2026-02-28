# Ashu_eggs - GEMINI Context

This project is a comprehensive collection of custom **Pterodactyl, Pelican, and Jexactyl eggs** developed by [@Ashu](https://github.com/Ashu11-A). It provides a standardized way to deploy and manage various services like VPNs, proxies, software, and games within a Pterodactyl-based panel.

## 🏗️ Project Overview

Ashu_eggs uses a modular architecture to simplify the maintenance and update process of Pterodactyl eggs. Instead of embedding all logic within the egg's JSON file, most of the execution logic is offloaded to external Bash scripts hosted in the repository.

### Key Technologies
- **Pterodactyl Egg Format (JSON):** Standard format for importing services into Pterodactyl.
- **Bash Scripting:** used for installation (`install.sh`), startup (`start.sh`), and launch logic.
- **Internationalization (i18n):** Support for multiple languages (English and Portuguese) using a custom `.conf` based system.
- **Docker:** Services run in optimized Docker containers (mostly Alpine-based).

## 📂 Directory Structure

- **`Eggs/`**: Contains the JSON definitions for the eggs, organized by language (`en`, `pt-BR`) and category (`games`, `proxies`, `software`).
- **`Connect/`**: Contains the core Bash scripts that the eggs execute during installation and runtime.
- **`Lang/`**: Localization files (`.conf`) containing translated strings for the scripts.
- **`Utils/`**: Shared utility scripts for common tasks (e.g., `lang.sh`, `toml.sh`).
- **`Archived/`**: Repository for older or deprecated eggs and scripts.

## 🛠️ Development Workflow

### Adding/Updating an Egg
1.  **JSON Definition**: Create or modify the egg JSON in `Eggs/`. Ensure the `installation` and `startup` commands point to the correct scripts in `Connect/` (usually via `curl` to the `main` branch).
2.  **Scripts**: Implement or update the installation and startup logic in `Connect/`.
3.  **Localization**: Add or update strings in the relevant `Lang/*.conf` files. Use `Utils/lang.sh` in your scripts to load these strings.
4.  **Testing**: Import the JSON into a Pterodactyl panel and verify the installation and startup process.

### Script Conventions
- **Architecture Detection**: Always detect the architecture (`uname -m`) to support both AMD64 and ARM64 where possible.
- **Version Management**: Use environment variables (like `VERSION` or `SERVICE_VERSION`) to allow users to specify which version to install. Implement version normalization (e.g., removing dots) if the service requires it.
- **User Feedback**: Use localized strings for all output to maintain multi-language support.
- **Auxiliary Scripts**: Save auxiliary or temporary scripts (like `lang.sh`) in `/tmp/` to avoid cluttering the server's root directory (e.g., `curl ... -o /tmp/lang.sh`).
- **Modular Architecture (Terraria Standard)**: For complex services, split the logic into separate scripts:
    - **`start.sh`**: The main entry point. Sets up the environment (i18n), checks for the existence of the executable, and delegates to either `install.sh` (if missing) or `launch.sh` (if present).
    - **`install.sh`**: Handles binary acquisition, extraction, and initial configuration.
    - **`launch.sh`**: Final execution logic. Use Bash arrays (`"${params[@]}"`) for parameters to handle spaces and empty values safely.
- **Logging & Diagnostics**:
    - Maintain a `logs/` folder.
    - Use `logs/language.conf` to persist the selected language.
    - Create `logs/run.log` or similar to store installation metadata (Version, Download Link, etc.).
    - Use `tee logs/terminal.log` during installation to capture output for debugging.

## 🚀 Key Commands & Usage

- **Importing an Egg**: Go to your Pterodactyl Admin Panel -> Nests -> Import Egg, and select a JSON file from the `Eggs/` directory.
- **Local Script Testing**: You can test individual scripts by running them in a Docker container that mimics the egg's environment:
  ```bash
  docker run --rm -it -v $(pwd):/mnt/server ashu11-a/installers:alpine bash
  ```
- **Fmt Utility**: Use `Utils/fmt.sh` if provided for formatting scripts (check file content for specific usage).

## 📝 Usage for Gemini
When assisting with this project, focus on maintaining the separation between the egg JSON and the Bash scripts. Ensure that any new features or bug fixes respect the internationalization system and architecture-agnostic approach.
