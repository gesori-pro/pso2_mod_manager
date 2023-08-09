// ignore_for_file: unused_import

import 'dart:io';

import 'package:file_selector/file_selector.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pso2_mod_manager/application.dart';
import 'package:pso2_mod_manager/filesDownloader/ice_files_download.dart';
import 'package:pso2_mod_manager/functions/apply_mods.dart';
import 'package:pso2_mod_manager/functions/checksum_check.dart';
import 'package:pso2_mod_manager/functions/hash_generator.dart';
import 'package:pso2_mod_manager/functions/og_ice_paths_fetcher.dart';
import 'package:pso2_mod_manager/functions/startup_icons_loader_popup.dart';
import 'package:pso2_mod_manager/global_variables.dart';
import 'package:pso2_mod_manager/loaders/language_loader.dart';
import 'package:pso2_mod_manager/loaders/mod_files_loader.dart';
import 'package:pso2_mod_manager/state_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:window_manager/window_manager.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart' as p;

//All paths go here
//Main paths
String modManPso2binPath = '';
String modManDirParentDirPath = '';
String modManDirPath = '';
String modManModsDirPath = '';
//String modManBackupsDirPath = '';
String modManChecksumDirPath = '';
String modManDeletedItemsDirPath = '';
String modManChecksumFilePath = '';
//Misc path
String modManAddModsTempDirPath = '';
String modManAddModsUnpackDirPath = '';
String modManZamboniExePath = Uri.file('${Directory.current.path}/Zamboni/Zamboni.exe').toFilePath();
String modManRefSheetsDirPath = Uri.file('${Directory.current.path}/ItemRefSheets').toFilePath();
String modManWin32CheckSumFilePath = '';
String modManWin32NaCheckSumFilePath = '';
String modManLocalChecksumMD5 = '';
String modManWin32ChecksumMD5 = '';
String modManWin32NaChecksumMD5 = '';
String modManModsAdderPath = Uri.file('${Directory.current.path}/modsAdder').toFilePath();
//Json files path
String modManModsListJsonPath = '';
String modManModSetsJsonPath = '';
String modManRefSheetListFilePath = '';
//Log file path
String modManOpLogsFilePath = '';
//Swapper paths
String modManSwapperDirPath = Uri.file('${Directory.current.path}/swapper').toFilePath();
String modManSwapperFromItemDirPath = Uri.file('${Directory.current.path}/swapper/fromitem').toFilePath();
String modManSwapperToItemDirPath = Uri.file('${Directory.current.path}/swapper/toitem').toFilePath();
String modManSwapperOutputDirPath = Uri.file('${Directory.current.path}/swapper/Swapped Items').toFilePath();
//sega patch server links
String masterURL = '';
String patchURL = '';
String backupMasterURL = '';
String backupPatchURL = '';

