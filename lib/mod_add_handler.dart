import 'dart:io';

import 'package:cross_file/cross_file.dart';
import 'package:desktop_drop/desktop_drop.dart';
import 'package:flutter/material.dart';
import 'package:archive/archive_io.dart';
// ignore: depend_on_referenced_packages
import 'package:collection/collection.dart';

// ignore: depend_on_referenced_packages
import 'package:path/path.dart' as p;
import 'package:pso2_mod_manager/file_functions.dart';
import 'package:pso2_mod_manager/item_ref.dart';
import 'package:pso2_mod_manager/main.dart';
import 'package:pso2_mod_manager/scroll_controller.dart';

List<String> _pathsToRemove = ['win32', 'win32reboot', 'win32_na', 'win32reboot_na'];
bool _newModDragging = false;
bool _exitConfirmDialog = false;
List<String> _duplicateModNames = [];
final List<XFile> _newModDragDropList = [];
List<XFile> modsToAddList = [];
Future? sortedModsListLoad;
List<List<String>> sortedModsList = [];
String tempDirPath = '${Directory.current.path}${s}temp';
TextEditingController renameTextBoxController = TextEditingController();
List<bool> _mainFolderRenameIndex = [];
List<List<bool>> _subFoldersRenameIndex = [];
bool _isNameEditing = false;

//Csv lists
List<String> _accessoriesCsv = ['Accessories.csv'];
List<String> _emoteCsv = ['LobbyActionsNGS_HandPoses.csv', 'LobbyActions.csv'];
List<String> _basewearCsv = ['GenderlessNGSBasewear.csv', 'FemaleNGSBasewear.csv', 'MaleNGSBasewear.csv', 'FemaleBasewear.csv', 'MaleBasewear.csv'];

