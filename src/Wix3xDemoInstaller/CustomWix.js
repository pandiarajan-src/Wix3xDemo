
// Represents bitmask of custom action flags to launch an executable that exists in the MSI file table and to suspend
// the main install thread until the process completes before continuing with install execute sequences
var LaunchExecutableFromFileTableAndWait = 82;

// Represents bitmask of custom action flags to launch an executable that exists in the MSI file table and to immediately
// continue running main install thread (that is, do NOT wait for the launched process to complete before continuing on)
var LaunchExecutableFromFileTableAndContinue = 210;

// Constant values from Windows Installer
var msiOpenDatabaseModeTransact = 1;

var msiViewModifyInsert = 1;
var msiViewModifyUpdate = 2;
var msiViewModifyAssign = 3;
var msiViewModifyReplace = 4;
var msiViewModifyDelete = 6;


if (WScript.Arguments.Length < 1) {
	WScript.StdErr.WriteLine(WScript.ScriptName + " file");
	WScript.Quit(1);
}

var filespec = WScript.Arguments(0);
var LangCult = WScript.Arguments(1);
var installer = WScript.CreateObject("WindowsInstaller.Installer");
var database = installer.OpenDatabase(filespec, msiOpenDatabaseModeTransact);

var sql;
var view;
var record;

