// implements an interactive javascript shell.
//
// from
// http://kobyk.wordpress.com/2007/09/14/a-jscript-interactive-interpreter-shell-for-the-windows-script-host/
//
// Sat Nov 28 00:09:55 2009
//

var GSHELL = (function () {

    var numberToHexString = function (n) {
        if (n >= 0) {
            return n.toString(16);
        } else {
            n += 0x100000000;
            return n.toString(16);
        }
    };
    var line, scriptText, previousLine, result;

    return function() {
        while(true) {
            WScript.StdOut.Write("js> ");
            if (WScript.StdIn.AtEndOfStream) {
                WScript.Echo("Bye.");
                break;
            }
            line = WScript.StdIn.ReadLine();
            scriptText = line + "\n";
            if (line === "") {
                WScript.Echo(
                    "Enter two consecutive blank lines to terminate multi-line input.");
                do {
                    if (WScript.StdIn.AtEndOfStream) {
                        break;
                    }
                    previousLine = line;
                    line = WScript.StdIn.ReadLine();
                    line += "\n";
                    scriptText += line;
                } while(previousLine != "\n" || line != "\n");
            }
            try {
                result = eval(scriptText);
            } catch (error) {
                WScript.Echo("0x" + numberToHexString(error.number) + " " + error.name + ": " +
                             error.message);
            }
            if (result) {
                try {
                    WScript.Echo(result);
                } catch (error) {
                    WScript.Echo("<<>>");
                }
            }
            result = null;
        }
    };
})();

GSHELL();
