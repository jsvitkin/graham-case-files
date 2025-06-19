import { execSync } from "child_process";
import { platform } from "os";
import path from "path";
import { fileURLToPath } from "url";

const __dirname = path.dirname(fileURLToPath(import.meta.url));

const isWindows = platform() === "win32";

const scriptPath = isWindows
  ? path.resolve(__dirname, "./sync.ps1")
  : path.resolve(__dirname, "./sync.sh");

try {
  if (!isWindows) {
    console.log("Ensuring sync script is executable...");
    execSync(`chmod +x "${scriptPath}"`);
  }

  console.log("Running sync script...");
  const command = isWindows
    ? `powershell -ExecutionPolicy Bypass -File "${scriptPath}"`
    : `"${scriptPath}"`;

  execSync(command, { stdio: "inherit" });
} catch (err) {
  console.error("Error running sync:", err.message);
  process.exit(1);
}