void modAddHandler(context) {
  showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
              // title: const Text('Adding mods'),
              // titlePadding: const EdgeInsets.all(5),
              contentPadding: const EdgeInsets.all(5),
              content: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.6,
                  height: MediaQuery.of(context).size.height,
                  child: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
                    return FutureBuilder(
                      future: popSheetsList(refSheetsDirPath),
                      builder: ((
                        BuildContext context,
                        AsyncSnapshot snapshot,
                      ) {
                        if (snapshot.connectionState == ConnectionState.waiting && ngsRefSheetsList.isEmpty) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: const [
                              Text(
                                'Preparing',
                                style: TextStyle(fontSize: 20),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              CircularProgressIndicator(),
                            ],
                          );
                        }
                        if (snapshot.connectionState == ConnectionState.done) {
                          ngsRefSheetsList = snapshot.data;
                        }
                        return Row(
                          children: [
                            RotatedBox(
                                quarterTurns: -1,
                                child: Text(
                                  'ADD MODS',
                                  style: TextStyle(
                                      color: MyApp.themeNotifier.value == ThemeMode.light ? Theme.of(context).primaryColorDark : Theme.of(context).iconTheme.color,
                                      fontWeight: FontWeight.w900,
                                      fontSize: 20,
                                      letterSpacing: constraints.maxHeight / 10),
                                )),
                            VerticalDivider(
                              width: 10,
                              thickness: 2,
                              indent: 5,
                              endIndent: 5,
                              color: Theme.of(context).textTheme.bodySmall!.color,
                            ),
                            Column(
                              children: [
                                DropTarget(
                                  //enable: true,
                                  onDragDone: (detail) async {
                                    for (var element in detail.files) {
                                      if (_newModDragDropList.indexWhere((file) => file.path == element.path) == -1) {
                                        _newModDragDropList.add(element);
                                      }
                                    }
                                    setState(
                                      () {},
                                    );
                                  },
                                  onDragEntered: (detail) {
                                    setState(() {
                                      _newModDragging = true;
                                    });
                                  },
                                  onDragExited: (detail) {
                                    setState(() {
                                      _newModDragging = false;
                                    });
                                  },
                                  child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(3),
                                        border: Border.all(color: Theme.of(context).hintColor),
                                        color: _newModDragging ? Colors.blue.withOpacity(0.4) : Colors.black26.withAlpha(20),
                                      ),
                                      height: constraints.maxHeight - 33,
                                      width: constraints.maxWidth * 0.45,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          if (_newModDragDropList.isEmpty)
                                            const Center(
                                                child: Text(
                                              'Drag and drop folders, zip files\nand .ice files here',
                                              textAlign: TextAlign.center,
                                            )),
                                          if (_newModDragDropList.isNotEmpty)
                                            Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.only(right: 5),
                                                child: SizedBox(
                                                    width: constraints.maxWidth,
                                                    height: constraints.maxHeight,
                                                    child: Padding(
                                                      padding: const EdgeInsets.symmetric(horizontal: 0),
                                                      child: ListView.builder(
                                                          itemCount: _newModDragDropList.length,
                                                          itemBuilder: (BuildContext context, int index) {
                                                            return ListTile(
                                                              //dense: true,
                                                              // leading: const Icon(
                                                              //     Icons.list),
                                                              trailing: SizedBox(
                                                                width: 40,
                                                                child: Tooltip(
                                                                  message: 'Remove',
                                                                  waitDuration: const Duration(seconds: 2),
                                                                  child: MaterialButton(
                                                                    child: const Icon(Icons.remove_circle),
                                                                    onPressed: () {
                                                                      _newModDragDropList.removeAt(index);
                                                                      setState(
                                                                        () {},
                                                                      );
                                                                    },
                                                                  ),
                                                                ),
                                                              ),
                                                              title: Text(_newModDragDropList[index].name),
                                                              subtitle: Text(
                                                                _newModDragDropList[index].path,
                                                                maxLines: 1,
                                                                overflow: TextOverflow.ellipsis,
                                                                softWrap: false,
                                                              ),
                                                            );
                                                          }),
                                                    )),
                                              ),
                                            )
                                        ],
                                      )),
                                ),
                                SizedBox(
                                  width: constraints.maxWidth * 0.45,
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 5),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Expanded(
                                          child: ElevatedButton(
                                              onPressed: _newModDragDropList.isNotEmpty
                                                  ? (() {
                                                      _newModDragDropList.clear();
                                                      setState(
                                                        () {},
                                                      );
                                                    })
                                                  : null,
                                              child: const Text('Clear All')),
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Expanded(
                                          child: ElevatedButton(
                                              onPressed: _newModDragDropList.isNotEmpty
                                                  ? (() async {
                                                      for (var file in _newModDragDropList) {
                                                        if (p.extension(file.path) == '.zip') {
                                                          await unzipPack(file.path, file.name.split('.').first);
                                                          modsToAddList.addAll(await sortFile(file.name.split('.').first));
                                                        } else if (Directory(file.path).existsSync()) {
                                                          List<XFile> filesInFolder = [XFile(file.path)];
                                                          for (var file in Directory(file.path).listSync(recursive: true)) {
                                                            //if (File(file.path).existsSync()) {
                                                            filesInFolder.add(XFile(file.path));
                                                            //}
                                                          }
                                                          modsToAddList.addAll(filesInFolder);
                                                        } else {
                                                          modsToAddList.add(XFile(file.path));
                                                        }
                                                      }

                                                      //Test
                                                      // for (var element in modsToAddList) {
                                                      //   print(element.path);
                                                      // }

                                                      //clear lists
                                                      sortedModsListLoad = fetchItemName(modsToAddList);
                                                      setState(
                                                        () {
                                                          _newModDragDropList.clear();
                                                        },
                                                      );
                                                    })
                                                  : null,
                                              child: const Text('Process')),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                            VerticalDivider(
                              width: 10,
                              thickness: 2,
                              indent: 5,
                              endIndent: 5,
                              color: Theme.of(context).textTheme.bodySmall!.color,
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  Stack(
                                    alignment: AlignmentDirectional.bottomStart,
                                    children: [
                                      SizedBox(
                                        height: constraints.maxHeight - 33,
                                        child: FutureBuilder(
                                            future: sortedModsListLoad,
                                            builder: (
                                              BuildContext context,
                                              AsyncSnapshot snapshot,
                                            ) {
                                              if (snapshot.connectionState == ConnectionState.none || modsToAddList.isEmpty) {
                                                return Center(
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: const [
                                                      Text(
                                                        'Waiting for data',
                                                        style: TextStyle(fontSize: 20),
                                                      ),
                                                      SizedBox(
                                                        height: 20,
                                                      ),
                                                      CircularProgressIndicator(),
                                                    ],
                                                  ),
                                                );
                                              } else {
                                                if (snapshot.hasError) {
                                                  return Center(
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: [
                                                        Text(
                                                          'Error when loading data. Restart the app.',
                                                          style: TextStyle(color: Theme.of(context).textTheme.bodyText1?.color, fontSize: 20),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                } else if (!snapshot.hasData) {
                                                  return Center(
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: const [
                                                        Text(
                                                          'Loading Data',
                                                          style: TextStyle(fontSize: 20),
                                                        ),
                                                        SizedBox(
                                                          height: 20,
                                                        ),
                                                        CircularProgressIndicator(),
                                                      ],
                                                    ),
                                                  );
                                                } else {
                                                  sortedModsList = snapshot.data;
                                                  if (_mainFolderRenameIndex.isEmpty) {
                                                    _mainFolderRenameIndex = List.generate(sortedModsList.length, (index) => false);
                                                    _subFoldersRenameIndex = List.generate(sortedModsList.length, (index) => []);
                                                    for (int i = 0; i < _subFoldersRenameIndex.length; i++) {
                                                      _subFoldersRenameIndex[i] = List.generate(sortedModsList[i][4].split('|').length, (index) => false);
                                                    }
                                                  }
                                                  //print(sortedModsList.length);
                                                  return SingleChildScrollView(
                                                      controller: AdjustableScrollController(80),
                                                      child: ListView.builder(
                                                          shrinkWrap: true,
                                                          physics: const NeverScrollableScrollPhysics(),
                                                          itemCount: sortedModsList.length,
                                                          itemBuilder: (context, index) {
                                                            return Card(
                                                              margin: const EdgeInsets.only(top: 0, bottom: 2, left: 0, right: 0),
                                                              shape: RoundedRectangleBorder(
                                                                  borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                                                                  side: BorderSide(
                                                                      width: 1,
                                                                      color: MyApp.themeNotifier.value == ThemeMode.light ? Theme.of(context).primaryColor : Theme.of(context).primaryColorLight)),
                                                              child: ExpansionTile(
                                                                initiallyExpanded: true,
                                                                title: curActiveLang == 'JP'
                                                                    ? Text('${sortedModsList[index].first} > ${sortedModsList[index][1]}',
                                                                        style: const TextStyle(
                                                                          fontWeight: FontWeight.w600,
                                                                        ))
                                                                    : Text('${sortedModsList[index].first} > ${sortedModsList[index][2]}',
                                                                        style: const TextStyle(
                                                                          fontWeight: FontWeight.w600,
                                                                        )),
                                                                textColor: MyApp.themeNotifier.value == ThemeMode.light ? Theme.of(context).primaryColor : Theme.of(context).iconTheme.color,
                                                                iconColor: MyApp.themeNotifier.value == ThemeMode.light ? Theme.of(context).primaryColor : Theme.of(context).iconTheme.color,
                                                                collapsedTextColor: MyApp.themeNotifier.value == ThemeMode.light ? Theme.of(context).primaryColor : Theme.of(context).iconTheme.color,
                                                                childrenPadding: const EdgeInsets.only(left: 10),
                                                                children: [
                                                                  for (int ex = 0; ex < sortedModsList[index][3].split('|').length; ex++)
                                                                    ExpansionTile(
                                                                      initiallyExpanded: true,
                                                                      textColor: MyApp.themeNotifier.value == ThemeMode.light ? Theme.of(context).primaryColor : Theme.of(context).iconTheme.color,
                                                                      iconColor: MyApp.themeNotifier.value == ThemeMode.light ? Theme.of(context).primaryColor : Theme.of(context).iconTheme.color,
                                                                      collapsedTextColor:
                                                                          MyApp.themeNotifier.value == ThemeMode.light ? Theme.of(context).primaryColor : Theme.of(context).iconTheme.color,
                                                                      //Edit Name
                                                                      title: _mainFolderRenameIndex[index]
                                                                          ? Row(
                                                                              children: [
                                                                                Expanded(
                                                                                  child: SizedBox(
                                                                                    //width: constraints.maxWidth * 0.4,
                                                                                    height: 40,
                                                                                    child: TextFormField(
                                                                                      autofocus: true,
                                                                                      controller: renameTextBoxController,
                                                                                      maxLines: 1,
                                                                                      decoration: InputDecoration(
                                                                                        contentPadding: const EdgeInsets.only(left: 10, top: 10),
                                                                                        border: const OutlineInputBorder(),
                                                                                        hintText: sortedModsList[index][3].split('|')[ex],
                                                                                      ),
                                                                                      onEditingComplete: () {
                                                                                        if (renameTextBoxController.text.isNotEmpty) {
                                                                                          String oldMainDirName = sortedModsList[index][3].split('|')[ex];
                                                                                          // Directory('$tempDirPath$s${sortedModsList[index][3].split('|')[ex]}')
                                                                                          //     .renameSync('$tempDirPath$s${renameTextBoxController.text}');
                                                                                          List<FileSystemEntity> curFilesInMainDir =
                                                                                              Directory('$tempDirPath$s$oldMainDirName').listSync(recursive: true);
                                                                                          for (var element in curFilesInMainDir) {
                                                                                            //print(curFilesInMainDir);
                                                                                            String newMainPath = element.path
                                                                                                .replaceFirst('$tempDirPath$s$oldMainDirName$s', '$tempDirPath$s${renameTextBoxController.text}$s');
                                                                                            if (!File(element.path).existsSync()) {
                                                                                              Directory(newMainPath).createSync(recursive: true);
                                                                                            }
                                                                                            if (sortedModsList[index][4].isEmpty) {
                                                                                              Directory('$tempDirPath$s${renameTextBoxController.text}').createSync(recursive: true);
                                                                                            }
                                                                                          }
                                                                                          for (var element in curFilesInMainDir) {
                                                                                            String newMainPath = element.path
                                                                                                .replaceFirst('$tempDirPath$s$oldMainDirName$s', '$tempDirPath$s${renameTextBoxController.text}$s');
                                                                                            if (File(element.path).existsSync()) {
                                                                                              File(element.path).copySync(newMainPath);
                                                                                            }
                                                                                          }

                                                                                          //Itemlist
                                                                                          List<String> mainDirsString = sortedModsList[index][3].split('|');
                                                                                          mainDirsString[mainDirsString.indexOf(oldMainDirName)] = renameTextBoxController.text;
                                                                                          sortedModsList[index][3] = mainDirsString.join('|');

                                                                                          List<String> mainDirsInItemString = sortedModsList[index][5].split('|');
                                                                                          for (var element in mainDirsInItemString) {
                                                                                            List<String> split = element.split((':'));
                                                                                            if (split.indexWhere((element) => element == oldMainDirName) != -1) {
                                                                                              split[split.indexOf(oldMainDirName)] = renameTextBoxController.text;
                                                                                              mainDirsInItemString[mainDirsInItemString.indexOf(element)] = split.join(':');
                                                                                            }
                                                                                          }
                                                                                          sortedModsList[index][5] = mainDirsInItemString.join('|');

                                                                                          //print(sortedModsList);
                                                                                        }
                                                                                        _mainFolderRenameIndex[index] = false;
                                                                                        renameTextBoxController.clear();
                                                                                        _isNameEditing = false;

                                                                                        setState(
                                                                                          () {},
                                                                                        );
                                                                                      },
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                const SizedBox(
                                                                                  width: 5,
                                                                                ),
                                                                                SizedBox(
                                                                                  width: 40,
                                                                                  child: MaterialButton(
                                                                                    onPressed: () {
                                                                                      if (renameTextBoxController.text.isNotEmpty) {
                                                                                        String oldMainDirName = sortedModsList[index][3].split('|')[ex];
                                                                                        // Directory('$tempDirPath$s${sortedModsList[index][3].split('|')[ex]}')
                                                                                        //     .renameSync('$tempDirPath$s${renameTextBoxController.text}');
                                                                                        List<FileSystemEntity> curFilesInMainDir = Directory('$tempDirPath$s$oldMainDirName').listSync(recursive: true);
                                                                                        for (var element in curFilesInMainDir) {
                                                                                          //print(curFilesInMainDir);
                                                                                          String newMainPath = element.path
                                                                                              .replaceFirst('$tempDirPath$s$oldMainDirName$s', '$tempDirPath$s${renameTextBoxController.text}$s');
                                                                                          if (!File(element.path).existsSync()) {
                                                                                            Directory(newMainPath).createSync(recursive: true);
                                                                                          }
                                                                                          if (sortedModsList[index][4].isEmpty) {
                                                                                            Directory('$tempDirPath$s${renameTextBoxController.text}').createSync(recursive: true);
                                                                                          }
                                                                                        }
                                                                                        for (var element in curFilesInMainDir) {
                                                                                          String newMainPath = element.path
                                                                                              .replaceFirst('$tempDirPath$s$oldMainDirName$s', '$tempDirPath$s${renameTextBoxController.text}$s');
                                                                                          if (File(element.path).existsSync()) {
                                                                                            File(element.path).copySync(newMainPath);
                                                                                          }
                                                                                        }

                                                                                        //Itemlist
                                                                                        List<String> mainDirsString = sortedModsList[index][3].split('|');
                                                                                        mainDirsString[mainDirsString.indexOf(oldMainDirName)] = renameTextBoxController.text;
                                                                                        sortedModsList[index][3] = mainDirsString.join('|');

                                                                                        List<String> mainDirsInItemString = sortedModsList[index][5].split('|');
                                                                                        for (var element in mainDirsInItemString) {
                                                                                          List<String> split = element.split((':'));
                                                                                          if (split.indexWhere((element) => element == oldMainDirName) != -1) {
                                                                                            split[split.indexOf(oldMainDirName)] = renameTextBoxController.text;
                                                                                            mainDirsInItemString[mainDirsInItemString.indexOf(element)] = split.join(':');
                                                                                          }
                                                                                        }
                                                                                        sortedModsList[index][5] = mainDirsInItemString.join('|');

                                                                                        //print(sortedModsList);
                                                                                      }
                                                                                      _mainFolderRenameIndex[index] = false;
                                                                                      renameTextBoxController.clear();
                                                                                      _isNameEditing = false;

                                                                                      setState(
                                                                                        () {},
                                                                                      );
                                                                                    },
                                                                                    child: const Icon(Icons.check),
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            )
                                                                          : Row(
                                                                              children: [
                                                                                Expanded(
                                                                                  child: Text(sortedModsList[index][3].split('|')[ex],
                                                                                      style: const TextStyle(
                                                                                        fontWeight: FontWeight.w500,
                                                                                      )),
                                                                                ),
                                                                                const SizedBox(
                                                                                  width: 5,
                                                                                ),
                                                                                SizedBox(
                                                                                  width: 40,
                                                                                  child: MaterialButton(
                                                                                    onPressed: !_isNameEditing
                                                                                        ? () {
                                                                                            _isNameEditing = true;
                                                                                            _mainFolderRenameIndex[index] = true;
                                                                                            setState(
                                                                                              () {},
                                                                                            );
                                                                                          }
                                                                                        : null,
                                                                                    child: const Icon(Icons.edit),
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                      children: [
                                                                        //if has subfolders
                                                                        for (int sub = 0; sub < sortedModsList[index][4].split('|').length; sub++)
                                                                          if (sortedModsList[index][4].split('|')[sub] != '')
                                                                            ExpansionTile(
                                                                              initiallyExpanded: false,
                                                                              textColor:
                                                                                  MyApp.themeNotifier.value == ThemeMode.light ? Theme.of(context).primaryColor : Theme.of(context).iconTheme.color,
                                                                              iconColor:
                                                                                  MyApp.themeNotifier.value == ThemeMode.light ? Theme.of(context).primaryColor : Theme.of(context).iconTheme.color,
                                                                              collapsedTextColor:
                                                                                  MyApp.themeNotifier.value == ThemeMode.light ? Theme.of(context).primaryColor : Theme.of(context).iconTheme.color,
                                                                              //Edit Sub Name
                                                                              title: _subFoldersRenameIndex[index][sub]
                                                                                  ? Row(
                                                                                      children: [
                                                                                        Expanded(
                                                                                          child: SizedBox(
                                                                                            height: 40,
                                                                                            child: TextFormField(
                                                                                              autofocus: true,
                                                                                              controller: renameTextBoxController,
                                                                                              maxLines: 1,
                                                                                              decoration: InputDecoration(
                                                                                                contentPadding: const EdgeInsets.only(left: 10, top: 10),
                                                                                                border: const OutlineInputBorder(),
                                                                                                hintText: sortedModsList[index][4].split('|')[sub],
                                                                                              ),
                                                                                              onEditingComplete: (() {
                                                                                                if (renameTextBoxController.text.isNotEmpty) {
                                                                                                  String oldSubDirName = sortedModsList[index][4].split('|')[sub];
                                                                                                  // Directory('$tempDirPath$s${sortedModsList[index][3].split('|')[ex]}$s$oldSubDirName').renameSync(
                                                                                                  //     '$tempDirPath$s${sortedModsList[index][3].split('|')[ex]}$s${renameTextBoxController.text}');
                                                                                                  List<FileSystemEntity> curFilesInSubDir =
                                                                                                      Directory('$tempDirPath$s${sortedModsList[index][3].split('|')[ex]}$s$oldSubDirName')
                                                                                                          .listSync(recursive: true);
                                                                                                  for (var element in curFilesInSubDir) {
                                                                                                    //print(curFilesInMainDir);
                                                                                                    String newMainPath = element.path.replaceFirst(
                                                                                                        '$tempDirPath$s${sortedModsList[index][3].split('|')[ex]}$s$oldSubDirName$s',
                                                                                                        '$tempDirPath$s${sortedModsList[index][3].split('|')[ex]}$s${renameTextBoxController.text}$s');
                                                                                                    if (!File(element.path).existsSync()) {
                                                                                                      Directory(newMainPath).createSync(recursive: true);
                                                                                                    } else {
                                                                                                      Directory(File(newMainPath).parent.path).createSync(recursive: true);
                                                                                                    }
                                                                                                  }
                                                                                                  for (var element in curFilesInSubDir) {
                                                                                                    String newMainPath = element.path.replaceFirst(
                                                                                                        '$tempDirPath$s${sortedModsList[index][3].split('|')[ex]}$s$oldSubDirName$s',
                                                                                                        '$tempDirPath$s${sortedModsList[index][3].split('|')[ex]}$s${renameTextBoxController.text}$s');
                                                                                                    if (File(element.path).existsSync()) {
                                                                                                      File(element.path).copySync(newMainPath);
                                                                                                    }
                                                                                                  }

                                                                                                  //List
                                                                                                  List<String> subDirsString = sortedModsList[index][4].split('|');
                                                                                                  subDirsString[subDirsString.indexOf(oldSubDirName)] = renameTextBoxController.text;
                                                                                                  sortedModsList[index][4] = subDirsString.join('|');

                                                                                                  List<String> subDirsInItemString = sortedModsList[index][5].split('|');
                                                                                                  for (var element in subDirsInItemString) {
                                                                                                    List<String> split = element.split((':'));
                                                                                                    if (split.indexWhere((element) => element == oldSubDirName) != -1) {
                                                                                                      split[split.indexOf(oldSubDirName)] = renameTextBoxController.text;
                                                                                                      subDirsInItemString[subDirsInItemString.indexOf(element)] = split.join(':');
                                                                                                    }
                                                                                                  }
                                                                                                  sortedModsList[index][5] = subDirsInItemString.join('|');
                                                                                                }

                                                                                                //Clear
                                                                                                _subFoldersRenameIndex[index][sub] = false;
                                                                                                renameTextBoxController.clear();
                                                                                                _isNameEditing = false;
                                                                                                setState(
                                                                                                  () {},
                                                                                                );
                                                                                              }),
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                        const SizedBox(
                                                                                          width: 5,
                                                                                        ),
                                                                                        SizedBox(
                                                                                          width: 40,
                                                                                          child: MaterialButton(
                                                                                            onPressed: () {
                                                                                              if (renameTextBoxController.text.isNotEmpty) {
                                                                                                String oldSubDirName = sortedModsList[index][4].split('|')[sub];
                                                                                                // Directory('$tempDirPath$s${sortedModsList[index][3].split('|')[ex]}$s$oldSubDirName').renameSync(
                                                                                                //     '$tempDirPath$s${sortedModsList[index][3].split('|')[ex]}$s${renameTextBoxController.text}');
                                                                                                List<FileSystemEntity> curFilesInSubDir =
                                                                                                    Directory('$tempDirPath$s${sortedModsList[index][3].split('|')[ex]}$s$oldSubDirName')
                                                                                                        .listSync(recursive: true);
                                                                                                for (var element in curFilesInSubDir) {
                                                                                                  //print(curFilesInMainDir);
                                                                                                  String newMainPath = element.path.replaceFirst(
                                                                                                      '$tempDirPath$s${sortedModsList[index][3].split('|')[ex]}$s$oldSubDirName$s',
                                                                                                      '$tempDirPath$s${sortedModsList[index][3].split('|')[ex]}$s${renameTextBoxController.text}$s');
                                                                                                  if (!File(element.path).existsSync()) {
                                                                                                    Directory(newMainPath).createSync(recursive: true);
                                                                                                  }
                                                                                                }
                                                                                                for (var element in curFilesInSubDir) {
                                                                                                  String newMainPath = element.path.replaceFirst(
                                                                                                      '$tempDirPath$s${sortedModsList[index][3].split('|')[ex]}$s$oldSubDirName$s',
                                                                                                      '$tempDirPath$s${sortedModsList[index][3].split('|')[ex]}$s${renameTextBoxController.text}$s');
                                                                                                  if (File(element.path).existsSync()) {
                                                                                                    File(element.path).copySync(newMainPath);
                                                                                                  }
                                                                                                }

                                                                                                //List
                                                                                                List<String> subDirsString = sortedModsList[index][4].split('|');
                                                                                                subDirsString[subDirsString.indexOf(oldSubDirName)] = renameTextBoxController.text;
                                                                                                sortedModsList[index][4] = subDirsString.join('|');

                                                                                                List<String> subDirsInItemString = sortedModsList[index][5].split('|');
                                                                                                for (var element in subDirsInItemString) {
                                                                                                  List<String> split = element.split((':'));
                                                                                                  if (split.indexWhere((element) => element == oldSubDirName) != -1) {
                                                                                                    split[split.indexOf(oldSubDirName)] = renameTextBoxController.text;
                                                                                                    subDirsInItemString[subDirsInItemString.indexOf(element)] = split.join(':');
                                                                                                  }
                                                                                                }
                                                                                                sortedModsList[index][5] = subDirsInItemString.join('|');
                                                                                              }

                                                                                              //Clear
                                                                                              _subFoldersRenameIndex[index][sub] = false;
                                                                                              renameTextBoxController.clear();
                                                                                              _isNameEditing = false;
                                                                                              setState(
                                                                                                () {},
                                                                                              );
                                                                                            },
                                                                                            child: const Icon(Icons.check),
                                                                                          ),
                                                                                        ),
                                                                                      ],
                                                                                    )
                                                                                  : Row(
                                                                                      children: [
                                                                                        Expanded(
                                                                                          child: Text(sortedModsList[index][4].split('|')[sub],
                                                                                              style: const TextStyle(
                                                                                                fontWeight: FontWeight.w500,
                                                                                              )),
                                                                                        ),
                                                                                        const SizedBox(
                                                                                          width: 5,
                                                                                        ),
                                                                                        SizedBox(
                                                                                          width: 40,
                                                                                          child: MaterialButton(
                                                                                            onPressed: !_isNameEditing
                                                                                                ? () {
                                                                                                    _subFoldersRenameIndex[index][sub] = true;
                                                                                                    _isNameEditing = true;
                                                                                                    setState(
                                                                                                      () {},
                                                                                                    );
                                                                                                  }
                                                                                                : null,
                                                                                            child: const Icon(Icons.edit),
                                                                                          ),
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                              children: [
                                                                                for (int i = 0; i < sortedModsList[index][5].split('|').length; i++)
                                                                                  if (sortedModsList[index][5].split('|')[i].split(':')[0] == sortedModsList[index][3].split('|')[ex] &&
                                                                                      sortedModsList[index][5].split('|')[i].split(':')[1] == sortedModsList[index][4].split('|')[sub])
                                                                                    ListTile(
                                                                                      title: Text(sortedModsList[index][5].split('|')[i].split(':').last),
                                                                                    )
                                                                              ],
                                                                            ),
                                                                        //if has no subfolders
                                                                        for (int u = 0; u < sortedModsList[index][4].split('|').length; u++)
                                                                          if (sortedModsList[index][4].split('|')[u] == '')
                                                                            for (int i = 0; i < sortedModsList[index][5].split('|').length; i++)
                                                                              if (sortedModsList[index][5].split('|')[i].split(':')[0] == sortedModsList[index][3].split('|')[ex] &&
                                                                                  sortedModsList[index][5].split('|')[i].split(':')[1] == '')
                                                                                ListTile(
                                                                                  title: Text(sortedModsList[index][5].split('|')[i].split(':').last),
                                                                                )
                                                                      ],
                                                                    )
                                                                ],
                                                              ),
                                                            );
                                                          }));
                                                }
                                              }
                                            }),
                                      ),
                                      if (_exitConfirmDialog)
                                        Container(
                                          //height: 60,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(3),
                                            color: MyApp.themeNotifier.value == ThemeMode.light ? Theme.of(context).cardColor : Theme.of(context).primaryColor,
                                          ),
                                          child: Column(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.all(5.0),
                                                child: Center(
                                                    child: _duplicateModNames.isNotEmpty
                                                        ? Text(
                                                            'Rename $_duplicateModNames before adding',
                                                            textAlign: TextAlign.center,
                                                          )
                                                        : const Text(
                                                            'There are still mods in the list waiting to be added',
                                                            textAlign: TextAlign.center,
                                                          )),
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              ElevatedButton(
                                                child: const Text('Return'),
                                                onPressed: () {
                                                  _exitConfirmDialog = false;
                                                  _duplicateModNames.clear();
                                                  setState(
                                                    () {},
                                                  );
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                    ],
                                  ),
                                  SizedBox(
                                    //width: constraints.maxWidth * 0.45,
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 5),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Expanded(
                                            child: ElevatedButton(
                                                onPressed: sortedModsList.isNotEmpty
                                                    ? (() {
                                                        Directory(tempDirPath).listSync(recursive: false).forEach((element) {
                                                          element.deleteSync(recursive: true);
                                                        });
                                                        _mainFolderRenameIndex.clear();
                                                        _exitConfirmDialog = false;
                                                        _duplicateModNames.clear();
                                                        sortedModsList.clear();
                                                        _newModDragDropList.clear();
                                                        modsToAddList.clear();
                                                        setState(
                                                          () {},
                                                        );
                                                      })
                                                    : null,
                                                child: const Text('Clear All')),
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          Expanded(
                                            child: ElevatedButton(
                                                onPressed: (() async {
                                                  if (_exitConfirmDialog) {
                                                    Directory(tempDirPath).listSync(recursive: false).forEach((element) {
                                                      element.deleteSync(recursive: true);
                                                    });
                                                    _mainFolderRenameIndex.clear();
                                                    _exitConfirmDialog = false;
                                                    _duplicateModNames.clear();
                                                    ngsRefSheetsList.clear();
                                                    sortedModsList.clear();
                                                    _newModDragDropList.clear();
                                                    modsToAddList.clear();
                                                    Navigator.of(context).pop();
                                                    setState(
                                                      () {},
                                                    );
                                                  } else if (sortedModsList.isNotEmpty || modsToAddList.isNotEmpty || _newModDragDropList.isNotEmpty) {
                                                    _exitConfirmDialog = true;
                                                  } else {
                                                    //clear lists
                                                    _mainFolderRenameIndex.clear();
                                                    ngsRefSheetsList.clear();
                                                    sortedModsList.clear();
                                                    _newModDragDropList.clear();
                                                    modsToAddList.clear();
                                                    Navigator.of(context).pop();
                                                  }
                                                  setState(
                                                    () {},
                                                  );
                                                }),
                                                child: const Text('Close')),
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          Expanded(
                                            child: ElevatedButton(
                                                onPressed: sortedModsList.isNotEmpty && _mainFolderRenameIndex.indexWhere((element) => element == true) == -1
                                                    ? (() async {
                                                        //Check for dub mods
                                                        _duplicateModNames.clear();
                                                        for (var sortedLine in sortedModsList) {
                                                          String category = sortedLine[0];
                                                          String itemName = '';
                                                          if (curActiveLang == 'JP') {
                                                            itemName = sortedLine[1];
                                                          } else {
                                                            itemName = sortedLine[2];
                                                          }
                                                          List<String> mainNames = sortedLine[3].split('|');

                                                          if (Directory('$modsDirPath$s$category$s$itemName').existsSync()) {
                                                            if (Directory('$modsDirPath$s$category$s$itemName')
                                                                    .listSync(recursive: false)
                                                                    .indexWhere((element) => mainNames.contains(element.path.split(s).last)) !=
                                                                -1) {
                                                              for (var mainName in mainNames) {
                                                                if (Directory('$modsDirPath$s$category$s$itemName')
                                                                        .listSync(recursive: false)
                                                                        .indexWhere((element) => element.path.split(s).last == mainName) !=
                                                                    -1) {
                                                                  _duplicateModNames.add(' "$mainName" in $itemName ');
                                                                }
                                                              }
                                                            }
                                                          }
                                                        }
                                                        //Add mods
                                                        if (_duplicateModNames.isEmpty) {
                                                          modFilesAdder(context, sortedModsList, XFile('')).then((_) {
                                                            //clear lists and delete temp
                                                            _mainFolderRenameIndex.clear();
                                                            _exitConfirmDialog = false;
                                                            _duplicateModNames.clear();
                                                            sortedModsList.clear();
                                                            _newModDragDropList.clear();
                                                            modsToAddList.clear();
                                                            Directory(tempDirPath).listSync(recursive: false).forEach((element) {
                                                              element.deleteSync(recursive: true);
                                                            });
                                                            setState(
                                                              () {},
                                                            );
                                                          });
                                                        } else {
                                                          _exitConfirmDialog = true;
                                                        }
                                                        setState(
                                                          () {},
                                                        );
                                                      })
                                                    : null,
                                                child: const Text('Add All')),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        );
                      }),
                    );
                  })));
        });
      });
}

Future<void> unzipPack(String filePath, String fileName) async {
  // Use an InputFileStream to access the zip file without storing it in memory.
  final inputStream = InputFileStream(filePath);
  // Decode the zip from the InputFileStream. The archive will have the contents of the
  // zip, without having stored the data in memory.
  final archive = ZipDecoder().decodeBuffer(inputStream);
  // For all of the entries in the archive
  for (var file in archive.files) {
    // If it's a file and not a directory
    if (file.isFile) {
      // Write the file content to a directory called 'out'.
      // In practice, you should make sure file.name doesn't include '..' paths
      // that would put it outside of the extraction directory.
      // An OutputFileStream will write the data to disk.
      final outputStream = OutputFileStream('unpack$s$fileName$s${file.name}');
      // The writeContent method will decompress the file content directly to disk without
      // storing the decompressed data in memory.
      file.writeContent(outputStream);
      // Make sure to close the output stream so the File is closed.
      outputStream.close();
    }
  }
}

Future<List<XFile>> sortFile(String fileName) async {
  List<XFile> filesList = [];
  for (var file in Directory('${Directory.current.path}${s}unpack').listSync(recursive: true)) {
    if (p.extension(file.path) == '' && !Directory(file.path).existsSync()) {
      XFile newFile = XFile(file.path);
      filesList.add(newFile);
    }
  }

  return filesList;
}

Future<List<List<String>>> fetchItemName(List<XFile> inputFiles) async {
  List<List<String>> filesList = [];
  //getting main dirs
  List<String> mainDirPaths = [];
  for (var file in _newModDragDropList) {
    mainDirPaths.add(file.path);
  }

  //copy files to temp with new folder structures
  List<List<String>> extraFiles = [];
  int unknownModsCounter = 1;
  for (var inputFile in inputFiles) {
    if (File(inputFile.path).existsSync() && !inputFile.path.contains(tempDirPath)) {
      for (var mainPath in mainDirPaths) {
        //Paths have main path and continue with /
        if (inputFile.path.contains('$mainPath$s')) {
          String mainDirName = mainPath.split(s).last;
          List<String> curPathSplit = inputFile.path.split(s);
          String subDirName = '';
          if (_pathsToRemove.indexWhere((element) => inputFile.path.split(s).contains(element)) != -1) {
            curPathSplit.removeRange(0, curPathSplit.indexOf(mainDirName) + 1);
            curPathSplit.removeRange(
                curPathSplit.indexWhere((element) => element == _pathsToRemove[_pathsToRemove.indexWhere((element) => inputFile.path.split(s).contains(element))]), curPathSplit.length);
            subDirName = curPathSplit.join(' - ');
          } else {
            curPathSplit.removeRange(0, curPathSplit.indexOf(mainDirName) + 1);
            curPathSplit.remove(inputFile.name);
            subDirName = curPathSplit.join(' - ');
          }

          //moving files to temp with sorted paths
          if (!Directory('$tempDirPath$s$mainDirName$s$subDirName').existsSync()) {
            Directory('$tempDirPath$s$mainDirName$s$subDirName').createSync(recursive: true);
          }
          File(inputFile.path).copySync('$tempDirPath$s$mainDirName$s$subDirName$s${inputFile.name}');

          //get category and item name
          int indexInFilesList = -1;
          if (p.extension(inputFile.path) == '') {
            List<String> itemInfo = await findItemInCsv(inputFile);
            if (itemInfo.isNotEmpty) {
              if (filesList.indexWhere((element) => element[1].contains(itemInfo[1])) != -1 && filesList.indexWhere((element) => element[2].contains(itemInfo[2])) != -1) {
                indexInFilesList = filesList.indexWhere((element) => element[1].contains(itemInfo[1]));
                itemInfo = filesList[indexInFilesList];
              }
            } else {
              itemInfo = ['Misc', '不明な項目 $unknownModsCounter', 'Unknown Item $unknownModsCounter'];
              unknownModsCounter++;
            }

            if (itemInfo.length < 4) {
              itemInfo.add(mainDirName);
            } else {
              if (!itemInfo[3].split('|').contains(mainDirName)) {
                itemInfo[3] += '|$mainDirName';
              }
            }
            if (itemInfo.length < 5) {
              itemInfo.add(subDirName);
            } else {
              if (!itemInfo[4].split('|').contains(subDirName)) {
                itemInfo[4] += '|$subDirName';
              }
            }
            if (itemInfo.length < 6) {
              itemInfo.add('$mainDirName:$subDirName:${inputFile.name}');
            } else {
              if (!itemInfo[5].split('|').contains('$mainDirName:$subDirName:${inputFile.name}')) {
                itemInfo[5] += '|$mainDirName:$subDirName:${inputFile.name}';
              }
            }

            //[0catname, 1jpname, 2enname, 3maindir, 4subdirs, 5files]
            if (indexInFilesList != -1) {
              filesList[indexInFilesList] = itemInfo;
            } else {
              filesList.add(itemInfo);
            }
          } else {
            extraFiles.add(['', '', '', mainDirName, subDirName, '$mainDirName:$subDirName:${inputFile.name}']);
          }

          //print('Sub: $subDirName');
        }
      }
    }
  }
  for (var extraFile in extraFiles) {
    for (var file in filesList) {
      if (file[3].split('|').contains(extraFile[3]) && file[4].split('|').contains(extraFile[4])) {
        file[5] += '|${extraFile[5]}';
      }
    }
  }

  //print(filesList);
  return filesList;
}

Future<List<String>> findItemInCsv(XFile inputFile) async {
  for (var file in ngsRefSheetsList) {
    for (var line in file) {
      if (p.extension(inputFile.path) == '' && line.contains(inputFile.name)) {
        var lineSplit = line.split(',');
        //[0 Category, 1 JP name, 2 EN name, 3 Parent Folder, 4 path, 5 new path, 6 sheets, 7 files]
        if (_emoteCsv.indexWhere((element) => file.first == element) != -1) {
          return (['Emotes', lineSplit[1].replaceAll('/', '_'), lineSplit[2].replaceAll('/', '_')]);
        } else if (_basewearCsv.indexWhere((element) => element == file.first) != -1) {
          if (lineSplit[0].contains('[Ba]') || lineSplit[1].contains('[Ba]')) {
            return (['Basewears', lineSplit[0].replaceAll('/', '_'), lineSplit[1].replaceAll('/', '_')]);
          } else if (lineSplit[0].contains('[Se]') || lineSplit[1].contains('[Se]')) {
            return (['Setwears', lineSplit[0].replaceAll('/', '_'), lineSplit[1].replaceAll('/', '_')]);
          } else {
            return (['Misc', lineSplit[0].replaceAll('/', '_'), lineSplit[1].replaceAll('/', '_')]);
          }
        } else {
          return ([file.first, lineSplit[0].replaceAll('/', '_'), lineSplit[1].replaceAll('/', '_')]);
        }
      }
    }
  }

  return [];
}
