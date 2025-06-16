const { execSync } = require("child_process");
const { platform } = require("os");
const path = require("path");

const scriptPath = path.resolve(__dirname, "./sync-vault");

try {
  if (platform() !== "win32") {
    console.log("Ensuring sync-vault is executable...");
    execSync(`chmod +x "${scriptPath}"`);
  }

  console.log("Running sync-vault...");
  execSync(`"${scriptPath}"`, { stdio: "inherit" });
} catch (err) {
  console.error("Error running sync:", err.message);
  process.exit(1);
}