# Game Dev with Zig and Raylib

Game development practices with Zig programming language and [Raylib](https://github.com/raylib-zig/raylib-zig) binding.

## Development Environment

| **Operating System** | **Zig Version** | **Raylib Binding Version** |
|------------------|-------------|------------------------|
| Windows 11       | 0.15.1      | devel                  |

## Games

| **Game Name**      | **Description**                      | **Zig Version**      |
|--------------------|--------------------------------------|----------------------|
| Space Invaders     | Classic Space Invaders game remake   | 0.15.1               |
| Blocks             | Memory matching blocks game          | 0.15.1               |

## Setup

To set up a Zig development environment with Raylib binding, follow these steps:

1. **Install Zig**: Download and install the latest version of Zig from the [official website](https://ziglang.org/download/) or use a package manager like Chocolatey for Windows:
   ```bash
   choco install zig
   ```
2. **Create a new Zig project**:
   ```bash
   mkdir game-name
   cd game-name
   zig init
   ```
3. **Add Raylib binding**:
    ```bash
    zig fetch --save git+https://github.com/raylib-zig/raylib-zig#devel
    ```
4. **Build and run your project**:
    ```bash
    zig build run
    ```

## Resources

- [Raylib Cheetsheet](https://www.raylib.com/cheatsheet/cheatsheet.html)
