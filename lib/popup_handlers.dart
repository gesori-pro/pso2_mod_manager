import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:pso2_mod_manager/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:window_manager/window_manager.dart';

class CustomPopups {
  const CustomPopups();

  binDirDialog(context) async {
    await showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              titlePadding: const EdgeInsets.only(top: 10),
              title: const Center(
                child: Text('Error',
                    style: TextStyle(fontWeight: FontWeight.w700)),
              ),
              contentPadding: const EdgeInsets.only(left: 16, right: 16),
              content: const SizedBox(
                  //width: 300,
                  height: 70,
                  child: Center(
                      child: Text(
                          'pso2_bin\'s directory path not found. Select now?'))),
              actions: <Widget>[
                ElevatedButton(
                    child: const Text('Exit'),
                    onPressed: () async {
                      Navigator.of(context).pop();
                      await windowManager.destroy();
                    }),
                ElevatedButton(
                    onPressed: (() async {
                      Navigator.of(context).pop();
                      String? binDirTempPath = '';
                      binDirTempPath =
                          await FilePicker.platform.getDirectoryPath(
                        dialogTitle: 'Select \'pso2_bin\' Directory Path',
                        lockParentWindow: true,
                      );

                      if (binDirTempPath == null) {
                        await FilePicker.platform.getDirectoryPath(
                          dialogTitle:
                              'Select \'pso2_bin\' Directory Path Again',
                          lockParentWindow: true,
                        );
                      } else {
                        List<String> getCorrectPath =
                            binDirTempPath.toString().split('\\');
                        //print(getCorrectPath.last);
                        if (getCorrectPath.last == 'pso2_bin') {
                          binDirPath = binDirTempPath.toString();
                          final prefs = await SharedPreferences.getInstance();
                          prefs.setString('binDirPath', binDirPath);
                          //Fill in paths
                          mainModDirPath = '$binDirPath\\PSO2 Mod Manager';
                          modsDirPath = '$mainModDirPath\\Mods';
                          backupDirPath = '$mainModDirPath\\Backups';
                          checksumDirPath = '$mainModDirPath\\Checksum';
                          //Check if exist, create dirs
                          if (!Directory(mainModDirPath).existsSync()) {
                            await Directory(mainModDirPath)
                                .create(recursive: true);
                          }
                          if (!Directory(modsDirPath).existsSync()) {
                            await Directory(modsDirPath)
                                .create(recursive: true);
                          }
                          if (!Directory(backupDirPath).existsSync()) {
                            await Directory(backupDirPath)
                                .create(recursive: true);
                          }
                          if (!Directory(checksumDirPath).existsSync()) {
                            await Directory(checksumDirPath)
                                .create(recursive: true);
                            print(binDirPath);
                          }
                        } else {
                          binDirTempPath =
                              await FilePicker.platform.getDirectoryPath(
                            dialogTitle: 'Select \'pso2_bin\' Directory Path',
                            lockParentWindow: true,
                          );
                        }
                      }
                    }),
                    child: const Text('Yes'))
              ],
            );
          });
        });
  }
}

class _SystemPadding extends StatelessWidget {
  final Widget child;

  const _SystemPadding({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    return AnimatedContainer(
        padding: mediaQuery.viewInsets,
        duration: const Duration(milliseconds: 300),
        child: child);
  }
}
