// The module 'vscode' contains the VS Code extensibility API
// Import the module and reference it with the alias vscode in your code below
const vscode = require("vscode");
const { exec } = require("child_process");
const path = require("path");
const fs = require("fs");

function pascalToSnake(str) {
    // Split the string into an array of characters
    const chars = str.split('');

    // Map over the characters, inserting underscores before uppercase letters
    const modifiedChars = chars.map((char, index) => {
        // Check if the character is an uppercase letter and not the first character
        if (char === char.toUpperCase() && char!== char.toLowerCase() && index > 0) {
            return '_' + char;
        }
        return char;
    });

    // Join the characters back into a string and convert to lowercase
    const snakeCaseStr = modifiedChars.join('').toLowerCase();

    return snakeCaseStr;
}

// This method is called when your extension is activated
// Your extension is activated the very first time the command is executed

/**
 * @param {vscode.ExtensionContext} context
 */
function activate(context) {
  // Use the console to output diagnostic information (console.log) and errors (console.error)
  // This line of code will only be executed once when your extension is activated
  console.log('Congratulations, your extension "dartmodelgenerator" is now active!');

  // The command has been defined in the package.json file
  // Now provide the implementation of the command with  registerCommand
  // The commandId parameter must match the command field in package.json
  const disposable = vscode.commands.registerCommand("dartmodelgenerator.helloWorld", function () {
    // The code you place here will be executed every time your command is executed

    // Display a message box to the user
    vscode.window.showInformationMessage("Hello World from DartModelGenerator!");
  });

  const disposable2 = vscode.commands.registerCommand("dartmodelgenerator.generateModel", async function () {
    if (!vscode.workspace.workspaceFolders || vscode.workspace.workspaceFolders.length === 0) {
      vscode.window.showInformationMessage("No project folder is opened.");
      return;
    }

    // Get the active text editor
    let editor = vscode.window.activeTextEditor;
    if (!editor) {
      vscode.window.showInformationMessage("No active editor found!");
      return;
    }

    // Get the content of the active text editor
    let document = editor.document;
    let content = document.getText();

    // Write the content to a temporary file
    const tempFilePath = path.join(context.extensionPath, "scripts", "request.json");
    fs.writeFileSync(tempFilePath, content);

    const userInput = await vscode.window.showInputBox({
      prompt: "Enter class name"
    });

    if (userInput === undefined) {
      vscode.window.showInformationMessage("No class name provided.");
      return;
    }

    // Get the path of the currently open Python file
    const pythonFilePath = path.join(context.extensionPath, "scripts", "main.py");
    // Run the Python file with the path to the temporary file as an argument
    exec(`python "${pythonFilePath}" "${tempFilePath}" "${userInput}"`, async (error, stdout, stderr) => {
      // Clean up the temporary file
      fs.unlinkSync(tempFilePath);

      if (error) {
        vscode.window.showErrorMessage(`Error: ${stderr}`);
        return;
      }
      // Create the GeneratedModel folder inside the workspace if it doesn't exist
      const workspaceFolder = vscode.workspace.workspaceFolders[0].uri.fsPath;
      const generatedModelFolder = path.join(workspaceFolder, "__generated_model");
      if (!fs.existsSync(generatedModelFolder)) {
        fs.mkdirSync(generatedModelFolder);
      }

      // Save the output to a file inside the GeneratedModel folder
      const outputFilePath = path.join(generatedModelFolder, `${pascalToSnake(userInput)}.dart`);
      fs.writeFileSync(outputFilePath, stdout);

      // Show a message that the output was saved
      vscode.window.showInformationMessage(`Output saved to ${outputFilePath}`);

      // Open the output file in a new editor tab
      vscode.workspace.openTextDocument(outputFilePath).then((doc) => {
        vscode.window.showTextDocument(doc);
      });
    });

    vscode.window.showInformationMessage("Started Generating DartModelGenerator!" + pythonFilePath);
  });

  context.subscriptions.push(disposable);
  context.subscriptions.push(disposable2);
}

// This method is called when your extension is deactivated
function deactivate() {}

module.exports = {
  activate,
  deactivate
};