Future<bool> pathsLoader(context) async {
  final prefs = await SharedPreferences.getInstance();
  //get profile
  modManCurActiveProfile = (prefs.getInt('modManCurActiveProfile') ?? 1);
  //pso2_bin path
  modManPso2binPath = Uri.file(prefs.getString(modManCurActiveProfile == 1 ? 'binDirPath' : 'binDirPath_profile2') ?? '').toFilePath();
  while (modManPso2binPath.isEmpty) {
    String? pso2binPathFromPicker = await pso2binPathGet(context);
    if (pso2binPathFromPicker != null) {
      modManPso2binPath = Uri.file(pso2binPathFromPicker).toFilePath();
      prefs.setString(modManCurActiveProfile == 1 ? 'binDirPath' : 'binDirPath_profile2', modManPso2binPath);
    }
  }
  //modman dir path
  modManDirParentDirPath = Uri.file(prefs.getString('mainModManDirPath') ?? '').toFilePath();
  while (modManDirParentDirPath.isEmpty) {
    String? modManDirPathFromPicker = await modManDirPathGet(context);
    if (modManDirPathFromPicker != null) {
      modManDirParentDirPath = Uri.file(modManDirPathFromPicker).toFilePath();
      prefs.setString('mainModManDirPath', modManDirParentDirPath);
    } else {
      modManDirParentDirPath = modManPso2binPath;
      //Create modman folder if not already existed
      modManDirPath = Uri.file('$modManDirParentDirPath/PSO2 Mod Manager').toFilePath();
      Directory(modManDirPath).createSync();
      prefs.setString('mainModManDirPath', modManDirParentDirPath);
    }
  }

  //Check modman folder if existed, if not choose path to it
  if (p.basename(modManDirParentDirPath) == 'PSO2 Mod Manager') {
    modManDirPath = modManDirParentDirPath;
  } else {
    modManDirPath = Uri.file('$modManDirParentDirPath/PSO2 Mod Manager').toFilePath();
  }
  while (!Directory(modManDirPath).existsSync()) {
    String? modManDirPathFromPicker = await modManDirPathGet(context);
    if (modManDirPathFromPicker != null) {
      modManDirParentDirPath = Uri.file(modManDirPathFromPicker).toFilePath();
    } else {
      modManDirParentDirPath = modManPso2binPath;
      //Create modman folder if not already existed
      modManDirPath = Uri.file('$modManDirParentDirPath/PSO2 Mod Manager').toFilePath();
      Directory(modManDirPath).createSync();
    }
  }

  //Create Mods folder and default categories
  modManModsDirPath = Uri.file('$modManDirPath/Mods').toFilePath();
  Directory(modManModsDirPath).createSync(recursive: true);
  for (var name in defaultCateforyDirs) {
    Directory(Uri.file('$modManModsDirPath/$name').toFilePath()).createSync();
  }
  //Backup folders removed since downloading backups from sega
  //Create Backups folder
  // modManBackupsDirPath = Uri.file('$modManDirPath/Backups').toFilePath();
  // Directory(modManBackupsDirPath).createSync();
  // List<String> dataFolders = ['win32', 'win32_na', 'win32reboot', 'win32reboot_na'];
  // for (var name in dataFolders) {
  //   Directory(Uri.file('$modManBackupsDirPath/$name').toFilePath()).createSync();
  // }
  //Remove backup folder if existing
  if (Directory(Uri.file('$modManDirPath/Backups').toFilePath()).existsSync()) {
    Directory(Uri.file('$modManDirPath/Backups').toFilePath()).deleteSync(recursive: true);
  }
  //Create Checksum folder
  modManChecksumDirPath = Uri.file('$modManDirPath/Checksum').toFilePath();
  Directory(modManChecksumDirPath).createSync();
  //Create Deleted Items folder
  modManDeletedItemsDirPath = Uri.file('$modManDirPath/Deleted Items').toFilePath();
  Directory(modManDeletedItemsDirPath);
  //Create misc folders
  modManAddModsTempDirPath = Uri.file('${Directory.current.path}/temp').toFilePath();
  Directory(modManAddModsTempDirPath).createSync(recursive: true);
  modManAddModsUnpackDirPath = Uri.file('${Directory.current.path}/unpack').toFilePath();
  Directory(modManAddModsUnpackDirPath).createSync(recursive: true);
  modManModsAdderPath = Uri.file('${Directory.current.path}/modsAdder').toFilePath();
  Directory(modManModsAdderPath).createSync(recursive: true);
  //Create Json files
  modManModsListJsonPath = modManCurActiveProfile == 1 ? Uri.file('$modManDirPath/PSO2ModManModsList.json').toFilePath() : Uri.file('$modManDirPath/PSO2ModManModsList_profile2.json').toFilePath();
  File(modManModsListJsonPath).createSync();
  modManModSetsJsonPath = modManCurActiveProfile == 1 ? Uri.file('$modManDirPath/PSO2ModManSetsList.json').toFilePath() : Uri.file('$modManDirPath/PSO2ModManSetsList_profile2.json').toFilePath();
  File(modManModSetsJsonPath).createSync();
  // modManModSettingsJsonPath = Uri.file('$modManDirPath/PSO2ModManSettings.json').toFilePath();
  // File(modManModSettingsJsonPath).createSync();
  modManRefSheetListFilePath = Uri.file('$modManRefSheetsDirPath/PSO2ModManRefSheetList.txt').toFilePath();
  if (!File(modManRefSheetListFilePath).existsSync()) {
    File(modManRefSheetListFilePath).createSync();
  }
  //Create log file
  // modManOpLogsFilePath = Uri.file('$modManDirPath/PSO2ModManSettings.json').toFilePath();
  // File(modManOpLogsFilePath).createSync();

  //Checksum check
  //await ApplicationConfig().checkChecksumFileForUpdates(context);
  await checksumChecker(context);

  //ref sheets check load files
  if (kDebugMode) {
    final sheetFiles = Directory(Uri.file('$modManRefSheetsDirPath/Player').toFilePath()).listSync(recursive: true).where((element) => p.extension(element.path) == '.csv');
    List<String> sheetPaths = sheetFiles.map((e) => Uri.file(e.path.replaceAll(modManRefSheetsDirPath, '')).toFilePath()).toList();
    File(modManRefSheetListFilePath).writeAsString(sheetPaths.join('\n').trim());
  }

  //ref sheets check
  ApplicationConfig().checkRefSheetsForUpdates(context);

  //startup icons loader
  if (firstTimeUser) {
    isAutoFetchingIconsOnStartup = await startupItemIconDialog(context);
    prefs.setString('isAutoFetchingIconsOnStartup', isAutoFetchingIconsOnStartup);
  }

  //sega patch server loader
  final patchLinks = await getPatchServerList();
  if (patchLinks.isNotEmpty) {
    masterURL = patchLinks.firstWhere((element) => element.contains('MasterURL=')).split('=').last.trim();
    patchURL = patchLinks.firstWhere((element) => element.contains('PatchURL=')).split('=').last.trim();
    backupMasterURL = patchLinks.firstWhere((element) => element.contains('BackupMasterURL=')).split('=').last.trim();
    backupPatchURL = patchLinks.firstWhere((element) => element.contains('BackupPatchURL=')).split('=').last.trim();
  }

  //Get patch file lists
  //await fetchOfficialPatchFileList();

  //Return true if all paths loaded
  return true;
}