try {


    // Modify font for text controls that are displayed over our banners to appear in white, not black
    WScript.Echo("Script to Update banner text controls...");


    ///////////////////////////////////////////////////////////////////////////////////////////////
    //
    //  Edit text in banner for Description control of many dialogs
    //
    ////////////////////////////////////////////////////////////////////////////////////////////////
    sql = "SELECT `X`, `Y`, `Width`, `Height`, `Text`, `Dialog_` FROM `Control` WHERE (`Dialog_`='InstallDirDlg' OR `Dialog_`='BrowseDlg' OR `Dialog_`='DiskCostDlg' OR `Dialog_`='FilesInUse' OR `Dialog_`='LicenseAgreementDlg' OR `Dialog_`='MaintenanceTypeDlg' OR `Dialog_`='MsiRMFilesInUse' OR `Dialog_`='OutOfDiskDlg' OR `Dialog_`='OutOfRbDiskDlg')  AND `Control`='Description'";
    view = database.OpenView(sql);
    view.Execute();
    record = view.Fetch();
	while (record) {
	    record.IntegerData(2) = 20; // Y Axis
	    record.IntegerData(4) = 30; // Height of control

	    // Capture current dialog
	    var Dlg = record.StringData(6);

	    // For German the text is still too long after using the smaller font below, so we need to also
	    // extend the width of the description text control on the InstallDirDlg
	    if (Dlg == "InstallDirDlg" && LangCult.toLowerCase() == "de-de") {
	        record.IntegerData(3) = 245; // Width of control
	        record.IntegerData(1) = 20; // X Axis
	    }
	    else {
	        record.IntegerData(3) = 230;  // Width of control
	        record.IntegerData(1) = 25; // X Axis
	    }

        // Here we need to capture the string data to remove the existing font and then add the new one
        var TmpStr = record.StringData(5);
        var TmpStr2;
        // If the string starts with {\ then there's a font specified, so remove it.
        if (TmpStr.indexOf("{\\") == 0) {
            TmpStr2 = TmpStr.substring(TmpStr.indexOf("}") + 1);
        }
        else {
            TmpStr2 = TmpStr;
        }

        // Now add the new font style we want to display the text in to the beginning of the string
        var NewStr = "{\\WixUI_Font_White_Normal}" + TmpStr2;

        // If this is the InstallDirDlg and the language is Russian, we need to make the text a little
        // smaller to fit as it is too long and wraps too much, overlapping into the dialog.
        if (Dlg == "InstallDirDlg" && (LangCult.toLowerCase() == "ru-ru" || LangCult.toLowerCase() == "fr-fr" || LangCult.toLowerCase() == "de-de"))
            NewStr = "{\\WixUI_Font_White_Small}" + TmpStr2;

        // Now store the new string in the Text field
        record.StringData(5) = NewStr;
        view.Modify(msiViewModifyReplace, record);

        record = view.Fetch();
    }
    view.Close();


    ///////////////////////////////////////////////////////////////////////////////////////////////
    //
    //  Edit text in banner for Title control of many dialogs
    //
    ////////////////////////////////////////////////////////////////////////////////////////////////
    sql = "SELECT `Y`, `Width`, `Height`, `Text`, `Dialog_` FROM `Control` WHERE (`Dialog_`='InstallDirDlg' OR `Dialog_`='BrowseDlg' OR `Dialog_`='DiskCostDlg' OR `Dialog_`='FilesInUse' OR `Dialog_`='LicenseAgreementDlg' OR `Dialog_`='MaintenanceTypeDlg' OR `Dialog_`='MsiRMFilesInUse' OR `Dialog_`='OutOfDiskDlg' OR `Dialog_`='OutOfRbDiskDlg') AND `Control`='Title'";
    view = database.OpenView(sql);
    view.Execute();
    record = view.Fetch();
    while (record) {
        record.IntegerData(2) = 230; // Width of control

        // Here we need to capture the string data to remove the existing font and then add the new one
        var TmpStr = record.StringData(4);
        var TmpStr2;
        // If the string starts with {\ then there's a font specified, so remove it.
        if (TmpStr.indexOf("{\\") == 0) {
            TmpStr2 = TmpStr.substring(TmpStr.indexOf("}") + 1);
        }
        else {
            TmpStr2 = TmpStr;
        }

        // Now add the new font style we want to display the text in to the beginning of the string
        var NewStr = "{\\WixUI_Font_White_Title}" + TmpStr2;

        // Now store the new string in the Text field
        record.StringData(4) = NewStr;
        view.Modify(msiViewModifyReplace, record);

        record = view.Fetch();
    }
    view.Close();


    ///////////////////////////////////////////////////////////////////////////////////////////////
    //
    //  Edit text in banner for different title controls of ProgressDlg
    //
    ////////////////////////////////////////////////////////////////////////////////////////////////
    sql = "SELECT `Y`, `Width`, `Height`, `Text`, `Dialog_` FROM `Control` WHERE `Dialog_`='ProgressDlg' AND (`Control`='TitleChanging' OR `Control`='TitleInstalling' OR `Control`='TitleRemoving' OR `Control`='TitleRepairing' OR `Control`='TitleUpdating')";
    view = database.OpenView(sql);
    view.Execute();
    record = view.Fetch();
    while (record) {
        record.IntegerData(2) = 230; // Width of control

        // Here we need to capture the string data to remove the existing font and then add the new one
        var TmpStr = record.StringData(4);
        var TmpStr2;
        // If the string starts with {\ then there's a font specified, so remove it.
        if (TmpStr.indexOf("{\\") == 0) {
            TmpStr2 = TmpStr.substring(TmpStr.indexOf("}") + 1);
        }
        else {
            TmpStr2 = TmpStr;
        }

        // Now add the new font style we want to display the text in to the beginning of the string
        var NewStr = "{\\WixUI_Font_White_Title}" + TmpStr2;

        // Now store the new string in the Text field
        record.StringData(4) = NewStr;
        view.Modify(msiViewModifyReplace, record);

        record = view.Fetch();
    }
    view.Close();


    ///////////////////////////////////////////////////////////////////////////////////////////////
    //
    //  Edit text in banner for different title controls of VerifyReadyDlg
    //
    ////////////////////////////////////////////////////////////////////////////////////////////////
    sql = "SELECT `Y`, `Width`, `Height`, `Text`, `Dialog_` FROM `Control` WHERE `Dialog_`='VerifyReadyDlg' AND (`Control`='ChangeTitle' OR `Control`='InstallTitle' OR `Control`='RemoveTitle' OR `Control`='RepairTitle' OR `Control`='UpdateTitle')";
    view = database.OpenView(sql);
    view.Execute();
    record = view.Fetch();
    while (record) {
        record.IntegerData(2) = 230; // Width of control

        // Here we need to capture the string data to remove the existing font and then add the new one
        var TmpStr = record.StringData(4);
        var TmpStr2;
        // If the string starts with {\ then there's a font specified, so remove it.
        if (TmpStr.indexOf("{\\") == 0) {
            TmpStr2 = TmpStr.substring(TmpStr.indexOf("}") + 1);
        }
        else {
            TmpStr2 = TmpStr;
        }

        // Now add the new font style we want to display the text in to the beginning of the string
        var NewStr = "{\\WixUI_Font_White_Title}" + TmpStr2;

        // Now store the new string in the Text field
        record.StringData(4) = NewStr;
        view.Modify(msiViewModifyReplace, record);

        record = view.Fetch();
    }
    view.Close();

    // Commit our MSI database changes
	database.Commit();
		
} catch (e) {

	WScript.StdErr.WriteLine(e);
	WScript.Quit(1);
}