//Get main paths
Future<String?> pso2binPathGet(context) async {
  return await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
              shape: RoundedRectangleBorder(side: BorderSide(color: Theme.of(context).primaryColorLight), borderRadius: const BorderRadius.all(Radius.circular(5))),
              backgroundColor: Color(context.watch<StateProvider>().uiBackgroundColorValue).withOpacity(0.8),
              titlePadding: const EdgeInsets.only(top: 10, bottom: 10, left: 16, right: 16),
              title: Center(
                child: Text(curLangText!.uiError, style: const TextStyle(fontWeight: FontWeight.w700)),
              ),
              contentPadding: const EdgeInsets.only(left: 16, right: 16),
              content: Text(
                curLangText!.uiPso2binFolderNotFoundSelect,
              ),
              actions: <Widget>[
                ElevatedButton(
                    child: Text(curLangText!.uiExit),
                    onPressed: () async {
                      Navigator.pop(context, null);
                      await windowManager.destroy();
                    }),
                ElevatedButton(
                    onPressed: () async {
                      Navigator.pop(
                          context,
                          // await FilePicker.platform.getDirectoryPath(
                          //   dialogTitle: curLangText!.uiSelectPso2binFolderPath,
                          //   lockParentWindow: true,
                          // )
                          await getDirectoryPath());
                    },
                    child: Text(curLangText!.uiYes))
              ]));
}

Future<String?> modManDirPathGet(context) async {
  return await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
              shape: RoundedRectangleBorder(side: BorderSide(color: Theme.of(context).primaryColorLight), borderRadius: const BorderRadius.all(Radius.circular(5))),
              backgroundColor: Color(context.watch<StateProvider>().uiBackgroundColorValue).withOpacity(0.8),
              titlePadding: const EdgeInsets.only(top: 10, bottom: 10, left: 16, right: 16),
              title: Center(
                child: Text(curLangText!.uiMMFolderNotFound, style: const TextStyle(fontWeight: FontWeight.w700)),
              ),
              contentPadding: const EdgeInsets.only(left: 16, right: 16),
              content: Text(
                curLangText!.uiSelectPathToStoreMMFolder,
              ),
              actions: <Widget>[
                ElevatedButton(
                    child: Text(curLangText!.uiNo),
                    onPressed: () async {
                      Navigator.pop(context, null);
                    }),
                ElevatedButton(
                    onPressed: () async {
                      Navigator.pop(
                          context,
                          // await FilePicker.platform.getDirectoryPath(
                          //   dialogTitle: curLangText!.uiSelectAFolderToStoreMMFolder,
                          //   lockParentWindow: true,
                          // )
                          await getDirectoryPath());
                    },
                    child: Text(curLangText!.uiYes))
              ]));
}

//Reselect main paths
Future<bool> pso2PathsReloader(context) async {
  final prefs = await SharedPreferences.getInstance();
  //pso2_bin path
  String? pso2binPathFromPicker = await pso2binPathReselect(context);
  if (pso2binPathFromPicker != null) {
    modManPso2binPath = Uri.file(pso2binPathFromPicker).toFilePath();
    prefs.setString(modManCurActiveProfile == 1 ? 'binDirPath' : 'binDirPath_profile2', modManPso2binPath);
    modManChecksumFilePath = '';
    ogModFilesLoader();
  } else {
    return false;
  }

  //Checksum
  await checksumChecker(context);

  //Apply mods to new data folder
  for (var type in appliedItemList) {
    for (var cate in type.categories) {
      for (var item in cate.items) {
        if (item.applyStatus == true) {
          for (var mod in item.mods) {
            if (mod.applyStatus == true) {
              for (var submod in mod.submods) {
                if (submod.applyStatus == true) {
                  for (var modFile in submod.modFiles) {
                    if (modFile.applyStatus == true) {
                      modFile.ogLocations = ogIcePathsFetcher(modFile.modFileName);
                      modFileApply(modFile);
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  }

  //Return true if all paths loaded
  return true;
}

Future<String?> pso2binPathReselect(context) async {
  return await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
              shape: RoundedRectangleBorder(side: BorderSide(color: Theme.of(context).primaryColorLight), borderRadius: const BorderRadius.all(Radius.circular(5))),
              backgroundColor: Color(context.watch<StateProvider>().uiBackgroundColorValue).withOpacity(0.8),
              titlePadding: const EdgeInsets.only(top: 10, bottom: 10, left: 16, right: 16),
              title: Center(
                child: Text(curLangText!.uiReselectPso2binPath, style: const TextStyle(fontWeight: FontWeight.w700)),
              ),
              contentPadding: const EdgeInsets.only(left: 16, right: 16, bottom: 10),
              content: Text('${curLangText!.uiCurrentPath}:\n$modManPso2binPath'),
              actions: <Widget>[
                ElevatedButton(
                    child: Text(curLangText!.uiReturn),
                    onPressed: () async {
                      Navigator.pop(context, null);
                    }),
                ElevatedButton(
                    onPressed: () async {
                      Navigator.pop(
                          context,
                          // await FilePicker.platform.getDirectoryPath(
                          //   dialogTitle: curLangText!.uiSelectPso2binFolderPath,
                          //   lockParentWindow: true,
                          // )
                          await getDirectoryPath());
                    },
                    child: Text(curLangText!.uiReselect))
              ]));
}

Future<bool> modManPathReloader(context) async {
  final prefs = await SharedPreferences.getInstance();
  String? modManDirPathFromPicker = await modManDirPathReselect(context);
  if (modManDirPathFromPicker != null) {
    modManDirParentDirPath = Uri.file(modManDirPathFromPicker).toFilePath();
    prefs.setString('mainModManDirPath', modManDirParentDirPath);
  } else {
    return false;
  }

  //Check modman folder
  if (p.basename(modManDirParentDirPath) == 'PSO2 Mod Manager') {
    modManDirPath = modManDirParentDirPath;
  } else {
    modManDirPath = Uri.file('$modManDirParentDirPath/PSO2 Mod Manager').toFilePath();
  }

  //Create Mods folder and default categories
  modManModsDirPath = Uri.file('$modManDirPath/Mods').toFilePath();
  Directory(modManModsDirPath).createSync(recursive: true);
  for (var name in defaultCateforyDirs) {
    Directory(Uri.file('$modManModsDirPath/$name').toFilePath()).createSync();
  }
  //Backup folders removed since downloading backups from sega
  //Create Backups folder
  // modManBackupsDirPath = Uri.file('$modManDirPath/Backups').toFilePath();
  // Directory(modManBackupsDirPath).createSync();
  // List<String> dataFolders = ['win32', 'win32_na', 'win32reboot', 'win32reboot_na'];
  // for (var name in dataFolders) {
  //   Directory(Uri.file('$modManBackupsDirPath/$name').toFilePath()).createSync();
  // }
  //Create Checksum folder
  modManChecksumDirPath = Uri.file('$modManDirPath/Checksum').toFilePath();
  Directory(modManChecksumDirPath).createSync();
  //Create Deleted Items folder
  modManDeletedItemsDirPath = Uri.file('$modManDirPath/Deleted Items').toFilePath();
  Directory(modManDeletedItemsDirPath);
  //Create misc folders
  modManAddModsTempDirPath = Uri.file('${Directory.current.path}/temp').toFilePath();
  Directory(modManAddModsTempDirPath).createSync(recursive: true);
  modManAddModsUnpackDirPath = Uri.file('${Directory.current.path}/unpack').toFilePath();
  Directory(modManAddModsUnpackDirPath).createSync(recursive: true);
  modManModsAdderPath = Uri.file('${Directory.current.path}/modsAdder').toFilePath();
  Directory(modManModsAdderPath).createSync(recursive: true);
  //Create Json files
  modManModsListJsonPath = modManCurActiveProfile == 1 ? Uri.file('$modManDirPath/PSO2ModManModsList.json').toFilePath() : Uri.file('$modManDirPath/PSO2ModManModsList_profile2.json').toFilePath();
  File(modManModsListJsonPath).createSync();
  modManModSetsJsonPath = modManCurActiveProfile == 1 ? Uri.file('$modManDirPath/PSO2ModManSetsList.json').toFilePath() : Uri.file('$modManDirPath/PSO2ModManSetsList_profile2.json').toFilePath();
  File(modManModSetsJsonPath).createSync();
  // modManModSettingsJsonPath = Uri.file('$modManDirPath/PSO2ModManSettings.json').toFilePath();
  // File(modManModSettingsJsonPath).createSync();
  modManRefSheetListFilePath = Uri.file('$modManRefSheetsDirPath/PSO2ModManRefSheetList.txt').toFilePath();
  File(modManRefSheetListFilePath).createSync();

  //Create log file
  // modManOpLogsFilePath = Uri.file('$modManDirPath/PSO2ModManSettings.json').toFilePath();
  // File(modManOpLogsFilePath).createSync();

  //Checksum check
  //await ApplicationConfig().checkChecksumFileForUpdates(context);
  await checksumChecker(context);

  //sega patch server loader
  final patchLinks = await getPatchServerList();
  if (patchLinks.isNotEmpty) {
    masterURL = patchLinks.firstWhere((element) => element.contains('MasterURL=')).split('=').last.trim();
    patchURL = patchLinks.firstWhere((element) => element.contains('PatchURL=')).split('=').last.trim();
    backupMasterURL = patchLinks.firstWhere((element) => element.contains('BackupMasterURL=')).split('=').last.trim();
    backupPatchURL = patchLinks.firstWhere((element) => element.contains('BackupPatchURL=')).split('=').last.trim();
  }

  //Get patch file lists
  await fetchOfficialPatchFileList();

  listsReloading = true;
  Provider.of<StateProvider>(context, listen: false).reloadSplashScreenTrue();
  Future.delayed(const Duration(milliseconds: 500), () {
    modFileStructureLoader().then((value) {
      moddedItemsList = value;
      listsReloading = false;
      Provider.of<StateProvider>(context, listen: false).reloadSplashScreenFalse();
    });
  });

  //Return true if all paths loaded
  return true;
}

Future<String?> modManDirPathReselect(context) async {
  return await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
              shape: RoundedRectangleBorder(side: BorderSide(color: Theme.of(context).primaryColorLight), borderRadius: const BorderRadius.all(Radius.circular(5))),
              backgroundColor: Color(context.watch<StateProvider>().uiBackgroundColorValue).withOpacity(0.8),
              titlePadding: const EdgeInsets.only(top: 10, bottom: 10, left: 16, right: 16),
              title: Center(
                child: Text(curLangText!.uiReselectModManFolderPath, style: const TextStyle(fontWeight: FontWeight.w700)),
              ),
              contentPadding: const EdgeInsets.only(left: 16, right: 16),
              content: Text('${curLangText!.uiMMPathReselectNoteCurrentPath}\n$modManDirPath'),
              actions: <Widget>[
                ElevatedButton(
                    child: Text(curLangText!.uiReturn),
                    onPressed: () async {
                      Navigator.pop(context, null);
                    }),
                ElevatedButton(
                    onPressed: () async {
                      Navigator.pop(
                          context,
                          // await FilePicker.platform.getDirectoryPath(
                          //   dialogTitle: curLangText!.uiSelectAFolderToStoreMMFolder,
                          //   lockParentWindow: true,
                          // )
                          await getDirectoryPath());
                    },
                    child: Text(curLangText!.uiReselect))
              ]));
}
